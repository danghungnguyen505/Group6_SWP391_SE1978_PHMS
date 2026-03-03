<%-- 
    Document   : dashboardReceptionist
    Created on : Feb 1, 2026, 10:36:50 PM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Receptionist Dashboard</title>
        <!-- Import FontAwesome for Icons -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>

        <!-- LEFT SIDEBAR -->
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>

            <ul class="menu">
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="active">
                        <i class="fa-solid fa-table-columns"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="text-danger">
                        <i class="fa-solid fa-truck-medical"></i> Emergency Triage
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/scheduling">
                        <i class="fa-solid fa-truck-medical"></i> Staff Scheduling
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/appointment">
                        <i class="fa-regular fa-calendar-check"></i> Appointments
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-paw"></i> My Pets
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-file-medical"></i> Medical Records
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-regular fa-credit-card"></i> Billing
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-gear"></i> Administration
                    </a>
                </li>
            </ul>

            <div class="help-box">
                <div class="help-text">Need help?</div>
                <a href="#" class="btn-contact">Contact Support</a>
            </div>
        </nav>

        <!-- RIGHT MAIN CONTENT -->
        <main class="main-content">

            <!-- Top Bar -->
            <div class="top-bar">
                <div class="page-header">
                    <h2>Booking Management</h2>
                    <p>Review and manage pending appointment requests.</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <!-- Notification -->
            <c:if test="${not empty actionMessage}">
                <div class="alert alert-info">
                    <i class="fa-solid fa-info-circle"></i> ${actionMessage}
                </div>
            </c:if>

            <!-- Main Card: Pending Requests -->
            <div class="card">
                <div class="section-title">
                    <span>Pending Requests</span>
                </div>

                <!-- Empty State -->
                <c:if test="${empty pendingList}">
                    <div class="empty-state">
                        <i class="fa-regular fa-calendar-times" style="font-size: 30px; margin-bottom: 10px;"></i>
                        <p>No pending appointment requests found.</p>
                    </div>
                </c:if>

                <!-- Data Table -->
                <c:if test="${not empty pendingList}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Owner Name</th>
                                <th>Pet Name</th>
                                <th>Service</th>
                                <th>Veterinarian</th>
                                <th>Date & Time</th>
                                <th>Notes</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${pendingList}" var="a">
                                <tr>
                                    <td class="col-id">#${a.apptId}</td> 
                                    <td>${a.ownerName}</td>
                                    <td class="col-pet">${a.petName}</td>
                                    <td class="col-service">${a.type}</td>
                                    <td>${a.vetName}</td>
                                    <td>${a.startTime}</td>
                                    <td>
                                        <c:if test="${not empty a.notes}">
                                            <button type="button" 
                                                    class="btn-view-note" 
                                                    data-note="${a.notes}" 
                                                    onclick="openModal(this)">
                                                <i class="fa-regular fa-eye"></i> View
                                            </button>
                                        </c:if>
                                        <c:if test="${empty a.notes}">
                                            <span style="color: #999; font-style: italic;">Not note</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <!-- Approve Button -->
                                            <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Confirmed" 
                                               class="btn btn-approve">
                                                Approve
                                            </a>
                                            <!-- Reject Button -->
                                            <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Cancelled" 
                                               class="btn btn-reject"
                                               onclick="return confirm('Are you sure you want to reject this appointment?');">
                                                Reject
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
            <!-- Main Card: Confirmed Requests -->
            <div class="card" style="margin-top: 20px;">
                <div class="section-title">
                    <jsp:useBean id="today" class="java.util.Date" />
                    <span>Today's Check-in Queue (<fmt:formatDate value="${today}" pattern="dd/MM/yyyy"/>)</span>
                </div>

                <c:if test="${empty todayList}">
                    <div class="empty-state">
                        <p>No appointments scheduled for today.</p>
                    </div>
                </c:if>

                <c:if test="${not empty todayList}">
                    <table>
                        <thead>
                            <tr>
                                <th>Time</th>
                                <th>ID</th>
                                <th>Owner & Pet</th>
                                <th>Service</th>
                                <th>Doctor</th>
                                <th>Status</th>
                                <th style="text-align: center;">Check-in Actions</th>
                            </tr>
                        </thead>
                        <tbody>${todayList}
                            <c:forEach items="${todayList}" var="t">
                                <jsp:useBean id="now" class="java.util.Date" />
                                <c:set var="isLate" value="${t.startTime.time < now.time && t.status == 'Confirmed'}" />

                                <tr style="${isLate ? 'background-color: #fff1f2;' : ''}">
                                    <td style="font-weight: bold; color: var(--primary);">
                            <fmt:formatDate value="${t.startTime}" pattern="HH:mm"/>
                            </td>
                            <td class="col-id">#${t.apptId}</td>
                                    <td>
                                        <div>${t.ownerName}</div>
                                        <small style="color: #666;">Pet: ${t.petName}</small>
                                    </td>
                                    <td class="col-service">${t.type}</td>
                                    <td>${t.vetName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'Confirmed'}">
                                                <span style="background: #d1fae5; color: #065f46; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 600;">
                                                    Confirmed</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Checked-in'}">
                                                <span style="background: #dbeafe; color: #1e40af; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 600;">
                                                    Checked-in</span>
                                            </c:when>
                                            <c:when test="${t.status == 'In-Progress'}">
                                                <span style="background: #fde68a; color: #92400e; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 600;">
                                                    In-Progress</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Process'}">
                                                <span style="background: #f3f4f6; color: #433751; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 600;">
                                                    Process</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Completed'}">
                                                <span style="background: #fee2e2; color: #b91c1c; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 600;">
                                                    Completed</span>
                                            </c:when>
                                        </c:choose>

                                        <c:if test="${isLate}">
                                            <div style="color: red; font-size: 11px; margin-top: 2px;"><i class="fa-solid fa-circle-exclamation"></i> Late</div>
                                        </c:if>
                                    </td>
                                    <td style="text-align: center;">
                                        <!-- Trường hợp chưa Check-in: hành động Check-in/No-show -->
                                        <c:if test="${t.status == 'Confirmed'}">
                                            <div class="action-group">
                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${t.apptId}&status=Checked-in" 
                                                   class="btn btn-approve" 
                                                   title="Patient Arrived">
                                                    <i class="fa-solid fa-check-to-slot"></i> Check-in
                                                </a>

                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${t.apptId}&status=No-show" 
                                                   class="btn btn-reject"
                                                   style="background-color: #64748b; color: white;"
                                                   title="Patient did not come"
                                                   onclick="return confirm('Mark this appointment as No-show?');">
                                                    <i class="fa-solid fa-user-slash"></i> No-show
                                                </a>
                                            </div>
                                        </c:if>

                                        <!-- Trường hợp đã Completed: cho phép tạo/xem hóa đơn -->
                                        <c:if test="${t.status == 'Completed'}">
                                            <a href="${pageContext.request.contextPath}/receptionist/invoice/create?apptId=${t.apptId}"
                                               class="btn btn-approve"
                                               style="text-decoration:none;"
                                               title="Tạo hoặc xem hóa đơn cho cuộc hẹn này">
                                                <i class="fa-regular fa-credit-card"></i> Tạo/Xem hóa đơn
                                            </a>
                                        </c:if>

                                        <!-- Các trạng thái khác đã xử lý rồi thì hiển thị nhãn chung -->
                                        <c:if test="${t.status != 'Confirmed' && t.status != 'Completed'}">
                                            <span style="color: #94a3b8; font-style: italic;">Action taken</span>
                                        </c:if>
                                    </td>
                                </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </main>
    </body>
</html>