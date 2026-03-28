package controller.petOwner;

import dal.AppointmentDAO;
import dal.InvoiceDAO;
import dal.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Appointment;
import model.Invoice;
import model.InvoiceDetail;
import model.Payment;
import model.User;

/**
 * Pet owner invoice detail (read-only).
 */
@WebServlet(name = "OwnerInvoiceDetailController", urlPatterns = {"/my-invoice/detail"})
public class OwnerInvoiceDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdStr = request.getParameter("apptId");
        if (!util.ValidationUtils.isNotEmpty(apptIdStr)
                || !util.ValidationUtils.isIntegerInRange(apptIdStr, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/my-medical-records");
            return;
        }
        int apptId = Integer.parseInt(apptIdStr);

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        Appointment appt = appointmentDAO.getAppointmentByIdForOwner(apptId, account.getUserId());
        if (appt == null) {
            response.sendRedirect(request.getContextPath() + "/my-medical-records?msg=no_permission");
            return;
        }

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        PaymentDAO paymentDAO = new PaymentDAO();

        Invoice invoice = invoiceDAO.getInvoiceByAppointment(apptId);
        if (invoice == null) {
            response.sendRedirect(request.getContextPath() + "/my-medical-records?msg=no_invoice");
            return;
        }

        List<InvoiceDetail> details = invoiceDAO.getDetailsByInvoice(invoice.getInvoiceId());
        List<Payment> payments = paymentDAO.getPaymentsByInvoice(invoice.getInvoiceId());

        request.setAttribute("invoice", invoice);
        request.setAttribute("appt", appt);
        request.setAttribute("details", details);
        request.setAttribute("payments", payments);
        request.getRequestDispatcher("/views/petOwner/invoiceDetail.jsp").forward(request, response);
    }
}

