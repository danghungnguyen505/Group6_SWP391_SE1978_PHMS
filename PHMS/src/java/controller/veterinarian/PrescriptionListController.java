package controller.veterinarian;

import dal.MedicalRecordDAO;
import dal.PrescriptionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.MedicalRecord;
import model.Prescription;
import model.User;

/**
 * Veterinarian views prescription list for a medical record.
 * SRP: Read list only.
 */
@WebServlet(name = "PrescriptionListController", urlPatterns = {"/veterinarian/prescription/list"})
public class PrescriptionListController extends HttpServlet {
    
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
        
        PrescriptionDAO presDAO = new PrescriptionDAO();
        List<Prescription> prescriptions = presDAO.getByRecordIdForVet(recordId, account.getUserId());
        
        request.setAttribute("record", record);
        request.setAttribute("prescriptions", prescriptions);
        request.getRequestDispatcher("/views/veterinarian/prescriptionList.jsp").forward(request, response);
    }
}
