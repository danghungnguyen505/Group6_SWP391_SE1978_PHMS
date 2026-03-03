<<<<<<< Updated upstream
package controller.veterinarian;

import dal.LabTestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Vet cancels lab request.
 * SRP: Update status only.
 */
@WebServlet(name = "LabRequestCancelController", urlPatterns = {"/veterinarian/lab/cancel"})
public class LabRequestCancelController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/lab/requests");
            return;
        }
        int testId;
        try {
            testId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/lab/requests");
            return;
        }

        LabTestDAO dao = new LabTestDAO();
        boolean ok = dao.cancelForVet(testId, account.getUserId());
        if (ok) {
            session.setAttribute("toastMessage", "success|Lab request cancelled.");
        } else {
            session.setAttribute("toastMessage", "error|Cannot cancel request (not found / access denied / already completed).");
        }
        response.sendRedirect(request.getContextPath() + "/veterinarian/lab/requests");
    }
}

=======
package controller.veterinarian;

import dal.LabTestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Vet cancels lab request.
 * SRP: Update status only.
 */
@WebServlet(name = "LabRequestCancelController", urlPatterns = {"/veterinarian/lab/cancel"})
public class LabRequestCancelController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/lab/requests");
            return;
        }
        int testId;
        try {
            testId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/lab/requests");
            return;
        }

        LabTestDAO dao = new LabTestDAO();
        boolean ok = dao.cancelForVet(testId, account.getUserId());
        if (ok) {
            session.setAttribute("toastMessage", "success|Lab request cancelled.");
        } else {
            session.setAttribute("toastMessage", "error|Cannot cancel request (not found / access denied / already completed).");
        }
        response.sendRedirect(request.getContextPath() + "/veterinarian/lab/requests");
    }
}

>>>>>>> Stashed changes
