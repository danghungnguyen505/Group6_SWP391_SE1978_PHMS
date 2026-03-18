<%-- 
    Document   : receptionistRequestAppointment
    Created on : Jan 25, 2026, 1:25:46 AM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
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
                        <i class="fa-solid fa-table-columns"></i> ${L == 'en' ? 'Dashboard' : 'Bảng điều khiển'}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/emergency/queue" class="text-danger">
                        <i class="fa-solid fa-truck-medical"></i> ${L == 'en' ? 'Emergency Triage' : 'Cấp cứu'}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/appointment" class="active">
                        <i class="fa-regular fa-calendar-check"></i> ${L == 'en' ? 'Appointments' : 'Cuộc hẹn'}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/invoice/create">
                        <i class="fa-regular fa-credit-card"></i> ${L == 'en' ? 'Billing' : 'Thanh toán'}
                    </a>
                </li>
            </ul>

            <!-- Language Switcher -->
            <div style="padding: 12px; margin-top: auto;">
                <div style="display:flex; background:#f1f5f9; border-radius:8px; padding:3px; gap:2px;">
                    <a href="${pageContext.request.contextPath}/language?lang=vi"
                       style="padding:5px 10px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; flex:1; text-align:center;
                              ${L == 'vi' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">VI</a>
                    <a href="${pageContext.request.contextPath}/language?lang=en"
                       style="padding:5px 10px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; flex:1; text-align:center;
                              ${L == 'en' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">EN</a>
                </div>
            </div>

            <div class="help-box">
                <div class="help-text">${L == 'en' ? 'Need help?' : 'Cần hỗ trợ?'}</div>
                <a href="#" class="btn-contact">${L == 'en' ? 'Contact Support' : 'Liên hệ hỗ trợ'}</a>
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
            <div class="card" style="margin-bottom: 20px; padding: 15px;">
                <form method="get" action="${pageContext.request.contextPath}/receptionist/appointment" style="display:grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap:10px; align-items:end;">
                    <div>
                        <label style="font-size:12px; color:#64748b; display:block; margin-bottom:4px;">${L == 'en' ? 'Date' : 'Ngày'}</label>
                        <input type="date" name="filterDate" value="${filterDate}" style="width:100%; padding:8px 12px; border:1px solid #e2e8f0; border-radius:8px; font-size:13px;">
                    </div>
                    <div>
                        <label style="font-size:12px; color:#64748b; display:block; margin-bottom:4px;">${L == 'en' ? 'Status' : 'Trạng thái'}</label>
                        <select name="filterStatus" style="width:100%; padding:8px 12px; border:1px solid #e2e8f0; border-radius:8px; font-size:13px;">
                            <option value="">${L == 'en' ? 'All' : 'Tất cả'}</option>
                            <option value="Pending" ${filterStatus == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Confirmed" ${filterStatus == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="Checked-in" ${filterStatus == 'Checked-in' ? 'selected' : ''}>Checked-in</option>
                            <option value="In-Progress" ${filterStatus == 'In-Progress' ? 'selected' : ''}>In-Progress</option>
                            <option value="Completed" ${filterStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                            <option value="Cancelled" ${filterStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-size:12px; color:#64748b; display:block; margin-bottom:4px;">${L == 'en' ? 'Veterinarian' : 'Bác sĩ'}</label>
                        <select name="filterVetId" style="width:100%; padding:8px 12px; border:1px solid #e2e8f0; border-radius:8px; font-size:13px;">
                            <option value="">${L == 'en' ? 'All' : 'Tất cả'}</option>
                            <c:forEach var="vet" items="${veterinarians}">
                                <option value="${vet.userId}" ${filterVetId == vet.userId ? 'selected' : ''}>${vet.fullName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div style="display:flex; gap:8px;">
                        <button type="submit" style="flex:1; padding:8px 16px; background:#10b981; color:#fff; border:none; border-radius:8px; font-size:13px; font-weight:600; cursor:pointer;">
                            <i class="fa-solid fa-search"></i> ${L == 'en' ? 'Search' : 'Tìm kiếm'}
                        </button>
                        <c:if test="${not empty filterDate || not empty filterStatus || not empty filterVetId}">
                            <a href="${pageContext.request.contextPath}/receptionist/appointment" style="flex:1; padding:8px 16px; background:#f1f5f9; color:#64748b; border:none; border-radius:8px; font-size:13px; font-weight:600; text-decoration:none; text-align:center;">
                                <i class="fa-solid fa-rotate-left"></i> ${L == 'en' ? 'Reset' : 'Đặt lại'}
                            </a>
                        </c:if>
                    </div>
                </form>
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
                                <th>${L == 'en' ? 'No.' : 'STT'}</th>
                                <th>Owner Name</th>
                                <th>Pet Name</th>
                                <th>Service</th>
                                <th>Veterinarian</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                                <th>Notes</th>
                                                            </tr>
                        </thead>
                        
                        <tbody>
                            <c:forEach items="${appointments}" var="a" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}<input type="hidden" value="${a.apptId}" /></td> 
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
</html>