/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.petOwner;

import dal.InvoiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Invoice;
import model.User;

/**
 *
 * @author TrungNguyen2002
 */
@WebServlet(name = "BillingHistoryServlet", urlPatterns = {"/billing-history"})
public class BillingHistoryServlet extends HttpServlet {

    private InvoiceDAO invoiceDAO = new InvoiceDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Make sure only PetOwner can access
        if (user == null || !"PetOwner".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        int ownerId = user.getUserId();

        List<Invoice> invoiceList = invoiceDAO.getInvoicesByOwnerId(ownerId);

        // Summary calculations
        int totalInvoices = invoiceList.size();
        int paidCount = 0;
        int unpaidCount = 0;
        double totalSpent = 0;

        for (Invoice inv : invoiceList) {
            if ("Paid".equalsIgnoreCase(inv.getStatus())) {
                paidCount++;
                totalSpent += inv.getTotalAmount();
            } else {
                unpaidCount++;
            }
        }

        request.setAttribute("invoiceList", invoiceList);
        request.setAttribute("totalInvoices", totalInvoices);
        request.setAttribute("paidCount", paidCount);
        request.setAttribute("unpaidCount", unpaidCount);
        request.setAttribute("totalSpent", totalSpent);

        request.getRequestDispatcher("billing-history.jsp").forward(request, response);
    }


    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
