package controller.admin;

import dal.AppointmentDAO;
import dal.ScheduleVeterianrianDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import model.User;

/**
 * Admin deletes a single schedule by schedule_id.
 * Triggered from weekly scheduling UI (click on a shift card).
 */
@WebServlet(name = "DoctorScheduleDeleteController", urlPatterns = {"/admin/doctor/schedule/delete"})
public class DoctorScheduleDeleteController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String scheduleIdStr = request.getParameter("scheduleId");
        String date = request.getParameter("date");
        String doctorId = request.getParameter("doctorId");

        int scheduleId;
        try {
            scheduleId = Integer.parseInt(scheduleIdStr);
        } catch (Exception e) {
            session.setAttribute("toastMessage", "error|Dữ liệu không hợp lệ (scheduleId).");
            response.sendRedirect(buildReturnUrl(request, date, doctorId));
            return;
        }

        ScheduleVeterianrianDAO dao = new ScheduleVeterianrianDAO();
        model.Schedule schedule = dao.getScheduleById(scheduleId);
        if (schedule == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy lịch cần xoá (có thể đã bị xoá trước đó).");
            response.sendRedirect(buildReturnUrl(request, date, doctorId));
            return;
        }

        // Block deletion if that vet already has any (non-cancelled) appointment on that date
        AppointmentDAO apptDao = new AppointmentDAO();
        if (schedule.getWorkDate() != null
                && apptDao.hasAppointmentsForVetOnDate(schedule.getEmpId(), schedule.getWorkDate())) {
            session.setAttribute("toastMessage", "error|Không thể xoá lịch vì bác sĩ đã có cuộc hẹn trong ngày này.");
            response.sendRedirect(buildReturnUrl(request, date, doctorId));
            return;
        }

        boolean ok = dao.deleteScheduleById(scheduleId);
        if (ok) {
            session.setAttribute("toastMessage", "success|Đã xoá lịch làm việc thành công.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể xoá lịch (có thể đã bị xoá trước đó).");
        }

        response.sendRedirect(buildReturnUrl(request, date, doctorId));
    }

    private String buildReturnUrl(HttpServletRequest request, String date, String doctorId) {
        StringBuilder url = new StringBuilder();
        url.append(request.getContextPath()).append("/admin/doctor/schedule/list");

        boolean hasParam = false;
        if (date != null && !date.trim().isEmpty()) {
            url.append(hasParam ? "&" : "?");
            url.append("date=").append(URLEncoder.encode(date.trim(), StandardCharsets.UTF_8));
            hasParam = true;
        }
        if (doctorId != null && !doctorId.trim().isEmpty()) {
            url.append(hasParam ? "&" : "?");
            url.append("doctorId=").append(URLEncoder.encode(doctorId.trim(), StandardCharsets.UTF_8));
        }
        return url.toString();
    }
}

