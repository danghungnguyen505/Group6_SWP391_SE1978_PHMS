<%--
    Document   : dashboardReceptionist
    Created on : Feb 1, 2026, 10:36:50 PM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Receptionist Dashboard</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <style>
            .pagination-bar {
                display: flex;
                gap: 6px;
                justify-content: flex-end;
                align-items: center;
                margin-top: 20px;
                flex-wrap: wrap;
            }
            .page-btn {
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                border: 1px solid #e2e8f0;
                background: #fff;
                color: #64748b;
                text-decoration: none;
                transition: 0.2s;
            }
            .page-btn:hover { background: #f0fdf4; color: #10b981; border-color: #10b981; }
            .page-btn.active { background: #10b981; color: #fff; border-color: #10b981; }
            .page-btn.disabled { opacity: 0.4; pointer-events: none; }
            .status-badge {
                display: inline-block;
                padding: 3px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }
            .badge-confirmed   { background: #d1fae5; color: #065f46; }
            .badge-checked-in  { background: #dbeafe; color: #1e40af; }
            .badge-in-progress { background: #fde68a; color: #92400e; }
            .badge-completed   { background: #fee2e2; color: #b91c1c; }
            .badge-no-show     { background: #f3f4f6; color: #6b7280; }
            .badge-pending     { background: #fef9c3; color: #854d0e; }
            .badge-cancelled   { background: #fce7f3; color: #9d174d; }
            .action-group { display: flex; gap: 6px; flex-wrap: wrap; }
            .action-group .btn { padding: 5px 10px; font-size: 11px; }
            .section-tabs {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }
            .tab-btn {
                padding: 8px 20px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                border: 1px solid #e2e8f0;
                background: #fff;
                color: #64748b;
                cursor: pointer;
                text-decoration: none;
                transition: 0.2s;
            }
            .tab-btn.active, .tab-btn:hover {
                background: #10b981;
                color: #fff;
                border-color: #10b981;
            }
        </style>
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
                        <i class="fa-solid fa-table-columns"></i> ${L == 'en' ? 'Dashboard' : 'Bảng điều khiển'}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/emergency/queue" class="text-danger">
                        <i class="fa-solid fa-truck-medical"></i> ${L == 'en' ? 'Emergency Triage' : 'Cấp cứu'}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/appointment">
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

            <!-- Main Card: Pending Requests -->
            <div class="card">
                <div class="section-title">
                    <span>Pending Requests</span>
                    <span style="font-size:13px; color:#94a3b8; font-weight:400;">${fn:length(pendingList)} request(s)</span>
                </div>

                <c:if test="${empty pendingList}">
                    <div class="empty-state">
                        <i class="fa-regular fa-calendar-times" style="font-size: 30px; margin-bottom: 10px;"></i>
                        <p>No pending appointment requests found.</p>
                    </div>
                </c:if>

                <c:if test="${not empty pendingList}">
                    <table>
                        <thead>
                            <tr>
                                <th>${L == 'en' ? 'No.' : 'STT'}</th>
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
                            <c:forEach items="${pendingList}" var="a" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}<input type="hidden" value="${a.apptId}" /></td>
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
                                            <span style="color: #999; font-style: italic;">No note</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Confirmed"
                                               class="btn btn-approve">
                                                <i class="fa-solid fa-check"></i> Approve
                                            </a>
                                            <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${a.apptId}&status=Cancelled"
                                               class="btn btn-reject"
                                               onclick="return confirm('Are you sure you want to reject this appointment?');">
                                                <i class="fa-solid fa-xmark"></i> Reject
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

            <!-- Main Card: Today's Appointments (read-only, sorted newest first, paginated) -->
            <div class="card" style="margin-top: 24px;">
                <div class="section-title">
                    <jsp:useBean id="today" class="java.util.Date" />
                    <span>Today's Appointments &mdash; <fmt:formatDate value="${today}" pattern="dd/MM/yyyy"/></span>
                    <span style="font-size:13px; color:#94a3b8; font-weight:400;">${totalTodayItems} appointment(s)</span>
                </div>

                <c:if test="${empty pagedTodayList}">
                    <div class="empty-state">
                        <p>No appointments scheduled for today.</p>
                    </div>
                </c:if>

                <c:if test="${not empty pagedTodayList}">
                    <table>
                        <thead>
                            <tr>
                                <th>${L == 'en' ? 'No.' : 'STT'}</th>
                                <th>Time</th>
                                <th>Owner &amp; Pet</th>
                                <th>Service</th>
                                <th>Doctor</th>
                                <th>Status</th>
                                <th>Notes</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${pagedTodayList}" var="t" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}<input type="hidden" value="${t.apptId}" /></td>
                                    <td style="font-weight: bold; color: #10b981;">
                                        <fmt:formatDate value="${t.startTime}" pattern="HH:mm"/>
                                    </td>
                                    <td>
                                        <div style="font-weight:600;">${t.ownerName}</div>
                                        <small style="color: #666;">Pet: ${t.petName}</small>
                                    </td>
                                    <td class="col-service">${t.type}</td>
                                    <td>${t.vetName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'Confirmed'}">
                                                <span class="status-badge badge-confirmed">Confirmed</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Checked-in'}">
                                                <span class="status-badge badge-checked-in">Checked-in</span>
                                            </c:when>
                                            <c:when test="${t.status == 'In-Progress'}">
                                                <span class="status-badge badge-in-progress">In-Progress</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Completed'}">
                                                <span class="status-badge badge-completed">Completed</span>
                                            </c:when>
                                            <c:when test="${t.status == 'No-show'}">
                                                <span class="status-badge badge-no-show">No-show</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge badge-pending">${t.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${not empty t.notes}">
                                            <button type="button" class="btn-view-note" data-note="${t.notes}" onclick="openModal(this)">
                                                <i class="fa-regular fa-eye"></i> View
                                            </button>
                                        </c:if>
                                        <c:if test="${empty t.notes}">
                                            <span style="color:#999; font-style:italic;">No note</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <c:if test="${t.status == 'Confirmed'}">
                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${t.apptId}&status=Checked-in"
                                                   class="btn btn-approve" style="font-size:12px;">
                                                    <i class="fa-solid fa-clipboard-check"></i> Check-in
                                                </a>
                                                <a href="${pageContext.request.contextPath}/receptionist/appointment-action?id=${t.apptId}&status=No-show"
                                                   class="btn btn-reject" style="font-size:12px;"
                                                   onclick="return confirm('Mark as No-show?');">
                                                    <i class="fa-solid fa-user-slash"></i> No-show
                                                </a>
                                            </c:if>
                                            <c:if test="${t.status == 'Completed'}">
                                                <c:choose>
                                                    <c:when test="${invoiceMap[t.apptId] != null && invoiceMap[t.apptId].status == 'Paid'}">
                                                        <a href="${pageContext.request.contextPath}/receptionist/invoice/detail?invoiceId=${invoiceMap[t.apptId].invoiceId}"
                                                           class="btn btn-approve" style="font-size:12px;">
                                                            <i class="fa-solid fa-eye"></i> View Invoice
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${invoiceMap[t.apptId] != null && invoiceMap[t.apptId].status == 'Unpaid'}">
                                                        <a href="${pageContext.request.contextPath}/receptionist/invoice/detail?invoiceId=${invoiceMap[t.apptId].invoiceId}"
                                                           class="btn btn-approve" style="font-size:12px; background:#f59e0b; border-color:#f59e0b;">
                                                            <i class="fa-solid fa-credit-card"></i> Pay Invoice
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/receptionist/invoice/create?apptId=${t.apptId}"
                                                           class="btn btn-approve" style="font-size:12px;">
                                                            <i class="fa-solid fa-file-invoice-dollar"></i> Create Invoice
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <c:if test="${totalTodayPages > 1}">
                        <div class="pagination-bar">
                            <a href="?todayPage=${todayCurrentPage - 1}" class="page-btn ${todayCurrentPage <= 1 ? 'disabled' : ''}">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                            <c:forEach begin="1" end="${totalTodayPages}" var="i">
                                <a href="?todayPage=${i}" class="page-btn ${todayCurrentPage == i ? 'active' : ''}">${i}</a>
                            </c:forEach>
                            <a href="?todayPage=${todayCurrentPage + 1}" class="page-btn ${todayCurrentPage >= totalTodayPages ? 'disabled' : ''}">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </div>
                    </c:if>
                </c:if>
            </div>
        </main>

        <!-- Note Modal -->
        <div id="noteModal" class="modal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,0.5);">
            <div class="modal-content" style="background:#fff; margin:10% auto; padding:30px; border-radius:12px; width:50%; max-width:600px; position:relative;">
                <span class="close-btn" onclick="closeModal()" style="position:absolute; top:15px; right:20px; font-size:24px; cursor:pointer; color:#94a3b8;">&times;</span>
                <h2 class="modal-title" style="font-size:16px; font-weight:700; margin-bottom:15px; color:#1e293b;">
                    <i class="fa-solid fa-clipboard-list"></i> Appointment Notes
                </h2>
                <div id="modalNoteContent" class="modal-body" style="font-size:14px; color:#475569; line-height:1.7;"></div>
            </div>
        </div>

        <script>
            function openModal(btn) {
                document.getElementById('modalNoteContent').textContent = btn.getAttribute('data-note');
                document.getElementById('noteModal').style.display = 'block';
            }
            function closeModal() {
                document.getElementById('noteModal').style.display = 'none';
            }
            window.onclick = function(e) {
                var m = document.getElementById('noteModal');
                if (e.target === m) closeModal();
            };
        </script>
    <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>


