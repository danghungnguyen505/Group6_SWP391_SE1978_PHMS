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
            session.setAttribute("toastMessage", "error|Invalid medical record ID.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        int recordId = Integer.parseInt(recordIdStr);
        MedicalRecordDAO mrDAO = new MedicalRecordDAO();
        MedicalRecord record = mrDAO.getByIdForVet(recordId, account.getUserId());
        if (record == null) {
            session.setAttribute("toastMessage", "error|Record not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        if ("Completed".equalsIgnoreCase(record.getApptStatus())) {
            session.setAttribute("toastMessage", "error|Appointment already completed. Cannot prescribe.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/prescription/list?recordId=" + recordId);
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
        boolean fromDetail = "detail".equalsIgnoreCase(request.getParameter("source"));
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String recordIdStr = request.getParameter("recordId");
        if (!util.ValidationUtils.isNotEmpty(recordIdStr)
                || !util.ValidationUtils.isIntegerInRange(recordIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Invalid medical record ID.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        int recordId = Integer.parseInt(recordIdStr);

        MedicalRecordDAO mrDAO = new MedicalRecordDAO();
        MedicalRecord record = mrDAO.getByIdForVet(recordId, account.getUserId());
        if (record == null) {
            session.setAttribute("toastMessage", "error|Record not found or access denied.");
            if (fromDetail) {
                response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
            } else {
                response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            }
            return;
        }
        if ("Completed".equalsIgnoreCase(record.getApptStatus())) {
            session.setAttribute("toastMessage", "error|Appointment already completed. Cannot prescribe.");
            if (fromDetail) {
                response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
            } else {
                response.sendRedirect(request.getContextPath() + "/veterinarian/prescription/list?recordId=" + recordId);
            }
            return;
        }

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

                Medicine med = medicineDAO.getById(medId);
                if (med == null || med.getStockQuantity() < qty) {
                    if (fromDetail) {
                        session.setAttribute("toastMessage", "error|Medicine not found or out of stock.");
                        response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
                        return;
                    }
                    request.setAttribute("error", "Medicine not found or insufficient stock.");
                    doGet(request, response);
                    return;
                }

                if (!util.ValidationUtils.isNotEmpty(dosageStr)
                        || !util.ValidationUtils.isLengthValid(dosageStr, 1, 100)) {
                    if (fromDetail) {
                        session.setAttribute("toastMessage", "error|Dosage is required (1-100 characters).");
                        response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
                        return;
                    }
                    request.setAttribute("error", "Dosage must be 1-100 characters.");
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
            if (fromDetail) {
                session.setAttribute("toastMessage", "error|Please select medicine, quantity, and dosage.");
                response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
                return;
            }
            request.setAttribute("error", "Please select at least one medicine.");
            doGet(request, response);
            return;
        }

        PrescriptionDAO presDAO = new PrescriptionDAO();
        try {
            boolean ok = presDAO.createPrescriptions(recordId, account.getUserId(), prescriptions);
            if (ok) {
                session.setAttribute("toastMessage", "success|Prescription created successfully.");
                if (fromDetail) {
                    response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/veterinarian/prescription/list?recordId=" + recordId);
                }
            } else {
                if (fromDetail) {
                    session.setAttribute("toastMessage", "error|Cannot create prescription.");
                    response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
                    return;
                }
                request.setAttribute("error", "Cannot create prescription. Please try again.");
                doGet(request, response);
            }
        } catch (SQLException e) {
            if (fromDetail) {
                session.setAttribute("toastMessage", "error|System error: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
                return;
            }
            request.setAttribute("error", "System error: " + e.getMessage());
            doGet(request, response);
        }
    }
}
