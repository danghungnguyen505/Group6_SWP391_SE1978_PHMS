package controller.veterinarian;

import dal.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Appointment;
import model.User;
import util.PaginationUtils;

/**
 * Veterinarian EMR Queue - list checked-in appointments for today.
 * SRP: Read queue only.
 */
@WebServlet(name = "EmrQueueController", urlPatterns = {"/veterinarian/emr/queue"})
public class EmrQueueController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> all = dao.getTodayCheckedInAppointmentsForVet(account.getUserId());

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
        List<Appointment> list = PaginationUtils.getPage(all, page, PAGE_SIZE);

        request.setAttribute("queueList", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/views/veterinarian/emrQueue.jsp").forward(request, response);
    }
}

