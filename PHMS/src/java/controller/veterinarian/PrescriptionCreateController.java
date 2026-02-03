package controller.veterinarian;

import dal.MedicalRecordDAO;
import dal.MedicineDAO;
import dal.PrescriptionDAO;
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
import model.MedicalRecord;
import model.Medicine;
import model.Prescription;
import model.User;

/**
 * Veterinarian creates prescription for a medical record.
 * SRP: Create prescription only.
 */
@WebServlet(name = "PrescriptionCreateController", urlPatterns = {"/veterinarian/prescription/create"})
public class PrescriptionCreateController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String recordIdStr = request.getParameter("recordId");
        if (!util.ValidationUtils.isNotEmpty(recordIdStr)
                || !util.ValidationUtils.isIntegerInRange(recordIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Medical record không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        
        int recordId = Integer.parseInt(recordIdStr);
        MedicalRecordDAO mrDAO = new MedicalRecordDAO();
        MedicalRecord record = mrDAO.getByIdForVet(recordId, account.getUserId());
        if (record == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy hồ sơ khám hoặc bạn không có quyền truy cập.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        
        MedicineDAO medicineDAO = new MedicineDAO();
        List<Medicine> medicines = medicineDAO.getAllMedicines();
        
        PrescriptionDAO presDAO = new PrescriptionDAO();
        List<Prescription> existingPrescriptions = presDAO.getByRecordIdForVet(recordId, account.getUserId());
        
        request.setAttribute("record", record);
        request.setAttribute("medicines", medicines);
        request.setAttribute("existingPrescriptions", existingPrescriptions);
        request.getRequestDispatcher("/views/veterinarian/prescriptionCreate.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String recordIdStr = request.getParameter("recordId");
        if (!util.ValidationUtils.isNotEmpty(recordIdStr)
                || !util.ValidationUtils.isIntegerInRange(recordIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Medical record không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        
        int recordId = Integer.parseInt(recordIdStr);
        
        // Verify record belongs to vet
        MedicalRecordDAO mrDAO = new MedicalRecordDAO();
        MedicalRecord record = mrDAO.getByIdForVet(recordId, account.getUserId());
        if (record == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy hồ sơ khám hoặc bạn không có quyền truy cập.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        
        // Collect prescription items
        String[] medicineIds = request.getParameterValues("medicineId");
        String[] quantities = request.getParameterValues("quantity");
        String[] dosages = request.getParameterValues("dosage");
        
        List<Prescription> prescriptions = new ArrayList<>();
        
        if (medicineIds != null && quantities != null && dosages != null) {
            MedicineDAO medicineDAO = new MedicineDAO();
            
            for (int i = 0; i < medicineIds.length; i++) {
                String medIdStr = medicineIds[i];
                String qtyStr = quantities[i];
                String dosageStr = dosages[i];
                
                if (!util.ValidationUtils.isNotEmpty(medIdStr) || !util.ValidationUtils.isNotEmpty(qtyStr)) {
                    continue;
                }
                
                if (!util.ValidationUtils.isIntegerInRange(medIdStr, 1, Integer.MAX_VALUE)
                        || !util.ValidationUtils.isIntegerInRange(qtyStr, 1, 1000)) {
                    continue;
                }
                
                int medId = Integer.parseInt(medIdStr);
                int qty = Integer.parseInt(qtyStr);
                
                // Check medicine exists and stock
                Medicine med = medicineDAO.getById(medId);
                if (med == null || med.getStockQuantity() < qty) {
                    request.setAttribute("error", "Thuốc không tồn tại hoặc không đủ số lượng tồn kho.");
                    doGet(request, response);
                    return;
                }
                
                // Validate dosage
                if (!util.ValidationUtils.isNotEmpty(dosageStr)
                        || !util.ValidationUtils.isLengthValid(dosageStr, 1, 100)) {
                    request.setAttribute("error", "Liều dùng phải có từ 1 đến 100 ký tự.");
                    doGet(request, response);
                    return;
                }
                
                Prescription p = new Prescription();
                p.setRecordId(recordId);
                p.setMedicineId(medId);
                p.setQuantity(qty);
                p.setDosage(util.ValidationUtils.sanitize(dosageStr));
                prescriptions.add(p);
            }
        }
        
        if (prescriptions.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn ít nhất một loại thuốc.");
            doGet(request, response);
            return;
        }
        
        PrescriptionDAO presDAO = new PrescriptionDAO();
        try {
            boolean ok = presDAO.createPrescriptions(recordId, account.getUserId(), prescriptions);
            if (ok) {
                session.setAttribute("toastMessage", "success|Kê đơn thuốc thành công.");
                response.sendRedirect(request.getContextPath() + "/veterinarian/prescription/list?recordId=" + recordId);
            } else {
                request.setAttribute("error", "Không thể tạo đơn thuốc. Vui lòng thử lại.");
                doGet(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }
}
