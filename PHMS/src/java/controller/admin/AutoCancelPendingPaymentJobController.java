package controller.admin;

import dal.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Non-UI endpoint to auto-cancel appointments in 'Pending Payment'
 * state that are older than 15 minutes (based on start_time).
 * Can be triggered manually or by an external scheduler.
 */
@WebServlet(name = "AutoCancelPendingPaymentJobController", urlPatterns = {"/admin/jobs/auto-cancel-pending-payment"})
public class AutoCancelPendingPaymentJobController extends HttpServlet {

    private static final int TIMEOUT_MINUTES = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        int affected = dao.autoCancelPendingPaymentAppointments(TIMEOUT_MINUTES);
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().println("Auto-cancelled " + affected + " pending payment appointments (older than "
                + TIMEOUT_MINUTES + " minutes).");
    }
}

