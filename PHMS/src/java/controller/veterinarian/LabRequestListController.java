package controller.veterinarian;

import dal.LabTestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.LabTest;
import model.User;
import util.PaginationUtils;

/**
 * Vet lab request list.
 * SRP: Read list only.
 */
@WebServlet(name = "LabRequestListController", urlPatterns = {"/veterinarian/lab/requests"})
public class LabRequestListController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private String extractLabImagePath(String resultData) {
        if (resultData == null) {
            return null;
        }
        String normalized = resultData.replace("\r", "").trim();
        if (!normalized.startsWith("/uploads/lab/")) {
            return null;
        }
        int lineBreakIdx = normalized.indexOf('\n');
        String path = lineBreakIdx >= 0 ? normalized.substring(0, lineBreakIdx).trim() : normalized;
        String lower = path.toLowerCase();
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")) {
            return path;
        }
        return null;
    }

    private String extractLabResultText(String resultData) {
        if (resultData == null) {
            return "";
        }
        String normalized = resultData.replace("\r", "");
        String trimmed = normalized.trim();
        if (!trimmed.startsWith("/uploads/lab/")) {
            return trimmed;
        }
        int lineBreakIdx = normalized.indexOf('\n');
        if (lineBreakIdx < 0) {
            return "";
        }
        return normalized.substring(lineBreakIdx + 1).trim();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        LabTestDAO dao = new LabTestDAO();

        String filter = request.getParameter("filter");
        if (filter == null) filter = "all";

        String search = request.getParameter("search");
        if (search != null && search.trim().isEmpty()) {
            search = null;
        }

        String dbStatus;
        switch (filter) {
            case "requested":
                dbStatus = "Requested";
                break;
            case "inprogress":
                dbStatus = "In Progress";
                break;
            case "completed":
                dbStatus = "Completed";
                break;
            case "cancelled":
                dbStatus = "Cancelled";
                break;
            default:
                filter = "all";
                dbStatus = null;
                break;
        }

        List<LabTest> all;
        if (search != null && !search.trim().isEmpty()) {
            all = dao.searchForVet(account.getUserId(), search.trim(), dbStatus);
        } else if ("all".equals(filter)) {
            all = dao.listForVet(account.getUserId());
        } else {
            all = dao.listByStatusForVet(account.getUserId(), dbStatus);
        }

        int page = 1;
        int pageSize = PaginationUtils.normalizePageSize(request.getParameter("size"), PAGE_SIZE);
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int totalPages = PaginationUtils.getTotalPages(all, pageSize);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<LabTest> list = PaginationUtils.getPage(all, page, pageSize);
        Map<Integer, String> labResultImageMap = new HashMap<>();
        Map<Integer, String> labResultTextMap = new HashMap<>();
        for (LabTest t : list) {
            labResultImageMap.put(t.getTestId(), extractLabImagePath(t.getResultData()));
            labResultTextMap.put(t.getTestId(), extractLabResultText(t.getResultData()));
        }

        request.setAttribute("tests", list);
        request.setAttribute("labResultImageMap", labResultImageMap);
        request.setAttribute("labResultTextMap", labResultTextMap);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("filter", filter);
        request.setAttribute("search", search != null ? search : "");
        request.getRequestDispatcher("/views/veterinarian/labRequestList.jsp").forward(request, response);
    }
}

