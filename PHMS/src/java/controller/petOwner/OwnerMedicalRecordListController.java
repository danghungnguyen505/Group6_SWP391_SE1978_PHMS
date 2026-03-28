package controller.petOwner;

import dal.MedicalRecordDAO;
import dal.InvoiceDAO;
import dal.PetDAO;
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
import model.Invoice;
import model.MedicalRecord;
import model.Pet;
import model.User;
import util.PaginationUtils;

/**
 * PetOwner medical record list.
 * SRP: Read list only.
 */
@WebServlet(name = "OwnerMedicalRecordListController", urlPatterns = {"/my-medical-records"})
public class OwnerMedicalRecordListController extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load pets for filter dropdown
        PetDAO petDAO = new PetDAO();
        List<Pet> pets = petDAO.getPetsByOwnerId(account.getUserId());
        request.setAttribute("pets", pets);

        Integer petId = null;
        String petIdStr = request.getParameter("petId");
        if (petIdStr != null && !petIdStr.trim().isEmpty()) {
            try {
                int pid = Integer.parseInt(petIdStr);
                // ensure pet belongs to owner
                boolean ok = false;
                for (Pet p : pets) {
                    if (p.getId() == pid) {
                        ok = true;
                        break;
                    }
                }
                if (ok) {
                    petId = pid;
                    request.setAttribute("selectedPetId", pid);
                }
            } catch (NumberFormatException ignored) {
            }
        }

        MedicalRecordDAO dao = new MedicalRecordDAO();
        List<MedicalRecord> all = dao.listForOwner(account.getUserId(), petId);

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
        List<MedicalRecord> list = PaginationUtils.getPage(all, page, pageSize);
        
        Map<Integer, Invoice> invoiceMap = new HashMap<>();
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        for (MedicalRecord r : list) {
            if (!invoiceMap.containsKey(r.getApptId())) {
                invoiceMap.put(r.getApptId(), invoiceDAO.getInvoiceByAppointment(r.getApptId()));
            }
        }

        request.setAttribute("records", list);
        request.setAttribute("invoiceMap", invoiceMap);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("/views/petOwner/medicalRecordList.jsp").forward(request, response);
    }
}

