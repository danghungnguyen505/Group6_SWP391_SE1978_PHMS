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

/**
 *
 * @author Nguyen Dang Hung
 */
public class DashboardController extends HttpServlet {
   
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
        List<Service> list = dao.getAllServices();
        
        request.setAttribute("services", list);
        
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
                double price = Double.parseDouble(request.getParameter("price"));
                String desc = request.getParameter("description");

                dao.addService(new Service(0, name, price, desc, true, currentAdminId));

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("serviceId"));
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                String desc = request.getParameter("description");

                dao.updateService(new Service(id, name, price, desc, true, currentAdminId));

            } else if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean status = Boolean.parseBoolean(request.getParameter("status"));
                dao.toggleServiceStatus(id, status);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("dashboard");
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
