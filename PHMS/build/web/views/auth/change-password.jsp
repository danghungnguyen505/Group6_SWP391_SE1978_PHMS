<%-- 
    Document   : change-password.jsp
    Created on : Jan 22, 2026, 8:14:35 AM
    Author     : Nguyen Dang Hung
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - VetCare Pro</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/change-password.css">
</head>
<body>
    <div class="back-home-floating">
        <a href="${pageContext.request.contextPath}/home" class="back-home-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            Về Trang chủ
        </a>
    </div>
    <div class="change-pass-wrapper">
        <div class="change-pass-card">
            <div class="change-pass-header">
                <div class="logo-icon-box">
                    <svg width="24" height="24" fill="none" stroke="white" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                    </svg>
                </div>
                <h1 class="change-pass-title">Bảo mật tài khoản</h1>
                <p class="change-pass-subtitle">Cập nhật mật khẩu định kỳ để bảo vệ dữ liệu thú cưng của bạn.</p>
            </div>

            <!-- Hiển thị lỗi từ Server -->
            <c:if test="${not empty error}">
                <div class="alert-box alert-error">
                    <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Hiển thị thành công từ Server -->
            <c:if test="${not empty message}">
                <div class="alert-box alert-success">
                    <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span>${message}</span>
                </div>
            </c:if>

            <!-- Lỗi Validate Client-side -->
            <div id="clientError" class="alert-box alert-error" style="display: none;">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <span id="errorText"></span>
            </div>

            <form action="change-password" method="post" onsubmit="return validatePasswords()">
                <div class="form-group">
                    <label class="label-micro">Mật khẩu hiện tại</label>
                    <div class="input-wrapper">
                        <div class="input-icon">
                            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
                            </svg>
                        </div>
                        <input type="password" name="oldPass" required class="form-input" placeholder="Nhập mật khẩu cũ">
                    </div>
                </div>

                <div class="form-group">
                    <label class="label-micro">Mật khẩu mới</label>
                    <div class="input-wrapper">
                        <div class="input-icon">
                            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                            </svg>
                        </div>
                        <input type="password" id="newPass" name="newPass" required minlength="6" class="form-input" placeholder="Tối thiểu 6 ký tự">
                    </div>
                </div>

                <div class="form-group">
                    <label class="label-micro">Xác nhận mật khẩu mới</label>
                    <div class="input-wrapper">
                        <div class="input-icon">
                            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                            </svg>
                        </div>
                        <input type="password" id="confirmPass" name="confirmPass" required class="form-input" placeholder="Nhập lại mật khẩu mới">
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    Cập nhật mật khẩu
                </button>

                <a href="${pageContext.request.contextPath}/profile" class="back-link">
                    Quay lại Hồ sơ cá nhân
                </a>
            </form>
        </div>
    </div>

    <script>
        function validatePasswords() {
            const newPass = document.getElementById("newPass").value;
            const confirmPass = document.getElementById("confirmPass").value;
            const errorDiv = document.getElementById("clientError");
            const errorText = document.getElementById("errorText");

            if (newPass !== confirmPass) {
                errorText.innerText = "Mật khẩu xác nhận không khớp!";
                errorDiv.style.display = "flex";
                return false;
            }
            
            errorDiv.style.display = "none";
            return true;
        }

        // Ẩn lỗi khi người dùng gõ lại
        document.getElementById("confirmPass").addEventListener("input", function() {
            document.getElementById("clientError").style.display = "none";
        });
    </script>
</body>
</html>

