<<<<<<< Updated upstream
<%-- 
    Document   : receptionistRequestAppointment
    Created on : Jan 25, 2026, 1:25:46 AM
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
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
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
                    <a href="${pageContext.request.contextPath}/receptionist/appointment" class="active">
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

            <!-- Filter Card -->
            <div class="card" style="margin-bottom:20px;">
                <div class="section-title">
                    <span>Filter Appointments</span>
                </div>
                <form method="get" action="${pageContext.request.contextPath}/receptionist/appointment" 
                      style="display:grid; grid-template-columns: 1fr 1fr 1fr auto; gap:10px; align-items:end;">
                    <div>
                        <label><b>Date</b></label>
                        <input type="date" name="filterDate" value="${filterDate}" style="width:100%; padding:8px;">
                    </div>
                    <div>
                        <label><b>Status</b></label>
                        <select name="filterStatus" style="width:100%; padding:8px;">
                            <option value="">All</option>
                            <option value="Pending" ${filterStatus == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Confirmed" ${filterStatus == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="Checked-in" ${filterStatus == 'Checked-in' ? 'selected' : ''}>Checked-in</option>
<<<<<<< Updated upstream
=======
                            <option value="In-Progress" ${filterStatus == 'Checked-in' ? 'selected' : ''}>In-Progress</option>
>>>>>>> Stashed changes
                            <option value="Completed" ${filterStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                            <option value="Cancelled" ${filterStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    <div>
                        <label><b>Veterinarian</b></label>
                        <select name="filterVetId" style="width:100%; padding:8px;">
                            <option value="">All</option>
                            <c:forEach var="vet" items="${veterinarians}">
                                <option value="${vet.userId}" ${filterVetId == vet.userId ? 'selected' : ''}>${vet.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-approve" style="width:100%;">
                            <i class="fa-solid fa-filter"></i> Filter
                        </button>
                    </div>
                </form>
                <c:if test="${not empty filterDate || not empty filterStatus || not empty filterVetId}">
                    <a href="${pageContext.request.contextPath}/receptionist/appointment" 
                       class="btn btn-secondary" style="margin-top:10px; text-decoration:none;">
                        <i class="fa-solid fa-times"></i> Clear Filters
                    </a>
                </c:if>
            </div>

            <!-- Main Card: Appointments List -->
            <div class="card">
                <div class="section-title">
                    <span>Appointments List</span>
                    <span style="float:right; font-size:14px; color:#6b7280;">Total: ${totalItems}</span>
                </div>

                <!-- Empty State -->
                <c:if test="${empty appointments}">
                    <div class="empty-state">
                        <i class="fa-regular fa-calendar-times" style="font-size: 30px; margin-bottom: 10px;"></i>
                        <p>No appointments found.</p>
                    </div>
                </c:if>
                ${appointments}
                <!-- Data Table -->
                <c:if test="${not empty appointments}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Owner Name</th>
                                <th>Pet Name</th>
                                <th>Service</th>
                                <th>Veterinarian</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                                <th>Notes</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <c:forEach items="${appointments}" var="a">
                                <tr>
                                    <td class="col-id">#${a.apptId}</td> 
                                    <td>${a.ownerName}</td>
                                    <td class="col-pet">${a.petName}</td>
                                    <td class="col-service">${a.type}</td>
                                    <td>${a.vetName}</td>
                                    <td><fmt:formatDate value="${a.startTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${a.status == 'Pending'}">
                                                <span style="background:#fef3c7; color:#92400e; padding:4px 8px; border-radius:4px; font-size:12px;">Pending</span>
                                            </c:when>
                                            <c:when test="${a.status == 'Confirmed'}">
                                                <span style="background:#d1fae5; color:#065f46; padding:4px 8px; border-radius:4px; font-size:12px;">Confirmed</span>
                                            </c:when>
                                            <c:when test="${a.status == 'Checked-in'}">
                                                <span style="background:#dbeafe; color:#1e40af; padding:4px 8px; border-radius:4px; font-size:12px;">Checked-in</span>
                                            </c:when>
<<<<<<< Updated upstream
=======
                                                <c:when test="${a.status == 'In-Progress'}">
                                                <span style="background:#dbeafe; color:#1e40af; padding:4px 8px; border-radius:4px; font-size:12px;">In-Progress</span>
                                            </c:when>
>>>>>>> Stashed changes
                                            <c:when test="${a.status == 'Completed'}">
                                                <span style="background:#dcfce7; color:#166534; padding:4px 8px; border-radius:4px; font-size:12px;">Completed</span>
                                            </c:when>
                                            <c:when test="${a.status == 'Cancelled'}">
                                                <span style="background:#fee2e2; color:#991b1b; padding:4px 8px; border-radius:4px; font-size:12px;">Cancelled</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${not empty a.notes}">
                                            <button type="button" class="btn-view-note" data-note="${a.notes}" onclick="openModal(this)">
                                                <i class="fa-regular fa-eye"></i> View
                                            </button>
                                        </c:if>
                                        <c:if test="${empty a.notes}">
                                            <span style="color: #999; font-style: italic;">No note</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <c:if test="${a.status == 'Pending'}">
                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Confirmed" 
                                                   class="btn btn-approve">Approve</a>
                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Cancelled" 
                                                   class="btn btn-reject"
                                                   onclick="return confirm('Are you sure you want to reject this appointment?');">Reject</a>
                                            </c:if>
                                            <c:if test="${a.status == 'Confirmed'}">
                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Checked-in" 
                                                   class="btn btn-approve">Check-in</a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div style="display:flex; gap:6px; justify-content:flex-end; margin-top:12px;">
                            <c:if test="${currentPage > 1}">
                                <a class="btn btn-approve" style="text-decoration:none;" 
                                   href="?page=${currentPage - 1}<c:if test='${not empty filterDate}'>&filterDate=${filterDate}</c:if><c:if test='${not empty filterStatus}'>&filterStatus=${filterStatus}</c:if><c:if test='${not empty filterVetId}'>&filterVetId=${filterVetId}</c:if>">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a class="btn ${currentPage == i ? 'btn-approve' : 'btn-reject'}"
                                   style="text-decoration:none; ${currentPage == i ? '' : 'background:#e5e7eb;color:#111827;'}"
                                   href="?page=${i}<c:if test='${not empty filterDate}'>&filterDate=${filterDate}</c:if><c:if test='${not empty filterStatus}'>&filterStatus=${filterStatus}</c:if><c:if test='${not empty filterVetId}'>&filterVetId=${filterVetId}</c:if>">${i}</a>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a class="btn btn-approve" style="text-decoration:none;" 
                                   href="?page=${currentPage + 1}<c:if test='${not empty filterDate}'>&filterDate=${filterDate}</c:if><c:if test='${not empty filterStatus}'>&filterStatus=${filterStatus}</c:if><c:if test='${not empty filterVetId}'>&filterVetId=${filterVetId}</c:if>">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
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
=======
<%-- 
    Document   : receptionistRequestAppointment
    Created on : Jan 25, 2026, 1:25:46 AM
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
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
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
                    <a href="${pageContext.request.contextPath}/receptionist/appointment" class="active">
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

            <!-- Filter Card -->
            <div class="card" style="margin-bottom:20px;">
                <div class="section-title">
                    <span>Filter Appointments</span>
                </div>
                <form method="get" action="${pageContext.request.contextPath}/receptionist/appointment" 
                      style="display:grid; grid-template-columns: 1fr 1fr 1fr auto; gap:10px; align-items:end;">
                    <div>
                        <label><b>Date</b></label>
                        <input type="date" name="filterDate" value="${filterDate}" style="width:100%; padding:8px;">
                    </div>
                    <div>
                        <label><b>Status</b></label>
                        <select name="filterStatus" style="width:100%; padding:8px;">
                            <option value="">All</option>
                            <option value="Pending" ${filterStatus == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Confirmed" ${filterStatus == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="Checked-in" ${filterStatus == 'Checked-in' ? 'selected' : ''}>Checked-in</option>
                            <option value="In-Progress" ${filterStatus == 'Checked-in' ? 'selected' : ''}>In-Progress</option>
                            <option value="Completed" ${filterStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                            <option value="Cancelled" ${filterStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    <div>
                        <label><b>Veterinarian</b></label>
                        <select name="filterVetId" style="width:100%; padding:8px;">
                            <option value="">All</option>
                            <c:forEach var="vet" items="${veterinarians}">
                                <option value="${vet.userId}" ${filterVetId == vet.userId ? 'selected' : ''}>${vet.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-approve" style="width:100%;">
                            <i class="fa-solid fa-filter"></i> Filter
                        </button>
                    </div>
                </form>
                <c:if test="${not empty filterDate || not empty filterStatus || not empty filterVetId}">
                    <a href="${pageContext.request.contextPath}/receptionist/appointment" 
                       class="btn btn-secondary" style="margin-top:10px; text-decoration:none;">
                        <i class="fa-solid fa-times"></i> Clear Filters
                    </a>
                </c:if>
            </div>

            <!-- Main Card: Appointments List -->
            <div class="card">
                <div class="section-title">
                    <span>Appointments List</span>
                    <span style="float:right; font-size:14px; color:#6b7280;">Total: ${totalItems}</span>
                </div>

                <!-- Empty State -->
                <c:if test="${empty appointments}">
                    <div class="empty-state">
                        <i class="fa-regular fa-calendar-times" style="font-size: 30px; margin-bottom: 10px;"></i>
                        <p>No appointments found.</p>
                    </div>
                </c:if>
                <!-- Data Table -->
                <c:if test="${not empty appointments}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Owner Name</th>
                                <th>Pet Name</th>
                                <th>Service</th>
                                <th>Veterinarian</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                                <th>Notes</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        
                        <tbody>
                            <c:forEach items="${appointments}" var="a">
                                <tr>
                                    <td class="col-id">#${a.apptId}</td> 
                                    <td>${a.ownerName}</td>
                                    <td class="col-pet">${a.petName}</td>
                                    <td class="col-service">${a.type}</td>
                                    <td>${a.vetName}</td>
                                    <td><fmt:formatDate value="${a.startTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${a.status == 'Pending'}">
                                                <span style="background:#fef3c7; color:#92400e; padding:4px 8px; border-radius:4px; font-size:12px;">Pending</span>
                                            </c:when>
                                            <c:when test="${a.status == 'Confirmed'}">
                                                <span style="background:#d1fae5; color:#065f46; padding:4px 8px; border-radius:4px; font-size:12px;">Confirmed</span>
                                            </c:when>
                                            <c:when test="${a.status == 'Checked-in'}">
                                                <span style="background:#dbeafe; color:#1e40af; padding:4px 8px; border-radius:4px; font-size:12px;">Checked-in</span>
                                            </c:when>
                                                <c:when test="${a.status == 'In-Progress'}">
                                                <span style="background:#dbeafe; color:#1e40af; padding:4px 8px; border-radius:4px; font-size:12px;">In-Progress</span>
                                            </c:when>
                                            <c:when test="${a.status == 'Completed'}">
                                                <span style="background:#dcfce7; color:#166534; padding:4px 8px; border-radius:4px; font-size:12px;">Completed</span>
                                            </c:when>
                                            <c:when test="${a.status == 'Cancelled'}">
                                                <span style="background:#fee2e2; color:#991b1b; padding:4px 8px; border-radius:4px; font-size:12px;">Cancelled</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${not empty a.notes}">
                                            <button type="button" class="btn-view-note" data-note="${a.notes}" onclick="openModal(this)">
                                                <i class="fa-regular fa-eye"></i> View
                                            </button>
                                        </c:if>
                                        <c:if test="${empty a.notes}">
                                            <span style="color: #999; font-style: italic;">No note</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <c:if test="${a.status == 'Pending'}">
                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Confirmed" 
                                                   class="btn btn-approve">Approve</a>
                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Cancelled" 
                                                   class="btn btn-reject"
                                                   onclick="return confirm('Are you sure you want to reject this appointment?');">Reject</a>
                                            </c:if>
                                            <c:if test="${a.status == 'Confirmed'}">
                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Checked-in" 
                                                   class="btn btn-approve">Check-in</a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div style="display:flex; gap:6px; justify-content:flex-end; margin-top:12px;">
                            <c:if test="${currentPage > 1}">
                                <a class="btn btn-approve" style="text-decoration:none;" 
                                   href="?page=${currentPage - 1}<c:if test='${not empty filterDate}'>&filterDate=${filterDate}</c:if><c:if test='${not empty filterStatus}'>&filterStatus=${filterStatus}</c:if><c:if test='${not empty filterVetId}'>&filterVetId=${filterVetId}</c:if>">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a class="btn ${currentPage == i ? 'btn-approve' : 'btn-reject'}"
                                   style="text-decoration:none; ${currentPage == i ? '' : 'background:#e5e7eb;color:#111827;'}"
                                   href="?page=${i}<c:if test='${not empty filterDate}'>&filterDate=${filterDate}</c:if><c:if test='${not empty filterStatus}'>&filterStatus=${filterStatus}</c:if><c:if test='${not empty filterVetId}'>&filterVetId=${filterVetId}</c:if>">${i}</a>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a class="btn btn-approve" style="text-decoration:none;" 
                                   href="?page=${currentPage + 1}<c:if test='${not empty filterDate}'>&filterDate=${filterDate}</c:if><c:if test='${not empty filterStatus}'>&filterStatus=${filterStatus}</c:if><c:if test='${not empty filterVetId}'>&filterVetId=${filterVetId}</c:if>">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
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
>>>>>>> Stashed changes
</html>