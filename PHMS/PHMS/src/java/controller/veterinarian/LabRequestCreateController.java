package controller.veterinarian;

import dal.LabTestDAO;
import dal.MedicalRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.MedicalRecord;
import model.User;

/**
 * Vet creates a lab request for a medical record.
 * SRP: Create only.
 */
@WebServlet(name = "LabRequestCreateController", urlPatterns = {"/veterinarian/lab/request"})
public class LabRequestCreateController extends HttpServlet {

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
        if (recordIdStr == null || recordIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        int recordId;
        try {
            recordId = Integer.parseInt(recordIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        MedicalRecordDAO mrDao = new MedicalRecordDAO();
        MedicalRecord mr = mrDao.getByIdForVet(recordId, account.getUserId());
        if (mr == null) {
            session.setAttribute("toastMessage", "error|Record not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        if ("Completed".equalsIgnoreCase(mr.getApptStatus())) {
            session.setAttribute("toastMessage", "error|Appointment already completed. Cannot request lab test.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/lab/requests");
            return;
        }
        request.setAttribute("record", mr);
        request.getRequestDispatcher("/views/veterinarian/labRequestCreate.jsp").forward(request, response);
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
        String testType = util.ValidationUtils.sanitize(request.getParameter("testType"));
        String requestNotes = util.ValidationUtils.sanitize(request.getParameter("requestNotes"));

        if (!util.ValidationUtils.isNotEmpty(recordIdStr) || !util.ValidationUtils.isIntegerInRange(recordIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Invalid record ID.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        int recordId = Integer.parseInt(recordIdStr);

        if (!util.ValidationUtils.isNotEmpty(testType) || testType.length() > 100) {
            request.setAttribute("error", "Test type is required and must be <= 100 characters.");
            request.setAttribute("recordId", recordId);
            request.setAttribute("testType", testType);
            request.setAttribute("requestNotes", requestNotes);
            request.getRequestDispatcher("/views/veterinarian/labRequestCreate.jsp").forward(request, response);
            return;
        }
        if (requestNotes != null && requestNotes.length() > 4000) {
            request.setAttribute("error", "Request notes must be <= 4000 characters.");
            request.setAttribute("recordId", recordId);
            request.setAttribute("testType", testType);
            request.setAttribute("requestNotes", requestNotes);
            request.getRequestDispatcher("/views/veterinarian/labRequestCreate.jsp").forward(request, response);
            return;
        }
        MedicalRecordDAO mrDao = new MedicalRecordDAO();
        MedicalRecord mr = mrDao.getByIdForVet(recordId, account.getUserId());
        if (mr == null) {
            session.setAttribute("toastMessage", "error|Record not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        if ("Completed".equalsIgnoreCase(mr.getApptStatus())) {
            session.setAttribute("toastMessage", "error|Appointment already completed. Cannot request lab test.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/lab/requests");
            return;
        }
        LabTestDAO dao = new LabTestDAO();
        boolean ok = dao.createForVet(recordId, account.getUserId(), testType, requestNotes);
        if (ok) {
            session.setAttribute("toastMessage", "success|Lab request created.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/lab/requests");
        } else {
            request.setAttribute("error", "Cannot create lab request (record not found or access denied).");
            request.setAttribute("recordId", recordId);
            request.setAttribute("testType", testType);
            request.setAttribute("requestNotes", requestNotes);
            request.getRequestDispatcher("/views/veterinarian/labRequestCreate.jsp").forward(request, response);
        }
    }
}

