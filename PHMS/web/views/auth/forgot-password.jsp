<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${L == 'en' ? 'Forgot Password' : 'Quên mật khẩu'} - VetCare Pro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/login.css">
    <style>
        .otp-input-container {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 10px 0;
        }
        .otp-input {
            width: 45px;
            height: 50px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            outline: none;
            transition: border-color 0.2s;
        }
        .otp-input:focus {
            border-color: #50b498;
        }
    </style>
</head>
<body>
    <div style="position: fixed; top: 15px; right: 15px; z-index: 1000;">
        <div style="display:inline-flex; align-items:center; background:#f1f5f9; border-radius:20px; padding:3px; gap:2px; box-shadow:0 1px 4px rgba(0,0,0,0.1);">
            <a href="${pageContext.request.contextPath}/language?lang=vi"
               style="padding:5px 12px; border-radius:16px; font-size:12px; font-weight:700; text-decoration:none; ${L == 'vi' ? 'background:#0f172a; color:#fff;' : 'color:#64748b;'}">
                VI
            </a>
            <a href="${pageContext.request.contextPath}/language?lang=en"
               style="padding:5px 12px; border-radius:16px; font-size:12px; font-weight:700; text-decoration:none; ${L == 'en' ? 'background:#0f172a; color:#fff;' : 'color:#64748b;'}">
                EN
            </a>
        </div>
    </div>

    <div class="back-home-floating">
        <a href="${pageContext.request.contextPath}/home" class="back-home-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
            </svg>
            ${t_back_home}
        </a>
    </div>

    <div class="login-wrapper">
        <div class="login-card">
            <h2 class="login-title text-center">${L == 'en' ? 'Password Recovery' : 'Khôi phục mật khẩu'}</h2>

            <c:if test="${not empty error}">
                <div class="error-box">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div style="color:#10b981; text-align:center; margin-bottom:12px;">${message}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div style="color:#2563eb; text-align:center; font-weight:700; margin-bottom:12px;">${success}</div>
                <script>
                    setTimeout(function () {
                        window.location.href = "${pageContext.request.contextPath}/login";
                    }, 5000);
                </script>
            </c:if>

            <c:if test="${empty success}">
                <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                    <c:if test="${empty step}">
                        <div class="form-group">
                            <label>${L == 'en' ? 'Enter your registered email address.' : 'Nhập email đã đăng ký.'}</label>
                            <input type="email" name="email" required class="form-input" placeholder="example@gmail.com">
                        </div>
                        <button type="submit" class="btn btn-primary btn-login">
                            ${L == 'en' ? 'Send OTP' : 'Gửi mã OTP'}
                        </button>
                    </c:if>

                    <c:if test="${step == '2'}">
                        <div class="form-group">
                            <label>${L == 'en' ? 'Enter OTP (check your email)' : 'Nhập OTP (kiểm tra email)'}</label>
                            <div class="otp-input-container">
                                <input type="text" name="otp1" maxlength="1" class="otp-input" required oninput="moveToNext(this, 'otp2')" onkeydown="handleBackspace(event, this, null)">
                                <input type="text" name="otp2" maxlength="1" class="otp-input" id="otp2" required oninput="moveToNext(this, 'otp3')" onkeydown="handleBackspace(event, this, 'otp1')">
                                <input type="text" name="otp3" maxlength="1" class="otp-input" id="otp3" required oninput="moveToNext(this, 'otp4')" onkeydown="handleBackspace(event, this, 'otp2')">
                                <input type="text" name="otp4" maxlength="1" class="otp-input" id="otp4" required oninput="moveToNext(this, 'otp5')" onkeydown="handleBackspace(event, this, 'otp3')">
                                <input type="text" name="otp5" maxlength="1" class="otp-input" id="otp5" required oninput="moveToNext(this, 'otp6')" onkeydown="handleBackspace(event, this, 'otp4')">
                                <input type="text" name="otp6" maxlength="1" class="otp-input" id="otp6" required onkeydown="handleBackspace(event, this, 'otp5')">
                                <input type="hidden" name="otp" id="fullOtp">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>${L == 'en' ? 'New Password' : 'Mật khẩu mới'}</label>
                            <input type="password" name="newPass" required class="form-input" minlength="6">
                        </div>
                        <div class="form-group">
                            <label>${L == 'en' ? 'Confirm Password' : 'Xác nhận mật khẩu'}</label>
                            <input type="password" name="confirmPass" required class="form-input" minlength="6">
                        </div>
                        <button type="submit" class="btn btn-primary btn-login" onclick="combineOtp()">
                            ${L == 'en' ? 'Reset Password' : 'Đổi mật khẩu'}
                        </button>
                    </c:if>
                </form>
            </c:if>

            <div class="register-prompt" style="margin-top:20px;">
                <a href="${pageContext.request.contextPath}/login">${L == 'en' ? 'Back to login' : 'Quay lại đăng nhập'}</a>
            </div>
        </div>
    </div>

    <script>
        function moveToNext(current, nextId) {
            if (current.value.length >= 1) {
                var next = document.getElementById(nextId);
                if (next) {
                    next.focus();
                }
            }
        }

        function handleBackspace(event, current, prevId) {
            if (event.key === "Backspace" && current.value.length === 0 && prevId) {
                var prev = document.getElementById(prevId);
                if (prev) {
                    prev.focus();
                }
            }
        }

        function combineOtp() {
            var otp1 = document.querySelector('input[name="otp1"]').value;
            var otp2 = document.querySelector('input[name="otp2"]').value;
            var otp3 = document.querySelector('input[name="otp3"]').value;
            var otp4 = document.querySelector('input[name="otp4"]').value;
            var otp5 = document.querySelector('input[name="otp5"]').value;
            var otp6 = document.querySelector('input[name="otp6"]').value;
            document.getElementById("fullOtp").value = otp1 + otp2 + otp3 + otp4 + otp5 + otp6;
        }
    </script>
</body>
</html>
