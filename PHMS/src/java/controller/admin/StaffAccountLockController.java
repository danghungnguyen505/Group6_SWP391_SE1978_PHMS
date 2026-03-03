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
 * Admin locks staff account.
 * SRP: Lock staff account only.
 */
@WebServlet(name = "StaffAccountLockController", urlPatterns = {"/admin/staff/lock"})
public class StaffAccountLockController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("account");
        
        // Kiểm tra quyền
        if (currentUser == null || (!"ClinicManager".equalsIgnoreCase(currentUser.getRole())
                && !"Admin".equalsIgnoreCase(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("list");
            return;
        }
        
        int targetId = Integer.parseInt(idStr);
        
        // Không cho phép tự khóa chính mình
        if (targetId == currentUser.getUserId()) {
            session.setAttribute("toastMessage", "error|Bạn không thể tự khóa tài khoản của chính mình!");
            response.sendRedirect("list");
            return;
        }
        
        StaffAccountDAO staffDAO = new StaffAccountDAO();
        boolean success = staffDAO.toggleStaffStatus(targetId);
        
        if (success) {
            session.setAttribute("toastMessage", "success|Cập nhật trạng thái tài khoản thành công.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể cập nhật. Nhân viên có thể đang có lịch hẹn chờ xử lý.");
        }
        
        response.sendRedirect("list");
    }
}