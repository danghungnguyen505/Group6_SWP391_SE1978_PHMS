/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.vnpayCommon;

import dal.InvoiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
/**
 *
 * @author TrungNguyen2002
 */
@WebServlet("/vnpay-ipn")
public class VnpayIPN extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

        Map<String,String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            if (!fieldName.equals("vnp_SecureHash") && 
                !fieldName.equals("vnp_SecureHashType")) {
                fields.put(fieldName, request.getParameter(fieldName));
            }
        }

        String signValue = Config.hashAllFields(fields);
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");

        if (signValue.equalsIgnoreCase(vnp_SecureHash)) {

            String txnRef = request.getParameter("vnp_TxnRef");
            String responseCode = request.getParameter("vnp_ResponseCode");

            int invoiceId = Integer.parseInt(txnRef.split("_")[0]);

            if ("00".equals(responseCode)) {
                new InvoiceDAO().updateInvoiceStatus(invoiceId, "Paid");
                response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
            } else {
                response.getWriter().write("{\"RspCode\":\"01\",\"Message\":\"Confirm Failed\"}");
            }

        } else {
            response.getWriter().write("{\"RspCode\":\"97\",\"Message\":\"Invalid Signature\"}");
        }
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
