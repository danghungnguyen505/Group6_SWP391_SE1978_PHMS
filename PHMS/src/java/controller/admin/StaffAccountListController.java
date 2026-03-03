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
<<<<<<< Updated upstream
        int totalStaff = staffDAO.getTotalStaffAccounts();
=======

        String search = request.getParameter("search");
        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");
>>>>>>> Stashed changes
        
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
        
<<<<<<< Updated upstream
        int totalPages = (int) Math.ceil((double) totalStaff / PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        
        List<User> staffAccounts = staffDAO.getAllStaffAccounts(page, PAGE_SIZE);
=======
        int totalStaff = staffDAO.getTotalStaffAccounts(search, roleFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) totalStaff / PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        
        List<User> staffAccounts = staffDAO.getAllStaffAccounts(page, PAGE_SIZE, search, roleFilter, statusFilter);
>>>>>>> Stashed changes
        
        request.setAttribute("staffAccounts", staffAccounts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("pageSize", PAGE_SIZE);
<<<<<<< Updated upstream
=======
        request.setAttribute("searchKeyword", search);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);
>>>>>>> Stashed changes
        
        request.getRequestDispatcher("/views/admin/staffList.jsp").forward(request, response);
    }
}
