/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.InvoiceDAO;
import dal.InvoiceDetailDAO;
import java.util.List;
import model.Invoice;
import model.InvoiceDetail;
/**
 *
 * @author TrungNguyen2002
 */
@WebServlet(name = "BillingController", urlPatterns = {"/billing"})
public class BillingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String invoiceIdRaw = req.getParameter("invoiceId");

        if (invoiceIdRaw == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "No invoice selected");
            return;
        }

        int invoiceId = Integer.parseInt(invoiceIdRaw);

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        InvoiceDetailDAO detailDAO = new InvoiceDetailDAO();

        Invoice invoice = invoiceDAO.getInvoiceFull(invoiceId);
        List<InvoiceDetail> details = detailDAO.getByInvoiceId(invoiceId);
double total = detailDAO.calculateTotalByInvoiceId(invoiceId);
invoiceDAO.updateTotalAmount(invoiceId, total);
invoice.setTotalAmount(total);
        req.setAttribute("invoice", invoice);
        req.setAttribute("details", details);

        req.setAttribute("contentPage", "/views/petOwner/billing.jsp");
req.getRequestDispatcher("/views/petOwner/layoutPetOwner.jsp").forward(req, resp);

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
