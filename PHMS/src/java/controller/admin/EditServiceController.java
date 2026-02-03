package controller.admin;

import dal.ServiceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Service;
import model.User;

/**
 * Update existing clinic service.
 * SRP: Handle service update only.
 * @author Nguyen Dang Hung
 */
@WebServlet(name = "EditServiceController", urlPatterns = {"/admin/edit-service"})
public class EditServiceController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (!util.ValidationUtils.isNotEmpty(idStr)
                || !util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|ID dịch vụ không hợp lệ!");
            response.sendRedirect("dashboard");
            return;
        }

        int id = Integer.parseInt(idStr);
        Service s = new ServiceDAO().getServiceById(id);
        if (s == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy dịch vụ!");
            response.sendRedirect("dashboard");
            return;
        }

        request.setAttribute("s", s);
        request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
    } 

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
        String name = util.ValidationUtils.sanitize(request.getParameter("name"));
        String priceStr = request.getParameter("price");
        String desc = util.ValidationUtils.sanitize(request.getParameter("description"));

        // Validate id
        if (!util.ValidationUtils.isNotEmpty(idStr)
                || !util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|ID dịch vụ không hợp lệ!");
            response.sendRedirect("dashboard");
            return;
        }
        int id = Integer.parseInt(idStr);

        // Validate name
        if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
            request.setAttribute("error", "Tên dịch vụ phải có từ 1 đến 100 ký tự!");
            request.setAttribute("s", new Service(id, name, 0, desc, true, account.getUserId()));
            request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
            return;
        }

        // Validate price
        if (!util.ValidationUtils.isPositiveNumber(priceStr)) {
            request.setAttribute("error", "Giá dịch vụ phải là số dương!");
            request.setAttribute("s", new Service(id, name, 0, desc, true, account.getUserId()));
            request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
            return;
        }

        double price = Double.parseDouble(priceStr);
        if (price <= 0 || price > 100000000) {
            request.setAttribute("error", "Giá dịch vụ không hợp lệ!");
            request.setAttribute("s", new Service(id, name, 0, desc, true, account.getUserId()));
            request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
            return;
        }

        if (desc == null) {
            desc = "";
        }

        try {
        new ServiceDAO().updateService(new Service(id, name, price, desc, true, account.getUserId()));
            session.setAttribute("toastMessage", "success|Cập nhật dịch vụ thành công!");
        response.sendRedirect("dashboard");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("s", new Service(id, name, price, desc, true, account.getUserId()));
            request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
        }
    }
}
