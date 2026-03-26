<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>

<c:set var="rawUri" value="${pageContext.request.requestURI}" />
<c:set var="uri" value="${fn:toLowerCase(rawUri)}" />

<aside class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-plus"></i>
        <span>VetCare Pro</span>
    </div>

    <div class="menu-label">${L == 'en' ? 'MAIN MENU' : 'MENU CHÍNH'}</div>
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/dashboard"
               class="nav-link ${uri.contains('dashboard') ? 'active' : ''}">
                <i class="fa-solid fa-table-columns"></i> ${L == 'en' ? 'Dashboard' : 'Bảng điều khiển'}
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/emergency/queue"
               class="nav-link ${uri.contains('emergency') ? 'active' : ''}">
                <i class="fa-solid fa-truck-medical"></i> ${L == 'en' ? 'Emergency Queue' : 'Khẩn cấp'}
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/emr/queue"
               class="nav-link ${uri.contains('emr/queue') || uri.contains('emrqueue') ? 'active' : ''}">
                <i class="fa-solid fa-stethoscope"></i> ${L == 'en' ? 'EMR Queue' : 'Hàng đợi EMR'}
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/emr/records"
               class="nav-link ${uri.contains('medicalrecord') || uri.contains('emr/records') || uri.contains('emr/detail') ? 'active' : ''}">
                <i class="fa-solid fa-file-medical"></i> ${L == 'en' ? 'Medical Records' : 'Hồ sơ bệnh án'}
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/lab/requests"
               class="nav-link ${uri.contains('lab') ? 'active' : ''}">
                <i class="fa-solid fa-vial"></i> ${L == 'en' ? 'Lab Requests' : 'Xét nghiệm'}
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/prescription/list"
               class="nav-link ${uri.contains('prescription') ? 'active' : ''}">
                <i class="fa-solid fa-prescription-bottle-medical"></i> ${L == 'en' ? 'Prescriptions' : 'Đơn thuốc'}
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/scheduling"
               class="nav-link ${uri.contains('scheduling') ? 'active' : ''}">
                <i class="fa-solid fa-calendar-days"></i> ${L == 'en' ? 'Staff Scheduling' : 'Lịch làm việc'}
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

    <div class="support-box">
        <p>${L == 'en' ? 'Need help?' : 'Cần hỗ trợ?'}</p>
        <button class="btn-support">${L == 'en' ? 'Contact Support' : 'Liên hệ hỗ trợ'}</button>
    </div>
</aside>
