package controller.veterinarian;

import dal.MedicalRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.io.IOException;
import java.util.List;
import model.MedicalRecord;
import model.User;
import util.PaginationUtils;

/**
 * Veterinarian medical record list.
 * SRP: Read list only.
 */
@WebServlet(name = "MedicalRecordListController", urlPatterns = {"/veterinarian/emr/records"})
public class MedicalRecordListController extends HttpServlet {

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

        MedicalRecordDAO dao = new MedicalRecordDAO();
        List<MedicalRecord> all = dao.listForVet(account.getUserId());

        int totalRecords = all != null ? all.size() : 0;
        int inProgressRecords = 0;
        int completedRecords = 0;
        if (all != null) {
            for (MedicalRecord r : all) {
                if ("In-Progress".equalsIgnoreCase(r.getApptStatus())) {
                    inProgressRecords++;
                } else if ("Completed".equalsIgnoreCase(r.getApptStatus())) {
                    completedRecords++;
                }
            }
        }

        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();

        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "All";
        } else {
            statusFilter = statusFilter.trim();
        }

        List<MedicalRecord> filtered = new ArrayList<>();
        String keywordLower = keyword.toLowerCase();
        if (all != null) {
            for (MedicalRecord r : all) {
                boolean matchesStatus = "All".equalsIgnoreCase(statusFilter)
                        || statusFilter.equalsIgnoreCase(r.getApptStatus());

                boolean matchesKeyword = keywordLower.isEmpty()
                        || String.valueOf(r.getRecordId()).contains(keywordLower)
                        || String.valueOf(r.getApptId()).contains(keywordLower)
                        || (r.getOwnerName() != null && r.getOwnerName().toLowerCase().contains(keywordLower))
                        || (r.getPetName() != null && r.getPetName().toLowerCase().contains(keywordLower));

                if (matchesStatus && matchesKeyword) {
                    filtered.add(r);
                }
            }
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
        int totalPages = PaginationUtils.getTotalPages(filtered, PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<MedicalRecord> list = PaginationUtils.getPage(filtered, page, PAGE_SIZE);

        request.setAttribute("records", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("inProgressRecords", inProgressRecords);
        request.setAttribute("completedRecords", completedRecords);
        request.setAttribute("filteredCount", filtered.size());
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);
        request.getRequestDispatcher("/views/veterinarian/medicalRecordList.jsp").forward(request, response);
    }
}

