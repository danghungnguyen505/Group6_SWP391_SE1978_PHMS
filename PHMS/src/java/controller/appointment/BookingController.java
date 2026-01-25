/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.appointment;

import dal.AppointmentDAO;
import dal.ScheduleVeterianrianDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.sql.Date;
import java.util.List;
import model.Schedule;
import dal.PetDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import model.Appointment;
import model.TimeSlot;
import model.User;
import java.sql.Timestamp;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processViewSlot(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("book".equals(action)) {
            saveAppointment(request, response);
        }
        processViewSlot(request, response);
    }

    //XỬ LÝ LƯU CUỘC HẸN
    private void saveAppointment(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Lấy dữ liệu từ form
            String petIdStr = request.getParameter("petId");
            String serviceType = request.getParameter("serviceType");
            String vetIdStr = request.getParameter("vetId");
            String dateStr = request.getParameter("selectedDate");
            String timeStr = request.getParameter("timeSlot");
            String notes = request.getParameter("notes");
            // Validate
            if (petIdStr == null || vetIdStr == null || timeStr == null || timeStr.isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn đầy đủ Ngày, Bác sĩ và Giờ khám!");
                return;
            }
            // Gộp Ngày + Giờ
            String dateTimeString = dateStr + " " + timeStr + ":00";
            Timestamp startTime = Timestamp.valueOf(dateTimeString);
            // Tạo Object
            Appointment appt = new Appointment();
            appt.setPetId(Integer.parseInt(petIdStr));
            appt.setVetId(Integer.parseInt(vetIdStr));
            appt.setStartTime(startTime);
            appt.setType(serviceType);
            appt.setNotes(notes);
            // Gọi DAO lưu
            AppointmentDAO dao = new AppointmentDAO();
            boolean isSaved = dao.insertAppointment(appt);
            if (isSaved) {
                request.setAttribute("successMessage", "Đặt lịch thành công! Vui lòng chờ Lễ tân duyệt.");
            } else {
                request.setAttribute("error", "Lỗi: Không thể lưu cuộc hẹn (Dữ liệu không hợp lệ hoặc lỗi server).");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi đặt lịch: " + e.getMessage());
        }
    }

    private void processViewSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        // 1. Load danh sách thú cưng
        if (account != null) {
            PetDAO petDAO = new PetDAO();
            List<model.Pet> pets = petDAO.getPetsByOwnerId(account.getUserId());
            request.setAttribute("pets", pets);
        }
        // 2. Xử lý logic lọc Bác sĩ theo Ngày
        String dateStr = request.getParameter("selectedDate");
        ScheduleVeterianrianDAO scheduleDAO = new ScheduleVeterianrianDAO();
        List<Schedule> listSchedules;
        if (dateStr != null && !dateStr.isEmpty()) {
            Date date = Date.valueOf(dateStr); // SQL Date
            List<Schedule> rawList = scheduleDAO.getSchedulesByDate(date);
            // Gộp lịch trùng 
            Map<Integer, Schedule> uniqueMap = new LinkedHashMap<>();
            for (Schedule s : rawList) {
                if (uniqueMap.containsKey(s.getEmpId())) {
                    Schedule existing = uniqueMap.get(s.getEmpId());
                    existing.setShiftTime(existing.getShiftTime() + " | " + s.getShiftTime());
                } else {
                    uniqueMap.put(s.getEmpId(), s);
                }
            }
            listSchedules = new ArrayList<>(uniqueMap.values());
            request.setAttribute("selectedDateStr", dateStr);
        } else {
            listSchedules = new ArrayList<>();
        }
        request.setAttribute("schedules", listSchedules);
        // 3.TÍNH TOÁN TIME SLOTS (Nếu đã chọn Ngày & Bác sĩ)
        String vetIdStr = request.getParameter("vetId");
        List<TimeSlot> availableSlots = new ArrayList<>();
        if (dateStr != null && !dateStr.isEmpty() && vetIdStr != null && !vetIdStr.isEmpty()) {
            try {
                int vetId = Integer.parseInt(vetIdStr);
                Date date = Date.valueOf(dateStr);
                // 1. Lấy dữ liệu từ DB
                List<String> shifts = scheduleDAO.getShiftsByVetAndDate(vetId, date);
                AppointmentDAO apptDAO = new AppointmentDAO();
                List<String> bookedTimes = apptDAO.getBookedSlots(vetId, dateStr);
                SimpleDateFormat sdfCheck = new SimpleDateFormat("HH:mm");       // 24h để so sánh
                SimpleDateFormat sdfDisplay = new SimpleDateFormat("hh:mm a");   // 12h để hiển thị (09:00 AM)
                SimpleDateFormat sdfParseShift = new SimpleDateFormat("hh:mm a");// Parse chuỗi ca làm việc "09:00 AM"
                // 2. Định nghĩa khung giờ hoạt động của phòng khám (Ví dụ: 08:00 - 17:30)
                Calendar cal = Calendar.getInstance();
                cal.set(Calendar.HOUR_OF_DAY, 9);  // Giờ mở cửa: 8h sáng
                cal.set(Calendar.MINUTE, 0);
                cal.set(Calendar.SECOND, 0);
                Calendar closeTime = Calendar.getInstance();
                closeTime.set(Calendar.HOUR_OF_DAY, 17); // Giờ đóng cửa: 17h chiều (5 PM)
                closeTime.set(Calendar.MINUTE, 30);      // Tùy chỉnh (ví dụ 17:30)
                closeTime.set(Calendar.SECOND, 0);
                // 3. Vòng lặp tạo ra TẤT CẢ các slot 30 phút trong ngày
                while (cal.getTime().before(closeTime.getTime())) {
                    java.util.Date currentSlotTime = cal.getTime();
                    String timeVal = sdfCheck.format(currentSlotTime);    // "09:00"
                    String timeLbl = sdfDisplay.format(currentSlotTime);  // "09:00 AM"
                    boolean isWithinShift = false;
                    // 4. Kiểm tra: Giờ này có nằm trong ca làm việc nào của bác sĩ không?
                    for (String shift : shifts) {
                        if (shift == null || !shift.contains("-")) {
                            continue;
                        }
                        try {
                            String[] parts = shift.split("-");
                            java.util.Date shiftStart = sdfParseShift.parse(parts[0].trim());
                            java.util.Date shiftEnd = sdfParseShift.parse(parts[1].trim());
                            // Tạo đối tượng Calendar để so sánh giờ (chỉ lấy giờ phút, bỏ ngày tháng)
                            Calendar shiftStartCal = Calendar.getInstance();
                            shiftStartCal.setTime(shiftStart);
                            // Reset ngày tháng về cùng ngày với 'cal' để so sánh giờ chính xác
                            shiftStartCal.set(Calendar.YEAR, cal.get(Calendar.YEAR));
                            shiftStartCal.set(Calendar.MONTH, cal.get(Calendar.MONTH));
                            shiftStartCal.set(Calendar.DAY_OF_MONTH, cal.get(Calendar.DAY_OF_MONTH));
                            Calendar shiftEndCal = Calendar.getInstance();
                            shiftEndCal.setTime(shiftEnd);
                            shiftEndCal.set(Calendar.YEAR, cal.get(Calendar.YEAR));
                            shiftEndCal.set(Calendar.MONTH, cal.get(Calendar.MONTH));
                            shiftEndCal.set(Calendar.DAY_OF_MONTH, cal.get(Calendar.DAY_OF_MONTH));
                            // Logic: Slot nằm trong khoảng [Start, End)
                            // (Lớn hơn hoặc bằng Start) VÀ (Nhỏ hơn End)
                            if (!cal.before(shiftStartCal) && cal.before(shiftEndCal)) {
                                isWithinShift = true;
                                break; // Đã tìm thấy ca phù hợp, thoát vòng lặp shift
                            }
                        } catch (Exception e) {
                            continue; // Bỏ qua nếu lỗi format chuỗi shift
                        }
                    }
                    // 5. Kiểm tra: Giờ này có bị đặt trước chưa?
                    boolean isBooked = bookedTimes.contains(timeVal);
                    // 6. Kết luận: Available = (Trong ca làm việc) VÀ (Chưa bị đặt)
                    boolean available = isWithinShift && !isBooked;
                    availableSlots.add(new TimeSlot(timeLbl, timeVal, available));
                    // Tăng thêm 30 phút
                    cal.add(Calendar.MINUTE, 30);
                }
            } catch (Exception e) {
                System.out.println("Error calculating full grid slots: " + e.getMessage());
                e.printStackTrace();
            }
        }
        // Đẩy danh sách slots và vetId đã chọn ra JSP
        request.setAttribute("availableSlots", availableSlots);
        request.setAttribute("selectedVetId", vetIdStr);
        request.getRequestDispatcher("/views/petOwner/menuPetOwner.jsp").forward(request, response);
    }
}
