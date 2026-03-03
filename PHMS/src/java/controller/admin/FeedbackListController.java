<<<<<<< Updated upstream
package controller.admin;

import dal.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Feedback;
import model.User;
import util.PaginationUtils;

/**
 * Admin views all feedbacks with pagination.
 * SRP: Read list only.
 */
@WebServlet(name = "FeedbackListController", urlPatterns = {"/admin/feedback/list"})
public class FeedbackListController extends HttpServlet {
    
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
        
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        int totalFeedbacks = feedbackDAO.getTotalFeedbacks();
        
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
        
        int totalPages = (int) Math.ceil((double) totalFeedbacks / PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        
        List<Feedback> feedbacks = feedbackDAO.getAllFeedbacks(page, PAGE_SIZE);
        
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalFeedbacks", totalFeedbacks);
        request.setAttribute("pageSize", PAGE_SIZE);
        
        request.getRequestDispatcher("/views/admin/feedbackList.jsp").forward(request, response);
    }
}
=======
package controller.admin;

import dal.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Feedback;
import model.User;
import util.PaginationUtils;

/**
 * Admin views all feedbacks with pagination.
 * SRP: Read list only.
 */
@WebServlet(name = "FeedbackListController", urlPatterns = {"/admin/feedback/list"})
public class FeedbackListController extends HttpServlet {
    
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
        
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        int totalFeedbacks = feedbackDAO.getTotalFeedbacks();
        
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
        
        int totalPages = (int) Math.ceil((double) totalFeedbacks / PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        
        List<Feedback> feedbacks = feedbackDAO.getAllFeedbacks(page, PAGE_SIZE);
        
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalFeedbacks", totalFeedbacks);
        request.setAttribute("pageSize", PAGE_SIZE);
        
        request.getRequestDispatcher("/views/admin/feedbackList.jsp").forward(request, response);
    }
}
>>>>>>> Stashed changes
