<%-- 
    Document   : myAppointment
    Created on : Jan 31, 2026
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Appointments - VetCare Pro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/myAppointment.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus"></i>
                <span>VetCare Pro</span>
            </div>

            <div class="menu-label">Main Menu</div>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fa-solid fa-border-all"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/booking" class="nav-link">
                        <i class="fa-regular fa-calendar-check"></i> Appointments
                    </a>
                </li>
                <li class="nav-item" style="font-size: 13px;" >
                    <a href="${pageContext.request.contextPath}/myAppointment"class="nav-link active">
                        <i class="fa-solid fa-calendar-check"></i> My Appointments
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/myPetOwner"class="nav-link">
                        <i class="fa-solid fa-paw"></i> My Pets
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/medicalRecords" class="nav-link">
                        <i class="fa-solid fa-file-medical"></i> Medical Records
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/billing" class="nav-link">
                        <i class="fa-regular fa-credit-card"></i> Billing
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/aiHealthGuide" class="nav-link">
                        <i class="fa-solid fa-bolt"></i> AI Health Guide
                    </a>
                </li>
            </ul>

            <div class="support-box">
                <p>Need help?</p>
                <button class="btn-support">Contact Support</button>
            </div>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                    Logout
                </a>
            </header>

            <div class="page-header">
                <div class="page-title">
                    <h1>My Appointments</h1>
                    <p>Track your upcoming visits and view past history.</p>
                </div>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary" style="text-decoration: none;">
                    <i class="fa-solid fa-arrow-left me-2"></i> Back to Home
                </a>
            </div>

            <div class="section-header">
                <i class="fa-regular fa-clock text-primary"></i> Upcoming Appointments
            </div>

            <c:if test="${empty upcomingList}">
                <div class="empty-state">
                    You have no upcoming appointments.
                </div>
            </c:if>

            <c:if test="${not empty upcomingList}">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>#ID</th>
                            <th>Date & Time</th>
                            <th>Pet</th>
                            <th>Service</th>
                            <th>Doctor</th>
                            <th>Status</th>
                            <th>Notes</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${upcomingList}" var="u">
                            <tr>
                                <td><b>#${u.apptId}</b></td>
                                <td>
                                    <i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${u.startTime}" pattern="dd-MM-yyyy HH:mm"/>
                                </td>
                                <td>${u.petName}</td>
                                <td>${u.type}</td>
                                <td>${u.vetName}</td>
                                <td>
                                    <span class="status-badge
                                          ${u.status == 'Pending' ? 'status-pending' : 'status-confirmed'}">
                                        ${u.status}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${not empty u.notes}">
                                        <button type="button" class="btn-view-note" data-note="${u.notes}" onclick="openModal(this)">
                                            <i class="fa-regular fa-eye"></i> View
                                        </button>
                                    </c:if>
                                    <c:if test="${empty u.notes}">
                                        <span style="color: #9ca3af; font-style: italic; font-size: 0.9em;">No notes</span>
                                    </c:if>
                                </td>
                                <td style="text-align: center;">
                                    <jsp:useBean id="now" class="java.util.Date" />
                                    <c:set var="currentTime" value="${now.time}" />
                                    <c:set var="createdTime" value="${u.createdAt != null ? u.createdAt.time : 0}" />
                                    <c:set var="hoursPassed" value="${(currentTime - createdTime) / (1000 * 60 * 60)}" />
                                    <c:if test="${hoursPassed < 5}">
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/booking?petId=${u.petId}&vetId=${u.vetId}&serviceType=${u.type}&rescheduleId=${u.apptId}&selectedDate=<fmt:formatDate value="${u.startTime}" pattern="yyyy-MM-dd"/>" 
                                               class="btn-action btn-reschedule" 
                                               title="Reschedule">
                                                <i class="fa-regular fa-clock"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/appointment-action?id=${u.apptId}&type=cancel" 
                                               class="btn-action btn-cancel" title="Cancel">
                                                <i class="fa-solid fa-user-doctor"></i>
                                            </a>
                                        </div>

                                        <div style="font-size: 0.75rem; color: #666; margin-top: 5px; text-align: left;">
                                            Time Can Change: <fmt:formatNumber value="${5 - hoursPassed}" maxFractionDigits="0"/>h
                                        </div>
                                    </c:if>

                                    <c:if test="${hoursPassed >= 5}">
                                        <div style="color: #9ca3af; font-size: 0.85rem; display: flex; align-items: center; justify-content: center; gap: 5px; background: #f3f4f6; padding: 5px; border-radius: 4px;">
                                            <i class="fa-solid fa-lock"></i> Locked
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <div class="section-header" style="margin-top: 40px;">
                <i class="fa-solid fa-history text-secondary"></i> History
            </div>

            <c:if test="${empty historyList}">
                <div class="empty-state">
                    No past appointment history found.
                </div>
            </c:if>

            <c:if test="${not empty historyList}">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th>#ID</th>
                            <th>Date & Time</th>
                            <th>Pet</th>
                            <th>Service</th>
                            <th>Doctor</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${historyList}" var="h">
                            <tr>
                                <td>#${h.apptId}</td>
                                <td style="color: #666;">
                                    <fmt:formatDate value="${h.startTime}" pattern="dd-MM-yyyy HH:mm"/>
                                </td>
                                <td>${h.petName}</td>
                                <td>${h.type}</td>
                                <td>${h.vetName}</td>
                                <td>
                                    <span class="status-badge
                                          ${h.status == 'Completed' ? 'status-completed' : 'status-cancelled'}">
                                        ${h.status}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <!--Paging của History-->           
            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}" class="page-link">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>
                    </c:if>
                    <c:choose>
                        <%-- TRƯỜNG HỢP 1: Tổng số trang ít hơn hoặc bằng 5 -> Hiển thị hết --%>
                        <c:when test="${totalPages <= 5}">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="?page=${i}" class="page-link ${currentPage == i ? 'active' : ''}">
                                    ${i}
                                </a>
                            </c:forEach>
                        </c:when>
                        <%-- TRƯỜNG HỢP 2: Tổng số trang lớn hơn 5 --%>
                        <c:otherwise>
                            <%-- Luôn hiện trang 1 --%>
                            <a href="?page=1" class="page-link ${currentPage == 1 ? 'active' : ''}">1</a>
                            <%-- Dấu ... bên trái nếu cần --%>
                            <c:if test="${currentPage > 3}"><span class="pagination-ellipsis">...</span></c:if>
                            <%-- Các trang ở giữa (current - 1 đến current + 1) --%>
                            <c:forEach begin="${currentPage > 2 ? currentPage - 1 : 2}" 
                                       end="${currentPage < totalPages - 1 ? currentPage + 1 : totalPages - 1}" var="i">
                                <a href="?page=${i}" class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
                            </c:forEach>
                            <%-- Dấu ... bên phải --%>
                            <c:if test="${currentPage < totalPages - 2}">
                                <span class="pagination-ellipsis">...</span>
                            </c:if>
                            <%-- Hiện trang cuối --%>
                            <a href="?page=${totalPages}" class="page-link ${currentPage == totalPages ? 'active' : ''}">
                                ${totalPages}
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}" class="page-link">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </c:if>
                </div>
            </c:if>
            <!--Click để xem note chi tiết-->
            <div id="noteModal" class="modal">
                <div class="modal-content">
                    <span class="close-btn" onclick="closeModal()"></span>
                    <h2 class="modal-title">
                        <i class="fa-solid fa-clipboard-list"></i> Appointment Notes
                    </h2>
                    <div id="modalNoteContent" class="modal-body">
                    </div>
                </div>
            </div>
        </main>
        <script src="${pageContext.request.contextPath}/assets/js/myAppointment.js"></script>
    </body>
</html>