package controller.receptionist;

import dal.AppointmentDAO;
import dal.InvoiceDAO;
import dal.TriageRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Appointment;
import model.Invoice;
import model.TriageRecord;
import model.User;
import util.PaginationUtils;

/**
 * Receptionist emergency queue.
 * SRP: Read list of emergency appointments only.
 */
@WebServlet(name = "EmergencyQueueReceptionistController", urlPatterns = {"/receptionist/emergency/queue"})
public class EmergencyQueueController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO apptDAO = new AppointmentDAO();
        // Lấy toàn bộ danh sách cuộc hẹn khẩn cấp
        List<Appointment> all = apptDAO.getEmergencyAppointmentsForReceptionist();

        // Xử lý phân trang
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
        List<Appointment> list = PaginationUtils.getPage(all, page, pageSize);

        // Map apptId -> TriageRecord (if any)
        TriageRecordDAO triageDAO = new TriageRecordDAO();
        Map<Integer, TriageRecord> triageMap = new HashMap<>();
        for (Appointment a : list) {
            TriageRecord tr = triageDAO.getByAppointment(a.getApptId());
            if (tr != null) {
                triageMap.put(a.getApptId(), tr);
            }
        }

        // Map apptId -> Invoice (if exists)
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Map<Integer, Invoice> invoiceMap = new HashMap<>();
        for (Appointment a : list) {
            Invoice inv = invoiceDAO.getInvoiceByAppointment(a.getApptId());
            if (inv != null) {
                invoiceMap.put(a.getApptId(), inv);
            }
        }

        request.setAttribute("appointments", list);
        request.setAttribute("triageMap", triageMap);
        request.setAttribute("invoiceMap", invoiceMap);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("/views/receptionist/emergencyQueue.jsp").forward(request, response);
    }
}

