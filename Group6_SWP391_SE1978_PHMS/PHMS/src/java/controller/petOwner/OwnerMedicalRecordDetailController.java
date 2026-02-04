package controller.petOwner;

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
 * PetOwner medical record detail.
 * SRP: Read detail only.
 */
@WebServlet(name = "OwnerMedicalRecordDetailController", urlPatterns = {"/my-medical-records/detail"})
public class OwnerMedicalRecordDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-medical-records");
            return;
        }

        int recordId;
        try {
            recordId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-medical-records");
            return;
        }

        MedicalRecordDAO dao = new MedicalRecordDAO();
        MedicalRecord mr = dao.getByIdForOwner(recordId, account.getUserId());
        if (mr == null) {
            session.setAttribute("toastMessage", "error|Record not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/my-medical-records");
            return;
        }

        request.setAttribute("record", mr);
        request.getRequestDispatcher("/views/petOwner/medicalRecordDetail.jsp").forward(request, response);
    }
}

