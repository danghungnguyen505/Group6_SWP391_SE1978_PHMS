package controller.nurse;

import dal.LabTestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import model.LabTest;
import model.User;

/**
 * Nurse updates lab result (status + result text / optional file upload).
 * SRP: Update only.
 */
@WebServlet(name = "NurseLabUpdateController", urlPatterns = {"/nurse/lab/update"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 15 * 1024 * 1024
)
public class NurseLabUpdateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Nurse".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/nurse/lab/queue");
            return;
        }
        int testId;
        try {
            testId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/nurse/lab/queue");
            return;
        }

        LabTestDAO dao = new LabTestDAO();
        LabTest lt = dao.getByIdForNurse(testId);
        if (lt == null) {
            session.setAttribute("toastMessage", "error|Lab test not found.");
            response.sendRedirect(request.getContextPath() + "/nurse/lab/queue");
            return;
        }

        // Check if test can be updated (not Completed or Cancelled)
        boolean canUpdate = dao.canUpdate(testId);
        request.setAttribute("test", lt);
        request.setAttribute("canUpdate", canUpdate);
        request.getRequestDispatcher("/views/nurse/labUpdate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Nurse".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("testId");
        String status = request.getParameter("status");
        String resultText = request.getParameter("resultText");

        if (!util.ValidationUtils.isNotEmpty(idStr) || !util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Invalid lab test ID.");
            response.sendRedirect(request.getContextPath() + "/nurse/lab/queue");
            return;
        }
        int testId = Integer.parseInt(idStr);

        // Block update if test is already Completed or Cancelled
        LabTestDAO daoCheck = new LabTestDAO();
        if (!daoCheck.canUpdate(testId)) {
            session.setAttribute("toastMessage", "error|This lab test is already completed or cancelled and cannot be updated.");
            response.sendRedirect(request.getContextPath() + "/nurse/lab/queue");
            return;
        }

        // Validate status
        if (!util.ValidationUtils.isNotEmpty(status)) {
            session.setAttribute("toastMessage", "error|Status is required.");
            response.sendRedirect(request.getContextPath() + "/nurse/lab/update?id=" + testId);
            return;
        }
        if (!("Requested".equals(status) || "In Progress".equals(status) || "Completed".equals(status))) {
            session.setAttribute("toastMessage", "error|Invalid status.");
            response.sendRedirect(request.getContextPath() + "/nurse/lab/update?id=" + testId);
            return;
        }

        // Sanitize resultText after validation
        if (resultText == null) resultText = "";
        resultText = resultText.trim();

        if (resultText.length() > 4000) {
            session.setAttribute("toastMessage", "error|Result text must be <= 4000 characters.");
            response.sendRedirect(request.getContextPath() + "/nurse/lab/update?id=" + testId);
            return;
        }

        String resultDataToStore = resultText;

        // Optional file upload
        Part filePart = null;
        try {
            filePart = request.getPart("resultFile");
        } catch (Exception ignored) {
        }

        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String lower = submittedFileName.toLowerCase();
            boolean allowed = lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".dcm");
            if (!allowed) {
                session.setAttribute("toastMessage", "error|Invalid file type. Allowed: JPG/PNG/DICOM(.dcm)");
                response.sendRedirect(request.getContextPath() + "/nurse/lab/update?id=" + testId);
                return;
            }

            String uploadDir = getServletContext().getRealPath("/uploads/lab");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String storedName = "lab_" + testId + "_" + System.currentTimeMillis() + "_" + submittedFileName;
            File out = new File(dir, storedName);
            filePart.write(out.getAbsolutePath());

            // Store relative path in result_data
            resultDataToStore = "/uploads/lab/" + storedName + (resultText != null && !resultText.isEmpty() ? ("\n\n" + resultText) : "");
        }

        LabTestDAO dao = new LabTestDAO();
        boolean ok = dao.updateResultForNurse(testId, account.getUserId(), status, resultDataToStore);
        if (ok) {
            session.setAttribute("toastMessage", "success|Lab test updated.");
        } else {
            session.setAttribute("toastMessage", "error|Cannot update lab test.");
        }
        response.sendRedirect(request.getContextPath() + "/nurse/lab/queue");
    }
}

