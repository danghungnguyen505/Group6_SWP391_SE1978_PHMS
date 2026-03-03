<%-- 
    Document   : nav
    Created on : Feb 7, 2026, 1:39:38 PM
    Author     : zoxy4
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-plus"></i>
        <span>VetCare Pro</span>
    </div>

    <div class="menu-label">Menu</div>
    <ul class="nav-menu">
<!--        <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" 
               class="nav-link ${pageContext.request.requestURI.contains('/dashboard') ? 'active' : ''}">
                <i class="fa-solid fa-border-all"></i> Dashboard </a>
        </li>-->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/booking" 
               class="nav-link ${pageContext.request.requestURI.contains('/booking') || pageContext.request.requestURI.contains('menuPetOwner') ? 'active' : ''}">
                <i class="fa-regular fa-calendar-check"></i> Appointments
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/myAppointment" 
               class="nav-link ${pageContext.request.requestURI.contains('/myAppointment') ? 'active' : ''}">
                <i class="fa-solid fa-calendar-check"></i> <span class="nav-text" style="white-space: nowrap;">My Appointments</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/myPetOwner" 
               class="nav-link ${pageContext.request.requestURI.contains('/myPetOwner') ? 'active' : ''}">
                <i class="fa-solid fa-paw"></i> My Pets
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/my-medical-records" 
               class="nav-link ${pageContext.request.requestURI.contains('/my-medical-records') || pageContext.request.requestURI.contains('medicalRecordList') || pageContext.request.requestURI.contains('medicalRecordDetail') ? 'active' : ''}">
                <i class="fa-solid fa-file-medical"></i> Medical Records
            </a>
        </li>
<!--        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/billing" 
               class="nav-link ${pageContext.request.requestURI.contains('/billing') || pageContext.request.requestURI.contains('billingPetOwner') ? 'active' : ''}">
                <i class="fa-regular fa-credit-card"></i> Billing
            </a>
        </li>-->
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/aiHealthGuide" 
               class="nav-link ${pageContext.request.requestURI.contains('/aiHealthGuide') || pageContext.request.requestURI.contains('aiHealthGuidePetOwner') ? 'active' : ''}">
                <i class="fa-solid fa-bolt"></i> AI Health Guide
            </a>
        </li>
    </ul>
    <div class="support-box">
        <p>Need help?</p>
        <button class="btn-support">Contact Support</button>
    </div>
</aside>