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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

    private String extractLabImagePath(String resultData) {
        if (resultData == null) {
            return null;
        }
        String normalized = resultData.replace("\r", "").trim();
        if (!normalized.startsWith("/uploads/lab/")) {
            return null;
        }
        int lineBreakIdx = normalized.indexOf('\n');
        String path = lineBreakIdx >= 0 ? normalized.substring(0, lineBreakIdx).trim() : normalized;
        String lower = path.toLowerCase();
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")) {
            return path;
        }
        return null;
    }

    private String extractLabResultText(String resultData) {
        if (resultData == null) {
            return "";
        }
        String normalized = resultData.replace("\r", "");
        String trimmed = normalized.trim();
        if (!trimmed.startsWith("/uploads/lab/")) {
            return trimmed;
        }
        int lineBreakIdx = normalized.indexOf('\n');
        if (lineBreakIdx < 0) {
            return "";
        }
        return normalized.substring(lineBreakIdx + 1).trim();
    }

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
        int historyPageSize = PaginationUtils.normalizePageSize(request.getParameter("historySize"), HISTORY_PAGE_SIZE);
        String historyPageStr = request.getParameter("historyPage");
        if (historyPageStr != null && !historyPageStr.trim().isEmpty()) {
            try {
                historyPage = Integer.parseInt(historyPageStr);
            } catch (NumberFormatException ignored) {
                historyPage = 1;
            }
        }
        int historyTotalPages = PaginationUtils.getTotalPages(allPetHistory, historyPageSize);
        historyPage = PaginationUtils.getValidPage(historyPage, historyTotalPages > 0 ? historyTotalPages : 1);
        List<MedicalRecord> petHistory = PaginationUtils.getPage(allPetHistory, historyPage, historyPageSize);

        List<LabTest> labTests = labDao.listByRecordForVet(recordId, account.getUserId());
        Map<Integer, String> labResultImageMap = new HashMap<>();
        Map<Integer, String> labResultTextMap = new HashMap<>();
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
            for (LabTest t : labTests) {
                String imagePath = extractLabImagePath(t.getResultData());
                String resultText = extractLabResultText(t.getResultData());
                labResultImageMap.put(t.getTestId(), imagePath);
                labResultTextMap.put(t.getTestId(), resultText);
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
        request.setAttribute("historyPageSize", historyPageSize);
        request.setAttribute("labTestTypes", labTestTypes);
        request.setAttribute("labTests", labTests);
        request.setAttribute("labResultImageMap", labResultImageMap);
        request.setAttribute("labResultTextMap", labResultTextMap);
        request.setAttribute("hasPendingLabTests", hasPendingLabTests);
        request.setAttribute("prescriptions", prescriptions);
        request.setAttribute("medicines", medicines);
        request.setAttribute("now", new Date());
        request.getRequestDispatcher("/views/veterinarian/medicalRecordDetail.jsp").forward(request, response);
    }
}

