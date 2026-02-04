package controller.hrm;

import dal.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import model.User;

/**
 * Staff create leave request.
 * SRP: Create leave request only.
 */
@WebServlet(name = "LeaveRequestCreateController", urlPatterns = {"/leave/request"})
public class LeaveRequestCreateController extends HttpServlet {

    private boolean isStaffRole(String role) {
        if (role == null) return false;
        String r = role.trim();
        return "Veterinarian".equalsIgnoreCase(r)
                || "Receptionist".equalsIgnoreCase(r)
                || "Nurse".equalsIgnoreCase(r)
                || "ClinicManager".equalsIgnoreCase(r);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !isStaffRole(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/views/hrm/leaveRequestForm.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !isStaffRole(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String dateStr = request.getParameter("startDate");
        String reason = util.ValidationUtils.sanitize(request.getParameter("reason"));

        // Basic validation
        if (!util.ValidationUtils.isNotEmpty(dateStr)) {
            request.setAttribute("error", "Vui lòng chọn ngày nghỉ.");
            request.setAttribute("reason", reason);
            request.getRequestDispatcher("/views/hrm/leaveRequestForm.jsp").forward(request, response);
            return;
        }

        Date startDate;
        try {
            startDate = Date.valueOf(dateStr);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Ngày nghỉ không hợp lệ.");
            request.setAttribute("reason", reason);
            request.getRequestDispatcher("/views/hrm/leaveRequestForm.jsp").forward(request, response);
            return;
        }

        Date today = new Date(System.currentTimeMillis());
        if (startDate.before(today)) {
            request.setAttribute("error", "Không thể đăng ký nghỉ trong quá khứ.");
            request.setAttribute("reason", reason);
            request.getRequestDispatcher("/views/hrm/leaveRequestForm.jsp").forward(request, response);
            return;
        }

        if (!util.ValidationUtils.isNotEmpty(reason)
                || !util.ValidationUtils.isLengthValid(reason, 5, 1000)) {
            request.setAttribute("error", "Lý do nghỉ phải có từ 5 đến 1000 ký tự.");
            request.setAttribute("reason", reason);
            request.getRequestDispatcher("/views/hrm/leaveRequestForm.jsp").forward(request, response);
            return;
        }

        LeaveRequestDAO dao = new LeaveRequestDAO();
        Integer managerId = dao.getDefaultManagerId();
        if (managerId == null) {
            request.setAttribute("error", "Không tìm thấy quản lý phê duyệt. Vui lòng liên hệ quản trị hệ thống.");
            request.setAttribute("reason", reason);
            request.getRequestDispatcher("/views/hrm/leaveRequestForm.jsp").forward(request, response);
            return;
        }

        boolean ok = dao.createRequest(account.getUserId(), managerId, startDate, reason);
        if (ok) {
            session.setAttribute("toastMessage", "success|Gửi đơn nghỉ thành công. Đang chờ phê duyệt.");
            response.sendRedirect(request.getContextPath() + "/leave/my-requests");
        } else {
            request.setAttribute("error", "Lỗi hệ thống: Không thể gửi đơn nghỉ. Vui lòng thử lại.");
            request.setAttribute("reason", reason);
            request.getRequestDispatcher("/views/hrm/leaveRequestForm.jsp").forward(request, response);
        }
    }
}

