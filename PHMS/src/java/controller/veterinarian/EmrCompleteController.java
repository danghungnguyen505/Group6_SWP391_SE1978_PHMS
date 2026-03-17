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

@WebServlet(name = "EmrCompleteController", urlPatterns = {"/veterinarian/emr/complete"})
public class EmrCompleteController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdStr = request.getParameter("apptId");
        int apptId;
        try {
            apptId = Integer.parseInt(apptIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "error|Invalid appointment ID.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        boolean ok = dao.completeForVet(apptId, account.getUserId());
        if (ok) {
            session.setAttribute("toastMessage", "success|Appointment marked as Completed.");
        } else {
            session.setAttribute("toastMessage", "error|Cannot complete. Appointment may not be In-Progress or not assigned to you.");
        }
        response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
    }
}
