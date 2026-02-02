/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import util.VNPayUtil;

@WebServlet("/vnpay-create")
public class VNPayCreateController extends HttpServlet {

    private static final String VNP_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String VNP_TMNCODE = "2ZJH1GC2";
    private static final String VNP_HASHSECRET = "UMPXS8LJ97M4UGOZIKTPDIG60DX49K4I";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String invoiceId = req.getParameter("invoiceId");

       long amount = 108000 * 100; // MUST be *100
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String createDate = sdf.format(new Date());
       String expireDate = sdf.format(new Date(System.currentTimeMillis() + 30 * 60 * 1000));

        Map<String, String> params = new HashMap<>();
        params.put("vnp_Version", "2.1.0");
params.put("vnp_Command", "pay");
params.put("vnp_TmnCode", VNP_TMNCODE);
params.put("vnp_Amount", String.valueOf(amount));
params.put("vnp_CurrCode", "VND");
params.put("vnp_TxnRef", invoiceId + "_" + System.currentTimeMillis());
params.put("vnp_OrderInfo", "Pay_invoice_" + invoiceId);

params.put("vnp_OrderType", "other");
params.put("vnp_Locale", "vn");
params.put("vnp_BankCode", "NCB");
params.put("vnp_ReturnUrl", "http://192.168.4.198:8080/PHMS/vnpay-return");
params.put("vnp_IpAddr", req.getRemoteAddr());
params.put("vnp_CreateDate", createDate);
params.put("vnp_ExpireDate", expireDate);

        String query = VNPayUtil.buildQuery(params, VNP_HASHSECRET);
        String fullUrl = VNP_URL + "?" + query;

        // 🔎 DEBUG
        System.out.println("VNPay FULL URL = " + fullUrl);

        resp.sendRedirect(fullUrl);
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
