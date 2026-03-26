package controller.admin;

import dal.ServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Service;
import model.User;

/**
 *
 * @author Nguyen Dang Hung
 */
public class AddServiceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddServiceController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddServiceController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        String serviceType = normalizeServiceType(request.getParameter("serviceType"));
        String priceStr = request.getParameter("price");
        String desc = util.ValidationUtils.sanitize(request.getParameter("description"));

        if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
            request.setAttribute("error", "Service name must be 1-100 characters.");
            request.setAttribute("name", name);
            request.setAttribute("serviceType", serviceType);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
            return;
        }

        if (!util.ValidationUtils.isPositiveNumber(priceStr)) {
            request.setAttribute("error", "Service price must be a positive number.");
            request.setAttribute("name", name);
            request.setAttribute("serviceType", serviceType);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
            return;
        }

        double price = Double.parseDouble(priceStr);
        if (price <= 0 || price > 100000000) {
            request.setAttribute("error", "Invalid service price.");
            request.setAttribute("name", name);
            request.setAttribute("serviceType", serviceType);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
            return;
        }

        if (desc == null) {
            desc = "";
        }

        ServiceDAO serviceDAO = new ServiceDAO();
        if (serviceDAO.existsByName(name)) {
            request.setAttribute("error", "Service name already exists.");
            request.setAttribute("name", name);
            request.setAttribute("serviceType", serviceType);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
            return;
        }

        try {
            serviceDAO.addService(new Service(0, name, serviceType, price, desc, true, account.getUserId()));
            session.setAttribute("toastMessage", "success|Service created successfully!");
            response.sendRedirect("services");
        } catch (Exception e) {
            String detailError = e.getClass().getSimpleName() + ": " + e.getMessage();
            request.setAttribute("error", "System error: " + detailError);
            request.setAttribute("name", name);
            request.setAttribute("serviceType", serviceType);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}

