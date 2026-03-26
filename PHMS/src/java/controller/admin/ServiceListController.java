/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import dal.ServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Service;
import model.User;
import util.PaginationUtils;

/**
 *
 * @author Nguyen Dang Hung
 */
public class ServiceListController extends HttpServlet {
   
    private static final int PAGE_SIZE = 10;
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminDashboardController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminDashboardController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect("../login");
            return;
        }

        ServiceDAO dao = new ServiceDAO();
        List<Service> allServices = dao.getAllServices();

        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status"); // active / inactive
        String typeFilter = request.getParameter("type"); // Basic / Emergency / LabTest

        List<Service> filteredServices = new java.util.ArrayList<>();
        for (Service s : allServices) {
            boolean match = true;

            if (search != null && !search.trim().isEmpty()) {
                String lower = search.trim().toLowerCase();
                String name = s.getName() != null ? s.getName().toLowerCase() : "";
                String desc = s.getDescription() != null ? s.getDescription().toLowerCase() : "";
                String type = s.getType() != null ? s.getType().toLowerCase() : "";
                match = name.contains(lower) || desc.contains(lower) || type.contains(lower);
            }

            if (match && statusFilter != null && !statusFilter.trim().isEmpty()) {
                boolean active = s.isActive();
                if ("active".equalsIgnoreCase(statusFilter)) {
                    match = active;
                } else if ("inactive".equalsIgnoreCase(statusFilter)) {
                    match = !active;
                }
            }

            if (match && typeFilter != null && !typeFilter.trim().isEmpty()) {
                String serviceType = s.getType() != null ? s.getType() : "";
                match = serviceType.equalsIgnoreCase(typeFilter.trim());
            }

            if (match) {
                filteredServices.add(s);
            }
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalPages = PaginationUtils.getTotalPages(filteredServices, PAGE_SIZE);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<Service> services = PaginationUtils.getPage(filteredServices, page, PAGE_SIZE);
        
        request.setAttribute("services", services);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalServices", filteredServices.size());
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("searchKeyword", search);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("typeFilter", typeFilter);
        
        request.getRequestDispatcher("/views/admin/serviceManagement.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("../login");
            return;
        }

        int currentAdminId = account.getUserId(); 
        String action = request.getParameter("action");
        ServiceDAO dao = new ServiceDAO();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String serviceType = normalizeServiceType(request.getParameter("serviceType"));
                double price = Double.parseDouble(request.getParameter("price"));
                String desc = request.getParameter("description");

                dao.addService(new Service(0, name, serviceType, price, desc, true, currentAdminId));

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("serviceId"));
                String name = request.getParameter("name");
                String serviceType = normalizeServiceType(request.getParameter("serviceType"));
                double price = Double.parseDouble(request.getParameter("price"));
                String desc = request.getParameter("description");

                dao.updateService(new Service(id, name, serviceType, price, desc, true, currentAdminId));

            } else if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean status = Boolean.parseBoolean(request.getParameter("status"));
                dao.toggleServiceStatus(id, status);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("services");
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

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
