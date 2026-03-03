package controller.admin;

import dal.StaffAccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;
import util.PaginationUtils;

/**
 * Admin views staff account list with pagination.
 * SRP: Read list only.
 */
@WebServlet(name = "StaffAccountListController", urlPatterns = {"/admin/staff/list"})
public class StaffAccountListController extends HttpServlet {
    
    private static final int PAGE_SIZE = 10;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        StaffAccountDAO staffDAO = new StaffAccountDAO();
        int totalStaff = staffDAO.getTotalStaffAccounts();
        
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int totalPages = (int) Math.ceil((double) totalStaff / PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        
        List<User> staffAccounts = staffDAO.getAllStaffAccounts(page, PAGE_SIZE);
        
        request.setAttribute("staffAccounts", staffAccounts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("pageSize", PAGE_SIZE);
        
        request.getRequestDispatcher("/views/admin/staffList.jsp").forward(request, response);
    }
}
