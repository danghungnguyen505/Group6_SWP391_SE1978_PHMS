package controller.admin;

import dal.StaffAccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Admin deletes staff account.
 * SRP: Delete staff account only.
 */
@WebServlet(name = "StaffAccountDeleteController", urlPatterns = {"/admin/staff/delete"})
public class StaffAccountDeleteController extends HttpServlet {
    
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
        
        String idStr = request.getParameter("id");
        if (!util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Staff ID không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            return;
        }
        
        int id = Integer.parseInt(idStr);
        
        // Prevent self-deletion
        if (id == account.getUserId()) {
            session.setAttribute("toastMessage", "error|Bạn không thể xóa tài khoản của chính mình.");
            response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            return;
        }
        
        StaffAccountDAO staffDAO = new StaffAccountDAO();
        boolean ok = staffDAO.deleteStaffAccount(id);
        
        if (ok) {
            session.setAttribute("toastMessage", "success|Đã xóa tài khoản nhân viên thành công.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể xóa tài khoản (có thể nhân viên đang có lịch hẹn hoặc dữ liệu liên quan).");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/staff/list");
    }
}
