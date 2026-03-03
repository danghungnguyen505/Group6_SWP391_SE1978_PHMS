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

/**
 *
 * @author Nguyen Dang Hung
 */
public class RegisterController extends HttpServlet {
   
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
            out.println("<title>Servlet RegisterController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterController at " + request.getContextPath () + "</h1>");
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
        request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
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
        // Get and sanitize input
        String user = util.ValidationUtils.sanitize(request.getParameter("username"));
        String pass = request.getParameter("password");
        String repass = request.getParameter("repassword");
        String name = util.ValidationUtils.sanitize(request.getParameter("fullname"));
        String email = util.ValidationUtils.sanitize(request.getParameter("email"));
        String phone = util.ValidationUtils.sanitize(request.getParameter("phone"));
        String address = util.ValidationUtils.sanitize(request.getParameter("address"));
        
        // Validate all fields
        if (!util.ValidationUtils.isNotEmpty(user) || !util.ValidationUtils.isValidUsername(user)) {
            request.setAttribute("error", "Tên đăng nhập không hợp lệ! (3-50 ký tự, chỉ chữ, số và dấu gạch dưới)");
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(pass) || !util.ValidationUtils.isValidPassword(pass)) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!pass.equals(repass)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp!");
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 2, 100)) {
            request.setAttribute("error", "Họ tên phải có từ 2 đến 100 ký tự!");
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(email) || !util.ValidationUtils.isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ!");
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(phone) || !util.ValidationUtils.isValidPhone(phone)) {
<<<<<<< Updated upstream
            request.setAttribute("error", "Số điện thoại không hợp lệ! (Ví dụ: 0912345678 hoặc +84912345678)");
=======
            request.setAttribute("error", "Số điện thoại không hợp lệ! (Ví dụ: 0912345678)");
>>>>>>> Stashed changes
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(address) || !util.ValidationUtils.isLengthValid(address, 5, 255)) {
            request.setAttribute("error", "Địa chỉ phải có từ 5 đến 255 ký tự!");
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }
        
        UserDAO dao = new UserDAO();
        // Uniqueness checks: username, email, phone
        if (dao.checkUsernameExists(user)) {
<<<<<<< Updated upstream
            request.setAttribute("error", "Tên đăng nhập này đã tồn tại!");
=======
            request.setAttribute("error", "Tên đăng nhập này đã tồn tại! Vui lòng chọn tên khác.");
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        if (dao.checkEmailExists(email)) {
            request.setAttribute("error", "Email này đã được sử dụng! Vui lòng dùng email khác.");
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        if (dao.checkPhoneExists(phone)) {
            request.setAttribute("error", "Số điện thoại này đã được sử dụng! Vui lòng dùng số khác.");
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        try {
            dao.registerOwner(user, pass, name, email, phone, address);
            request.getSession().setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
            response.sendRedirect("login");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
>>>>>>> Stashed changes
            request.setAttribute("username", user);
            request.setAttribute("fullname", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
<<<<<<< Updated upstream
        } else {
            try {
                dao.registerOwner(user, pass, name, email, phone, address);
                request.getSession().setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                response.sendRedirect("login");
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                request.setAttribute("username", user);
                request.setAttribute("fullname", name);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.setAttribute("address", address);
                request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            }
=======
>>>>>>> Stashed changes
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
