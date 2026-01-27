<%-- 
    Document   : navbar
    Created on : Jan 22, 2026, 10:55:27 AM
    Author     : Nguyen Dang Hung
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="admin-navbar">
    <div class="nav-left">
        <div class="admin-logo">
            VetCare Admin
        </div>
    </div>
    <div class="header-actions">
        <div class="user-info">
            <span>Xin chào, <strong class="user-name">${sessionScope.account.fullName}</strong></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger">
                Đăng xuất
            </a>
        </div>
    </div>
</nav>

<div class="admin-nav-links">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-nav-item active">
        <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"></path>
        </svg>
        Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/admin/users" class="admin-nav-item active">
        <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"></path>
        </svg>
        User Management
    </a>
</div>



