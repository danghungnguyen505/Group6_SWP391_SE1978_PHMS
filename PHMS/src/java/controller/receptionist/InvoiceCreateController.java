package controller.receptionist;

import dal.AppointmentDAO;
import dal.InvoiceDAO;
import dal.ServiceDAO;
import dal.TriageRecordDAO;
import model.TriageRecord;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Appointment;
import model.InvoiceDetail;
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

        // For emergency (Urgent) appointments, use triage level to find the correct emergency service
        if ("Urgent".equalsIgnoreCase(appt.getType())) {
            TriageRecordDAO triageDAO = new TriageRecordDAO();
            TriageRecord triage = triageDAO.getByAppointment(apptId);
            if (triage != null && triage.getConditionLevel() != null) {
                mainService = serviceDAO.getServiceByTriageLevel(triage.getConditionLevel());
            }
            if (mainService == null) {
                mainService = serviceDAO.getFirstActiveServiceByType("Emergency");
            }
        }

        // For non-emergency or if triage lookup failed, try matching by appointment type name
        if (mainService == null && appt.getType() != null && !appt.getType().trim().isEmpty()) {
            mainService = serviceDAO.getActiveServiceByName(appt.getType());
            if (mainService == null) {
                mainService = serviceDAO.getActiveServiceByNameLike(appt.getType());
            }
        }
        if (mainService == null) {
            mainService = serviceDAO.getFirstActiveService();
        }

        // Load lab-test based services for this appointment (medicine is NOT billed in invoice)
        List<InvoiceDetail> labServices = invoiceDAO.getLabServiceDetailsForAppointment(apptId);

        Double subtotal = null;
        Double grandTotal = null;
        double s = 0;
        if (mainService != null) {
            s += mainService.getBasePrice();
        }
        for (InvoiceDetail lab : labServices) {
            s += lab.getQuantity() * lab.getUnitPrice();
        }
        subtotal = s;
        grandTotal = subtotal;

        // Simple invoice number & date preview
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.LocalTime now = java.time.LocalTime.now();
        java.time.format.DateTimeFormatter timeFormatter = java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss");
        String invoiceNumber = String.format("INV-%d-%03d", today.getYear(), apptId);

        request.setAttribute("appt", appt);
        request.setAttribute("mainService", mainService);
        request.setAttribute("labServices", labServices);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("invoiceNumber", invoiceNumber);
        request.setAttribute("invoiceDate", today.toString());
        request.setAttribute("invoiceTime", now.format(timeFormatter));
        request.setAttribute("invoiceDateTime", today + " " + now.format(timeFormatter));
        request.setAttribute("staffName", account.getFullName() != null ? account.getFullName() : account.getUsername());
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
            // Tự động sinh chi tiết hóa đơn từ dữ liệu khám (dịch vụ chính + dịch vụ xét nghiệm)
            Integer invoiceId = invoiceDAO.autoCreateInvoiceForAppointment(apptId, account.getUserId());
            if (invoiceId == null) {
                session.setAttribute("toastMessage", "error|Không thể tự động tạo hóa đơn (chưa có dịch vụ phù hợp hoặc đã tồn tại hóa đơn).");
                response.sendRedirect(request.getContextPath() + "/receptionist/invoice/create?apptId=" + apptId);
                return;
            }
            session.setAttribute("toastMessage", "success|Tạo hóa đơn thành công. Chuyển sang thanh toán VNPay.");
            // Sau khi tạo hóa đơn xong, chuyển ngay sang luồng thanh toán VNPay
            //response.sendRedirect(request.getContextPath() + "/payment/vnpay/checkout?invoiceId=" + invoiceId);
            session.setAttribute("toastMessage", "success|Hóa đơn đã được tạo. Vui lòng chọn phương thức thanh toán.");
            response.sendRedirect(request.getContextPath() + "/receptionist/payment/create?invoiceId=" + invoiceId);
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "error|Lỗi hệ thống khi tạo hóa đơn: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/create?apptId=" + apptId);
        }
    }
}
