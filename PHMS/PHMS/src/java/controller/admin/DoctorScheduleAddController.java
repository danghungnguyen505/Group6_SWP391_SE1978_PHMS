package controller.admin;

import dal.ScheduleVeterianrianDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.format.DateTimeFormatter;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.User;

/**
 * Admin adds work schedule for doctors with repeat options (daily, weekly, monthly).
 */
@WebServlet(name = "DoctorScheduleAddController", urlPatterns = {"/admin/doctor/schedule/add"})
public class DoctorScheduleAddController extends HttpServlet {

    // Time slots from 09:00 AM to 05:30 PM
    private static final LocalTime SLOT_START = LocalTime.of(9, 0);
    private static final LocalTime SLOT_END = LocalTime.of(17, 30);
    private static final int SLOT_MINUTES = 30;
    // Display & store time as 12-hour format with AM/PM (e.g. 09:00 AM)
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("hh:mm a");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get list of veterinarians
        UserDAO userDAO = new UserDAO();
        List<User> veterinarians = userDAO.getAllVeterinarians();
        request.setAttribute("veterinarians", veterinarians);

        // Build time slots (07:00 -> 17:30, 30 minutes each)
        request.setAttribute("timeSlots", buildTimeSlots());

        // Prefill date (from weekly calendar "Add Another" button)
        String prefillDate = request.getParameter("date");
        if (prefillDate != null && !prefillDate.trim().isEmpty()) {
            try {
                LocalDate.parse(prefillDate.trim());
                request.setAttribute("prefillDate", prefillDate.trim());
            } catch (Exception ignore) {
                // ignore invalid date
            }
        }
        
        request.getRequestDispatcher("/views/admin/doctorScheduleAdd.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get parameters
        String doctorIdStr = request.getParameter("doctorId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String[] selectedSlots = request.getParameterValues("slots");
        String repeatType = request.getParameter("repeatType");
        String repeatEndDateStr = request.getParameter("repeatEndDate");
        
        // Validation
        if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn bác sĩ!");
            doGet(request, response);
            return;
        }
        
        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn ngày bắt đầu!");
            doGet(request, response);
            return;
        }
        
        if (selectedSlots == null || selectedSlots.length == 0) {
            request.setAttribute("error", "Vui lòng chọn ít nhất 1 slot làm việc (07:00 - 17:30, mỗi 30 phút)!");
            doGet(request, response);
            return;
        }
        
        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            LocalDate startDate = LocalDate.parse(startDateStr);

            // Validate selected slots against allowed slot list
            Set<String> allowedSlots = new HashSet<>(buildTimeSlots());
            List<String> validSlots = new ArrayList<>();
            for (String slot : selectedSlots) {
                if (slot != null) {
                    String trimmed = slot.trim();
                    if (allowedSlots.contains(trimmed)) {
                        validSlots.add(trimmed);
                    }
                }
            }
            if (validSlots.isEmpty()) {
                request.setAttribute("error", "Slot không hợp lệ. Vui lòng chọn lại!");
                doGet(request, response);
                return;
            }
            
            ScheduleVeterianrianDAO scheduleDAO = new ScheduleVeterianrianDAO();
            int managerId = account.getUserId();
            int successCount = 0;
            
            if (repeatType == null || repeatType.isEmpty() || "none".equals(repeatType)) {
                // Single schedule - no repeat
                if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                    LocalDate endDate = LocalDate.parse(endDateStr);
                    if (endDate.isBefore(startDate)) {
                        request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu!");
                        doGet(request, response);
                        return;
                    }
                    // Create schedules for date range
                    LocalDate currentDate = startDate;
                    while (!currentDate.isAfter(endDate)) {
                        for (String slot : validSlots) {
                            if (scheduleDAO.insertSchedule(doctorId, managerId, Date.valueOf(currentDate), slot)) {
                                successCount++;
                            }
                        }
                        currentDate = currentDate.plusDays(1);
                    }
                } else {
                    // Single date
                    for (String slot : validSlots) {
                        if (scheduleDAO.insertSchedule(doctorId, managerId, Date.valueOf(startDate), slot)) {
                            successCount++;
                        }
                    }
                }
            } else {
                // Repeat schedule
                LocalDate repeatEndDate;
                if (repeatEndDateStr != null && !repeatEndDateStr.trim().isEmpty()) {
                    repeatEndDate = LocalDate.parse(repeatEndDateStr);
                } else {
                    // Default: repeat for 3 months
                    repeatEndDate = startDate.plusMonths(3);
                }
                
                if (repeatEndDate.isBefore(startDate)) {
                    request.setAttribute("error", "Ngày kết thúc lặp lại phải sau ngày bắt đầu!");
                    doGet(request, response);
                    return;
                }
                
                LocalDate currentDate = startDate;
                
                while (!currentDate.isAfter(repeatEndDate)) {
                    for (String slot : validSlots) {
                        if (scheduleDAO.insertSchedule(doctorId, managerId, Date.valueOf(currentDate), slot)) {
                            successCount++;
                        }
                    }
                    
                    // Calculate next date based on repeat type
                    switch (repeatType) {
                        case "daily":
                            currentDate = currentDate.plusDays(1);
                            break;
                        case "weekly":
                            currentDate = currentDate.plusWeeks(1);
                            break;
                        case "monthly":
                            currentDate = currentDate.plusMonths(1);
                            break;
                        default:
                            currentDate = repeatEndDate.plusDays(1); // Exit loop
                            break;
                    }
                }
            }
            
            if (successCount > 0) {
                session.setAttribute("toastMessage", "success|Đã thêm " + successCount + " lịch làm việc thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/doctor/schedule/add");
            } else {
                request.setAttribute("error", "Không thể thêm lịch làm việc. Có thể lịch đã tồn tại!");
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }

    private static List<String> buildTimeSlots() {
        List<String> slots = new ArrayList<>();
        LocalTime t = SLOT_START;
        while (!t.plusMinutes(SLOT_MINUTES).isAfter(SLOT_END)) {
            LocalTime t2 = t.plusMinutes(SLOT_MINUTES);
            slots.add(TIME_FMT.format(t) + "-" + TIME_FMT.format(t2));
            t = t2;
        }
        return slots;
    }
}
