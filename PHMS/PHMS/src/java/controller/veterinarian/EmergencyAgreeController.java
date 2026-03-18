package controller.veterinarian;

import dal.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "EmergencyAgreeController", urlPatterns = {"/veterinarian/emergency/agree"})
public class EmergencyAgreeController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int apptId = -1;
        String apptIdStr = request.getParameter("apptId");
        if (apptIdStr != null) {
            try {
                apptId = Integer.parseInt(apptIdStr.trim());
            } catch (NumberFormatException ignored) {
                apptId = -1;
            }
        }

        if (apptId > 0) {
            AppointmentDAO apptDAO = new AppointmentDAO();
            boolean ok = apptDAO.agreeEmergencyAppointmentForVet(apptId, account.getUserId());
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/veterinarian/emr/create?apptId=" + apptId);
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
    }
}

