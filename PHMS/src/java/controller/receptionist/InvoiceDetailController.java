<<<<<<< Updated upstream
package controller.receptionist;

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
        List<InvoiceDetail> details = invoiceDAO.getDetailsByInvoice(invoiceId);
        List<Payment> payments = paymentDAO.getPaymentsByInvoice(invoiceId);

        request.setAttribute("invoice", inv);
        request.setAttribute("details", details);
        request.setAttribute("payments", payments);
        request.getRequestDispatcher("/views/receptionist/invoiceDetail.jsp").forward(request, response);
    }
}

=======
package controller.receptionist;

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
        List<InvoiceDetail> details = invoiceDAO.getDetailsByInvoice(invoiceId);
        List<Payment> payments = paymentDAO.getPaymentsByInvoice(invoiceId);

        request.setAttribute("invoice", inv);
        request.setAttribute("details", details);
        request.setAttribute("payments", payments);
        request.getRequestDispatcher("/views/receptionist/invoiceDetail.jsp").forward(request, response);
    }
}

>>>>>>> Stashed changes
