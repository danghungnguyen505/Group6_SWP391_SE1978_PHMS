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

    private String extractLabFilePath(String resultData) {
        if (resultData == null) {
            return null;
        }
        String trimmed = resultData.trim();
        if (!trimmed.startsWith("/uploads/lab/")) {
            return null;
        }
        int lineBreakIdx = trimmed.indexOf('\n');
        if (lineBreakIdx < 0) {
            return trimmed;
        }
        return trimmed.substring(0, lineBreakIdx).trim();
    }

    private String extractLabResultText(String resultData) {
        if (resultData == null) {
            return "";
        }
        String normalized = resultData.replace("\r", "");
        if (!normalized.trim().startsWith("/uploads/lab/")) {
            return normalized.trim();
        }
        int lineBreakIdx = normalized.indexOf('\n');
        if (lineBreakIdx < 0) {
            return "";
        }
        String remain = normalized.substring(lineBreakIdx + 1).trim();
        return remain;
    }

    private String composeResultData(String filePath, String resultText) {
        String text = resultText == null ? "" : resultText.trim();
        if (filePath != null && !filePath.trim().isEmpty()) {
            if (text.isEmpty()) {
                return filePath.trim();
            }
            return filePath.trim() + "\n\n" + text;
        }
        return text;
    }

    private String sanitizeFileName(String fileName) {
        if (fileName == null) {
            return "upload";
        }
        return fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

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
        String existingFilePath = extractLabFilePath(lt.getResultData());
        String existingResultText = extractLabResultText(lt.getResultData());
        request.setAttribute("test", lt);
        request.setAttribute("canUpdate", canUpdate);
        request.setAttribute("existingFilePath", existingFilePath);
        request.setAttribute("existingResultText", existingResultText);
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

        LabTest currentTest = daoCheck.getByIdForNurse(testId);
        String existingFilePath = currentTest != null ? extractLabFilePath(currentTest.getResultData()) : null;
        String resultDataToStore;

        // Optional file upload
        Part filePart = null;
        try {
            filePart = request.getPart("resultFile");
        } catch (Exception ignored) {
        }

        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String lower = submittedFileName.toLowerCase();
            String contentType = filePart.getContentType() != null ? filePart.getContentType().toLowerCase() : "";
            boolean allowedExtension = lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png");
            boolean allowedMime = contentType.startsWith("image/");
            boolean allowed = allowedExtension && allowedMime;
            if (!allowed) {
                session.setAttribute("toastMessage", "error|Invalid image type. Allowed: JPG, JPEG, PNG.");
                response.sendRedirect(request.getContextPath() + "/nurse/lab/update?id=" + testId);
                return;
            }

            String uploadDir = getServletContext().getRealPath("/uploads/lab");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String safeFileName = sanitizeFileName(submittedFileName);
            String storedName = "lab_" + testId + "_" + System.currentTimeMillis() + "_" + safeFileName;
            File out = new File(dir, storedName);
            filePart.write(out.getAbsolutePath());

            resultDataToStore = composeResultData("/uploads/lab/" + storedName, resultText);
        } else {
            resultDataToStore = composeResultData(existingFilePath, resultText);
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

