<<<<<<< Updated upstream
package controller.hrm;

import dal.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.LeaveRequest;
import model.User;
import util.LeaveAutoBlockService;

/**
 * ClinicManager approve/reject leave request.
 * SRP: Update status (and trigger auto-block) only.
 */
@WebServlet(name = "LeaveRequestUpdateStatusController", urlPatterns = {"/admin/leave/update-status"})
public class LeaveRequestUpdateStatusController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"ClinicManager".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        String action = request.getParameter("action"); // approve / reject

        if (!util.ValidationUtils.isNotEmpty(idStr)
                || !util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)
                || !util.ValidationUtils.isNotEmpty(action)) {
            session.setAttribute("toastMessage", "error|Dữ liệu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/leave/pending");
            return;
        }

        int leaveId = Integer.parseInt(idStr);
        String newStatus;
        if ("approve".equalsIgnoreCase(action)) {
            newStatus = "Approved";
        } else if ("reject".equalsIgnoreCase(action)) {
            newStatus = "Rejected";
        } else {
            session.setAttribute("toastMessage", "error|Hành động không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/leave/pending");
            return;
        }

        LeaveRequestDAO dao = new LeaveRequestDAO();
        // Lấy lại đơn để phục vụ auto-block nếu cần
        LeaveRequest lr = dao.getByIdForManager(leaveId, account.getUserId());
        if (lr == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy đơn nghỉ hoặc bạn không có quyền duyệt.");
            response.sendRedirect(request.getContextPath() + "/admin/leave/pending");
            return;
        }

        boolean ok = dao.updateStatus(leaveId, account.getUserId(), newStatus);
        if (ok) {
            if ("Approved".equals(newStatus)) {
                // Auto-block schedules & appointments for this staff and date
                LeaveAutoBlockService.autoBlockForLeave(lr.getEmpId(), lr.getStartDate());
                session.setAttribute("toastMessage", "success|Đã duyệt đơn nghỉ và cập nhật lịch làm việc/cuộc hẹn.");
            } else {
                session.setAttribute("toastMessage", "success|Đã từ chối đơn nghỉ.");
            }
        } else {
            session.setAttribute("toastMessage", "error|Không thể cập nhật trạng thái (đơn có thể đã được xử lý).");
        }

        response.sendRedirect(request.getContextPath() + "/admin/leave/pending");
    }
}

=======
package controller.hrm;

import dal.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.LeaveRequest;
import model.User;
import util.LeaveAutoBlockService;

/**
 * ClinicManager approve/reject leave request.
 * SRP: Update status (and trigger auto-block) only.
 */
@WebServlet(name = "LeaveRequestUpdateStatusController", urlPatterns = {"/admin/leave/update-status"})
public class LeaveRequestUpdateStatusController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"ClinicManager".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        String action = request.getParameter("action"); // approve / reject

        if (!util.ValidationUtils.isNotEmpty(idStr)
                || !util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)
                || !util.ValidationUtils.isNotEmpty(action)) {
            session.setAttribute("toastMessage", "error|Dữ liệu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/leave/pending");
            return;
        }

        int leaveId = Integer.parseInt(idStr);
        String newStatus;
        if ("approve".equalsIgnoreCase(action)) {
            newStatus = "Approved";
        } else if ("reject".equalsIgnoreCase(action)) {
            newStatus = "Rejected";
        } else {
            session.setAttribute("toastMessage", "error|Hành động không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/leave/pending");
            return;
        }

        LeaveRequestDAO dao = new LeaveRequestDAO();
        // Lấy lại đơn để phục vụ auto-block nếu cần
        LeaveRequest lr = dao.getByIdForManager(leaveId, account.getUserId());
        if (lr == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy đơn nghỉ hoặc bạn không có quyền duyệt.");
            response.sendRedirect(request.getContextPath() + "/admin/leave/pending");
            return;
        }

        boolean ok = dao.updateStatus(leaveId, account.getUserId(), newStatus);
        if (ok) {
            if ("Approved".equals(newStatus)) {
                // Auto-block schedules & appointments for this staff and date
                LeaveAutoBlockService.autoBlockForLeave(lr.getEmpId(), lr.getStartDate());
                session.setAttribute("toastMessage", "success|Đã duyệt đơn nghỉ và cập nhật lịch làm việc/cuộc hẹn.");
            } else {
                session.setAttribute("toastMessage", "success|Đã từ chối đơn nghỉ.");
            }
        } else {
            session.setAttribute("toastMessage", "error|Không thể cập nhật trạng thái (đơn có thể đã được xử lý).");
        }

        response.sendRedirect(request.getContextPath() + "/admin/leave/pending");
    }
}

>>>>>>> Stashed changes
