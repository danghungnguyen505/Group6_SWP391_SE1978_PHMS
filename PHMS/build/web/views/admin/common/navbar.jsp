<%--
    Document   : navbar
    Created on : Jan 22, 2026
    Author     : Nguyen Dang Hung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>

<aside class="sidebar">
    <div class="logo">
        <i class="fa-solid fa-square-plus"></i> VetCare Pro
    </div>

    <div class="menu-label">${L == 'en' ? 'Admin Menu' : 'Menu Quản trị'}</div>
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="nav-link ${param.activePage == 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-chart-pie"></i> ${L == 'en' ? 'Overview' : 'Tổng quan'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/services"
               class="nav-link ${param.activePage == 'services' ? 'active' : ''}">
                <i class="fa-solid fa-file-medical"></i> ${L == 'en' ? 'Services' : 'Dịch vụ'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/medicine/list"
               class="nav-link ${param.activePage == 'pharmacy' ? 'active' : ''}">
                <i class="fa-solid fa-capsules"></i> ${L == 'en' ? 'Pharmacy' : 'Nhà thuốc'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/staff/list"
               class="nav-link ${param.activePage == 'staff' ? 'active' : ''}">
                <i class="fa-solid fa-users-gear"></i> ${L == 'en' ? 'Staff Management' : 'Quản lý nhân viên'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/reports"
               class="nav-link ${param.activePage == 'revenue' ? 'active' : ''}">
                <i class="fa-solid fa-chart-line"></i> ${L == 'en' ? 'Revenue' : 'Doanh thu'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/feedback/list"
               class="nav-link ${param.activePage == 'feedback' ? 'active' : ''}">
                <i class="fa-solid fa-comment-dots"></i> ${L == 'en' ? 'Feedback' : 'Phản hồi'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/leavePending"
               class="nav-link ${param.activePage == 'leave' ? 'active' : ''}">
                <i class="fa-solid fa-calendar-check"></i> ${L == 'en' ? 'Leave Requests' : 'Xin nghỉ'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/doctor/schedule/list"
               class="nav-link ${param.activePage == 'scheduling' ? 'active' : ''}">
                <i class="fa-solid fa-clock"></i> ${L == 'en' ? 'Scheduling' : 'Lịch làm việc'}
            </a>
        </li>
    </ul>

    <!-- Language Switcher -->
    <div style="padding: 15px; margin-top: auto;">
        <div style="display:flex; align-items:center; background:#f1f5f9; border-radius:8px; padding:3px; gap:2px; justify-content:center;">
            <a href="${pageContext.request.contextPath}/language?lang=vi"
               style="padding:6px 12px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; transition:0.2s; flex:1; text-align:center;
                      ${L == 'vi' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">
                VI
            </a>
            <a href="${pageContext.request.contextPath}/language?lang=en"
               style="padding:6px 12px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; transition:0.2s; flex:1; text-align:center;
                      ${L == 'en' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">
                EN
            </a>
        </div>
    </div>

    <div class="help-box">
        <p>${L == 'en' ? 'Need help?' : 'Cần hỗ trợ?'}</p>
        <a href="#" class="btn-support">${L == 'en' ? 'Contact Support' : 'Liên hệ hỗ trợ'}</a>
    </div>
</aside>
