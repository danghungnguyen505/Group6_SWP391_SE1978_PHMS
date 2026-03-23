package controller.veterinarian;

import dal.MedicalRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "EmrCompleteController", urlPatterns = {"/veterinarian/emr/complete"})
public class EmrCompleteController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdStr = request.getParameter("apptId");
        int apptId;
        try {
            apptId = Integer.parseInt(apptIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "error|Invalid appointment ID.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        MedicalRecordDAO recordDAO = new MedicalRecordDAO();
        Integer recordId = recordDAO.getRecordIdByApptForVet(apptId, account.getUserId());
        if (recordId != null) {
            session.setAttribute("toastMessage", "error|Please complete examination inside EMR Detail page.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
        } else {
            session.setAttribute("toastMessage", "error|Medical record not found. Please create/open EMR from queue.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
        }
    }
}
