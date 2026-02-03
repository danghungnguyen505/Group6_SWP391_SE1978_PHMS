package controller.receptionist;

import dal.AppointmentDAO;
import dal.InvoiceDAO;
import dal.PrescriptionDAO;
import dal.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Appointment;
import model.User;

/**
 * Receptionist creates invoice for an appointment.
 * SRP: Create invoice only.
 */
@WebServlet(name = "InvoiceCreateController", urlPatterns = {"/receptionist/invoice/create"})
public class InvoiceCreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdStr = request.getParameter("apptId");
        if (!util.ValidationUtils.isNotEmpty(apptIdStr)
                || !util.ValidationUtils.isIntegerInRange(apptIdStr, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
            return;
        }
        int apptId = Integer.parseInt(apptIdStr);

        AppointmentDAO apptDao = new AppointmentDAO();
        Appointment appt = apptDao.getAppointmentById(apptId);
        if (appt == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy cuộc hẹn để tạo hóa đơn.");
            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
            return;
        }

        // Business rule: Do not allow creating duplicated invoice for the same appointment
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        if (invoiceDAO.getInvoiceByAppointment(apptId) != null) {
            session.setAttribute("toastMessage", "error|Cuộc hẹn này đã có hóa đơn. Vui lòng xem chi tiết hóa đơn hiện có.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId="
                    + invoiceDAO.getInvoiceByAppointment(apptId).getInvoiceId());
            return;
        }

        // Build invoice preview data: main service based on appointment type
        ServiceDAO serviceDAO = new ServiceDAO();
        model.Service mainService = null;
        if (appt.getType() != null && !appt.getType().trim().isEmpty()) {
            mainService = serviceDAO.getActiveServiceByName(appt.getType());
        }
        if (mainService == null) {
            mainService = serviceDAO.getFirstActiveService();
        }

        // Load prescription medicines for this appointment (for billing preview)
        PrescriptionDAO presDAO = new PrescriptionDAO();
        List<model.Prescription> rawPrescriptions = presDAO.getByApptId(apptId);

        // Aggregate by medicine to show one line per medicine
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

        Double subtotal = null;
        Double tax = null;
        Double grandTotal = null;
        if (mainService != null) {
            double s = mainService.getBasePrice();
            for (model.Prescription p : prescriptions) {
                s += p.getQuantity() * p.getMedicinePrice();
            }
            subtotal = s;
            tax = subtotal * 0.08; // 8% tax
            grandTotal = subtotal + tax;
        }

        // Simple invoice number & date preview
        java.time.LocalDate today = java.time.LocalDate.now();
        String invoiceNumber = String.format("INV-%d-%03d", today.getYear(), apptId);

        request.setAttribute("appt", appt);
        request.setAttribute("mainService", mainService);
        request.setAttribute("prescriptions", prescriptions);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("tax", tax);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("invoiceNumber", invoiceNumber);
        request.setAttribute("invoiceDate", today.toString());
        request.getRequestDispatcher("/views/receptionist/invoiceCreate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdStr = request.getParameter("apptId");
        if (!util.ValidationUtils.isNotEmpty(apptIdStr)
                || !util.ValidationUtils.isIntegerInRange(apptIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Cuộc hẹn không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
            return;
        }
        int apptId = Integer.parseInt(apptIdStr);

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        try {
            // Tự động sinh chi tiết hóa đơn từ dữ liệu khám (Appointment + Prescription)
            Integer invoiceId = invoiceDAO.autoCreateInvoiceForAppointment(apptId, account.getUserId());
            if (invoiceId == null) {
                session.setAttribute("toastMessage", "error|Không thể tự động tạo hóa đơn (chưa có dịch vụ/thuốc hoặc đã tồn tại hóa đơn).");
                response.sendRedirect(request.getContextPath() + "/receptionist/invoice/create?apptId=" + apptId);
                return;
            }
            session.setAttribute("toastMessage", "success|Tạo hóa đơn thành công. Chuyển sang thanh toán VNPay.");
            // Sau khi tạo hóa đơn xong, chuyển ngay sang luồng thanh toán VNPay
            response.sendRedirect(request.getContextPath() + "/payment/vnpay/checkout?invoiceId=" + invoiceId);
            session.setAttribute("toastMessage", "success|Hóa đơn đã được tạo. Vui lòng chọn phương thức thanh toán.");
            response.sendRedirect(request.getContextPath() + "/receptionist/payment/create?invoiceId=" + invoiceId);
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "error|Lỗi hệ thống khi tạo hóa đơn: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/create?apptId=" + apptId);
        }
    }
}

