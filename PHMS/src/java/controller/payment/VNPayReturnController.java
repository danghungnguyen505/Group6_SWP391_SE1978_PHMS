<<<<<<< Updated upstream
package controller.payment;

import dal.InvoiceDAO;
import dal.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Map;
import java.util.TreeMap;
import model.Invoice;
import util.VNPayConfig;

/**
 * Handle VNPay return URL after payment.
 */
@WebServlet(name = "VNPayReturnController", urlPatterns = {"/payment/vnpay/return"})
public class VNPayReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Collect VNPay params
        Map<String, String> fields = new TreeMap<>();
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = fields.remove("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");

        // Build data string for hash
        StringBuilder hashData = new StringBuilder();
        for (Map.Entry<String, String> entry : fields.entrySet()) {
            if (hashData.length() > 0) {
                hashData.append('&');
            }
            hashData.append(entry.getKey()).append('=').append(entry.getValue());
        }

        String calculatedHash = VNPayConfig.hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
        boolean validSignature = calculatedHash.equalsIgnoreCase(vnp_SecureHash);

        String vnp_ResponseCode = fields.get("vnp_ResponseCode");
        String vnp_TxnRef = fields.get("vnp_TxnRef");
        String vnp_TransactionNo = fields.get("vnp_TransactionNo");

        if (!validSignature) {
            session.setAttribute("toastMessage", "error|Chữ ký VNPay không hợp lệ. Giao dịch bị từ chối.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if (!"00".equals(vnp_ResponseCode)) {
            session.setAttribute("toastMessage", "error|Giao dịch VNPay thất bại. Mã: " + vnp_ResponseCode);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int invoiceId;
        try {
            invoiceId = Integer.parseInt(vnp_TxnRef);
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "error|Mã hóa đơn không hợp lệ trong phản hồi VNPay.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice inv = invoiceDAO.getInvoiceById(invoiceId);
        if (inv == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy hóa đơn tương ứng giao dịch VNPay.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        if ("Paid".equalsIgnoreCase(inv.getStatus())) {
            session.setAttribute("toastMessage", "success|Hóa đơn đã được thanh toán trước đó.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
            return;
        }

        double amount = inv.getTotalAmount();
        PaymentDAO paymentDAO = new PaymentDAO();
        boolean ok = paymentDAO.createPayment(invoiceId, amount, "VNPay", "Success", vnp_TransactionNo);
        if (ok) {
            invoiceDAO.updateStatus(invoiceId, "Paid");
            session.setAttribute("toastMessage", "success|Thanh toán VNPay thành công. Hóa đơn đã Paid.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể ghi nhận giao dịch VNPay.");
        }

        response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
    }
}

=======
package controller.payment;

import dal.InvoiceDAO;
import dal.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Map;
import java.util.TreeMap;
import model.Invoice;
import util.VNPayConfig;

/**
 * Handle VNPay return URL after payment.
 */
@WebServlet(name = "VNPayReturnController", urlPatterns = {"/payment/vnpay/return"})
public class VNPayReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Collect VNPay params
        Map<String, String> fields = new TreeMap<>();
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = fields.remove("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");

        // Build data string for hash
        StringBuilder hashData = new StringBuilder();
        for (Map.Entry<String, String> entry : fields.entrySet()) {
            if (hashData.length() > 0) {
                hashData.append('&');
            }
            hashData.append(entry.getKey()).append('=').append(entry.getValue());
        }

        String calculatedHash = VNPayConfig.hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
        boolean validSignature = calculatedHash.equalsIgnoreCase(vnp_SecureHash);

        String vnp_ResponseCode = fields.get("vnp_ResponseCode");
        String vnp_TxnRef = fields.get("vnp_TxnRef");
        String vnp_TransactionNo = fields.get("vnp_TransactionNo");

        if (!validSignature) {
            session.setAttribute("toastMessage", "error|Chữ ký VNPay không hợp lệ. Giao dịch bị từ chối.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if (!"00".equals(vnp_ResponseCode)) {
            session.setAttribute("toastMessage", "error|Giao dịch VNPay thất bại. Mã: " + vnp_ResponseCode);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int invoiceId;
        try {
            invoiceId = Integer.parseInt(vnp_TxnRef);
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "error|Mã hóa đơn không hợp lệ trong phản hồi VNPay.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice inv = invoiceDAO.getInvoiceById(invoiceId);
        if (inv == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy hóa đơn tương ứng giao dịch VNPay.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        if ("Paid".equalsIgnoreCase(inv.getStatus())) {
            session.setAttribute("toastMessage", "success|Hóa đơn đã được thanh toán trước đó.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
            return;
        }

        double amount = inv.getTotalAmount();
        PaymentDAO paymentDAO = new PaymentDAO();
        boolean ok = paymentDAO.createPayment(invoiceId, amount, "VNPay", "Success", vnp_TransactionNo);
        if (ok) {
            invoiceDAO.updateStatus(invoiceId, "Paid");
            session.setAttribute("toastMessage", "success|Thanh toán VNPay thành công. Hóa đơn đã Paid.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể ghi nhận giao dịch VNPay.");
        }

        response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
    }
}

>>>>>>> Stashed changes
