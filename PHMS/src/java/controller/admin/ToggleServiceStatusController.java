<<<<<<< Updated upstream
package controller.admin;

import dal.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Toggle active/inactive status for a service.
 * SRP: Update status only.
 */
@WebServlet(name = "ToggleServiceStatusController", urlPatterns = {"/admin/service-toggle"})
public class ToggleServiceStatusController extends HttpServlet {

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
        String statusStr = request.getParameter("status");

        if (!util.ValidationUtils.isNotEmpty(idStr)
                || !util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|ID dịch vụ không hợp lệ!");
            response.sendRedirect("dashboard");
            return;
        }

        int id = Integer.parseInt(idStr);
        boolean status = Boolean.parseBoolean(statusStr);

        try {
            ServiceDAO dao = new ServiceDAO();
            dao.toggleServiceStatus(id, status);
            session.setAttribute("toastMessage", "success|Cập nhật trạng thái dịch vụ thành công!");
        } catch (Exception e) {
            session.setAttribute("toastMessage", "error|Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect("dashboard");
    }
}

=======
package controller.admin;

import dal.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Toggle active/inactive status for a service.
 * SRP: Update status only.
 */
@WebServlet(name = "ToggleServiceStatusController", urlPatterns = {"/admin/service-toggle"})
public class ToggleServiceStatusController extends HttpServlet {

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
        String statusStr = request.getParameter("status");

        if (!util.ValidationUtils.isNotEmpty(idStr)
                || !util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|ID dịch vụ không hợp lệ!");
            response.sendRedirect("dashboard");
            return;
        }

        int id = Integer.parseInt(idStr);
        boolean status = Boolean.parseBoolean(statusStr);

        try {
            ServiceDAO dao = new ServiceDAO();
            dao.toggleServiceStatus(id, status);
            session.setAttribute("toastMessage", "success|Cập nhật trạng thái dịch vụ thành công!");
        } catch (Exception e) {
            session.setAttribute("toastMessage", "error|Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect("dashboard");
    }
}

>>>>>>> Stashed changes
