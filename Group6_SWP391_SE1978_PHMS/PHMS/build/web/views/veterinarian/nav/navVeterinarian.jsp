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
        <li class="nav-item"><a href="${pageContext.request.contextPath}/veterinarian/dashboard" class="nav-link ${requestScope.activePage == 'dashboard' ? 'active' : ''}"><i class="fa-solid fa-table-columns"></i> Dashboard</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/veterinarian/emergency/queue" class="nav-link text-danger ${requestScope.activePage == 'emergencyQueue' ? 'active' : ''}"><i class="fa-solid fa-truck-medical"></i> Emergency Queue</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/veterinarian/emr/queue" class="nav-link ${requestScope.activePage == 'emrQueue' ? 'active' : ''}"><i class="fa-solid fa-stethoscope"></i> EMR Queue</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/veterinarian/emr/records" class="nav-link ${requestScope.activePage == 'medicalRecords' ? 'active' : ''}"><i class="fa-solid fa-notes-medical"></i> Medical Records</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/veterinarian/lab/requests" class="nav-link ${requestScope.activePage == 'labRequests' ? 'active' : ''}"><i class="fa-solid fa-vial"></i> Lab Requests</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/veterinarian/scheduling" class="nav-link ${requestScope.activePage == 'staffScheduling' ? 'active' : ''}"><i class="fa-solid fa-calendar-days"></i> Staff Scheduling</a></li>
    </ul>

    <div class="support-box">
        <p>Need help?</p>
        <button class="btn-support">Contact Support</button>
    </div>
</aside>