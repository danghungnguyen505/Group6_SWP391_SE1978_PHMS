package controller.receptionist;

import dal.AppointmentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import model.Appointment;
import model.User;

@WebServlet(name = "DashboardReceptionistController", urlPatterns = {"/receptionist/dashboard"})
public class DashboardReceptionistController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();

        // 1. Pending list (approve/reject)
        List<Appointment> pendingList = dao.getPendingAppointments();
        request.setAttribute("pendingList", pendingList);

        // 2. Today's list – sorted newest (latest startTime) first
        List<Appointment> todayList = dao.getTodayAppointments();
        if (todayList != null) {
            Collections.sort(todayList, new Comparator<Appointment>() {
                @Override
                public int compare(Appointment a, Appointment b) {
                    if (a.getStartTime() == null && b.getStartTime() == null) return 0;
                    if (a.getStartTime() == null) return 1;
                    if (b.getStartTime() == null) return -1;
                    return b.getStartTime().compareTo(a.getStartTime()); // descending
                }
            });
        }

        // Pagination for today list
        int totalItems = (todayList == null) ? 0 : todayList.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;

        int currentPage = 1;
        String pageParam = request.getParameter("todayPage");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalItems);
        List<Appointment> pagedList = (todayList == null || todayList.isEmpty())
                ? java.util.Collections.emptyList()
                : todayList.subList(fromIndex, toIndex);

        request.setAttribute("pagedTodayList", pagedList);
        request.setAttribute("todayCurrentPage", currentPage);
        request.setAttribute("totalTodayPages", totalPages);
        request.setAttribute("totalTodayItems", totalItems);

        request.getRequestDispatcher("/views/receptionist/dashboardReceptionist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
