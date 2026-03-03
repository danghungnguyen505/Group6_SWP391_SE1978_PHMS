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
<<<<<<< Updated upstream
=======

        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status"); // active / inactive (out-of-stock)

        List<Medicine> filteredMedicines = new java.util.ArrayList<>();
        for (Medicine m : allMedicines) {
            boolean match = true;

            if (search != null && !search.trim().isEmpty()) {
                String lower = search.trim().toLowerCase();
                String name = m.getName() != null ? m.getName().toLowerCase() : "";
                String unit = m.getUnit() != null ? m.getUnit().toLowerCase() : "";
                match = name.contains(lower) || unit.contains(lower);
            }

            if (match && statusFilter != null && !statusFilter.trim().isEmpty()) {
                boolean inStock = m.getStockQuantity() > 0;
                if ("active".equalsIgnoreCase(statusFilter)) {
                    match = inStock;
                } else if ("inactive".equalsIgnoreCase(statusFilter)) {
                    match = !inStock;
                }
            }

            if (match) {
                filteredMedicines.add(m);
            }
        }
>>>>>>> Stashed changes
        
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
        
<<<<<<< Updated upstream
        int totalPages = PaginationUtils.getTotalPages(allMedicines, PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<Medicine> medicines = PaginationUtils.getPage(allMedicines, page, PAGE_SIZE);
=======
        int totalPages = PaginationUtils.getTotalPages(filteredMedicines, PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<Medicine> medicines = PaginationUtils.getPage(filteredMedicines, page, PAGE_SIZE);
>>>>>>> Stashed changes
        
        request.setAttribute("medicines", medicines);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
<<<<<<< Updated upstream
        request.setAttribute("totalMedicines", allMedicines.size());
        request.setAttribute("pageSize", PAGE_SIZE);
=======
        request.setAttribute("totalMedicines", filteredMedicines.size());
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("statusFilter", statusFilter);
>>>>>>> Stashed changes
        
        request.getRequestDispatcher("/views/admin/medicineList.jsp").forward(request, response);
    }
}
