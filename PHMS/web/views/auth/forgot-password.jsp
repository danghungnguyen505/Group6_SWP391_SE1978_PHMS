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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/login.css">
</head>
<body>
    <div class="back-home-floating">
        <a href="${pageContext.request.contextPath}/home" class="back-home-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            Back to home
        </a>
    </div>
    <div class="login-wrapper">
        <div class="login-card">
            <h2 class="login-title text-center">Password Recovery</h2>
            
            <p style="color:red; text-align:center">${error}</p>
            <p style="color:green; text-align:center">${message}</p>
            <p style="color:blue; text-align:center; font-weight:bold">${success}</p>
            <c:if test="${not empty success}">
                <script>
                    setTimeout(function() {
                        window.location.href = "${pageContext.request.contextPath}/login";
                    }, 5000);
                </script>
            </c:if>

            <!-- NẾU CHƯA CÓ SUCCESS, HIỆN FORM -->
            <c:if test="${empty success}">
                <form action="forgot-password" method="post">
                    
                    <!-- BƯỚC 1: NHẬP EMAIL -->
                    <c:if test="${empty step}">
                        <div class="form-group">
                            <label>Enter your registered email address.</label>
                            <input type="email" name="email" required class="form-input" placeholder="example@gmail.com">
                        </div>
                        <button type="submit" class="btn btn-primary btn-login">Send OTP</button>
                    </c:if>

                    <!-- BƯỚC 2: NHẬP OTP & PASS MỚI -->
                    <c:if test="${step == '2'}">
                        <div class="form-group">
                            <label>Input OTP (Check Email)</label>
                            <div class="otp-input-container">
                                <input type="text" name="otp1" maxlength="1" class="otp-input" required oninput="moveToNext(this, 'otp2')" onkeydown="handleBackspace(event, this, 'otp1')">
                                <input type="text" name="otp2" maxlength="1" class="otp-input" id="otp2" required oninput="moveToNext(this, 'otp3')" onkeydown="handleBackspace(event, this, 'otp1')">
                                <input type="text" name="otp3" maxlength="1" class="otp-input" id="otp3" required oninput="moveToNext(this, 'otp4')" onkeydown="handleBackspace(event, this, 'otp2')">
                                <input type="text" name="otp4" maxlength="1" class="otp-input" id="otp4" required oninput="moveToNext(this, 'otp5')" onkeydown="handleBackspace(event, this, 'otp3')">
                                <input type="text" name="otp5" maxlength="1" class="otp-input" id="otp5" required oninput="moveToNext(this, 'otp6')" onkeydown="handleBackspace(event, this, 'otp4')">
                                <input type="text" name="otp6" maxlength="1" class="otp-input" id="otp6" required onkeydown="handleBackspace(event, this, 'otp5')">
                                <input type="hidden" name="otp" id="fullOtp">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" name="newPass" required class="form-input" minlength="6">
                        </div>
                        <div class="form-group">
                            <label>Confirm Password</label>
                            <input type="password" name="confirmPass" required class="form-input" minlength="6">
                        </div>
                        <button type="submit" class="btn btn-primary btn-login" onclick="combineOtp()">Đổi mật khẩu</button>
                    </c:if>
                    
                </form>
            </c:if>

            <div class="register-prompt" style="margin-top:20px;">
                <a href="login">Back to login</a>
            </div>
        </div>
    </div>
    <script>
        function moveToNext(current, nextId) {
            if (current.value.length >= 1) {
                var next = document.getElementById(nextId);
                if (next) next.focus();
            }
        }

        function handleBackspace(event, current, prevId) {
            if (event.key === 'Backspace' && current.value.length === 0) {
                var prev = document.getElementById(prevId);
                if (prev) prev.focus();
            }
        }

        function combineOtp() {
            var otp1 = document.querySelector('input[name="otp1"]').value;
            var otp2 = document.querySelector('input[name="otp2"]').value;
            var otp3 = document.querySelector('input[name="otp3"]').value;
            var otp4 = document.querySelector('input[name="otp4"]').value;
            var otp5 = document.querySelector('input[name="otp5"]').value;
            var otp6 = document.querySelector('input[name="otp6"]').value;
            var fullOtp = otp1 + otp2 + otp3 + otp4 + otp5 + otp6;
            document.getElementById('fullOtp').value = fullOtp;
        }
    </script>
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
</body>
</html>
