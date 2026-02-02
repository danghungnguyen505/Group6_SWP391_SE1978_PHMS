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
import dal.PaymentDAO;
import model.Payment;
import model.Invoice;

/**
 *
 * @author TrungNguyen2002
 */
@WebServlet("/vnpay-return")
public class VNPayReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String responseCode = req.getParameter("vnp_ResponseCode");
        String invoiceId = req.getParameter("vnp_TxnRef");

        if ("00".equals(responseCode)) {
            InvoiceDAO dao = new InvoiceDAO();
            dao.updateInvoiceStatus(Integer.parseInt(invoiceId), "PAID");
        }

        resp.sendRedirect(req.getContextPath() + "/billing?invoiceId=" + invoiceId);
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
