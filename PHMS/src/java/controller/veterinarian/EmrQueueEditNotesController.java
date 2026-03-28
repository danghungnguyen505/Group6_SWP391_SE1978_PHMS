package controller.veterinarian;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Legacy queue edit route.
 * Current flow: all veterinarian actions must be done in EMR detail page.
 */
@WebServlet(name = "EmrQueueEditNotesController", urlPatterns = {"/veterinarian/emr/queue/edit"})
public class EmrQueueEditNotesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdRaw = request.getParameter("apptId");
        int apptId;
        try {
            apptId = Integer.parseInt(apptIdRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        session.setAttribute("toastMessage", "success|Please continue in EMR Detail page.");
        response.sendRedirect(request.getContextPath() + "/veterinarian/emr/submit?apptId=" + apptId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdRaw = request.getParameter("apptId");
        int apptId;
        try {
            apptId = Integer.parseInt(apptIdRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        session.setAttribute("toastMessage", "error|Editing from queue is disabled. Please use EMR Detail page.");
        response.sendRedirect(request.getContextPath() + "/veterinarian/emr/submit?apptId=" + apptId);
    }
}
