package controller.veterinarian;

import dal.MedicalRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Delete medical record for veterinarian.
 * SRP: Delete only.
 */
@WebServlet(name = "MedicalRecordDeleteController", urlPatterns = {"/veterinarian/emr/delete"})
public class MedicalRecordDeleteController extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        int recordId;
        try {
            recordId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        MedicalRecordDAO dao = new MedicalRecordDAO();
        boolean ok = dao.deleteForVet(recordId, account.getUserId());
        if (ok) {
            session.setAttribute("toastMessage", "success|Medical record deleted.");
        } else {
            session.setAttribute("toastMessage", "error|Cannot delete record (not found or access denied).");
        }
        response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
    }
}

