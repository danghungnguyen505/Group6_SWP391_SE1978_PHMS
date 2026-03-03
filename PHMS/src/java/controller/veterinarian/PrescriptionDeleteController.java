<<<<<<< Updated upstream
package controller.veterinarian;

import dal.PrescriptionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Veterinarian deletes a prescription item.
 * SRP: Delete only.
 */
@WebServlet(name = "PrescriptionDeleteController", urlPatterns = {"/veterinarian/prescription/delete"})
public class PrescriptionDeleteController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String presIdStr = request.getParameter("presId");
        String recordIdStr = request.getParameter("recordId");
        
        if (!util.ValidationUtils.isNotEmpty(presIdStr)
                || !util.ValidationUtils.isIntegerInRange(presIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Prescription không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        
        int presId = Integer.parseInt(presIdStr);
        
        PrescriptionDAO presDAO = new PrescriptionDAO();
        boolean ok = presDAO.deletePrescription(presId, account.getUserId());
        
        if (ok) {
            session.setAttribute("toastMessage", "success|Đã xóa thuốc khỏi đơn.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể xóa thuốc (có thể bạn không có quyền hoặc đơn đã được sử dụng).");
        }
        
        if (recordIdStr != null && util.ValidationUtils.isIntegerInRange(recordIdStr, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/prescription/list?recordId=" + recordIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
        }
    }
}
=======
package controller.veterinarian;

import dal.PrescriptionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Veterinarian deletes a prescription item.
 * SRP: Delete only.
 */
@WebServlet(name = "PrescriptionDeleteController", urlPatterns = {"/veterinarian/prescription/delete"})
public class PrescriptionDeleteController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String presIdStr = request.getParameter("presId");
        String recordIdStr = request.getParameter("recordId");
        
        if (!util.ValidationUtils.isNotEmpty(presIdStr)
                || !util.ValidationUtils.isIntegerInRange(presIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Prescription không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        
        int presId = Integer.parseInt(presIdStr);
        
        PrescriptionDAO presDAO = new PrescriptionDAO();
        boolean ok = presDAO.deletePrescription(presId, account.getUserId());
        
        if (ok) {
            session.setAttribute("toastMessage", "success|Đã xóa thuốc khỏi đơn.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể xóa thuốc (có thể bạn không có quyền hoặc đơn đã được sử dụng).");
        }
        
        if (recordIdStr != null && util.ValidationUtils.isIntegerInRange(recordIdStr, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/prescription/list?recordId=" + recordIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
        }
    }
}
>>>>>>> Stashed changes
