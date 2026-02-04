package controller.admin;

import dal.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Medicine;
import model.User;
import util.PaginationUtils;

/**
 * Admin views medicine list with pagination.
 * SRP: Read list only.
 */
@WebServlet(name = "MedicineListController", urlPatterns = {"/admin/medicine/list"})
public class MedicineListController extends HttpServlet {
    
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
        
        MedicineDAO medicineDAO = new MedicineDAO();
        List<Medicine> allMedicines = medicineDAO.getAllMedicines();
        
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
        
        int totalPages = PaginationUtils.getTotalPages(allMedicines, PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<Medicine> medicines = PaginationUtils.getPage(allMedicines, page, PAGE_SIZE);
        
        request.setAttribute("medicines", medicines);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalMedicines", allMedicines.size());
        request.setAttribute("pageSize", PAGE_SIZE);
        
        request.getRequestDispatcher("/views/admin/medicineList.jsp").forward(request, response);
    }
}
