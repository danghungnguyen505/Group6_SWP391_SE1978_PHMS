<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Veterinarian Dashboard</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
        <style>
            :root {
                --primary: #10b981;
                --primary-light: #d1fae5;
                --danger: #ef4444;
                --danger-light: #fee2e2;
                --bg: #f8fafc;
                --card-shadow: 0 4px 20px -2px rgba(0,0,0,0.06);
                --text-main: #1e293b;
                --text-muted: #64748b;
            }
            body { background: var(--bg); font-family: 'Inter', sans-serif; }
            .main-content { padding: 32px 40px; }

            /* Top bar */
            .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }
            .page-header h2 { font-size: 22px; font-weight: 800; color: var(--text-main); margin-bottom: 4px; }
            .page-header p { color: var(--text-muted); font-size: 14px; }
            .btn-signout { padding: 9px 20px; border: 1px solid #e2e8f0; background: #fff; border-radius: 8px; color: var(--text-muted); font-size: 13px; font-weight: 600; text-decoration: none; transition: 0.2s; }
            .btn-signout:hover { background: #f1f5f9; }

            /* Stats */
            .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 28px; }
            .stat-card { background: #fff; border-radius: 16px; padding: 22px 24px; box-shadow: var(--card-shadow); display: flex; align-items: center; gap: 16px; }
            .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; }
            .stat-icon.green  { background: #d1fae5; color: #059669; }
            .stat-icon.blue   { background: #dbeafe; color: #2563eb; }
            .stat-icon.orange { background: #fef3c7; color: #d97706; }
            .stat-icon.red    { background: #fee2e2; color: #dc2626; }
            .stat-value { font-size: 28px; font-weight: 800; color: var(--text-main); }
            .stat-label { font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }

            /* Dashboard grid */
            .dash-grid { display: grid; grid-template-columns: 1.4fr 1fr; gap: 22px; }

            /* Panel */
            .panel { background: #fff; border-radius: 20px; box-shadow: var(--card-shadow); overflow: hidden; }
            .panel-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #f1f5f9; }
            .panel-title { font-size: 14px; font-weight: 800; color: var(--text-main); }
            .badge-count { background: var(--primary-light); color: #065f46; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 700; }
            .badge-emergency { background: var(--danger-light); color: #991b1b; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 700; }

            /* Table */
            .dash-table { width: 100%; border-collapse: collapse; }
            .dash-table thead th { padding: 12px 20px; text-align: left; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: #94a3b8; background: #f8fafc; border-bottom: 1px solid #f1f5f9; }
            .dash-table tbody tr { border-bottom: 1px solid #f8fafc; transition: background 0.15s; }
            .dash-table tbody tr:hover { background: #f8fafc; }
            .dash-table tbody tr:last-child { border-bottom: none; }
            .dash-table tbody td { padding: 14px 20px; font-size: 14px; color: var(--text-main); vertical-align: middle; }

            /* Time badge */
            .time-badge { display: inline-flex; align-items: center; gap: 5px; background: #f0fdf4; color: #059669; padding: 4px 10px; border-radius: 8px; font-weight: 700; font-size: 13px; }
            .time-badge.emergency { background: #fee2e2; color: #dc2626; }

            /* Owner/pet */
            .owner-name { font-weight: 600; }
            .pet-name { font-size: 12px; color: var(--text-muted); margin-top: 2px; }

            /* Service tag */
            .service-tag { display: inline-block; background: #eff6ff; color: #2563eb; padding: 3px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; }
            .service-tag.urgent { background: #fee2e2; color: #dc2626; }

            /* Status badge */
            .status-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
            .badge-checked-in  { background: #dbeafe; color: #1e40af; }
            .badge-in-progress { background: #fef3c7; color: #92400e; }
            .badge-emergency-s { background: #fee2e2; color: #991b1b; }

            /* Action buttons */
            .btn-action { display: inline-flex; align-items: center; gap: 5px; padding: 6px 14px; border-radius: 8px; font-size: 13px; font-weight: 600; text-decoration: none; transition: 0.2s; }
            .btn-emr { background: #fff; border: 1px solid #e2e8f0; color: var(--text-main); }
            .btn-emr:hover { border-color: var(--primary); color: var(--primary); }
            .btn-treat { background: var(--primary); color: #fff; border: none; }
            .btn-treat:hover { background: #059669; }
            .btn-emergency { background: var(--danger); color: #fff; border: none; }
            .btn-emergency:hover { background: #dc2626; }

            /* Empty state */
            .empty-state { text-align: center; padding: 40px 20px; color: #94a3b8; }
            .empty-state i { font-size: 36px; margin-bottom: 10px; display: block; }

            /* Quick actions */
            .quick-actions { display: flex; flex-direction: column; gap: 12px; padding: 20px; }
            .quick-btn { display: flex; align-items: center; gap: 14px; padding: 16px 18px; border-radius: 14px; text-decoration: none; transition: 0.2s; border: 1px solid #f1f5f9; }
            .quick-btn:hover { transform: translateX(4px); box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
            .quick-btn-icon { width: 42px; height: 42px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 18px; flex-shrink: 0; }
            .quick-btn-text .title { font-size: 14px; font-weight: 700; color: var(--text-main); }
            .quick-btn-text .desc { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        </style>
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <div class="page-header">
                    <h2><i class="fa-solid fa-stethoscope" style="color:#10b981; margin-right:8px;"></i>Veterinarian Dashboard</h2>
                    <jsp:useBean id="today" class="java.util.Date" />
                    <p>Welcome back, ${sessionScope.account.fullName} &mdash; <fmt:formatDate value="${today}" pattern="EEEE, dd MMMM yyyy"/></p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">
                    <i class="fa-solid fa-right-from-bracket"></i> Sign Out
                </a>
            </div>

            <!-- Stats Row -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fa-solid fa-user-check"></i></div>
                    <div>
                        <div class="stat-value">${totalPatients}</div>
                        <div class="stat-label">Today's Patients</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="fa-solid fa-clock"></i></div>
                    <div>
                        <div class="stat-value">${pendingEMR}</div>
                        <div class="stat-label">Awaiting EMR</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange"><i class="fa-solid fa-file-medical"></i></div>
                    <div>
                        <div class="stat-value">${completedToday}</div>
                        <div class="stat-label">In Progress</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red"><i class="fa-solid fa-truck-medical"></i></div>
                    <div>
                        <div class="stat-value">${emergencyCount}</div>
                        <div class="stat-label">Emergencies</div>
                    </div>
                </div>
            </div>

            <!-- Dashboard Grid -->
            <div class="dash-grid">
                <!-- Left: Today's Queue -->
                <div style="display:flex; flex-direction:column; gap:22px;">
                    <!-- Today's Appointments -->
                    <div class="panel">
                        <div class="panel-header">
                            <span class="panel-title"><i class="fa-regular fa-calendar-check" style="margin-right:8px; color:#10b981;"></i>Today's Queue</span>
                            <span class="badge-count">${totalPatients} patient(s)</span>
                        </div>
                        <c:if test="${empty todayQueue}">
                            <div class="empty-state">
                                <i class="fa-regular fa-calendar-check"></i>
                                <p>No checked-in patients for today.</p>
                            </div>
                        </c:if>
                        <c:if test="${not empty todayQueue}">
                            <table class="dash-table">
                                <thead>
                                    <tr>
                                        <th>Time</th>
                                        <th>Owner &amp; Pet</th>
                                        <th>Service</th>
                                        <th>Status</th>
                                        <th style="text-align:center;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${todayQueue}" var="a">
                                        <tr>
                                            <td>
                                                <span class="time-badge">
                                                    <i class="fa-regular fa-clock"></i>
                                                    <fmt:formatDate value="${a.startTime}" pattern="HH:mm"/>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="owner-name">${a.ownerName}</div>
                                                <div class="pet-name"><i class="fa-solid fa-paw" style="font-size:10px;"></i> ${a.petName}</div>
                                            </td>
                                            <td><span class="service-tag">${a.type}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${a.status == 'Checked-in'}">
                                                        <span class="status-badge badge-checked-in">Checked-in</span>
                                                    </c:when>
                                                    <c:when test="${a.status == 'In-Progress'}">
                                                        <span class="status-badge badge-in-progress">In-Progress</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge badge-checked-in">${a.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align:center;">
                                                <c:choose>
                                                    <c:when test="${a.status == 'Checked-in'}">
                                                        <a class="btn-action btn-emr"
                                                           href="${pageContext.request.contextPath}/veterinarian/emr/submit?apptId=${a.apptId}">
                                                            <i class="fa-solid fa-file-circle-plus"></i> Create EMR
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${a.status == 'In-Progress'}">
                                                        <a class="btn-action btn-treat"
                                                           href="${pageContext.request.contextPath}/veterinarian/emr/submit?apptId=${a.apptId}">
                                                            <i class="fa-solid fa-stethoscope"></i> Open EMR Detail
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a class="btn-action btn-emr"
                                                           href="${pageContext.request.contextPath}/veterinarian/emr/queue">
                                                            <i class="fa-solid fa-eye"></i> View Queue
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                    </div>

                    <!-- Emergency Queue -->
                    <div class="panel">
                        <div class="panel-header">
                            <span class="panel-title" style="color:#dc2626;"><i class="fa-solid fa-truck-medical" style="margin-right:8px;"></i>Emergency Queue</span>
                            <span class="badge-emergency">${emergencyCount} case(s)</span>
                        </div>
                        <c:if test="${empty emergencyQueue}">
                            <div class="empty-state">
                                <i class="fa-solid fa-shield-heart" style="color:#d1fae5;"></i>
                                <p>No active emergencies.</p>
                            </div>
                        </c:if>
                        <c:if test="${not empty emergencyQueue}">
                            <table class="dash-table">
                                <thead>
                                    <tr>
                                        <th>Time</th>
                                        <th>Owner &amp; Pet</th>
                                        <th>Type</th>
                                        <th style="text-align:center;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${emergencyQueue}" var="e">
                                        <tr>
                                            <td>
                                                <span class="time-badge emergency">
                                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                                    <fmt:formatDate value="${e.startTime}" pattern="HH:mm"/>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="owner-name">${e.ownerName}</div>
                                                <div class="pet-name"><i class="fa-solid fa-paw" style="font-size:10px;"></i> ${e.petName}</div>
                                            </td>
                                            <td><span class="service-tag urgent">${e.type}</span></td>
                                            <td style="text-align:center;">
                                                <a class="btn-action btn-emergency"
                                                   href="${pageContext.request.contextPath}/veterinarian/emergency/queue">
                                                    <i class="fa-solid fa-arrow-right"></i> Treat
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                    </div>
                </div>

                <!-- Right: Quick Actions -->
                <div style="display:flex; flex-direction:column; gap:22px;">
                    <div class="panel">
                        <div class="panel-header">
                            <span class="panel-title">Quick Actions</span>
                        </div>
                        <div class="quick-actions">
                            <a href="${pageContext.request.contextPath}/veterinarian/emr/queue" class="quick-btn">
                                <div class="quick-btn-icon" style="background:#d1fae5; color:#059669;">
                                    <i class="fa-solid fa-stethoscope"></i>
                                </div>
                                <div class="quick-btn-text">
                                    <div class="title">EMR Queue</div>
                                    <div class="desc">View today's checked-in patients</div>
                                </div>
                                <i class="fa-solid fa-chevron-right" style="margin-left:auto; color:#cbd5e0;"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/veterinarian/emergency/queue" class="quick-btn">
                                <div class="quick-btn-icon" style="background:#fee2e2; color:#dc2626;">
                                    <i class="fa-solid fa-truck-medical"></i>
                                </div>
                                <div class="quick-btn-text">
                                    <div class="title">Emergency Queue</div>
                                    <div class="desc">Handle urgent cases</div>
                                </div>
                                <i class="fa-solid fa-chevron-right" style="margin-left:auto; color:#cbd5e0;"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/veterinarian/emr/records" class="quick-btn">
                                <div class="quick-btn-icon" style="background:#dbeafe; color:#2563eb;">
                                    <i class="fa-solid fa-file-medical"></i>
                                </div>
                                <div class="quick-btn-text">
                                    <div class="title">Medical Records</div>
                                    <div class="desc">View and manage patient records</div>
                                </div>
                                <i class="fa-solid fa-chevron-right" style="margin-left:auto; color:#cbd5e0;"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/veterinarian/scheduling" class="quick-btn">
                                <div class="quick-btn-icon" style="background:#fef3c7; color:#d97706;">
                                    <i class="fa-solid fa-calendar-alt"></i>
                                </div>
                                <div class="quick-btn-text">
                                    <div class="title">My Schedule</div>
                                    <div class="desc">View your work schedule</div>
                                </div>
                                <i class="fa-solid fa-chevron-right" style="margin-left:auto; color:#cbd5e0;"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/veterinarian/scheduling" class="quick-btn">
                                <div class="quick-btn-icon" style="background:#ede9fe; color:#7c3aed;">
                                    <i class="fa-solid fa-umbrella-beach"></i>
                                </div>
                                <div class="quick-btn-text">
                                    <div class="title">Request Leave</div>
                                    <div class="desc">Submit a leave request</div>
                                </div>
                                <i class="fa-solid fa-chevron-right" style="margin-left:auto; color:#cbd5e0;"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>
