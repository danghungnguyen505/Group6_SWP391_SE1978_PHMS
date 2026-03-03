<%-- 
    Document   : profile
    Created on : Jan 22, 2026, 5:39:23 AM
    Author     : Nguyen Dang Hung
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - VetCare Pro</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/profile.css">
</head>
<body>
    <div class="back-home-floating">
        <a href="${pageContext.request.contextPath}/home" class="back-home-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            Về Trang chủ
        </a>
    </div>
    <div class="profile-wrapper">
        <div class="profile-card">
            <div class="profile-cover"></div>
            
            <div class="profile-header">
                <div class="profile-avatar-wrapper">
                    <div class="profile-avatar">
                        <img src="https://picsum.photos/seed/user/200" alt="Avatar">
                    </div>
                    <button class="btn-edit-avatar" title="Đổi ảnh đại diện">
                        <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                    </button>
                </div>
                <h2 style="font-size: 1.5rem; font-weight: 900; color: var(--secondary);">${sessionScope.account.fullName}</h2>
                <p style="font-size: 0.875rem; color: var(--primary); font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em;">
                    ${sessionScope.account.role}
                </p>
            </div>

            <div class="profile-body">
                <c:if test="${not empty message}">
                    <div class="message-box message-success">
                        <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="display:inline; vertical-align:middle; margin-right:8px">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                        </svg>
                        ${message}
                    </div>
                </c:if>

                <form action="profile" method="post">
                    <div class="profile-grid">      
                        <div class="form-group">
                            <label class="label-micro">Username</label>
                            <div class="input-wrapper">
                                <div class="input-icon">
                                    <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                </div>
                                <input type="text" name="username" required class="form-input" value="${sessionScope.account.username}" readonly style="background-color: #f1f5f9; color: var(--text-light); cursor: not-allowed;">
                            </div>
                        </div>

                    <div class="form-group">
                        <label class="label-micro">Email</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                            </div>
                            <input type="email" name="email" required class="form-input" value="${sessionScope.account.email}" readonly style="background-color: #f1f5f9; color: var(--text-light); cursor: not-allowed;">
                        </div>
                    </div>
                        
                    <div class="form-group">
                        <label class="label-micro">Họ và tên</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <!-- Icon User -->
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                            </div>
                            <input type="text" name="fullname" required class="form-input" value="${sessionScope.account.fullName}" required placeholder="Cập nhật họ tên của bạn">
                        </div>
                    </div>

                    

                    <div class="form-group">
                        <label class="label-micro">Số điện thoại</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                            </div>
                            <input type="text" name="phone" required class="form-input" value="${sessionScope.account.phone}" placeholder="Nhập số điện thoại mới">
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="label-micro">Địa chỉ</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            </div>
                            <input type="text" name="address" required class="form-input" value="${sessionScope.account.address}" placeholder="Số nhà, tên đường, khu vực...">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="label-micro">Mật khẩu</label>
                        <div class="input-wrapper">
                            <div class="input-icon">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                            </div>
                            <input type="password" name="password" required class="form-input" placeholder="••••••••">
                        </div>
                    </div>

                    <div class="profile-actions">
                        <button type="submit" class="btn-save">
                            Lưu thay đổi hồ sơ
                        </button>
                        </div>
                        <div class="secondary-nav">
                            <a href="${pageContext.request.contextPath}/change-password" class="nav-link security">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                                Bảo mật & Mật khẩu
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/home" class="nav-link">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                                Quay lại Trang chủ
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

</body>
</html>
