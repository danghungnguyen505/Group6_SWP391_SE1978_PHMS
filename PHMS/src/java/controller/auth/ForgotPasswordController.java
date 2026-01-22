/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author Nguyen Dang Hung
 */
public class ForgotPasswordController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet ForgotPasswordController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgotPasswordController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        request.getRequestDispatcher("views/auth/forgot-password.jsp").forward(request, response);
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
        //processRequest(request, response);
        String email = request.getParameter("email");
        String otpInput = request.getParameter("otp");
        String newPass = request.getParameter("newPass");

        HttpSession session = request.getSession();
        UserDAO dao = new UserDAO();
        
        if (email != null && otpInput == null) {
            User user = dao.checkEmailExist(email);
            if (user != null) {
                String otp = util.SendMail.getRandomOTP();

                try {
                    util.SendMail.sendRecoveryOTP(getServletContext(), email, otp);

                    session.setAttribute("otp", otp);
                    session.setAttribute("resetEmail", email);
                    session.setAttribute("resetUserId", user.getUserId());

                    request.setAttribute("step", "2");
                    request.setAttribute("message", "Mã OTP đã được gửi đến email: " + email);

                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Error: " + e.getMessage());
                }
            } else {
                request.setAttribute("error", "Email này không tồn tại trong hệ thống!");
            }
            request.getRequestDispatcher("views/auth/forgot-password.jsp").forward(request, response);
        }
        else if (otpInput != null && newPass != null) {
            String serverOtp = (String) session.getAttribute("otp");

            if (serverOtp != null && otpInput.equals(serverOtp)) {
                int userId = (int) session.getAttribute("resetUserId");

                dao.changePassword(userId, newPass);

                session.removeAttribute("otp");
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetUserId");

                request.setAttribute("success", "Đổi mật khẩu thành công! Vui lòng đăng nhập.");
            } else {
                request.setAttribute("step", "2"); 
                request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn!");
            }
            request.getRequestDispatcher("views/auth/forgot-password.jsp").forward(request, response);
        }
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
