<<<<<<< Updated upstream
package controller.payment;

import dal.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.TreeMap;
import model.Invoice;
import model.User;
import util.VNPayConfig;

/**
 * Redirect user to VNPay checkout page for an invoice.
 */
@WebServlet(name = "VNPayCheckoutController", urlPatterns = {"/payment/vnpay/checkout"})
public class VNPayCheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String invoiceIdStr = request.getParameter("invoiceId");
        if (!util.ValidationUtils.isNotEmpty(invoiceIdStr)
                || !util.ValidationUtils.isIntegerInRange(invoiceIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Hóa đơn không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        int invoiceId = Integer.parseInt(invoiceIdStr);

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice inv = invoiceDAO.getInvoiceById(invoiceId);
        if (inv == null || inv.getTotalAmount() <= 0) {
            session.setAttribute("toastMessage", "error|Không tìm thấy hóa đơn hoặc tổng tiền không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        if ("Paid".equalsIgnoreCase(inv.getStatus())) {
            session.setAttribute("toastMessage", "error|Hóa đơn đã được thanh toán.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
            return;
        }

        if (VNPayConfig.VNP_PAY_URL == null || VNPayConfig.VNP_PAY_URL.isEmpty()) {
            session.setAttribute("toastMessage", "error|VNPay chưa được cấu hình trên hệ thống.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
            return;
        }

        long amount = Math.round(inv.getTotalAmount() * 100); // VNPAY dùng đơn vị x100
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_TmnCode = VNPayConfig.VNP_TMNCODE;
        String vnp_TxnRef = String.valueOf(invoiceId);
        String vnp_OrderInfo = "Thanh toan hoa don #" + invoiceId;
        String vnp_OrderType = "other";
        String vnp_Locale = "vn";
        String vnp_IpAddr = request.getRemoteAddr();
        String vnp_ReturnUrl = VNPayConfig.VNP_RETURN_URL;

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(new Date());

        Map<String, String> vnp_Params = new TreeMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", vnp_OrderType);
        vnp_Params.put("vnp_Locale", vnp_Locale);
        vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        for (Map.Entry<String, String> entry : vnp_Params.entrySet()) {
            if (hashData.length() > 0) {
                hashData.append('&');
                query.append('&');
            }
            hashData.append(entry.getKey()).append('=').append(entry.getValue());
            query.append(entry.getKey()).append('=').append(VNPayConfig.urlEncode(entry.getValue()));
        }

        String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
        query.append("&vnp_SecureHash=").append(vnp_SecureHash);

        String paymentUrl = VNPayConfig.VNP_PAY_URL + "?" + query;
        response.sendRedirect(paymentUrl);
    }
}

=======
package controller.payment;

import dal.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.TreeMap;
import model.Invoice;
import model.User;
import util.VNPayConfig;

/**
 * Redirect user to VNPay checkout page for an invoice.
 */
@WebServlet(name = "VNPayCheckoutController", urlPatterns = {"/payment/vnpay/checkout"})
public class VNPayCheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String invoiceIdStr = request.getParameter("invoiceId");
        if (!util.ValidationUtils.isNotEmpty(invoiceIdStr)
                || !util.ValidationUtils.isIntegerInRange(invoiceIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Hóa đơn không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        int invoiceId = Integer.parseInt(invoiceIdStr);

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice inv = invoiceDAO.getInvoiceById(invoiceId);
        if (inv == null || inv.getTotalAmount() <= 0) {
            session.setAttribute("toastMessage", "error|Không tìm thấy hóa đơn hoặc tổng tiền không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        if ("Paid".equalsIgnoreCase(inv.getStatus())) {
            session.setAttribute("toastMessage", "error|Hóa đơn đã được thanh toán.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
            return;
        }

        if (VNPayConfig.VNP_PAY_URL == null || VNPayConfig.VNP_PAY_URL.isEmpty()) {
            session.setAttribute("toastMessage", "error|VNPay chưa được cấu hình trên hệ thống.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
            return;
        }

        long amount = Math.round(inv.getTotalAmount() * 100); // VNPAY dùng đơn vị x100
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_TmnCode = VNPayConfig.VNP_TMNCODE;
        String vnp_TxnRef = String.valueOf(invoiceId);
        String vnp_OrderInfo = "Thanh toan hoa don #" + invoiceId;
        String vnp_OrderType = "other";
        String vnp_Locale = "vn";
        String vnp_IpAddr = request.getRemoteAddr();
        String vnp_ReturnUrl = VNPayConfig.VNP_RETURN_URL;

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(new Date());

        Map<String, String> vnp_Params = new TreeMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", vnp_OrderType);
        vnp_Params.put("vnp_Locale", vnp_Locale);
        vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        for (Map.Entry<String, String> entry : vnp_Params.entrySet()) {
            if (hashData.length() > 0) {
                hashData.append('&');
                query.append('&');
            }
            hashData.append(entry.getKey()).append('=').append(entry.getValue());
            query.append(entry.getKey()).append('=').append(VNPayConfig.urlEncode(entry.getValue()));
        }

        String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.VNP_HASH_SECRET, hashData.toString());
        query.append("&vnp_SecureHash=").append(vnp_SecureHash);

        String paymentUrl = VNPayConfig.VNP_PAY_URL + "?" + query;
        response.sendRedirect(paymentUrl);
    }
}

>>>>>>> Stashed changes
