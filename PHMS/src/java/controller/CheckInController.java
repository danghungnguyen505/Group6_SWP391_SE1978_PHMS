package controller;

import dal.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "CheckInController", urlPatterns = {"/checkin"})
public class CheckInController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = account.getRole();
        AppointmentDAO appointmentDAO = new AppointmentDAO();

        if (role.equalsIgnoreCase("Receptionist")) {
            // Receptionist can see all today's appointments for check-in
            request.setAttribute("appointments", appointmentDAO.getTodayAppointmentsForVet(0)); // 0 means all
        } else if (role.equalsIgnoreCase("Veterinarian")) {
            // Veterinarian sees only their appointments
            request.setAttribute("appointments", appointmentDAO.getTodayAppointmentsForVet(account.getId()));
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/views/checkInQueue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("checkin".equals(action)) {
            int apptId = Integer.parseInt(request.getParameter("apptId"));
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            
            // Update status to "Checked-in"
            boolean success = appointmentDAO.updateAppointmentStatus(apptId, "Checked-in");
            
            if (success) {
                request.setAttribute("success", "Đã check-in thành công!");
            } else {
                request.setAttribute("error", "Check-in thất bại!");
            }
        } else if ("confirm".equals(action)) {
            int apptId = Integer.parseInt(request.getParameter("apptId"));
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            
            // Update status to "Confirmed"
            boolean success = appointmentDAO.updateAppointmentStatus(apptId, "Confirmed");
            
            if (success) {
                request.setAttribute("success", "Đã xác nhận lịch hẹn!");
            } else {
                request.setAttribute("error", "Xác nhận thất bại!");
            }
        }

        doGet(request, response);
    }
}
