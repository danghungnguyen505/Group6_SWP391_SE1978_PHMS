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
public class ChangePasswordController extends HttpServlet {
   
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
            out.println("<title>Servlet ChangePasswordController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePasswordController at " + request.getContextPath () + "</h1>");
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
        request.getRequestDispatcher("views/auth/change-password.jsp").forward(request, response);
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
        User user = (User) session.getAttribute("account");
        
        if(user == null) {
            response.sendRedirect("login");
            return;
        }

        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");
        
        // Validate input
        if (oldPass == null || oldPass.trim().isEmpty() || 
            newPass == null || newPass.trim().isEmpty() || 
            confirmPass == null || confirmPass.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        // Validate password strength
        if (!util.ValidationUtils.isValidPassword(newPass)) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu mới không khớp!");
            request.getRequestDispatcher("views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        if (oldPass.equals(newPass)) {
            request.setAttribute("error", "Mật khẩu mới phải khác mật khẩu cũ!");
            request.getRequestDispatcher("views/auth/change-password.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        // Get user with password hash from database
        User dbUser = dao.getUserById(user.getUserId());
        if (dbUser == null) {
            request.setAttribute("error", "Không tìm thấy thông tin người dùng!");
            request.getRequestDispatcher("views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        // Verify old password
        String storedPassword = dbUser.getPassword();
        boolean passwordMatches = false;
        if (util.PasswordUtil.isValidHash(storedPassword)) {
            passwordMatches = util.PasswordUtil.verifyPassword(oldPass, storedPassword);
        } else {
            // Legacy plain text support
            passwordMatches = oldPass.equals(storedPassword);
        }
        
        if (!passwordMatches) {
            request.setAttribute("error", "Mật khẩu cũ không đúng!");
            request.getRequestDispatcher("views/auth/change-password.jsp").forward(request, response);
            return;
        }
        
        dao.changePassword(user.getUserId(), newPass);
        
        request.setAttribute("message", "Đổi mật khẩu thành công!");
        request.getRequestDispatcher("views/auth/change-password.jsp").forward(request, response);
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
