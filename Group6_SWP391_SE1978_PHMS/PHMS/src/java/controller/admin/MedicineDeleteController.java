package controller.admin;

import dal.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Admin deletes medicine.
 * SRP: Delete medicine only.
 */
@WebServlet(name = "MedicineDeleteController", urlPatterns = {"/admin/medicine/delete"})
public class MedicineDeleteController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String idStr = request.getParameter("id");
        if (!util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Medicine ID không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/medicine/list");
            return;
        }
        
        int id = Integer.parseInt(idStr);
        MedicineDAO medicineDAO = new MedicineDAO();
        boolean ok = medicineDAO.deleteMedicine(id);
        
        if (ok) {
            session.setAttribute("toastMessage", "success|Đã xóa thuốc thành công.");
        } else {
            session.setAttribute("toastMessage", "error|Không thể xóa thuốc (có thể đang được sử dụng trong đơn thuốc hoặc hóa đơn).");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/medicine/list");
    }
}
