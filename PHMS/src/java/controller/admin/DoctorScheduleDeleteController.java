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
@WebServlet(name = "DoctorScheduleDeleteController", urlPatterns = { "/admin/doctor/schedule/delete" })
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

        String scheduleIdsStr = request.getParameter("scheduleId");
        String date = request.getParameter("date");
        String doctorId = request.getParameter("doctorId");

        if (scheduleIdsStr == null || scheduleIdsStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "error|Dữ liệu không hợp lệ (không có scheduleId).");
            response.sendRedirect(buildReturnUrl(request, date, doctorId));
            return;
        }

        java.util.List<Integer> ids = new java.util.ArrayList<>();
        try {
            for (String idPart : scheduleIdsStr.split(",")) {
                if (!idPart.trim().isEmpty()) {
                    ids.add(Integer.parseInt(idPart.trim()));
                }
            }
        } catch (Exception e) {
            session.setAttribute("toastMessage", "error|Dữ liệu không hợp lệ (lỗi format scheduleId).");
            response.sendRedirect(buildReturnUrl(request, date, doctorId));
            return;
        }

        if (ids.isEmpty()) {
            session.setAttribute("toastMessage", "error|Không có lịch nào để xoá.");
            response.sendRedirect(buildReturnUrl(request, date, doctorId));
            return;
        }

        ScheduleVeterianrianDAO dao = new ScheduleVeterianrianDAO();
        // Check the first schedule to validate date & empId
        model.Schedule firstSchedule = dao.getScheduleById(ids.get(0));
        if (firstSchedule == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy lịch cần xoá (có thể đã bị xoá).");
            response.sendRedirect(buildReturnUrl(request, date, doctorId));
            return;
        }

        // Block deletion if that vet already has any (non-cancelled) appointment on
        // that date
        AppointmentDAO apptDao = new AppointmentDAO();
        if (firstSchedule.getWorkDate() != null
                && apptDao.hasAppointmentsForVetOnDate(firstSchedule.getEmpId(), firstSchedule.getWorkDate())) {
            session.setAttribute("toastMessage", "error|Không thể xoá lịch vì bác sĩ đã có cuộc hẹn trong ngày này.");
            response.sendRedirect(buildReturnUrl(request, date, doctorId));
            return;
        }

        boolean ok = dao.deleteSchedulesByIds(ids);
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