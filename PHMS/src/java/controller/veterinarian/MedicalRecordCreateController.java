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
import model.Appointment;
import model.User;

/**
 * Create medical record for a checked-in appointment.
 * SRP: Create only.
 */
@WebServlet(name = "MedicalRecordCreateController", urlPatterns = {"/veterinarian/emr/create"})
public class MedicalRecordCreateController extends HttpServlet {

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
        if (apptIdStr == null || apptIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        int apptId;
        try {
            apptId = Integer.parseInt(apptIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        // Load appointment details (basic)
        AppointmentDAO apptDao = new AppointmentDAO();
        Appointment appt = apptDao.getAppointmentById(apptId);
        if (appt == null || appt.getVetId() != account.getUserId() || !"Checked-in".equalsIgnoreCase(appt.getStatus())) {
            session.setAttribute("toastMessage", "error|Appointment not found or not eligible for examination.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        request.setAttribute("appt", appt);
        request.getRequestDispatcher("/views/veterinarian/medicalRecordCreate.jsp").forward(request, response);
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

        String apptIdStr = request.getParameter("apptId");
        String diagnosis = util.ValidationUtils.sanitize(request.getParameter("diagnosis"));
        String treatmentPlan = util.ValidationUtils.sanitize(request.getParameter("treatmentPlan"));

        if (!util.ValidationUtils.isNotEmpty(apptIdStr) || !util.ValidationUtils.isIntegerInRange(apptIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Invalid appointment ID.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }
        int apptId = Integer.parseInt(apptIdStr);

        // Validate fields
        if (!util.ValidationUtils.isNotEmpty(diagnosis) || diagnosis.length() > 4000) {
            request.setAttribute("error", "Diagnosis is required and must be <= 4000 characters.");
            request.setAttribute("diagnosis", diagnosis);
            request.setAttribute("treatmentPlan", treatmentPlan);
            request.setAttribute("apptId", apptId);
            request.getRequestDispatcher("/views/veterinarian/medicalRecordCreate.jsp").forward(request, response);
            return;
        }
        if (!util.ValidationUtils.isNotEmpty(treatmentPlan) || treatmentPlan.length() > 4000) {
            request.setAttribute("error", "Treatment plan is required and must be <= 4000 characters.");
            request.setAttribute("diagnosis", diagnosis);
            request.setAttribute("treatmentPlan", treatmentPlan);
            request.setAttribute("apptId", apptId);
            request.getRequestDispatcher("/views/veterinarian/medicalRecordCreate.jsp").forward(request, response);
            return;
        }

        try {
            MedicalRecordDAO dao = new MedicalRecordDAO();
            boolean ok = dao.createForVet(apptId, account.getUserId(), diagnosis, treatmentPlan);
            if (ok) {
                session.setAttribute("toastMessage", "success|Medical record created. Appointment marked as Completed.");
                response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            } else {
                request.setAttribute("error", "Cannot create medical record. Appointment may not be Checked-in or not assigned to you.");
                request.setAttribute("diagnosis", diagnosis);
                request.setAttribute("treatmentPlan", treatmentPlan);
                request.setAttribute("apptId", apptId);
                request.getRequestDispatcher("/views/veterinarian/medicalRecordCreate.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.setAttribute("diagnosis", diagnosis);
            request.setAttribute("treatmentPlan", treatmentPlan);
            request.setAttribute("apptId", apptId);
            request.getRequestDispatcher("/views/veterinarian/medicalRecordCreate.jsp").forward(request, response);
        }
    }
}

