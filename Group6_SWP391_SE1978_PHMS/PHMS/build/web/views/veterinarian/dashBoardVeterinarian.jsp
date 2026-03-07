<%-- 
    Document   : dashBoardVeterinarian
    Created on : Feb 1, 2026, 11:29:28 PM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Veterinarian Dashboard</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
        <link href="${pageContext.request.contextPath}/assets/css/veterinarian/dashboardVeterinarian.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/staffScheduling.css">
    </head>
    <body>
        <c:set var="activePage" value="dashboard" scope="request" />
        <jsp:include page="nav/navVeterinarian.jsp" />
        
        <main class="main-content">
            <!-- Header: Welcome & Profile -->
            <header class="dashboard-header">
                <div class="welcome-text">
                    <h1>Hello, Dr. ${sessionScope.account != null ? sessionScope.account.fullName : 'Veterinarian'}! 👋</h1>
                    <p>Here's what's happening in your clinic today.</p>
                </div>
                <div class="user-actions">
                    <a href="${pageContext.request.contextPath}/logout" class="btn-signout"><i class="fa-solid fa-arrow-right-from-bracket"></i> Sign Out</a>
                </div>
            </header>

            <!-- Stats Row (Overview) -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon green-bg"><i class="fa-solid fa-user-injured"></i></div>
                    <div class="stat-info">
                        <h3>${patientsToday != null ? patientsToday : '0'}</h3>
                        <p>Patients Today</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue-bg"><i class="fa-solid fa-vial"></i></div>
                    <div class="stat-info">
                        <h3>${pendingLabResults != null ? pendingLabResults : '0'}</h3>
                        <p>Pending Lab Results</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon purple-bg"><i class="fa-solid fa-notes-medical"></i></div>
                    <div class="stat-info">
                        <h3>${emrUpdatesReq != null ? emrUpdatesReq : '0'}</h3>
                        <p>EMR Updates Req.</p>
                    </div>
                </div>
            </div>

            <!-- Dashboard Grid Layout -->
            <div class="dashboard-grid">
                <!-- Left Column (Big Content) -->
                <div class="left-col">
                    <div class="section-card">
                        <div class="card-header">
                            <h3><i class="fa-solid fa-calendar-check"></i> Today's Schedule</h3>
                            <a href="${pageContext.request.contextPath}/veterinarian/emr/queue" class="view-all">View Full Queue</a>
                        </div>
                        <div class="schedule-list">
                            <c:if test="${empty todaySchedule}">
                                <div style="text-align: center; color: #6B7280; padding: 20px;">
                                    No appointments scheduled for today.
                                </div>
                            </c:if>
                            <c:if test="${not empty todaySchedule}">
                                <c:forEach items="${todaySchedule}" var="appt">
                                    <div class="schedule-item">
                                        <div class="appt-time"><fmt:formatDate value="${appt.startTime}" pattern="hh:mm a"/></div>
                                        <div class="appt-details">
                                            <h4>${appt.type}</h4>
                                            <p>Patient: ${appt.petName} • Owner: ${appt.ownerName}</p>
                                        </div>
                                        
                                        <c:choose>
                                            <c:when test="${appt.status eq 'Checked-in'}">
                                                <a href="${pageContext.request.contextPath}/veterinarian/emr/create?apptId=${appt.apptId}" class="btn-action-small">Start</a>
                                            </c:when>
                                            <c:when test="${appt.status eq 'In-Progress'}">
                                                <a href="${pageContext.request.contextPath}/veterinarian/emr/edit?apptId=${appt.apptId}" class="btn-action-small" style="background:#F59E0B;">Resume</a>
                                            </c:when>
                                            <c:when test="${appt.status eq 'Completed'}">
                                                <button class="btn-action-small" style="background:#E5E7EB;color:#374151;cursor:not-allowed;" disabled>Completed</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn-action-small" style="background:#E5E7EB;color:#374151;cursor:not-allowed;" disabled>${appt.status}</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Right Column (Side Actions) -->
                <div class="right-col">
                    <div class="section-card">
                        <div class="card-header">
                            <h3><i class="fa-solid fa-bolt"></i> Quick Actions</h3>
                        </div>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/veterinarian/emr/queue" class="btn-quick-action">
                                <i class="fa-solid fa-stethoscope"></i> Examine Next Patient
                            </a>
                            <a href="${pageContext.request.contextPath}/veterinarian/prescription/list" class="btn-quick-action">
                                <i class="fa-solid fa-prescription-bottle-medical"></i> Write Prescription
                            </a>
                            <a href="${pageContext.request.contextPath}/veterinarian/lab/requests" class="btn-quick-action">
                                <i class="fa-solid fa-flask"></i> Request Lab Test
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>
