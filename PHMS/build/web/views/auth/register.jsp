<%-- 
    Document   : register
    Created on : Jan 22, 2026, 4:29:38 AM
    Author     : Nguyen Dang Hung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - ${L == 'en' ? 'Create Account' : 'Đăng ký Tài khoản'}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/register.css">
</head>
<body>
    <!-- Language Switcher -->
    <div style="position: fixed; top: 15px; right: 15px; z-index: 1000;">
        <div style="display:inline-flex; align-items:center; background:#f1f5f9; border-radius:20px; padding:3px; gap:2px; box-shadow: 0 1px 4px rgba(0,0,0,0.1);">
            <a href="${pageContext.request.contextPath}/language?lang=vi"
               style="padding:5px 12px; border-radius:16px; font-size:12px; font-weight:700; text-decoration:none; transition:0.2s;
                      ${L == 'vi' ? 'background:#0f172a; color:#fff;' : 'color:#64748b;'}">
                VI
            </a>
            <a href="${pageContext.request.contextPath}/language?lang=en"
               style="padding:5px 12px; border-radius:16px; font-size:12px; font-weight:700; text-decoration:none; transition:0.2s;
                      ${L == 'en' ? 'background:#0f172a; color:#fff;' : 'color:#64748b;'}">
                EN
            </a>
        </div>
    </div>

    <div class="back-home-floating">
        <a href="${pageContext.request.contextPath}/home" class="back-home-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            ${t_back_home}
        </a>
    </div>
    <div class="register-wrapper">
        <div class="register-card">
            <div class="register-header">
                <h1 style="font-size: 2rem; font-weight: 800; color: #1e293b; margin-bottom: 0.5rem;">${L == 'en' ? 'Create New Account' : 'Tạo tài khoản mới'}</h1>
                <p style="color: #64748b;">${L == 'en' ? 'Join the VetCare Pro pet care community' : 'Tham gia cộng đồng chăm sóc thú cưng VetCare Pro'}</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="error-box" style="margin-bottom: 1.5rem;">
                    ${error}
                </div>
            </c:if>

            <form action="register" method="post">
                <div class="register-grid">
                    
                    <div class="form-group">
                        <label class="label-micro">${L == 'en' ? 'Full Name' : 'Họ và tên'}</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <!-- Icon User -->
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                            </div>
                            <input type="text" name="fullname" required class="form-input" placeholder="Nguyễn Văn A"
                                   value="${fullname}">
                        </div>
                    </div>

                    <!-- Cột 2: Username -->
                    <div class="form-group">
                        <label class="label-micro">Username</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            </div>
                            <input type="text" name="username" required class="form-input" placeholder="username123"
                                   value="${username}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="label-micro">${L == 'en' ? 'Email' : 'Email'}</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                            </div>
                            <input type="email" name="email" required class="form-input" placeholder="email@example.com"
                                   value="${email}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="label-micro">${L == 'en' ? 'Phone Number' : 'Số điện thoại'}</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                            </div>
                            <input type="text" name="phone" required class="form-input" placeholder="0912..."
                                   value="${phone}">
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="label-micro">${L == 'en' ? 'Address' : 'Địa chỉ'}</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            </div>
                            <input type="text" name="address" required class="form-input" placeholder="${L == 'en' ? 'House number, Street, District...' : 'Số nhà, Đường, Quận/Huyện...'}"
                                   value="${address}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="label-micro">${t_password}</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                            </div>
                            <input type="password" name="password" required class="form-input" placeholder="••••••••">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="label-micro">${L == 'en' ? 'Confirm Password' : 'Nhập lại mật khẩu'}</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            </div>
                            <input type="password" name="repassword" required class="form-input" placeholder="••••••••">
                        </div>
                    </div>

                    <div class="full-width">
                        <button type="submit" class="btn-register">
                            <span>${t_register_now}</span>
                            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                        </button>
                    </div>
                </div> 
                
                <div class="login-prompt">
                    ${L == 'en' ? 'Already have an account?' : 'Đã có tài khoản?'} <a href="login">${t_login}</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
