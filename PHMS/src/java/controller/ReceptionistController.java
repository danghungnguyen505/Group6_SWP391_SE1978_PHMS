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

@WebServlet(name = "ReceptionistController", urlPatterns = {"/recep-appointments"})
public class ReceptionistController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !account.getRole().equalsIgnoreCase("Receptionist")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        
        // Get completed appointments
        request.setAttribute("completedAppointments", appointmentDAO.getCompletedAppointments());
        
        // Get pending confirmation appointments
        request.setAttribute("pendingAppointments", appointmentDAO.getPendingConfirmationAppointments());

        request.getRequestDispatcher("/views/recepAppointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !account.getRole().equalsIgnoreCase("Receptionist")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int apptId = Integer.parseInt(request.getParameter("apptId"));
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        
        if ("approve".equals(action)) {
            // Approve appointment - change status to Confirmed
            boolean success = appointmentDAO.updateAppointmentStatus(apptId, "Confirmed");
            if (success) {
                request.setAttribute("success", "Đã phê duyệt lịch hẹn thành công!");
            } else {
                request.setAttribute("error", "Phê duyệt thất bại!");
            }
        } else if ("reject".equals(action)) {
            // Reject appointment - change status to Cancelled
            boolean success = appointmentDAO.updateAppointmentStatus(apptId, "Cancelled");
            if (success) {
                request.setAttribute("success", "Đã từ chối lịch hẹn!");
            } else {
                request.setAttribute("error", "Từ chối thất bại!");
            }
        } else if ("delete".equals(action)) {
            // Delete appointment
            boolean success = appointmentDAO.deleteAppointment(apptId);
            if (success) {
                request.setAttribute("success", "Đã xóa cuộc hẹn thành công!");
            } else {
                request.setAttribute("error", "Xóa thất bại!");
            }
        }

        doGet(request, response);
    }
}
