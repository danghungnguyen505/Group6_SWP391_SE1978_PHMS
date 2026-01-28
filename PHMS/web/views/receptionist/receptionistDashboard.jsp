<%-- 
    Document   : receptionistDashboard
    Created on : Jan 25, 2026, 1:25:46 AM
    Author     : zoxy4
    Updated UI : Standard CSS (No Tailwind)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-table-columns"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/triage" class="text-danger">
                        <i class="fa-solid fa-truck-medical"></i> Emergency Triage
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/appointments" class="active">
                        <i class="fa-regular fa-calendar-check"></i> Appointments
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/pets">
                        <i class="fa-solid fa-paw"></i> My Pets
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/records">
                        <i class="fa-solid fa-file-medical"></i> Medical Records
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/billing">
                        <i class="fa-regular fa-credit-card"></i> Billing
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/admin">
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
                                    <td style="text-align: center;">
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
                    <span>Upcoming Appointments (Confirmed)</span>
                </div>

                <c:if test="${empty confirmedList}">
                    <div class="empty-state">
                        <p>No confirmed appointments found.</p>
                    </div>
                </c:if>

                <c:if test="${not empty confirmedList}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Owner</th>
                                <th>Pet</th>
                                <th>Service</th>
                                <th>Veterinarian</th>
                                <th>Time</th>
                                <th>Notes</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${confirmedList}" var="c">
                                <tr>
                                    <td class="col-id">#${c.apptId}</td> 
                                    <td>${c.ownerName}</td>
                                    <td class="col-pet">${c.petName}</td>
                                    <td class="col-service">${c.type}</td>
                                    <td>${c.vetName}</td>
                                    <td>${c.startTime}</td>
                                    <td class="col-notes">${c.notes}</td>
                                    <td>
                                        <span style="background-color: #d1fae5; color: #065f46; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 600;">
                                            Confirmed
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </main>
            <!--Bảng note details-->
        <div id="noteModal" class="modal">
            <div class="modal-content">
                <span class="close-btn" onclick="closeModal()">&times;</span>
                <h2 class="modal-title">
                    <i class="fa-regular fa-clipboard"></i> Notes Details
                </h2>
                <div id="modalNoteContent" class="modal-body">
                    </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/assets/js/receptionistDashboard.js"></script>   
    </body>
</html>