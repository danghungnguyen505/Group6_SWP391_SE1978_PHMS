package controller;

import dal.AppointmentDAO;
import dal.PetDAO;
import dal.ServiceDAO;
import dal.VeterinarianDAO;
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

        request.setAttribute("pets", petDAO.getPetsByOwnerId(account.getId()));
        request.setAttribute("services", serviceDAO.getAllActiveServices());
        request.setAttribute("veterinarians", vetDAO.getAllVeterinarians());

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

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            java.util.Date date = sdf.parse(dateTime);
            Timestamp startTime = new Timestamp(date.getTime());

            AppointmentDAO appointmentDAO = new AppointmentDAO();
            
            // Check if time slot is available
            if (!appointmentDAO.isTimeSlotAvailable(vetId, startTime)) {
                request.setAttribute("error", "Thời gian này đã được đặt. Vui lòng chọn thời gian khác.");
                doGet(request, response);
                return;
            }

            int apptId = appointmentDAO.createAppointment(petId, vetId, startTime, type, serviceId);
            
            if (apptId > 0) {
                request.setAttribute("success", "Đặt lịch thành công! Vui lòng thanh toán trong vòng 15 phút.");
                response.sendRedirect(request.getContextPath() + "/appointments");
            } else {
                request.setAttribute("error", "Đặt lịch thất bại. Vui lòng thử lại.");
                doGet(request, response);
            }
        } catch (ParseException | NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            doGet(request, response);
        }
    }
}
