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
 * Create new clinic service.
 * SRP: Handle service creation only.
 * @author Nguyen Dang Hung
 */
@WebServlet(name = "AddServiceController", urlPatterns = {"/admin/add-service"})
public class AddServiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Authorization: only ClinicManager/Admin via servlet-level check (filter already applied)
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
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

        String name = util.ValidationUtils.sanitize(request.getParameter("name"));
        String priceStr = request.getParameter("price");
        String desc = util.ValidationUtils.sanitize(request.getParameter("description"));

        // Validate name
        if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
            request.setAttribute("error", "Tên dịch vụ phải có từ 1 đến 100 ký tự!");
            request.setAttribute("name", name);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
            return;
        }

        // Validate price
        if (!util.ValidationUtils.isPositiveNumber(priceStr)) {
            request.setAttribute("error", "Giá dịch vụ phải là số dương!");
            request.setAttribute("name", name);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
            return;
        }

        double price = Double.parseDouble(priceStr);
        if (price <= 0 || price > 100000000) {
            request.setAttribute("error", "Giá dịch vụ không hợp lệ!");
            request.setAttribute("name", name);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
            return;
        }

        // Normalize description
        if (desc == null) {
            desc = "";
        }

        // Persist
        try {
            new ServiceDAO().addService(new Service(0, name, price, desc, true, account.getUserId()));
            session.setAttribute("toastMessage", "success|Thêm dịch vụ thành công!");
            response.sendRedirect("dashboard");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("name", name);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
        }
    }
}
