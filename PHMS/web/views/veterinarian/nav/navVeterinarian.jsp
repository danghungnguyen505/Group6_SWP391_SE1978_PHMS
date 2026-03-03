<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="rawUri" value="${pageContext.request.requestURI}" />
<c:set var="uri" value="${fn:toLowerCase(rawUri)}" />

<aside class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-plus"></i>
        <span>VetCare Pro</span>
    </div>

    <div class="menu-label">MAIN MENU</div>
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/dashboard"
               class="nav-link ${uri.contains('dashboard') ? 'active' : ''}">
                <i class="fa-solid fa-table-columns"></i> Dashboard
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/emergency/queue"
               class="nav-link ${uri.contains('emergency') ? 'active' : ''}">
                <i class="fa-solid fa-truck-medical"></i> Emergency Queue
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/emr/queue"
               class="nav-link ${uri.contains('emr/queue') || uri.contains('emrqueue') ? 'active' : ''}">
                <i class="fa-solid fa-stethoscope"></i> EMR Queue
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/emr/records"
               class="nav-link ${uri.contains('medicalrecord') || uri.contains('emr/records') || uri.contains('emr/detail') ? 'active' : ''}">
                <i class="fa-solid fa-file-medical"></i> Medical Records
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/lab/requests"
               class="nav-link ${uri.contains('lab') ? 'active' : ''}">
                <i class="fa-solid fa-vial"></i> Lab Requests
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/prescription/list"
               class="nav-link ${uri.contains('prescription') ? 'active' : ''}">
                <i class="fa-solid fa-prescription-bottle-medical"></i> Prescriptions
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/veterinarian/scheduling"
               class="nav-link ${uri.contains('scheduling') ? 'active' : ''}">
                <i class="fa-solid fa-calendar-days"></i> Staff Scheduling
            </a>
        </li>
    </ul>

    <div class="support-box">
        <p>Need help?</p>
        <button class="btn-support">Contact Support</button>
    </div>
</aside>