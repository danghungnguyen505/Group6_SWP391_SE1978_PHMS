package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra nếu có tham số logout thì đăng xuất
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            request.setAttribute("message", "Đã đăng xuất thành công!");
        }
        // Redirect to login page
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Lấy dữ liệu người dùng nhập
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        // 2. Gọi DAO để kiểm tra trong SQL
        UserDAO dao = new UserDAO();
        User account = dao.checkLogin(user, pass);
        if (account == null) {
            // Trường hợp SAI: Gửi báo lỗi và quay lại trang login
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        } else {
            // Đăng nhập đúng -> Lưu session
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            // --- BẮT ĐẦU PHÂN QUYỀN (ROLE BASED REDIRECT) ---
            String role = account.getRole();
            
            // Kiểm tra role không null
            if (role == null) {
                request.setAttribute("error", "Tài khoản không có quyền truy cập!");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
                return;
            }
            
            // Dùng equalsIgnoreCase để so sánh và redirect với context path nhất quán
            String contextPath = request.getContextPath();
            if (role.equalsIgnoreCase("Manager")) {
                response.sendRedirect(contextPath + "/views/adminHome.jsp");
            } else if (role.equalsIgnoreCase("Veterinarian")) {
                response.sendRedirect(contextPath + "/views/vetHome.jsp");
            } else if (role.equalsIgnoreCase("Nurse")) {
                response.sendRedirect(contextPath + "/views/nurseHome.jsp");
            } else if (role.equalsIgnoreCase("Receptionist")) {
                response.sendRedirect(contextPath + "/views/recepHome.jsp");
            } else if (role.equalsIgnoreCase("Owner")) {
                response.sendRedirect(contextPath + "/views/userHome.jsp");
            } else {
                request.setAttribute("error", "Role không được hỗ trợ: " + role);
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }
        }
    }

}
