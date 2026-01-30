/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.petOwner;

import dal.AppointmentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.Date;
import model.Appointment;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "AppointmentActionController", urlPatterns = {"/appointment-action"})
public class AppointmentActionController extends HttpServlet {

    private static final int WORK_START_HOUR = 8;
    private static final int WORK_END_HOUR = 17;

    @Override
    //Hiển thị trang xác nhận Hủy/Đổi lịch
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        String idStr = request.getParameter("id");
        String type = request.getParameter("type"); // 'cancel' hoặc 'reschedule'
        if (idStr != null) {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appt = dao.getAppointmentById(Integer.parseInt(idStr));
            // Logic kiểm tra 5 tiếng
            long hoursPassed = 0;
            if (appt.getCreatedAt() != null) {
                Date now = new Date();
                // Thời gian trôi qua = Hiện tại - Lúc đặt
                long diffMs = now.getTime() - appt.getCreatedAt().getTime();
                hoursPassed = diffMs / (60 * 60 * 1000);
            } else {
                // Nếu data cũ chưa có createdAt, mặc định cho phép hoặc chặn (ở đây cho là 0)
                hoursPassed = 999; // Coi như đã quá hạn để an toàn
            }
            // Nếu đã trôi qua >= 5 tiếng -> KHÓA
            boolean isLocked = hoursPassed >= 5;
            request.setAttribute("appt", appt);
            request.setAttribute("isLocked", isLocked);
            request.setAttribute("actionType", type);
            request.getRequestDispatcher("/views/petOwner/appointmentAction.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/my-appointments");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int apptId = Integer.parseInt(request.getParameter("apptId"));
        AppointmentDAO dao = new AppointmentDAO();
        Appointment appt = dao.getAppointmentById(apptId);
        // Check lại logic 5 tiếng ở Backend
        long hoursPassed = 0;
        if (appt.getCreatedAt() != null) {
            Date now = new Date();
            long diffMs = now.getTime() - appt.getCreatedAt().getTime();
            hoursPassed = diffMs / (60 * 60 * 1000);
        } else {
            hoursPassed = 999;
        }
        if (hoursPassed >= 5) {// Nếu đã quá 5 tiếng -> Chặn
            request.getSession().setAttribute("toastMessage", "error|Hành động bị từ chối! Đã quá thời gian cho phép hủy kể từ khi đặt lịch.");
            response.sendRedirect(request.getContextPath() + "/my-appointments");
            return;
        }
        // Xử lý Hủy/Đổi nếu còn trong 5 tiếng
        if ("confirm_cancel".equals(action)) {
            dao.updateAppointmentStatus(apptId, "Cancelled");
            request.getSession().setAttribute("toastMessage", "success|Đã hủy lịch hẹn.");
        } else if ("confirm_reschedule".equals(action)) {
            String newDate = request.getParameter("newDate");
            String newTime = request.getParameter("newTime");
            String dateTimeStr = newDate + " " + newTime + ":00";
            Timestamp newStart = Timestamp.valueOf(dateTimeStr);
            dao.rescheduleAppointment(apptId, newStart);
            request.getSession().setAttribute("toastMessage", "success|Đã gửi yêu cầu đổi lịch.");
        }
        response.sendRedirect(request.getContextPath() + "/my-appointments");
    }

}
