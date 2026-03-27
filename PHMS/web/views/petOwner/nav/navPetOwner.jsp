<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>

<aside class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-plus"></i>
        <span>VetCare Pro</span>
    </div>

    <div class="menu-label">${L == 'en' ? 'Menu' : 'Menu'}</div>
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/booking"
               class="nav-link ${pageContext.request.requestURI.contains('/booking') || pageContext.request.requestURI.contains('menuPetOwner') ? 'active' : ''}">
                <i class="fa-regular fa-calendar-check"></i> ${L == 'en' ? 'Appointments' : 'Đặt lịch'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/myAppointment"
               class="nav-link ${pageContext.request.requestURI.contains('/myAppointment') ? 'active' : ''}">
                <i class="fa-solid fa-calendar-check"></i>
                <span class="nav-text" style="white-space: nowrap;">${L == 'en' ? 'My Appointments' : 'Lịch hẹn của tôi'}</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/myPetOwner"
               class="nav-link ${pageContext.request.requestURI.contains('/myPetOwner') ? 'active' : ''}">
                <i class="fa-solid fa-paw"></i> ${L == 'en' ? 'My Pets' : 'Thú cưng của tôi'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/my-medical-records"
               class="nav-link ${pageContext.request.requestURI.contains('/my-medical-records') || pageContext.request.requestURI.contains('medicalRecordList') || pageContext.request.requestURI.contains('medicalRecordDetail') || pageContext.request.requestURI.contains('/my-invoice/detail') ? 'active' : ''}">
                <i class="fa-solid fa-file-medical"></i> ${L == 'en' ? 'Medical Records' : 'Hồ sơ bệnh án'}
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/aiHealthGuide"
               class="nav-link ${pageContext.request.requestURI.contains('/aiHealthGuide') || pageContext.request.requestURI.contains('aiHealthGuidePetOwner') ? 'active' : ''}">
                <i class="fa-solid fa-bolt"></i> ${L == 'en' ? 'AI Health Guide' : 'Hướng dẫn sức khỏe AI'}
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
