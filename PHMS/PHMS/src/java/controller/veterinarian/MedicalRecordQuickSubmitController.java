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
 * Quick submit from EMR Queue:
 * Auto-create a medical record with placeholder fields and redirect to list.
 */
@WebServlet(name = "MedicalRecordQuickSubmitController", urlPatterns = {"/veterinarian/emr/submit"})
public class MedicalRecordQuickSubmitController extends HttpServlet {

    private static final String DEFAULT_DIAGNOSIS = "Pending diagnosis.";
    private static final String DEFAULT_TREATMENT_PLAN = "Pending treatment plan.";

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

        try {
            MedicalRecordDAO dao = new MedicalRecordDAO();
            int recordId = dao.createForVetReturnId(apptId, account.getUserId(), DEFAULT_DIAGNOSIS, DEFAULT_TREATMENT_PLAN);
            if (recordId > 0) {
                session.setAttribute("toastMessage", "success|Medical record submitted.");
                response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            } else {
                session.setAttribute("toastMessage", "error|Cannot submit medical record. Appointment may not be Checked-in or not assigned to you.");
                response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            }
        } catch (Exception e) {
            session.setAttribute("toastMessage", "error|System error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
        }
    }
}

