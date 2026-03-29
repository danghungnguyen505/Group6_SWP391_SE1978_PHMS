package controller.auth;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String email = util.ValidationUtils.sanitize(request.getParameter("email"));
        String otpInput = util.ValidationUtils.sanitize(request.getParameter("otp"));
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        HttpSession session = request.getSession();
        UserDAO dao = new UserDAO();

        // Step 1: request OTP by email
        if (email != null && (otpInput == null || otpInput.trim().isEmpty())) {
            if (!util.ValidationUtils.isNotEmpty(email) || !util.ValidationUtils.isValidEmail(email)) {
                request.setAttribute("error", "Email không hợp lệ!");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            User user = dao.checkEmailExist(email);
            if (user == null) {
                request.setAttribute("error", "Email này không tồn tại trong hệ thống!");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            String otp = util.SendMail.getRandomOTP();
            try {
                util.SendMail.sendRecoveryOTP(getServletContext(), email, otp);

                session.setAttribute("otp", otp);
                session.setAttribute("otpCreatedAt", System.currentTimeMillis());
                session.setAttribute("resetEmail", email);
                session.setAttribute("resetUserId", user.getUserId());

                request.setAttribute("step", "2");
                request.setAttribute("message", "Mã OTP đã được gửi đến email: " + email);
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi gửi email: " + e.getMessage());
            }
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Step 2: verify OTP + reset password
        if (otpInput != null && newPass != null) {
            String serverOtp = (String) session.getAttribute("otp");
            Long otpCreatedAt = (Long) session.getAttribute("otpCreatedAt");
            long now = System.currentTimeMillis();

            // OTP expires after 5 minutes
            if (serverOtp == null || otpCreatedAt == null || (now - otpCreatedAt) > 5 * 60 * 1000) {
                session.removeAttribute("otp");
                session.removeAttribute("otpCreatedAt");
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetUserId");

                request.setAttribute("step", "2");
                request.setAttribute("error", "Mã OTP đã hết hạn! Vui lòng yêu cầu mã mới.");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            if (!util.ValidationUtils.isNotEmpty(otpInput) || otpInput.length() > 10) {
                request.setAttribute("step", "2");
                request.setAttribute("error", "Mã OTP không hợp lệ!");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            if (!util.ValidationUtils.isValidPassword(newPass)) {
                request.setAttribute("step", "2");
                request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            if (confirmPass == null || !confirmPass.equals(newPass)) {
                request.setAttribute("step", "2");
                request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            if (!otpInput.equals(serverOtp)) {
                request.setAttribute("step", "2");
                request.setAttribute("error", "Mã OTP không đúng!");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            Object userIdObj = session.getAttribute("resetUserId");
            if (!(userIdObj instanceof Integer)) {
                request.setAttribute("error", "Phiên đặt lại mật khẩu không hợp lệ. Vui lòng thử lại.");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            int userId = (Integer) userIdObj;
            dao.changePassword(userId, newPass);

            session.removeAttribute("otp");
            session.removeAttribute("otpCreatedAt");
            session.removeAttribute("resetEmail");
            session.removeAttribute("resetUserId");

            request.setAttribute("success", "Đổi mật khẩu thành công! Tự động chuyển về trang đăng nhập sau 5 giây.");
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Forgot password with OTP flow";
    }
}
