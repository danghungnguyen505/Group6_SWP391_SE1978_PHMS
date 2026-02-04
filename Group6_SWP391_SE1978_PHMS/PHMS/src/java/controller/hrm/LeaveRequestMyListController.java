package controller.hrm;

import dal.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.LeaveRequest;
import model.User;
import util.PaginationUtils;

/**
 * Staff view own leave requests.
 * SRP: Read list only.
 */
@WebServlet(name = "LeaveRequestMyListController", urlPatterns = {"/leave/my-requests"})
public class LeaveRequestMyListController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

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

        LeaveRequestDAO dao = new LeaveRequestDAO();
        List<LeaveRequest> all = dao.listByEmployee(account.getUserId());

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalPages = PaginationUtils.getTotalPages(all, PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<LeaveRequest> list = PaginationUtils.getPage(all, page, PAGE_SIZE);

        request.setAttribute("requests", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/views/hrm/leaveMyList.jsp").forward(request, response);
    }
}

