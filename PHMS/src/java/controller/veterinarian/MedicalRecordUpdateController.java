package controller.veterinarian;

import dal.MedicalRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.MedicalRecord;
import model.User;

/**
 * Update medical record for veterinarian.
 * SRP: Update only.
 */
@WebServlet(name = "MedicalRecordUpdateController", urlPatterns = {"/veterinarian/emr/update"})
public class MedicalRecordUpdateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
        MedicalRecord mr = dao.getByIdForVet(recordId, account.getUserId());
        if (mr == null) {
            session.setAttribute("toastMessage", "error|Record not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        request.setAttribute("record", mr);
        request.getRequestDispatcher("/views/veterinarian/medicalRecordUpdate.jsp").forward(request, response);
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

        String idStr = request.getParameter("recordId");
        String diagnosis = util.ValidationUtils.sanitize(request.getParameter("diagnosis"));
        String treatmentPlan = util.ValidationUtils.sanitize(request.getParameter("treatmentPlan"));

        if (!util.ValidationUtils.isNotEmpty(idStr) || !util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Invalid record ID.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        int recordId = Integer.parseInt(idStr);

        if (!util.ValidationUtils.isNotEmpty(diagnosis) || diagnosis.length() > 4000) {
            request.setAttribute("error", "Diagnosis is required and must be <= 4000 characters.");
            request.setAttribute("recordId", recordId);
            request.setAttribute("diagnosis", diagnosis);
            request.setAttribute("treatmentPlan", treatmentPlan);
            request.getRequestDispatcher("/views/veterinarian/medicalRecordUpdate.jsp").forward(request, response);
            return;
        }
        if (!util.ValidationUtils.isNotEmpty(treatmentPlan) || treatmentPlan.length() > 4000) {
            request.setAttribute("error", "Treatment plan is required and must be <= 4000 characters.");
            request.setAttribute("recordId", recordId);
            request.setAttribute("diagnosis", diagnosis);
            request.setAttribute("treatmentPlan", treatmentPlan);
            request.getRequestDispatcher("/views/veterinarian/medicalRecordUpdate.jsp").forward(request, response);
            return;
        }

        MedicalRecordDAO dao = new MedicalRecordDAO();
        boolean ok = dao.updateForVet(recordId, account.getUserId(), diagnosis, treatmentPlan);
        if (ok) {
            session.setAttribute("toastMessage", "success|Medical record updated.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
        } else {
            request.setAttribute("error", "Cannot update record (not found or access denied).");
            request.setAttribute("recordId", recordId);
            request.setAttribute("diagnosis", diagnosis);
            request.setAttribute("treatmentPlan", treatmentPlan);
            request.getRequestDispatcher("/views/veterinarian/medicalRecordUpdate.jsp").forward(request, response);
        }
    }
}

