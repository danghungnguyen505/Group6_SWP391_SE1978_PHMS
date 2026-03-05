<%-- 
    Document   : doctorScheduleList
    Created on : Jan 22, 2026
    Author     : Auto
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - LỊCH LÀM VIỆC BÁC SĨ</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/staffScheduling.css">
    
    <style>
        :root {
            --sidebar-width: 280px;
            --primary-green: #50b498;
            --bg-body: #f8fafc;
            --text-main: #0f172a;
            --text-muted: #718096;
            --input-bg: #f8fafc;
            --card-shadow: 0 4px 25px -5px rgba(0, 0, 0, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            -webkit-font-smoothing: antialiased;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-body);
            color: var(--text-main);
            display: flex;
            min-height: 100vh;
        }

        /* --- SIDEBAR --- */
        .sidebar {
            width: var(--sidebar-width);
            background: #ffffff;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding: 35px 25px;
            display: flex;
            flex-direction: column;
            border-right: 1px solid #edf2f7;
            z-index: 1000;
        }
        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--primary-green);
            font-weight: 800;
            font-size: 22px;
            margin-bottom: 50px;
            padding-left: 10px;
        }
        .menu-label {
            color: #a0aec0;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            margin-bottom: 20px;
            padding-left: 10px;
        }
        .nav-menu {
            list-style: none;
            flex: 1;
        }
        .nav-item {
            margin-bottom: 6px;
        }
        .nav-link {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 18px;
            text-decoration: none;
            color: var(--text-muted);
            font-weight: 500;
            font-size: 15px;
            border-radius: 12px;
            transition: 0.2s;
        }
        .nav-link:hover {
            background: #f7fafc;
            color: var(--text-main);
        }
        .nav-link.active {
            background: #f0fff4;
            color: var(--primary-green);
            font-weight: 600;
        }
        .nav-link i {
            width: 22px;
            font-size: 18px;
            text-align: center;
        }

        /* --- MAIN CONTENT --- */
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            /* Extra bottom padding to avoid content being hidden behind fixed footer-stats bar */
            padding: 35px 60px 90px;
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .header-text h2 {
            font-size: 28px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: -0.5px;
            margin-bottom: 5px;
        }

        .header-text p {
            color: var(--text-muted);
            font-size: 14px;
        }

        .header-actions {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .btn-primary {
            background: var(--primary-green);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-primary:hover {
            opacity: 0.9;
        }

        /* --- CONTROLS BAR --- */
        .controls-bar {
            background: white;
            padding: 15px 20px;
            border-radius: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
            flex-wrap: wrap;
            gap: 15px;
        }

        .date-nav {
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: 700;
        }

        .nav-arrow {
            background: #f1f5f9;
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
            text-decoration: none;
            transition: 0.2s;
        }

        .nav-arrow:hover {
            background: #e2e8f0;
        }

        .date-range {
            font-size: 14px;
            color: var(--text-main);
        }

        .doctor-filter {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            color: #64748b;
        }

        .doctor-filter select {
            padding: 6px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 13px;
            font-family: 'Inter', sans-serif;
            background: white;
            cursor: pointer;
        }

        .doctor-filter strong {
            color: var(--text-main);
            font-weight: 700;
        }

        /* --- SCHEDULE GRID --- */
        .schedule-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 15px;
        }

        .day-column {
            background: white;
            border-radius: 12px;
            padding: 15px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            border: 1px solid #eef2f6;
            min-height: 400px;
        }

        .day-column.today {
            border: 2px solid var(--primary-green);
            background-color: #f0fdf4;
        }

        .day-header {
            text-align: center;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 10px;
            margin-bottom: 5px;
        }

        .day-name {
            font-size: 11px;
            font-weight: 700;
            color: #94a3b8;
            text-transform: uppercase;
            display: block;
        }

        .day-num {
            font-size: 24px;
            font-weight: 800;
            color: #334155;
            display: block;
            margin-top: 5px;
        }

        .day-column.today .day-name,
        .day-column.today .day-num {
            color: var(--primary-green);
        }

        /* --- SHIFT CARDS --- */
        .shift-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 12px;
            display: flex;
            gap: 10px;
            transition: 0.2s;
        }

        .shift-card.schedule-click-delete {
            cursor: pointer;
        }

        .shift-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }

        .avatar-circle {
            width: 36px;
            height: 36px;
            background: #f1f5f9;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #64748b;
            flex-shrink: 0;
            font-size: 14px;
        }

        .shift-info {
            flex: 1;
        }

        .shift-info h4 {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 4px;
        }

        .role-badge {
            display: inline-block;
            font-size: 10px;
            font-weight: 700;
            padding: 2px 6px;
            border-radius: 4px;
            text-transform: uppercase;
            margin-bottom: 6px;
        }

        .role-badge.vet {
            background: #dbeafe;
            color: #1e40af;
        }

        .time {
            font-size: 12px;
            color: #64748b;
            display: flex;
            align-items: center;
            gap: 5px;
            margin-top: 4px;
        }

        .add-another-btn {
            width: 100%;
            padding: 8px;
            background: #f1f5f9;
            color: #64748b;
            border: none;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            margin-top: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            transition: 0.2s;
        }

        .add-another-btn:hover {
            background: #e2e8f0;
        }

        /* --- FOOTER --- */
        .footer-stats {
            position: fixed;
            bottom: 0;
            left: var(--sidebar-width);
            right: 0;
            background: #0f172a;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 100;
        }

        .stats-group {
            display: flex;
            gap: 30px;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
        }

        .stat-label {
            font-size: 11px;
            color: #94a3b8;
            font-weight: 700;
            text-transform: uppercase;
        }

        .stat-value {
            font-size: 20px;
            font-weight: 800;
            display: block;
        }

        .warning-box {
            background: #1f2937;
            border: 1px solid #374151;
            padding: 8px 15px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .warning-text {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .warning-text strong {
            font-size: 12px;
        }

        .warning-text span {
            font-size: 13px;
            color: #cbd5e0;
        }

        .help-box {
            margin-top: auto;
            background: #f8fafc;
            padding: 20px;
            border-radius: 16px;
            border: 1px solid #edf2f7;
        }
        .help-box p {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 12px;
        }
        .btn-support {
            display: block;
            background: #0f172a;
            color: white;
            text-align: center;
            padding: 10px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            font-size: 12px;
        }

        .empty-day {
            text-align: center;
            color: #cbd5e0;
            padding: 20px;
            font-size: 13px;
        }
    </style>
</head>
<body>

    <jsp:include page="common/navbar.jsp">
        <jsp:param name="activePage" value="scheduling" />
    </jsp:include>

    <main class="main-content">
        <c:if test="${not empty sessionScope.toastMessage}">
            <c:set var="toast" value="${sessionScope.toastMessage}" />
            <c:choose>
                <c:when test="${fn:startsWith(toast, 'success|')}">
                    <div style="background:#ecfdf5;border:1px solid #a7f3d0;color:#065f46;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-weight:600;">
                        <i class="fa-solid fa-check-circle" style="margin-right: 8px;"></i>
                        ${fn:substringAfter(toast, 'success|')}
                    </div>
                </c:when>
                <c:when test="${fn:startsWith(toast, 'error|')}">
                    <div style="background:#fef2f2;border:1px solid #fecaca;color:#991b1b;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-weight:600;">
                        <i class="fa-solid fa-triangle-exclamation" style="margin-right: 8px;"></i>
                        ${fn:substringAfter(toast, 'error|')}
                    </div>
                </c:when>
            </c:choose>
            <c:remove var="toastMessage" scope="session" />
        </c:if>

        <div class="header-section">
            <div class="header-text">
                <h2>LỊCH LÀM VIỆC BÁC SĨ</h2>
                <p>Xem và quản lý lịch làm việc của các bác sĩ</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/admin/doctor/schedule/add" class="btn-primary">
                    <i class="fa-solid fa-plus"></i> Thêm Lịch
                </a>
            </div>
        </div>

        <div class="controls-bar">
            <div class="date-nav">
                <a href="?date=${prevWeek}${not empty selectedDoctorId ? '&doctorId='.concat(selectedDoctorId) : ''}" class="nav-arrow">
                    <i class="fa-solid fa-chevron-left"></i>
                </a>
                <span class="date-range">
                    <fmt:parseDate value="${startOfWeek}" pattern="yyyy-MM-dd" var="parsedStart" />
                    <fmt:parseDate value="${endOfWeek}" pattern="yyyy-MM-dd" var="parsedEnd" />
                    <fmt:formatDate value="${parsedStart}" pattern="MMM dd"/> - 
                    <fmt:formatDate value="${parsedEnd}" pattern="MMM dd, yyyy"/>
                </span>
                <a href="?date=${nextWeek}${not empty selectedDoctorId ? '&doctorId='.concat(selectedDoctorId) : ''}" class="nav-arrow">
                    <i class="fa-solid fa-chevron-right"></i>
                </a>
            </div>

            <div class="doctor-filter">
                <span>Đang xem:</span>
                <strong>${selectedDoctorName}</strong>
                <form method="get" action="${pageContext.request.contextPath}/admin/doctor/schedule/list" style="display: inline;">
                    <input type="hidden" name="date" value="${startOfWeek}">
                    <select name="doctorId" onchange="this.form.submit()" style="margin-left: 8px;">
                        <option value="">Tất cả bác sĩ</option>
                        <c:forEach var="vet" items="${veterinarians}">
                            <c:set var="vetIdStr" value="${vet.userId}" />
                            <option value="${vet.userId}" ${selectedDoctorId != null && selectedDoctorId == vetIdStr ? 'selected' : ''}>
                                ${vet.fullName}
                            </option>
                        </c:forEach>
                    </select>
                </form>
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
                    <c:forEach var="schedule" items="${entry.value}">
                        <c:set var="leaveStatus" value="${schedule.leaveStatus}" />
                        <form id="deleteForm_${schedule.scheduleId}" method="post"
                              action="${pageContext.request.contextPath}/admin/doctor/schedule/delete" style="display:none;">
                            <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                            <input type="hidden" name="date" value="${currentDate}">
                            <c:if test="${not empty selectedDoctorId}">
                                <input type="hidden" name="doctorId" value="${selectedDoctorId}">
                            </c:if>
                        </form>
                        <div class="shift-card
                             schedule-click-delete
                             ${leaveStatus == 'Pending' ? ' leave-pending' : ''}
                             ${leaveStatus == 'Approved' ? ' leave-approved' : ''}
                             ${leaveStatus == 'Rejected' ? ' leave-rejected' : ''}">
                            <div class="avatar-circle">
                                ${fn:substring(schedule.vetName, 0, 1)}
                            </div>
                            <div class="shift-info">
                                <h4>${schedule.vetName}</h4>
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
                                    <span>${schedule.shiftTime}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <button class="add-another-btn" onclick="window.location.href='${pageContext.request.contextPath}/admin/doctor/schedule/add?date=${entry.key}'">
                        <i class="fa-solid fa-plus"></i> Add Another
                    </button>
                </div>
            </c:forEach>
        </div>
    </main>

    <div class="footer-stats">
        <div class="stats-group">
            <div class="stat-item">
                <span class="stat-label">Total Shifts</span>
                <span class="stat-value">${totalShifts}</span>
            </div>
        </div>
        <div class="warning-box" style="display: none;">
            <i class="fa-solid fa-triangle-exclamation" style="color: #fbbf24;"></i>
            <div class="warning-text">
                <strong>Staff Warning</strong>
                <span>No warnings at this time.</span>
            </div>
        </div>
    </div>

    <script>
        // Click on a schedule card => confirm => POST delete
        document.querySelectorAll('.shift-card.schedule-click-delete').forEach(function (card) {
            card.addEventListener('click', function () {
                // Find the hidden form right before this card
                var form = this.previousElementSibling;
                if (!form || form.tagName !== 'FORM') return;

                var ok = confirm('Bạn có chắc muốn xoá ca làm việc này không?');
                if (!ok) return;

                form.submit();
            });
        });
    </script>

</body>
</html>
