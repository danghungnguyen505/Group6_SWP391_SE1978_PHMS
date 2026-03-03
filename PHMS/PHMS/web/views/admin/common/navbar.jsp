<%-- 
    Document   : navbar
    Created on : Jan 22, 2026, 10:55:27 AM
    Author     : Nguyen Dang Hung
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <div class="logo">
        <i class="fa-solid fa-square-plus"></i> VetCare Pro
    </div>

    <div class="menu-label">Admin Menu</div>
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="nav-link ${param.activePage == 'dashboard' ? 'active' : ''}">
                <i class="fa-solid fa-chart-pie"></i> Overview
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/services" 
               class="nav-link ${param.activePage == 'services' ? 'active' : ''}">
                <i class="fa-solid fa-file-medical"></i> Services
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/medicine/list" 
               class="nav-link ${param.activePage == 'pharmacy' ? 'active' : ''}">
                <i class="fa-solid fa-capsules"></i> Pharmacy
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/staff/list" 
               class="nav-link ${param.activePage == 'staff' ? 'active' : ''}">
                <i class="fa-solid fa-users-gear"></i> Staff Management
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/reports" 
               class="nav-link ${param.activePage == 'revenue' ? 'active' : ''}">
                <i class="fa-solid fa-chart-line"></i> Revenue
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/feedback/list" 
               class="nav-link ${param.activePage == 'feedback' ? 'active' : ''}">
                <i class="fa-solid fa-comment-dots"></i> Feedback
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/leavePending" 
               class="nav-link ${param.activePage == 'leave' ? 'active' : ''}">
                <i class="fa-solid fa-calendar-check"></i> Leave Requests
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/doctor/schedule/list" 
               class="nav-link ${param.activePage == 'scheduling' ? 'active' : ''}">
                <i class="fa-solid fa-clock"></i> Scheduling
            </a>
        </li>
    </ul>

    <div class="help-box">
        <p>Need help?</p>
        <a href="#" class="btn-support">Contact Support</a>
    </div>
</aside>