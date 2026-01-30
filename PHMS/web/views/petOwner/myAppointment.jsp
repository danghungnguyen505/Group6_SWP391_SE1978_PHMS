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

        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>

        <link href="${pageContext.request.contextPath}/assets/css/pages/myAppointment.css" rel="stylesheet" type="text/css"/>
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
                    <a href="#" class="nav-link">
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
                    <a href="#" class="nav-link">
                        <i class="fa-solid fa-paw"></i> My Pets
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fa-solid fa-file-medical"></i> Medical Records
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fa-regular fa-credit-card"></i> Billing
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fa-solid fa-bolt"></i> AI Health Guide
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fa-solid fa-gear"></i> Administration
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
                <button type="button" class="btn-cancel" onclick="window.location.href='${pageContext.request.contextPath}/home'">
                       Back to home
                </button>
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

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="?page=${i}" class="page-link ${currentPage == i ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>

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
                <span class="close-btn" onclick="closeModal()">&times;</span>
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