package controller.receptionist;

import dal.AppointmentDAO;
import dal.InvoiceDAO;
import dal.MedicineDAO;
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
import java.util.List;
import model.Appointment;
import model.InvoiceDetail;
import model.Medicine;
import model.Service;
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

        ServiceDAO serviceDAO = new ServiceDAO();
        MedicineDAO medicineDAO = new MedicineDAO();

        List<Service> services = serviceDAO.getAllActiveServices();
        List<Medicine> medicines = medicineDAO.getAllMedicines();

        request.setAttribute("appt", appt);
        request.setAttribute("services", services);
        request.setAttribute("medicines", medicines);
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

        // Collect service items
        String[] serviceIds = request.getParameterValues("serviceId");
        String[] serviceQtys = request.getParameterValues("serviceQty");
        String[] medicineIds = request.getParameterValues("medicineId");
        String[] medicineQtys = request.getParameterValues("medicineQty");

        List<InvoiceDetail> detailList = new ArrayList<>();

        if (serviceIds != null && serviceQtys != null) {
            for (int i = 0; i < serviceIds.length; i++) {
                String sid = serviceIds[i];
                String sqty = serviceQtys[i];
                if (!util.ValidationUtils.isNotEmpty(sid) || !util.ValidationUtils.isNotEmpty(sqty)) continue;
                if (!util.ValidationUtils.isIntegerInRange(sid, 1, Integer.MAX_VALUE)
                        || !util.ValidationUtils.isIntegerInRange(sqty, 1, 1000)) continue;
                InvoiceDetail d = new InvoiceDetail();
                d.setServiceId(Integer.parseInt(sid));
                d.setItemType("Service");
                d.setQuantity(Integer.parseInt(sqty));
                detailList.add(d);
            }
        }

        if (medicineIds != null && medicineQtys != null) {
            for (int i = 0; i < medicineIds.length; i++) {
                String mid = medicineIds[i];
                String mqty = medicineQtys[i];
                if (!util.ValidationUtils.isNotEmpty(mid) || !util.ValidationUtils.isNotEmpty(mqty)) continue;
                if (!util.ValidationUtils.isIntegerInRange(mid, 1, Integer.MAX_VALUE)
                        || !util.ValidationUtils.isIntegerInRange(mqty, 1, 1000)) continue;
                InvoiceDetail d = new InvoiceDetail();
                d.setMedicineId(Integer.parseInt(mid));
                d.setItemType("Medicine");
                d.setQuantity(Integer.parseInt(mqty));
                detailList.add(d);
            }
        }

        if (detailList.isEmpty()) {
            session.setAttribute("toastMessage", "error|Vui lòng chọn ít nhất một dịch vụ hoặc thuốc.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/create?apptId=" + apptId);
            return;
        }

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        try {
            Integer invoiceId = invoiceDAO.createInvoiceForAppointment(apptId, account.getUserId(), detailList);
            if (invoiceId == null) {
                session.setAttribute("toastMessage", "error|Không thể tạo hóa đơn. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/receptionist/invoice/create?apptId=" + apptId);
                return;
            }
<<<<<<< Updated upstream
            session.setAttribute("toastMessage", "success|Tạo hóa đơn thành công.");
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/detail?invoiceId=" + invoiceId);
=======
            session.setAttribute("toastMessage", "success|Tạo hóa đơn thành công. Chuyển sang thanh toán VNPay.");
            // Sau khi tạo hóa đơn xong, chuyển ngay sang luồng thanh toán VNPay
            //response.sendRedirect(request.getContextPath() + "/payment/vnpay/checkout?invoiceId=" + invoiceId);
            session.setAttribute("toastMessage", "success|Hóa đơn đã được tạo. Vui lòng chọn phương thức thanh toán.");
            response.sendRedirect(request.getContextPath() + "/receptionist/payment/create?invoiceId=" + invoiceId);
>>>>>>> Stashed changes
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("toastMessage", "error|Lỗi hệ thống khi tạo hóa đơn: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/receptionist/invoice/create?apptId=" + apptId);
        }
    }
}

