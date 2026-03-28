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

        String ratingFilter = request.getParameter("ratingFilter");
        if (ratingFilter != null && (ratingFilter.isEmpty() || "all".equals(ratingFilter))) {
            ratingFilter = null;
        }

        String statusFilter = request.getParameter("statusFilter");
        if (statusFilter != null && (statusFilter.isEmpty() || "all".equals(statusFilter))) {
            statusFilter = null;
        }

        int totalFeedbacks = feedbackDAO.getTotalFeedbacks(ratingFilter, statusFilter);
        int pageSize = PaginationUtils.normalizePageSize(request.getParameter("size"), PAGE_SIZE);

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

        int totalPages = (int) Math.ceil((double) totalFeedbacks / pageSize);
        page = PaginationUtils.getValidPage(page, totalPages);

        List<Feedback> feedbacks = feedbackDAO.getAllFeedbacks(page, pageSize, ratingFilter, statusFilter);

        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalFeedbacks", totalFeedbacks);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("ratingFilter", ratingFilter);
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/views/admin/feedbackList.jsp").forward(request, response);
    }

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

        String action = request.getParameter("action");
        String feedbackIdStr = request.getParameter("feedbackId");

        if (feedbackIdStr != null && action != null) {
            int feedbackId = Integer.parseInt(feedbackIdStr);
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            switch (action) {
                case "markRead":
                    feedbackDAO.updateFeedbackStatus(feedbackId, "Read");
                    break;
                case "flag":
                    feedbackDAO.updateFeedbackStatus(feedbackId, "Flagged");
                    break;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/feedback/list");
    }
}
