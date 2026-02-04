<%-- 
    Document   : login
    Created on : Jan 22, 2026, 2:27:25 AM
    Author     : Nguyen Dang Hung
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - Đăng nhập Hệ thống</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/login.css">
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
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
            <div class="login-header">
                <div class="logo-container">
                    <svg width="32" height="32" fill="none" stroke="white" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4" />
                    </svg>
                </div>
                <h1 class="login-title">VetCare Pro</h1>
                <p class="login-subtitle">Hệ thống quản lý y tế thú cưng toàn diện</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-box">
                    <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    ${error}
                </div>
            </c:if>

            <form action="login" method="post" autocomplete="off">
                <div class="form-group">
                    <label class="label-micro">Username</label>
                    <div class="input-wrapper">
                        <div class="input-icon">
                            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.206" />
                            </svg>
                        </div>
                        <input type="text" name="username" required class="form-input" placeholder="Nhập username của bạn" value="${param.username}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="label-micro">Mật khẩu</label>
                    <div class="input-wrapper">
                        <div class="input-icon">
                            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                            </svg>
                        </div>
                        <input type="password" name="password" required class="form-input" placeholder="••••••••">
                    </div>
                    <a href="forgot-password" class="forgot-link">Quên mật khẩu?</a>
                </div>

                <div class="form-group">
                    <div class="g-recaptcha" data-sitekey="6LcAviwsAAAAAGKIudNAMh40LlgZP5ic49odI-2N"></div>
                </div>

                <button type="submit" class="btn btn-primary btn-login">
                    <span>Đăng nhập ngay</span>
                    <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                    </svg>
                </button>

                <div class="register-prompt">
                    Bạn chưa có tài khoản? <a href="register">Đăng ký ngay</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
