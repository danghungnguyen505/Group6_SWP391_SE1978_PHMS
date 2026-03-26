package controller.petOwner;

import dal.AppointmentDAO;
import dal.FeedbackDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.Appointment;
import model.Feedback;
import model.User;
import util.PaginationUtils;
import java.util.Date;

@WebServlet(name = "MyAppointmentController", urlPatterns = {"/myAppointment"})
public class MyAppointmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> allList = dao.getAppointmentsByOwnerId(account.getUserId());

        List<Appointment> upcomingList = new ArrayList<>();
        List<Appointment> historyList = new ArrayList<>();

        Date now = new Date();
        for (Appointment a : allList) {
            String status = a.getStatus();
            Date startTime = a.getStartTime();
            boolean isActiveStatus = "Pending".equalsIgnoreCase(status)
                    || "Confirmed".equalsIgnoreCase(status);
            boolean isFuture = startTime != null && startTime.after(now);
            if (isActiveStatus && isFuture) {
                upcomingList.add(a);
            } else {
                historyList.add(a);
            }
        }

        // Build set of apptIds that already have feedback
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> existingFeedbacks = feedbackDAO.getFeedbacksByOwner(account.getUserId());
        Set<Integer> feedbackedApptIds = new HashSet<>();
        for (Feedback f : existingFeedbacks) {
            feedbackedApptIds.add(f.getApptId());
        }
        request.setAttribute("feedbackedApptIds", feedbackedApptIds);

        // Pagination for history
        int page = 1;
        int pageSize = 5;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int totalPages = PaginationUtils.getTotalPages(historyList, pageSize);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<Appointment> paginatedHistory = PaginationUtils.getPage(historyList, page, pageSize);

        request.setAttribute("upcomingList", upcomingList);
        request.setAttribute("historyList", paginatedHistory);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("/views/petOwner/myAppointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
