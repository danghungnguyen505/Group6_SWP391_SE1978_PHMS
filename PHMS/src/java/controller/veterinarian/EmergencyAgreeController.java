package controller.veterinarian;

import dal.AppointmentDAO;
import dal.MedicalRecordDAO;
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

    private static final String DEFAULT_DIAGNOSIS = "Pending diagnosis.";
    private static final String DEFAULT_TREATMENT_PLAN = "Pending treatment plan.";

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
            try {
                MedicalRecordDAO mrDAO = new MedicalRecordDAO();
                int recordId = mrDAO.createOrGetForVetByAppointment(
                        apptId,
                        account.getUserId(),
                        DEFAULT_DIAGNOSIS,
                        DEFAULT_TREATMENT_PLAN
                );
                // Backward compatibility: allow old Pending/Confirmed emergencies
                // to be accepted first, then create/open EMR.
                if (recordId <= 0) {
                    AppointmentDAO apptDAO = new AppointmentDAO();
                    boolean accepted = apptDAO.agreeEmergencyAppointmentForVet(apptId, account.getUserId());
                    if (accepted) {
                        recordId = mrDAO.createOrGetForVetByAppointment(
                                apptId,
                                account.getUserId(),
                                DEFAULT_DIAGNOSIS,
                                DEFAULT_TREATMENT_PLAN
                        );
                    }
                }
                if (recordId > 0) {
                    session.setAttribute("toastMessage", "success|Emergency case accepted. Medical record is ready.");
                    response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
                    return;
                }
                session.setAttribute("toastMessage", "error|Cannot accept. Appointment may not be eligible or not assigned to you.");
            } catch (Exception e) {
                session.setAttribute("toastMessage", "error|System error: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/veterinarian/emergency/queue");
    }
}

