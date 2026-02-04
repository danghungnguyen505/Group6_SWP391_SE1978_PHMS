package controller.receptionist;

import dal.AppointmentDAO;
import dal.TriageRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Appointment;
import model.TriageRecord;
import model.User;

/**
 * Receptionist triage emergency appointment.
 * SRP: Create/update triage record only.
 */
@WebServlet(name = "EmergencyTriageController", urlPatterns = {"/receptionist/emergency/triage"})
public class EmergencyTriageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdStr = request.getParameter("apptId");
        if (!util.ValidationUtils.isNotEmpty(apptIdStr)
                || !util.ValidationUtils.isIntegerInRange(apptIdStr, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/receptionist/emergency/queue");
            return;
        }
        int apptId = Integer.parseInt(apptIdStr);

        AppointmentDAO apptDAO = new AppointmentDAO();
        Appointment appt = apptDAO.getAppointmentById(apptId);
        if (appt == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy cuộc hẹn cấp cứu.");
            response.sendRedirect(request.getContextPath() + "/receptionist/emergency/queue");
            return;
        }

        TriageRecordDAO triageDAO = new TriageRecordDAO();
        TriageRecord triage = triageDAO.getByAppointment(apptId);

        request.setAttribute("appt", appt);
        request.setAttribute("triage", triage);
        request.getRequestDispatcher("/views/receptionist/emergencyTriage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdStr = request.getParameter("apptId");
        String level = util.ValidationUtils.sanitize(request.getParameter("conditionLevel"));
        String symptoms = util.ValidationUtils.sanitize(request.getParameter("initialSymptoms"));

        if (!util.ValidationUtils.isNotEmpty(apptIdStr)
                || !util.ValidationUtils.isIntegerInRange(apptIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Cuộc hẹn không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/receptionist/emergency/queue");
            return;
        }
        int apptId = Integer.parseInt(apptIdStr);

        // Validate 4 levels: Critical, High, Medium, Low
        if (!("Critical".equalsIgnoreCase(level) || 
              "High".equalsIgnoreCase(level) || 
              "Medium".equalsIgnoreCase(level) || 
              "Low".equalsIgnoreCase(level))) {
            request.setAttribute("error", "Vui lòng chọn mức độ ưu tiên (Critical / High / Medium / Low).");
            doGet(request, response);
            return;
        }

        if (!util.ValidationUtils.isNotEmpty(symptoms)
                || !util.ValidationUtils.isLengthValid(symptoms, 5, 2000)) {
            request.setAttribute("error", "Triệu chứng ban đầu phải có từ 5 đến 2000 ký tự.");
            doGet(request, response);
            return;
        }

        TriageRecordDAO triageDAO = new TriageRecordDAO();
        boolean ok = triageDAO.upsertForAppointment(apptId, account.getUserId(), level, symptoms);
        if (ok) {
            // Optionally mark as Checked-in so vet thấy trong queue
            AppointmentDAO apptDAO = new AppointmentDAO();
            apptDAO.changeAppointmentStatus(apptId, "Checked-in");
            session.setAttribute("toastMessage", "success|Đã triage ca cấp cứu.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể lưu thông tin triage.");
        }

        response.sendRedirect(request.getContextPath() + "/receptionist/emergency/queue");
    }
}

