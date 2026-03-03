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
import model.Service;
import model.User;

/**
 *
 * @author Nguyen Dang Hung
 */
public class AddServiceController extends HttpServlet {
   
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
            out.println("<title>Servlet AddServiceController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddServiceController at " + request.getContextPath () + "</h1>");
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

        ServiceDAO serviceDAO = new ServiceDAO();
        // Business validation: service name must be unique
        if (serviceDAO.existsByName(name)) {
            request.setAttribute("error", "Tên dịch vụ đã tồn tại! Vui lòng chọn tên khác.");
            request.setAttribute("name", name);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
            return;
        }

        // Persist
        try {
            serviceDAO.addService(new Service(0, name, price, desc, true, account.getUserId()));
            session.setAttribute("toastMessage", "success|Thêm dịch vụ thành công!");
            response.sendRedirect("services");
        } catch (Exception e) {
             String detailError = e.getClass().getSimpleName() + ": " + e.getMessage();
            request.setAttribute("error", "Lỗi hệ thống: " + detailError);
            
            request.setAttribute("name", name);
            request.setAttribute("price", priceStr);
            request.setAttribute("description", desc);
            request.getRequestDispatcher("/views/admin/addService.jsp").forward(request, response);
        }
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
