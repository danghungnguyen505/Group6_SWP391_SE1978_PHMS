package controller.veterinarian;

import dal.MedicalRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
        List<MedicalRecord> list = PaginationUtils.getPage(all, page, PAGE_SIZE);

        request.setAttribute("records", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/views/veterinarian/medicalRecordList.jsp").forward(request, response);
    }
}

