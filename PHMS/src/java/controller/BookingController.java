package controller;

import dal.AppointmentDAO;
import dal.PetDAO;
import dal.ScheduleDAO;
import dal.ServiceDAO;
import dal.VeterinarianDAO;
import java.sql.Date;
import java.util.Calendar;
import java.util.List;
import model.Pet;
import model.TimeSlot;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import model.User;

@WebServlet(name = "BookingController", urlPatterns = {"/booking"})
public class BookingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !account.getRole().equalsIgnoreCase("Owner")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PetDAO petDAO = new PetDAO();
        ServiceDAO serviceDAO = new ServiceDAO();
        VeterinarianDAO vetDAO = new VeterinarianDAO();
        ScheduleDAO scheduleDAO = new ScheduleDAO();

        System.out.println("BookingController - User ID: " + account.getId() + ", Role: " + account.getRole());

        // Get date parameter or use today
        String dateParam = request.getParameter("date");
        Date selectedDate;
        if (dateParam != null && !dateParam.isEmpty()) {
            selectedDate = Date.valueOf(dateParam);
        } else {
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            selectedDate = new Date(cal.getTimeInMillis());
        }

        java.util.List<model.Pet> pets = petDAO.getPetsByOwnerId(account.getId());
        System.out.println("BookingController - Number of pets: " + pets.size());
        request.setAttribute("pets", pets);
        request.setAttribute("services", serviceDAO.getAllActiveServices());
        request.setAttribute("veterinarians", vetDAO.getAllVeterinarians());
        request.setAttribute("schedules", scheduleDAO.getAllVetSchedules());
        request.setAttribute("timeSlots", scheduleDAO.getAvailableTimeSlots(selectedDate));
        request.setAttribute("selectedDate", selectedDate);

        request.getRequestDispatcher("/views/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !account.getRole().equalsIgnoreCase("Owner")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int petId = Integer.parseInt(request.getParameter("petId"));
            int vetId = Integer.parseInt(request.getParameter("vetId"));
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String dateTime = request.getParameter("dateTime");
            String type = request.getParameter("type");

            System.out.println("BookingController.doPost - petId: " + petId + ", vetId: " + vetId + ", dateTime: " + dateTime);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            java.util.Date date = sdf.parse(dateTime);
            Timestamp startTime = new Timestamp(date.getTime());
            
            System.out.println("Parsed startTime: " + startTime);

            AppointmentDAO appointmentDAO = new AppointmentDAO();
            
            // Check if time slot is available
            boolean available = appointmentDAO.isTimeSlotAvailable(vetId, startTime);
            System.out.println("Time slot available: " + available);
            
            if (!available) {
                request.setAttribute("error", "Thời gian này đã được đặt. Vui lòng chọn thời gian khác.");
                doGet(request, response);
                return;
            }

            System.out.println("Creating appointment...");
            int apptId = appointmentDAO.createAppointment(petId, vetId, startTime, type, serviceId);
            System.out.println("Appointment created with ID: " + apptId);
            
            if (apptId > 0) {
                request.setAttribute("success", "Đặt lịch thành công! ID: " + apptId + ". Đang chờ xác nhận từ lễ tân.");
                response.sendRedirect(request.getContextPath() + "/appointments");
                return;
            } else {
                request.setAttribute("error", "Đặt lịch thất bại. Vui lòng kiểm tra console log để xem chi tiết lỗi.");
            }
            
            doGet(request, response);
        } catch (ParseException | NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            doGet(request, response);
        }
    }
}
