<%-- 
    Document   : staffSchedulingVeterinarian
    Created on : Feb 1, 2026, 11:47:01 PM
    Author     : zoxy4
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - My Schedule</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/staffScheduling.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <div class="header-section">
                <div class="header-text">
                    <h2>MY SCHEDULE</h2>
                    <p>Manage your personal work shifts.</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-primary"><i class="fa-solid fa-plus"></i> Add Shift</button>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-signout" style="margin-left: 15px;">Sign Out</a>
                </div>
            </div>

            <div class="controls-bar">
                <div class="date-nav">
                    <a href="?date=${currentDate.minusWeeks(1)}" class="nav-arrow"><i class="fa-solid fa-chevron-left"></i></a>
                        <fmt:setLocale value="en_US"/>
                    <span class="date-range">
                        <fmt:parseDate value="${startOfWeek}" pattern="yyyy-MM-dd" var="parsedStart" type="date" />
                        <fmt:parseDate value="${endOfWeek}" pattern="yyyy-MM-dd" var="parsedEnd" type="date" />
                        <fmt:formatDate value="${parsedStart}" pattern="MMM dd"/> - <fmt:formatDate value="${parsedEnd}" pattern="MMM dd, yyyy"/>
                    </span>
                    <a href="?date=${currentDate.plusWeeks(1)}" class="nav-arrow"><i class="fa-solid fa-chevron-right"></i></a>
                </div>

                <div style="font-size: 13px; color: #64748b;">
                    Currently viewing: <span style="color: #1e293b; font-weight: 700;">${sessionScope.account.fullName}</span>
                </div>
            </div>
            <div class="schedule-grid">
                <jsp:useBean id="now" class="java.util.Date" />
                <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="todayStr"/>
                <c:forEach var="entry" items="${weeklyMap}">
                    <div class="day-column ${entry.key == todayStr ? 'today' : ''}">
                        <div class="day-header">
                            <fmt:parseDate value="${entry.key}" pattern="yyyy-MM-dd" var="colDate" />
                            <span class="day-name"><fmt:formatDate value="${colDate}" pattern="EEEE"/></span>
                            <span class="day-num"><fmt:formatDate value="${colDate}" pattern="dd"/></span>
                        </div>

                        <%-- Ca Sáng --%>
                        <c:set var="morningShift" value="${entry.value['morning']}" />
                        <c:if test="${not empty morningShift}">
                            <div class="shift-section morning-section">
                                <div class="shift-section-header morning">
                                    <i class="fa-solid fa-sun"></i> Ca Sáng (09:00 - 12:00)
                                </div>
                                <c:set var="leaveStatus" value="${leaveMap[entry.key]}" />
                                <div class="shift-card
                                     ${leaveStatus == 'Pending' ? ' leave-pending' : ''}
                                     ${leaveStatus == 'Approved' ? ' leave-approved' : ''}
                                     ${leaveStatus == 'Rejected' ? ' leave-rejected' : ''}
                                     ${empty leaveStatus ? ' clickable' : ' non-clickable'}"
                                     <c:if test="${empty leaveStatus}">
                                         onclick="window.location.href = '${pageContext.request.contextPath}/requestLeaveVeterinarian?date=${entry.key}&shiftType=morning'"
                                     </c:if>>
                                    <div class="avatar-circle">
                                        ${morningShift.staffName != null ? morningShift.staffName.charAt(0) : 'U'}
                                    </div>
                                    <div class="shift-info">
                                        <h4>${morningShift.staffName}</h4>
                                        <span class="role-badge vet">VETERINARIAN</span>
                                        <c:if test="${not empty leaveStatus}">
                                            <div style="font-size: 11px; font-weight: bold; margin-top: 5px;
                                                 color:
                                                 ${leaveStatus == 'Pending' ? '#d97706' :
                                                   leaveStatus == 'Approved' ? '#dc2626' : '#6b7280'};">
                                                [Leave: ${leaveStatus}]
                                            </div>
                                        </c:if>
                                        <div class="time">
                                            <i class="fa-regular fa-clock"></i>
                                            <span>09:00 - 12:00</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <%-- Ca Chiều --%>
                        <c:set var="afternoonShift" value="${entry.value['afternoon']}" />
                        <c:if test="${not empty afternoonShift}">
                            <div class="shift-section afternoon-section">
                                <div class="shift-section-header afternoon">
                                    <i class="fa-solid fa-cloud-sun"></i> Ca Chiều (14:00 - 17:00)
                                </div>
                                <c:set var="leaveStatus" value="${leaveMap[entry.key]}" />
                                <div class="shift-card
                                     ${leaveStatus == 'Pending' ? ' leave-pending' : ''}
                                     ${leaveStatus == 'Approved' ? ' leave-approved' : ''}
                                     ${leaveStatus == 'Rejected' ? ' leave-rejected' : ''}
                                     ${empty leaveStatus ? ' clickable' : ' non-clickable'}"
                                     <c:if test="${empty leaveStatus}">
                                         onclick="window.location.href = '${pageContext.request.contextPath}/requestLeaveVeterinarian?date=${entry.key}&shiftType=afternoon'"
                                     </c:if>>
                                    <div class="avatar-circle">
                                        ${afternoonShift.staffName != null ? afternoonShift.staffName.charAt(0) : 'U'}
                                    </div>
                                    <div class="shift-info">
                                        <h4>${afternoonShift.staffName}</h4>
                                        <span class="role-badge vet">VETERINARIAN</span>
                                        <c:if test="${not empty leaveStatus}">
                                            <div style="font-size: 11px; font-weight: bold; margin-top: 5px;
                                                 color:
                                                 ${leaveStatus == 'Pending' ? '#d97706' :
                                                   leaveStatus == 'Approved' ? '#dc2626' : '#6b7280'};">
                                                [Leave: ${leaveStatus}]
                                            </div>
                                        </c:if>
                                        <div class="time">
                                            <i class="fa-regular fa-clock"></i>
                                            <span>14:00 - 17:00</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                    </div>
                </c:forEach>
            </div>
            <br><br>
        </main>
        <div class="footer-stats">
            <div class="stats-group">
                <div class="stat-item">
                    <span class="stat-label">Total Shifts</span>
                    <span class="stat-value">18</span> </div>
            </div>
            <div class="warning-box">
                <i class="fa-solid fa-triangle-exclamation" style="color: #fbbf24;"></i>
                <div class="warning-text">
                    <strong style="color:white; font-size:12px;">Staff Warning</strong>
                    <span>Dr. James Chen is on leave.</span>
                </div>
            </div>
        </div>
    <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>
