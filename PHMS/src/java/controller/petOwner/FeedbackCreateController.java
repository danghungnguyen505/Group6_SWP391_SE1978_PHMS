package controller.petOwner;

import dal.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * PetOwner creates feedback for completed appointment.
 * SRP: Create feedback only.
 */
@WebServlet(name = "FeedbackCreateController", urlPatterns = {"/feedback/create"})
public class FeedbackCreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdStr = request.getParameter("apptId");
        if (apptIdStr == null || apptIdStr.trim().isEmpty()) {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            java.util.List<model.Appointment> appointments = feedbackDAO.getAppointmentsForFeedback(account.getUserId());
            request.setAttribute("appointments", appointments);
            request.getRequestDispatcher("/views/petOwner/feedbackCreate.jsp").forward(request, response);
            return;
        }

        if (!util.ValidationUtils.isIntegerInRange(apptIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Appointment không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/feedback/create");
            return;
        }

        int apptId = Integer.parseInt(apptIdStr);
        dal.AppointmentDAO apptDAO = new dal.AppointmentDAO();
        model.Appointment appt = apptDAO.getAppointmentByIdForOwner(apptId, account.getUserId());

        if (appt == null || !"Completed".equalsIgnoreCase(appt.getStatus())) {
            session.setAttribute("toastMessage", "error|Không tìm thấy lịch hẹn hoặc lịch hẹn chưa hoàn thành.");
            response.sendRedirect(request.getContextPath() + "/feedback/create");
            return;
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        model.Feedback existingFeedback = feedbackDAO.getFeedbackByAppointmentAndOwner(apptId, account.getUserId());
        if (existingFeedback != null) {
            boolean canEdit = "New".equalsIgnoreCase(existingFeedback.getStatus());
            request.setAttribute("appt", appt);
            request.setAttribute("existingFeedback", existingFeedback);
            request.setAttribute("canEdit", canEdit);
            request.setAttribute("rating", String.valueOf(existingFeedback.getRating()));
            request.setAttribute("comment", existingFeedback.getComment());
            if (canEdit) {
                request.setAttribute("infoMessage", "Feedback chưa được đọc, bạn có thể chỉnh sửa và gửi lại.");
            } else {
                request.setAttribute("infoMessage", "Feedback đã được đọc, không thể sửa.");
            }
            request.getRequestDispatcher("/views/petOwner/feedbackForm.jsp").forward(request, response);
            return;
        }

        request.setAttribute("appt", appt);
        request.getRequestDispatcher("/views/petOwner/feedbackForm.jsp").forward(request, response);
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

        String apptIdStr = request.getParameter("apptId");
        String ratingStr = request.getParameter("rating");
        String comment = util.ValidationUtils.sanitize(request.getParameter("comment"));

        if (!util.ValidationUtils.isNotEmpty(apptIdStr)
                || !util.ValidationUtils.isIntegerInRange(apptIdStr, 1, Integer.MAX_VALUE)) {
            request.setAttribute("error", "Appointment không hợp lệ.");
            doGet(request, response);
            return;
        }

        if (!util.ValidationUtils.isNotEmpty(ratingStr)
                || !util.ValidationUtils.isIntegerInRange(ratingStr, 1, 5)) {
            request.setAttribute("error", "Vui lòng chọn đánh giá từ 1 đến 5 sao.");
            request.setAttribute("apptId", apptIdStr);
            doGet(request, response);
            return;
        }

        if (!util.ValidationUtils.isNotEmpty(comment)
                || !util.ValidationUtils.isLengthValid(comment, 5, 1000)) {
            request.setAttribute("error", "Bình luận phải có từ 5 đến 1000 ký tự.");
            request.setAttribute("apptId", apptIdStr);
            request.setAttribute("rating", ratingStr);
            doGet(request, response);
            return;
        }

        int apptId = Integer.parseInt(apptIdStr);
        int rating = Integer.parseInt(ratingStr);

        dal.AppointmentDAO apptDAO = new dal.AppointmentDAO();
        model.Appointment appt = apptDAO.getAppointmentByIdForOwner(apptId, account.getUserId());
        if (appt == null || !"Completed".equalsIgnoreCase(appt.getStatus())) {
            session.setAttribute("toastMessage", "error|Không tìm thấy lịch hẹn hoặc lịch hẹn chưa hoàn thành.");
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        model.Feedback existingFeedback = feedbackDAO.getFeedbackByAppointmentAndOwner(apptId, account.getUserId());

        if (existingFeedback != null) {
            if ("New".equalsIgnoreCase(existingFeedback.getStatus())) {
                boolean updated = feedbackDAO.updateFeedbackIfNew(apptId, account.getUserId(), rating, comment);
                if (updated) {
                    session.setAttribute("toastMessage", "success|Đã cập nhật feedback thành công!");
                } else {
                    session.setAttribute("toastMessage", "error|Không thể cập nhật feedback lúc này.");
                }
            } else {
                session.setAttribute("toastMessage", "error|Feedback đã được đọc, không thể sửa. Trạng thái New là chưa đọc.");
            }
            response.sendRedirect(request.getContextPath() + "/myAppointment");
            return;
        }

        boolean ok = feedbackDAO.createFeedback(apptId, account.getUserId(), rating, comment);

        if (ok) {
            session.setAttribute("toastMessage", "success|Cảm ơn bạn đã gửi phản hồi!");
            response.sendRedirect(request.getContextPath() + "/myAppointment");
        } else {
            request.setAttribute("error", "Không thể gửi feedback. Có thể bạn đã gửi feedback cho lịch hẹn này rồi.");
            request.setAttribute("apptId", apptIdStr);
            doGet(request, response);
        }
    }
}
