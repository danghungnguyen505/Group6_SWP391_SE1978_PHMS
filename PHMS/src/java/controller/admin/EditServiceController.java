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
            session.setAttribute("toastMessage", "error|Invalid service ID!");
            response.sendRedirect("services");
            return;
        }

        int id = Integer.parseInt(idStr);
        Service s = new ServiceDAO().getServiceById(id);
        if (s == null) {
            session.setAttribute("toastMessage", "error|Service not found!");
            response.sendRedirect("services");
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
        String serviceType = normalizeServiceType(request.getParameter("serviceType"));
        String priceStr = request.getParameter("price");
        String desc = util.ValidationUtils.sanitize(request.getParameter("description"));

        if (!util.ValidationUtils.isNotEmpty(idStr)
                || !util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Invalid service ID!");
            response.sendRedirect("services");
            return;
        }
        int id = Integer.parseInt(idStr);

        if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
            request.setAttribute("error", "Service name must be 1-100 characters.");
            request.setAttribute("s", new Service(id, name, serviceType, 0, desc, true, account.getUserId()));
            request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
            return;
        }

        if (!util.ValidationUtils.isPositiveNumber(priceStr)) {
            request.setAttribute("error", "Service price must be a positive number.");
            request.setAttribute("s", new Service(id, name, serviceType, 0, desc, true, account.getUserId()));
            request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
            return;
        }

        double price = Double.parseDouble(priceStr);
        if (price <= 0 || price > 100000000) {
            request.setAttribute("error", "Invalid service price.");
            request.setAttribute("s", new Service(id, name, serviceType, 0, desc, true, account.getUserId()));
            request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
            return;
        }

        if (desc == null) {
            desc = "";
        }

        ServiceDAO serviceDAO = new ServiceDAO();
        if (serviceDAO.existsByNameForOther(id, name)) {
            request.setAttribute("error", "Service name is already used by another service.");
            request.setAttribute("s", new Service(id, name, serviceType, price, desc, true, account.getUserId()));
            request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
            return;
        }

        try {
            serviceDAO.updateService(new Service(id, name, serviceType, price, desc, true, account.getUserId()));
            session.setAttribute("toastMessage", "success|Service updated successfully!");
            response.sendRedirect("services");
        } catch (Exception e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.setAttribute("s", new Service(id, name, serviceType, price, desc, true, account.getUserId()));
            request.getRequestDispatcher("/views/admin/editService.jsp").forward(request, response);
        }
    }

    private String normalizeServiceType(String rawType) {
        if (rawType == null) {
            return "Basic";
        }
        String t = rawType.trim();
        if ("Emergency".equalsIgnoreCase(t)) {
            return "Emergency";
        }
        if ("LabTest".equalsIgnoreCase(t)) {
            return "LabTest";
        }
        return "Basic";
    }
}

