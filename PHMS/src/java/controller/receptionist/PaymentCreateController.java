
package controller.receptionist;

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
import model.Invoice;
import model.User;

@WebServlet(name = "PaymentCreateController", urlPatterns = {"/receptionist/payment/create"})
public class PaymentCreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hỗ trợ method GET để hiển thị trang chọn phương thức thanh toán
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        // 1. Check quyền
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String invoiceIdStr = request.getParameter("invoiceId");
        if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
             response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
             return;
        }

        // 2. Lấy thông tin hóa đơn để hiển thị lên JSP
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice invoice = invoiceDAO.getInvoiceById(Integer.parseInt(invoiceIdStr));
        
        request.setAttribute("invoice", invoice);
        request.getRequestDispatcher("/views/receptionist/paymentCreate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        // 1. Check Login
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Lấy dữ liệu từ Form
        String invoiceIdStr = request.getParameter("invoiceId");
        // Lưu ý: JSP đặt name="paymentMethod", nên ở đây phải get đúng tên
        String paymentMethod = util.ValidationUtils.sanitize(request.getParameter("paymentMethod"));

        if (!util.ValidationUtils.isNotEmpty(invoiceIdStr)
                || !util.ValidationUtils.isIntegerInRange(invoiceIdStr, 1, Integer.MAX_VALUE)
                || !util.ValidationUtils.isNotEmpty(paymentMethod)) {
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

        // 3. XỬ LÝ PHÂN LUỒNG (QUAN TRỌNG)
        
        // === TRƯỜNG HỢP 1: VNPAY / ONLINE ===
        if ("vnpay".equalsIgnoreCase(paymentMethod)) {
            // Chuyển hướng sang Controller xử lý VNPay Checkout
            // Controller này sẽ chịu trách nhiệm tạo URL thanh toán và redirect sang cổng VNPay
            response.sendRedirect(request.getContextPath() + "/payment/vnpay/checkout?invoiceId=" + invoiceId);
            return; // Kết thúc xử lý tại đây
        }

        // === TRƯỜNG HỢP 2: CASH (TIỀN MẶT) ===
        // Logic cũ: Update DB ngay lập tức
        if ("Paid".equalsIgnoreCase(inv.getStatus())) {
            session.setAttribute("toastMessage", "error|Hóa đơn đã được thanh toán trước đó.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
            return;
        }

        double amount = inv.getTotalAmount();
        String finalMethod = "Cash"; // Mặc định là Cash nếu không phải VNPay

        PaymentDAO paymentDAO = new PaymentDAO();
        boolean ok = paymentDAO.createPayment(invoiceId, amount, finalMethod, "Success", null);
        
        if (ok) {
            invoiceDAO.updateStatus(invoiceId, "Paid");
//            AppointmentDAO apptDAO = new AppointmentDAO();
//            apptDAO.completeIfNotCancelled(inv.getApptId());
            session.setAttribute("toastMessage", "success|Thanh toán tiền mặt thành công.");
        } else {
            session.setAttribute("toastMessage", "error|Lỗi hệ thống khi ghi nhận thanh toán.");
        }

        response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
    }
}