/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.vnpayCommon;
import dal.InvoiceDAO;
import java.io.IOException;
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
 * @author CTT VNPAY
 */
@WebServlet(name = "vnpayReturn", urlPatterns = {"/vnpay-return"})
public class vnpayReturn extends HttpServlet {
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

        // 1. Lấy tất cả tham số từ VNPay trả về
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // 2. Kiểm tra chữ ký (Hash)
        String signValue = Config.hashAllFields(fields);
        if (signValue.equals(vnp_SecureHash)) {
            
            // vnp_TxnRef của bạn có dạng "id_random" (ví dụ: "15_12345678")
            String rawTxnRef = request.getParameter("vnp_TxnRef");
            int invoiceId = Integer.parseInt(rawTxnRef.split("_")[0]); // Lấy phần ID trước dấu gạch dưới

            String responseCode = request.getParameter("vnp_ResponseCode");
            boolean isSuccess = "00".equals(responseCode);

            // 3. Cập nhật DB
            InvoiceDAO dao = new InvoiceDAO();
            if (isSuccess) {
                dao.updateInvoiceStatus(invoiceId, "Paid"); // Hoặc "Completed" tùy DB của bạn
                request.setAttribute("message", "Thanh toán thành công hóa đơn #" + invoiceId);
            } else {
                dao.updateInvoiceStatus(invoiceId, "Failed");
                request.setAttribute("message", "Thanh toán không thành công (Mã lỗi: " + responseCode + ")");
            }

            request.setAttribute("isSuccess", isSuccess);
            request.getRequestDispatcher("/views/receptionist/vnpay_return.jsp").forward(request, response);
            
        } else {
            response.getWriter().println(signValue);
            response.getWriter().println(vnp_SecureHash);
            response.getWriter().println("Chữ ký không hợp lệ (Invalid Signature)!");
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
        processRequest(request, response);
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
        processRequest(request, response);
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
