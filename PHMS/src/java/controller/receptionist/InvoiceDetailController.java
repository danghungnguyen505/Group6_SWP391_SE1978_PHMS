package controller.receptionist;

import dal.AppointmentDAO;
import dal.InvoiceDAO;
import dal.PaymentDAO;
import dal.PrescriptionDAO;
import dal.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Appointment;
import model.Invoice;
import model.InvoiceDetail;
import model.Payment;
import model.User;

/**
 * Receptionist view invoice detail.
 * SRP: Read invoice & details only.
 */
@WebServlet(name = "InvoiceDetailController", urlPatterns = {"/receptionist/invoice/detail"})
public class InvoiceDetailController extends HttpServlet {

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    User account = (User) session.getAttribute("account");
    if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String invoiceIdStr = request.getParameter("invoiceId");
    if (!util.ValidationUtils.isNotEmpty(invoiceIdStr)
            || !util.ValidationUtils.isIntegerInRange(invoiceIdStr, 1, Integer.MAX_VALUE)) {
        response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
        return;
    }

    int invoiceId = Integer.parseInt(invoiceIdStr);

    InvoiceDAO invoiceDAO = new InvoiceDAO();
    PaymentDAO paymentDAO = new PaymentDAO();

    Invoice inv = invoiceDAO.getInvoiceById(invoiceId);
    if (inv == null) {
        session.setAttribute("toastMessage", "error|Không tìm thấy hóa đơn.");
        response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
        return;
    }

    // 🔁 REBUILD VIEW DATA USING APPOINTMENT (same as create flow)
    int apptId = inv.getApptId();

    AppointmentDAO apptDao = new AppointmentDAO();
    Appointment appt = apptDao.getAppointmentById(apptId);

    ServiceDAO serviceDAO = new ServiceDAO();
    model.Service mainService = serviceDAO.getActiveServiceByName(appt.getType());
    if (mainService == null) {
        mainService = serviceDAO.getFirstActiveService();
    }

    PrescriptionDAO presDAO = new PrescriptionDAO();
    List<model.Prescription> rawPrescriptions = presDAO.getByApptId(apptId);

    Map<Integer, model.Prescription> agg = new LinkedHashMap<>();
    for (model.Prescription p : rawPrescriptions) {
        int medId = p.getMedicineId();
        if (!agg.containsKey(medId)) {
            agg.put(medId, p);
        } else {
            model.Prescription ex = agg.get(medId);
            ex.setQuantity(ex.getQuantity() + p.getQuantity());
        }
    }
    List<model.Prescription> prescriptions = new ArrayList<>(agg.values());

    double subtotal = mainService != null ? mainService.getBasePrice() : 0;
    for (model.Prescription p : prescriptions) {
        subtotal += p.getQuantity() * p.getMedicinePrice();
    }
    double tax = subtotal * 0.08;
    double grandTotal = subtotal + tax;

    // ===== ATTRIBUTES invoiceCreate.jsp EXPECTS =====
    request.setAttribute("appt", appt);
    request.setAttribute("mainService", mainService);
    request.setAttribute("prescriptions", prescriptions);
    request.setAttribute("subtotal", subtotal);
    request.setAttribute("tax", tax);
    request.setAttribute("grandTotal", grandTotal);

    request.setAttribute("invoiceId", inv.getInvoiceId());
    request.setAttribute("invoiceNumber", "INV-" + inv.getInvoiceId());
request.setAttribute("invoiceDate", java.time.LocalDate.now().toString());

    request.setAttribute("invoiceStatus", inv.getStatus());

    request.getRequestDispatcher("/views/receptionist/invoiceCreate.jsp")
            .forward(request, response);
}

}

