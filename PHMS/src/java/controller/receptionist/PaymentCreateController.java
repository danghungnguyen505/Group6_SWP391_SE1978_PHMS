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
import model.Invoice;
import model.User;

/**
 * Receptionist records a payment (cash/transfer) for an invoice.
 * SRP: Create payment & update invoice status only.
 */
@WebServlet(name = "PaymentCreateController", urlPatterns = {"/receptionist/payment/create"})
public class PaymentCreateController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String invoiceIdStr = request.getParameter("invoiceId");
        String method = util.ValidationUtils.sanitize(request.getParameter("method"));

        if (!util.ValidationUtils.isNotEmpty(invoiceIdStr)
                || !util.ValidationUtils.isIntegerInRange(invoiceIdStr, 1, Integer.MAX_VALUE)
                || !util.ValidationUtils.isNotEmpty(method)) {
            session.setAttribute("toastMessage", "error|Dữ liệu thanh toán không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
            return;
        }
        int invoiceId = Integer.parseInt(invoiceIdStr);

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice inv = invoiceDAO.getInvoiceById(invoiceId);
        if (inv == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy hóa đơn.");
            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
            return;
        }
        if ("Paid".equalsIgnoreCase(inv.getStatus())) {
            session.setAttribute("toastMessage", "error|Hóa đơn đã được thanh toán trước đó.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
            return;
        }

        double amount = inv.getTotalAmount();
        if (amount <= 0) {
            session.setAttribute("toastMessage", "error|Tổng tiền hóa đơn không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
            return;
        }

        // Normalize method
        if (!"Cash".equalsIgnoreCase(method) && !"Transfer".equalsIgnoreCase(method)) {
            method = "Cash";
        }

        PaymentDAO paymentDAO = new PaymentDAO();
        boolean ok = paymentDAO.createPayment(invoiceId, amount, method, "Success", null);
        if (ok) {
            invoiceDAO.updateStatus(invoiceId, "Paid");
            session.setAttribute("toastMessage", "success|Thanh toán thành công, hóa đơn đã được cập nhật Paid.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể ghi nhận thanh toán.");
        }

        response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
    }
}

