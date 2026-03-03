<<<<<<< Updated upstream
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
import java.util.Date;
import model.Appointment;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "AppointmentActionController", urlPatterns = {"/appointment-action"})
public class AppointmentActionController extends HttpServlet {

    // PetOwner chỉ được hủy/đổi lịch nếu còn >= 5 tiếng trước giờ hẹn
    private static final int CANCEL_RESCHEDULE_LIMIT_HOURS = 5;

    @Override
    //Hiển thị trang xác nhận Hủy/Đổi lịch
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idStr = request.getParameter("id");
        String type = request.getParameter("type"); // 'cancel' hoặc 'reschedule'
        if (idStr != null && !idStr.trim().isEmpty()) {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appt;
            try {
                int apptId = Integer.parseInt(idStr);
                appt = dao.getAppointmentByIdForOwner(apptId, account.getUserId());
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/myAppointment");
                return;
            }

            if (appt == null) {
                session.setAttribute("toastMessage", "error|Không tìm thấy lịch hẹn hoặc bạn không có quyền thao tác.");
                response.sendRedirect(request.getContextPath() + "/myAppointment");
                return;
            }

            // Chỉ cho phép thao tác khi appointment còn Pending/Confirmed
            boolean isActionStatusAllowed = "Pending".equalsIgnoreCase(appt.getStatus())
                    || "Confirmed".equalsIgnoreCase(appt.getStatus());

            // Check điều kiện thời gian: còn >= 5 tiếng trước start_time
            Date now = new Date();
            long diffMs = appt.getStartTime().getTime() - now.getTime();
            long hoursUntilStart = diffMs / (60 * 60 * 1000);
            boolean isLocked = !isActionStatusAllowed || hoursUntilStart < CANCEL_RESCHEDULE_LIMIT_HOURS;

            request.setAttribute("appt", appt);
            request.setAttribute("isLocked", isLocked);
            request.setAttribute("actionType", type);
            request.getRequestDispatcher("/views/petOwner/appointmentAction.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/myAppointment");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String apptIdStr = request.getParameter("apptId");
        if (action == null || apptIdStr == null || apptIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        int apptId;
        try {
            apptId = Integer.parseInt(apptIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        Appointment appt = dao.getAppointmentByIdForOwner(apptId, account.getUserId());
        if (appt == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy lịch hẹn hoặc bạn không có quyền thao tác.");
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        boolean isActionStatusAllowed = "Pending".equalsIgnoreCase(appt.getStatus())
                || "Confirmed".equalsIgnoreCase(appt.getStatus());

        Date now = new Date();
        long diffMs = appt.getStartTime().getTime() - now.getTime();
        long hoursUntilStart = diffMs / (60 * 60 * 1000);
        if (!isActionStatusAllowed || hoursUntilStart < CANCEL_RESCHEDULE_LIMIT_HOURS) {
            session.setAttribute("toastMessage", "error|Hành động bị từ chối! Bạn chỉ có thể hủy/đổi lịch trước giờ hẹn ít nhất 5 tiếng.");
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        if ("confirm_cancel".equals(action)) {
            boolean ok = dao.cancelAppointmentByOwner(apptId, account.getUserId());
            if (ok) {
                session.setAttribute("toastMessage", "success|Đã hủy lịch hẹn.");
            } else {
                session.setAttribute("toastMessage", "error|Không thể hủy lịch (có thể trạng thái đã thay đổi).");
            }
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        if ("confirm_reschedule".equals(action)) {
            // Redirect sang trang booking để chọn lại slot, và lưu rescheduleId để SaveAppointmentController update
            String redirectUrl = request.getContextPath() + "/booking"
                    + "?petId=" + appt.getPetId()
                    + "&serviceType=" + appt.getType()
                    + "&selectedDate=" + new java.text.SimpleDateFormat("yyyy-MM-dd").format(appt.getStartTime())
                    + "&vetId=" + appt.getVetId()
                    + "&rescheduleId=" + apptId;
            session.setAttribute("toastMessage", "success|Vui lòng chọn lịch mới để gửi yêu cầu đổi lịch.");
            response.sendRedirect(redirectUrl);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/myAppointment");
    }

}
=======
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
import java.util.Date;
import model.Appointment;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "AppointmentActionController", urlPatterns = {"/appointment-action"})
public class AppointmentActionController extends HttpServlet {

    // PetOwner chỉ được hủy/đổi lịch nếu còn >= 5 tiếng trước giờ hẹn
    private static final int CANCEL_RESCHEDULE_LIMIT_HOURS = 5;

    @Override
    //Hiển thị trang xác nhận Hủy/Đổi lịch
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idStr = request.getParameter("id");
        String type = request.getParameter("type"); // 'cancel' hoặc 'reschedule'
        if (idStr != null && !idStr.trim().isEmpty()) {
            AppointmentDAO dao = new AppointmentDAO();
            Appointment appt;
            try {
                int apptId = Integer.parseInt(idStr);
                appt = dao.getAppointmentByIdForOwner(apptId, account.getUserId());
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/myAppointment");
                return;
            }

            if (appt == null) {
                session.setAttribute("toastMessage", "error|Không tìm thấy lịch hẹn hoặc bạn không có quyền thao tác.");
                response.sendRedirect(request.getContextPath() + "/myAppointment");
                return;
            }

            // Chỉ cho phép thao tác khi appointment còn Pending/Confirmed
            boolean isActionStatusAllowed = "Pending".equalsIgnoreCase(appt.getStatus())
                    || "Confirmed".equalsIgnoreCase(appt.getStatus());

            // Check điều kiện thời gian: còn >= 5 tiếng trước start_time
            Date now = new Date();
            long diffMs = appt.getStartTime().getTime() - now.getTime();
            long hoursUntilStart = diffMs / (60 * 60 * 1000);
            boolean isLocked = !isActionStatusAllowed || hoursUntilStart < CANCEL_RESCHEDULE_LIMIT_HOURS;

            request.setAttribute("appt", appt);
            request.setAttribute("isLocked", isLocked);
            request.setAttribute("actionType", type);
            request.getRequestDispatcher("/views/petOwner/appointmentAction.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/myAppointment");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String apptIdStr = request.getParameter("apptId");
        if (action == null || apptIdStr == null || apptIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        int apptId;
        try {
            apptId = Integer.parseInt(apptIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        Appointment appt = dao.getAppointmentByIdForOwner(apptId, account.getUserId());
        if (appt == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy lịch hẹn hoặc bạn không có quyền thao tác.");
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        boolean isActionStatusAllowed = "Pending".equalsIgnoreCase(appt.getStatus())
                || "Confirmed".equalsIgnoreCase(appt.getStatus());

        Date now = new Date();
        long diffMs = appt.getStartTime().getTime() - now.getTime();
        long hoursUntilStart = diffMs / (60 * 60 * 1000);
        if (!isActionStatusAllowed || hoursUntilStart < CANCEL_RESCHEDULE_LIMIT_HOURS) {
            session.setAttribute("toastMessage", "error|Hành động bị từ chối! Bạn chỉ có thể hủy/đổi lịch trước giờ hẹn ít nhất 5 tiếng.");
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        if ("confirm_cancel".equals(action)) {
            boolean ok = dao.cancelAppointmentByOwner(apptId, account.getUserId());
            if (ok) {
                session.setAttribute("toastMessage", "success|Đã hủy lịch hẹn.");
            } else {
                session.setAttribute("toastMessage", "error|Không thể hủy lịch (có thể trạng thái đã thay đổi).");
            }
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        if ("confirm_reschedule".equals(action)) {
            // Redirect sang trang booking để chọn lại slot, và lưu rescheduleId để SaveAppointmentController update
            String redirectUrl = request.getContextPath() + "/booking"
                    + "?petId=" + appt.getPetId()
                    + "&serviceType=" + appt.getType()
                    + "&selectedDate=" + new java.text.SimpleDateFormat("yyyy-MM-dd").format(appt.getStartTime())
                    + "&vetId=" + appt.getVetId()
                    + "&rescheduleId=" + apptId;
            session.setAttribute("toastMessage", "success|Vui lòng chọn lịch mới để gửi yêu cầu đổi lịch.");
            response.sendRedirect(redirectUrl);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/myAppointment");
    }

}
>>>>>>> Stashed changes
