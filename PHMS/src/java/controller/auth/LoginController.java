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
import util.VerifyRecaptcha;

/**
 *
 * @author Nguyen Dang Hung
 */
public class LoginController extends HttpServlet {

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
            out.println("<title>Servlet LoginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginController at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
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
        // Validate reCAPTCHA
        String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
        VerifyRecaptcha vr = new VerifyRecaptcha();
        boolean isCaptchaValid = vr.verify(gRecaptchaResponse);
        if (isCaptchaValid) {
            request.setAttribute("error", "Vui lÃƒÂ²ng xÃƒÂ¡c thÃ¡Â»Â±c bÃ¡ÂºÂ¡n khÃƒÂ´ng phÃ¡ÂºÂ£i lÃƒÂ  ngÃ†Â°Ã¡Â»Âi mÃƒÂ¡y!");
            request.setAttribute("username", request.getParameter("username"));
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
            return;
        }

        // Validate input
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty()) {
            request.setAttribute("error", "Vui lÃƒÂ²ng nhÃ¡ÂºÂ­p Ã„â€˜Ã¡ÂºÂ§y Ã„â€˜Ã¡Â»Â§ tÃƒÂªn Ã„â€˜Ã„Æ’ng nhÃ¡ÂºÂ­p vÃƒÂ  mÃ¡ÂºÂ­t khÃ¡ÂºÂ©u!");
            request.setAttribute("username", u != null ? u : "");
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        User account = dao.checkLogin(u, p);

        if (account == null) {
            if (dao.isLockedUser(u)) {
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
            } else {
                request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            }
            request.setAttribute("username", u);
            request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("account", account);

            String role = account.getRole(); // LÃ¡ÂºÂ¥y tÃ¡Â»Â« DB: Admin, Veterinarian, PetOwner...
            if ("ClinicManager".equalsIgnoreCase(role) || "Admin".equalsIgnoreCase(role)) {
                response.sendRedirect("admin/dashboard");
            } else if ("Veterinarian".equalsIgnoreCase(role)) {
                response.sendRedirect("veterinarian/dashboard");
            } else if ("Receptionist".equalsIgnoreCase(role)) {
                response.sendRedirect("receptionist/dashboard");
            } else if ("Nurse".equalsIgnoreCase(role)) {
                response.sendRedirect("nurse/lab/queue");
            } else if ("PetOwner".equalsIgnoreCase(role)) {
                response.sendRedirect("home");
            } else {
                response.sendRedirect("home");
            }
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
