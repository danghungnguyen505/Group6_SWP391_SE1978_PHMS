<%-- 
    Document   : forgot-password
    Created on : Jan 22, 2026, 5:46:25 AM
    Author     : Nguyen Dang Hung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/login.css">
</head>
<body>
    <div class="back-home-floating">
        <a href="${pageContext.request.contextPath}/home" class="back-home-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            Về Trang chủ
        </a>
    </div>
    <div class="login-wrapper">
        <div class="login-card">
            <h2 class="login-title text-center">Khôi phục mật khẩu</h2>
            
            <p style="color:red; text-align:center">${error}</p>
            <p style="color:green; text-align:center">${message}</p>
            <p style="color:blue; text-align:center; font-weight:bold">${success}</p>

            <!-- NẾU CHƯA CÓ SUCCESS, HIỆN FORM -->
            <c:if test="${empty success}">
                <form action="forgot-password" method="post">
                    
                    <!-- BƯỚC 1: NHẬP EMAIL -->
                    <c:if test="${empty step}">
                        <div class="form-group">
                            <label>Nhập Email đã đăng ký</label>
                            <input type="email" name="email" required class="form-input" placeholder="example@gmail.com">
                        </div>
                        <button type="submit" class="btn btn-primary btn-login">Gửi mã OTP</button>
                    </c:if>

                    <!-- BƯỚC 2: NHẬP OTP & PASS MỚI -->
                    <c:if test="${step == '2'}">
                        <div class="form-group">
                            <label>Nhập mã OTP (Kiểm tra Email)</label>
                            <input type="text" name="otp" required class="form-input">
                        </div>
                        <div class="form-group">
                            <label>Mật khẩu mới</label>
                            <input type="password" name="newPass" required class="form-input">
                        </div>
                        <button type="submit" class="btn btn-primary btn-login">Đổi mật khẩu</button>
                    </c:if>
                    
                </form>
            </c:if>

            <div class="register-prompt" style="margin-top:20px;">
                <a href="login">Quay lại Đăng nhập</a>
            </div>
        </div>
    </div>
</body>
</html>
