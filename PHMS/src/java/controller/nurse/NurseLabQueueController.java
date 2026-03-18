package controller.nurse;

import dal.LabTestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.LabTest;
import model.User;
import util.PaginationUtils;

/**
 * Nurse lab queue.
 * SRP: Read list only.
 */
@WebServlet(name = "NurseLabQueueController", urlPatterns = {"/nurse/lab/queue"})
public class NurseLabQueueController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Nurse".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        LabTestDAO dao = new LabTestDAO();

        String filter = request.getParameter("filter");
        if (filter == null) filter = "requested";

        String search = request.getParameter("search");
        if (search != null && search.trim().isEmpty()) {
            search = null;
        }

        String dbStatus;
        switch (filter) {
            case "all":
                dbStatus = null;
                break;
            case "inprogress":
                dbStatus = "In Progress";
                break;
            case "completed":
                dbStatus = "Completed";
                break;
            default:
                filter = "requested";
                dbStatus = "Requested";
                break;
        }

        List<LabTest> all;
        if (search != null && !search.trim().isEmpty()) {
            all = dao.searchForNurse(search.trim(), dbStatus);
        } else if ("all".equals(filter)) {
            all = dao.listAllForNurse();
        } else {
            all = dao.listByStatusForNurse(dbStatus);
        }

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
        List<LabTest> list = PaginationUtils.getPage(all, page, PAGE_SIZE);

        request.setAttribute("tests", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("filter", filter != null ? filter : "requested");
        request.setAttribute("search", search != null ? search : "");
        request.getRequestDispatcher("/views/nurse/labQueue.jsp").forward(request, response);
    }
}

