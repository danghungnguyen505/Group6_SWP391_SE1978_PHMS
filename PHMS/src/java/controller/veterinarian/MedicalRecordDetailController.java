package controller.veterinarian;

import dal.LabTestDAO;
import dal.MedicineDAO;
import dal.MedicalRecordDAO;
import dal.PrescriptionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import model.LabTest;
import model.MedicalRecord;
import model.Medicine;
import model.Prescription;
import model.User;
import util.PaginationUtils;

/**
 * Veterinarian medical record detail.
 * SRP: Read detail only.
 */
@WebServlet(name = "MedicalRecordDetailController", urlPatterns = {"/veterinarian/emr/detail"})
public class MedicalRecordDetailController extends HttpServlet {

    private static final int HISTORY_PAGE_SIZE = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            idStr = request.getParameter("recordId");
        }
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        int recordId;
        try {
            recordId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        MedicalRecordDAO dao = new MedicalRecordDAO();
        MedicalRecord mr = dao.getByIdForVet(recordId, account.getUserId());
        if (mr == null) {
            session.setAttribute("toastMessage", "error|Record not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        LabTestDAO labDao = new LabTestDAO();
        List<String> labTestTypes = labDao.listDistinctTestTypes();

        List<MedicalRecord> allPetHistory = dao.listHistoryForPet(mr.getPetId(), mr.getRecordId());
        int historyPage = 1;
        String historyPageStr = request.getParameter("historyPage");
        if (historyPageStr != null && !historyPageStr.trim().isEmpty()) {
            try {
                historyPage = Integer.parseInt(historyPageStr);
            } catch (NumberFormatException ignored) {
                historyPage = 1;
            }
        }
        int historyTotalPages = PaginationUtils.getTotalPages(allPetHistory, HISTORY_PAGE_SIZE);
        historyPage = PaginationUtils.getValidPage(historyPage, historyTotalPages > 0 ? historyTotalPages : 1);
        List<MedicalRecord> petHistory = PaginationUtils.getPage(allPetHistory, historyPage, HISTORY_PAGE_SIZE);

        List<LabTest> labTests = labDao.listByRecordForVet(recordId, account.getUserId());
        boolean hasPendingLabTests = false;
        if (labTests != null) {
            for (LabTest t : labTests) {
                String status = t.getStatus() != null ? t.getStatus().trim().toUpperCase() : "";
                String resultData = t.getResultData();
                boolean hasResult = resultData != null && !resultData.trim().isEmpty();
                boolean isPendingStatus = "REQUESTED".equals(status)
                        || "IN PROGRESS".equals(status)
                        || "IN-PROGRESS".equals(status);
                if (isPendingStatus && !hasResult) {
                    hasPendingLabTests = true;
                    break;
                }
            }
        }

        PrescriptionDAO presDao = new PrescriptionDAO();
        List<Prescription> prescriptions = presDao.getByRecordIdForVet(recordId, account.getUserId());

        MedicineDAO medicineDao = new MedicineDAO();
        List<Medicine> medicines = medicineDao.getAllMedicines();

        request.setAttribute("record", mr);
        request.setAttribute("petHistory", petHistory);
        request.setAttribute("historyCurrentPage", historyPage);
        request.setAttribute("historyTotalPages", historyTotalPages);
        request.setAttribute("labTestTypes", labTestTypes);
        request.setAttribute("labTests", labTests);
        request.setAttribute("hasPendingLabTests", hasPendingLabTests);
        request.setAttribute("prescriptions", prescriptions);
        request.setAttribute("medicines", medicines);
        request.setAttribute("now", new Date());
        request.getRequestDispatcher("/views/veterinarian/medicalRecordDetail.jsp").forward(request, response);
    }
}

