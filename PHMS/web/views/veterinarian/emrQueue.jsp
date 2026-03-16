<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - EMR Queue</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
        <style>
            :root {
                --primary: #10b981;
                --primary-light: #d1fae5;
                --bg: #f8fafc;
                --card-shadow: 0 4px 20px -2px rgba(0,0,0,0.06);
                --text-main: #1e293b;
                --text-muted: #64748b;
            }

            body { background: var(--bg); font-family: 'Inter', sans-serif; }

            .main-content { padding: 32px 40px; }

            /* Top bar */
            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 28px;
            }
            .page-header h2 {
                font-size: 22px;
                font-weight: 800;
                color: var(--text-main);
                margin-bottom: 4px;
            }
            .page-header p { color: var(--text-muted); font-size: 14px; }
            .btn-signout {
                padding: 9px 20px;
                border: 1px solid #e2e8f0;
                background: #fff;
                border-radius: 8px;
                color: var(--text-muted);
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
                transition: 0.2s;
            }
            .btn-signout:hover { background: #f1f5f9; }

            /* Stats row */
            .stats-row {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 18px;
                margin-bottom: 28px;
            }
            .stat-card {
                background: #fff;
                border-radius: 16px;
                padding: 22px 26px;
                box-shadow: var(--card-shadow);
                display: flex;
                align-items: center;
                gap: 16px;
            }
            .stat-icon {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                flex-shrink: 0;
            }
            .stat-icon.green  { background: #d1fae5; color: #059669; }
            .stat-icon.blue   { background: #dbeafe; color: #2563eb; }
            .stat-icon.orange { background: #fef3c7; color: #d97706; }
            .stat-value { font-size: 26px; font-weight: 800; color: var(--text-main); }
            .stat-label { font-size: 12px; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }

            /* Main card */
            .emr-card {
                background: #fff;
                border-radius: 20px;
                box-shadow: var(--card-shadow);
                overflow: hidden;
            }
            .emr-card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 24px 30px;
                border-bottom: 1px solid #f1f5f9;
            }
            .emr-card-header h3 {
                font-size: 16px;
                font-weight: 800;
                color: var(--text-main);
            }
            .emr-card-header .badge-count {
                background: var(--primary-light);
                color: #065f46;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
            }

            /* Table */
            .emr-table { width: 100%; border-collapse: collapse; }
            .emr-table thead th {
                padding: 14px 20px;
                text-align: left;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.6px;
                color: #94a3b8;
                background: #f8fafc;
                border-bottom: 1px solid #f1f5f9;
            }
            .emr-table tbody tr {
                border-bottom: 1px solid #f8fafc;
                transition: background 0.15s;
            }
            .emr-table tbody tr:hover { background: #f8fafc; }
            .emr-table tbody tr:last-child { border-bottom: none; }
            .emr-table tbody td {
                padding: 16px 20px;
                font-size: 14px;
                color: var(--text-main);
                vertical-align: middle;
            }

            /* Time badge */
            .time-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: #f0fdf4;
                color: #059669;
                padding: 5px 12px;
                border-radius: 8px;
                font-weight: 700;
                font-size: 13px;
            }

            /* Owner/pet cell */
            .owner-cell .owner-name { font-weight: 600; color: var(--text-main); }
            .owner-cell .pet-name   { font-size: 12px; color: var(--text-muted); margin-top: 2px; }

            /* Service tag */
            .service-tag {
                display: inline-block;
                background: #eff6ff;
                color: #2563eb;
                padding: 3px 10px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
            }

            /* Notes */
            .notes-text { font-size: 13px; color: var(--text-muted); font-style: italic; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

            /* Action buttons */
            .action-cell { display: flex; gap: 8px; align-items: center; }
            .btn-edit {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 7px 14px;
                background: #fff;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                color: var(--text-main);
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
                transition: 0.2s;
            }
            .btn-edit:hover { border-color: var(--primary); color: var(--primary); }
            .btn-submit {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 7px 14px;
                background: var(--primary);
                border: none;
                border-radius: 8px;
                color: #fff;
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
                transition: 0.2s;
            }
            .btn-submit:hover { background: #059669; }
            .btn-complete {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 7px 14px;
                background: #2563eb;
                border: none;
                border-radius: 8px;
                color: #fff;
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
                transition: 0.2s;
            }
            .btn-complete:hover { background: #1d4ed8; }

            /* Empty state */
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #94a3b8;
            }
            .empty-state i { font-size: 40px; margin-bottom: 12px; display: block; }
            .empty-state p { font-size: 15px; }

            /* Pagination */
            .pagination-bar {
                display: flex;
                gap: 6px;
                justify-content: flex-end;
                align-items: center;
                padding: 18px 24px;
                border-top: 1px solid #f1f5f9;
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
            .page-btn:hover { background: #f0fdf4; color: var(--primary); border-color: var(--primary); }
            .page-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); }
            .page-btn.disabled { opacity: 0.4; pointer-events: none; }
        </style>
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <div class="page-header">
                    <h2><i class="fa-solid fa-stethoscope" style="color:#10b981; margin-right:8px;"></i>Today's EMR Queue</h2>
                    <jsp:useBean id="today" class="java.util.Date" />
                    <p>Checked-in patients for <fmt:formatDate value="${today}" pattern="EEEE, dd MMMM yyyy"/></p>
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
                        <div class="stat-value">${totalQueueItems}</div>
                        <div class="stat-label">Checked-in Today</div>
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
                        <div class="stat-value">${completedEMR}</div>
                        <div class="stat-label">Submitted Today</div>
                    </div>
                </div>
            </div>

            <!-- Main EMR Table Card -->
            <div class="emr-card">
                <div class="emr-card-header">
                    <h3>Checked-in Appointments</h3>
                    <span class="badge-count">${totalQueueItems} patient(s)</span>
                </div>

                <c:if test="${empty queueList}">
                    <div class="empty-state">
                        <i class="fa-regular fa-calendar-check"></i>
                        <p>No checked-in appointments for today.</p>
                    </div>
                </c:if>

                <c:if test="${not empty queueList}">
                    <table class="emr-table">
                        <thead>
                            <tr>
                                <th>Time</th>
                                <th>ID</th>
                                <th>Owner &amp; Pet</th>
                                <th>Service</th>
                                <th>Notes</th>
                                <th style="text-align:center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${queueList}" var="a">
                                <tr>
                                    <td>
                                        <span class="time-badge">
                                            <i class="fa-regular fa-clock"></i>
                                            <fmt:formatDate value="${a.startTime}" pattern="HH:mm"/>
                                        </span>
                                    </td>
                                    <td style="font-weight:700; color:#1e293b;">#${a.apptId}</td>
                                    <td>
                                        <div class="owner-cell">
                                            <div class="owner-name">${a.ownerName}</div>
                                            <div class="pet-name"><i class="fa-solid fa-paw" style="font-size:10px;"></i> ${a.petName}</div>
                                        </div>
                                    </td>
                                    <td><span class="service-tag">${a.type}</span></td>
                                    <td>
                                        <c:if test="${empty a.notes}">
                                            <span style="color:#cbd5e0; font-style:italic; font-size:13px;">No notes</span>
                                        </c:if>
                                        <c:if test="${not empty a.notes}">
                                            <span class="notes-text" title="${a.notes}">${a.notes}</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="action-cell" style="justify-content:center;">
                                            <a class="btn-edit"
                                               href="${pageContext.request.contextPath}/veterinarian/emr/queue/edit?apptId=${a.apptId}">
                                                <i class="fa-solid fa-pen-to-square"></i> Edit EMR
                                            </a>
                                            <c:if test="${a.status == 'Checked-in'}">
                                                <a class="btn-submit"
                                                   href="${pageContext.request.contextPath}/veterinarian/emr/submit?apptId=${a.apptId}">
                                                    <i class="fa-solid fa-paper-plane"></i> Submit
                                                </a>
                                            </c:if>
                                            <c:if test="${a.status == 'In-Progress'}">
                                                <a class="btn-complete"
                                                   href="${pageContext.request.contextPath}/veterinarian/emr/complete?apptId=${a.apptId}"
                                                   onclick="return confirm('Mark this appointment as Completed?');">
                                                    <i class="fa-solid fa-check-circle"></i> Complete
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-bar">
                            <a class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" href="?page=${currentPage - 1}">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a class="page-btn ${currentPage == i ? 'active' : ''}" href="?page=${i}">${i}</a>
                            </c:forEach>
                            <a class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" href="?page=${currentPage + 1}">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </div>
                    </c:if>
                </c:if>
            </div>
        </main>
    </body>
</html>
