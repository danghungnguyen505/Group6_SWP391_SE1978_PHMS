<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Medical Records</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
        <style>
            :root {
                --primary: #10b981;
                --primary-dark: #059669;
                --primary-light: #d1fae5;
                --bg: #f8fafc;
                --card-shadow: 0 4px 20px -2px rgba(0,0,0,0.06);
                --text-main: #1e293b;
                --text-muted: #64748b;
                --border-soft: #e2e8f0;
            }

            body {
                background: var(--bg);
                font-family: 'Inter', sans-serif;
            }

            .main-content {
                padding: 32px 40px;
            }

            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 14px;
                margin-bottom: 26px;
                flex-wrap: wrap;
            }

            .page-header h2 {
                font-size: 22px;
                font-weight: 800;
                color: var(--text-main);
                margin-bottom: 4px;
            }

            .page-header p {
                color: var(--text-muted);
                font-size: 14px;
            }

            .header-actions {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .btn-header {
                display: inline-flex;
                align-items: center;
                gap: 7px;
                padding: 9px 14px;
                border-radius: 9px;
                border: 1px solid var(--border-soft);
                background: #fff;
                color: var(--text-main);
                font-size: 13px;
                font-weight: 700;
                text-decoration: none;
                transition: 0.2s;
            }

            .btn-header:hover {
                border-color: var(--primary);
                color: var(--primary-dark);
            }

            .btn-header.primary {
                background: var(--primary);
                color: #fff;
                border-color: var(--primary);
            }

            .btn-header.primary:hover {
                background: var(--primary-dark);
                border-color: var(--primary-dark);
                color: #fff;
            }

            .stats-row {
                display: grid;
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 16px;
                margin-bottom: 20px;
            }

            .stat-card {
                background: #fff;
                border-radius: 16px;
                padding: 20px 22px;
                box-shadow: var(--card-shadow);
                display: flex;
                align-items: center;
                gap: 14px;
            }

            .stat-icon {
                width: 44px;
                height: 44px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 19px;
                flex-shrink: 0;
            }

            .stat-icon.green {
                background: #d1fae5;
                color: #059669;
            }

            .stat-icon.blue {
                background: #dbeafe;
                color: #2563eb;
            }

            .stat-icon.orange {
                background: #fef3c7;
                color: #d97706;
            }

            .stat-value {
                font-size: 26px;
                font-weight: 800;
                color: var(--text-main);
                line-height: 1;
                margin-bottom: 4px;
            }

            .stat-label {
                font-size: 11px;
                letter-spacing: 0.5px;
                text-transform: uppercase;
                font-weight: 700;
                color: var(--text-muted);
            }

            .filter-card {
                background: #fff;
                border-radius: 16px;
                box-shadow: var(--card-shadow);
                padding: 16px 20px;
                margin-bottom: 20px;
            }

            .filter-form {
                display: grid;
                grid-template-columns: 1.6fr 0.8fr auto auto;
                gap: 10px;
                align-items: center;
            }

            .filter-input,
            .filter-select {
                width: 100%;
                border: 1px solid var(--border-soft);
                border-radius: 10px;
                padding: 10px 12px;
                font-size: 13px;
                color: var(--text-main);
                background: #fff;
            }

            .filter-input:focus,
            .filter-select:focus {
                outline: none;
                border-color: #34d399;
                box-shadow: 0 0 0 3px #d1fae5;
            }

            .btn-filter {
                border: 1px solid var(--primary);
                background: var(--primary);
                color: #fff;
                border-radius: 10px;
                padding: 10px 12px;
                font-size: 13px;
                font-weight: 700;
                cursor: pointer;
                min-width: 92px;
            }

            .btn-filter:hover {
                background: var(--primary-dark);
                border-color: var(--primary-dark);
            }

            .btn-reset {
                border: 1px solid var(--border-soft);
                background: #fff;
                color: var(--text-muted);
                border-radius: 10px;
                padding: 10px 12px;
                font-size: 13px;
                font-weight: 700;
                text-decoration: none;
                text-align: center;
                min-width: 92px;
            }

            .btn-reset:hover {
                border-color: #cbd5e1;
                color: var(--text-main);
            }

            .records-card {
                background: #fff;
                border-radius: 20px;
                box-shadow: var(--card-shadow);
                overflow: hidden;
            }

            .records-card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 10px;
                padding: 20px 24px;
                border-bottom: 1px solid #f1f5f9;
            }

            .records-title {
                font-size: 15px;
                font-weight: 800;
                color: var(--text-main);
            }

            .records-meta {
                font-size: 12px;
                font-weight: 700;
                color: #065f46;
                background: var(--primary-light);
                padding: 4px 10px;
                border-radius: 999px;
            }

            .table-wrap {
                overflow-x: auto;
            }

            .records-table {
                width: 100%;
                border-collapse: collapse;
                min-width: 860px;
            }

            .records-table thead th {
                padding: 13px 18px;
                text-align: left;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #94a3b8;
                background: #f8fafc;
                border-bottom: 1px solid #f1f5f9;
            }

            .records-table tbody tr {
                border-bottom: 1px solid #f8fafc;
                transition: background 0.15s;
            }

            .records-table tbody tr:hover {
                background: #f8fafc;
            }

            .records-table tbody td {
                padding: 15px 18px;
                font-size: 14px;
                color: var(--text-main);
                vertical-align: middle;
            }

            .record-id {
                font-weight: 800;
            }

            .sub-text {
                color: var(--text-muted);
                font-size: 12px;
                margin-top: 2px;
            }

            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                border-radius: 999px;
                padding: 5px 10px;
                font-size: 12px;
                font-weight: 700;
            }

            .status-in-progress {
                background: #fef3c7;
                color: #92400e;
            }

            .status-completed {
                background: #dcfce7;
                color: #166534;
            }

            .status-other {
                background: #dbeafe;
                color: #1e40af;
            }

            .btn-view {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 7px 12px;
                border-radius: 8px;
                border: 1px solid #bfdbfe;
                color: #1d4ed8;
                background: #eff6ff;
                font-size: 13px;
                font-weight: 700;
                text-decoration: none;
                transition: 0.2s;
            }

            .btn-view:hover {
                background: #dbeafe;
                border-color: #93c5fd;
            }

            .empty-state {
                text-align: center;
                padding: 48px 20px;
                color: #94a3b8;
            }

            .empty-state i {
                font-size: 34px;
                margin-bottom: 12px;
                display: block;
            }

            .empty-state p {
                font-size: 14px;
            }

            .pagination-bar {
                display: flex;
                gap: 6px;
                justify-content: flex-end;
                align-items: center;
                padding: 16px 22px;
                border-top: 1px solid #f1f5f9;
            }

            .page-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 34px;
                height: 34px;
                padding: 0 10px;
                border: 1px solid var(--border-soft);
                border-radius: 8px;
                background: #fff;
                color: #64748b;
                font-size: 13px;
                font-weight: 700;
                text-decoration: none;
                transition: 0.2s;
            }

            .page-btn:hover {
                border-color: var(--primary);
                color: var(--primary);
                background: #f0fdf4;
            }

            .page-btn.active {
                border-color: var(--primary);
                background: var(--primary);
                color: #fff;
            }

            .page-btn.disabled {
                opacity: 0.4;
                pointer-events: none;
            }

            @media (max-width: 1200px) {
                .stats-row {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 860px) {
                .filter-form {
                    grid-template-columns: 1fr;
                }

                .btn-filter,
                .btn-reset {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2><i class="fa-solid fa-file-medical" style="color:#10b981; margin-right:8px;"></i>Medical Records</h2>
                    <p>Quickly review and open EMRs you have created.</p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/veterinarian/emr/queue" class="btn-header primary">
                        <i class="fa-solid fa-file-circle-plus"></i> Create EMR
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-header">
                        <i class="fa-solid fa-right-from-bracket"></i> Sign Out
                    </a>
                </div>
            </div>

            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fa-solid fa-folder-open"></i></div>
                    <div>
                        <div class="stat-value">${totalRecords}</div>
                        <div class="stat-label">Total Records</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange"><i class="fa-solid fa-hourglass-half"></i></div>
                    <div>
                        <div class="stat-value">${inProgressRecords}</div>
                        <div class="stat-label">In-Progress</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="fa-solid fa-circle-check"></i></div>
                    <div>
                        <div class="stat-value">${completedRecords}</div>
                        <div class="stat-label">Completed</div>
                    </div>
                </div>
            </div>

            <div class="filter-card">
                <form method="get" action="${pageContext.request.contextPath}/veterinarian/emr/records" class="filter-form">
                    <input type="text"
                           class="filter-input"
                           name="keyword"
                           value="${fn:escapeXml(keyword)}"
                           placeholder="Search by Record ID, Appointment ID, Owner, Pet...">

                    <select class="filter-select" name="status">
                        <option value="All" <c:if test="${statusFilter == 'All'}">selected</c:if>>All Status</option>
                        <option value="In-Progress" <c:if test="${statusFilter == 'In-Progress'}">selected</c:if>>In-Progress</option>
                        <option value="Completed" <c:if test="${statusFilter == 'Completed'}">selected</c:if>>Completed</option>
                    </select>

                    <button type="submit" class="btn-filter">
                        <i class="fa-solid fa-magnifying-glass"></i> Filter
                    </button>

                    <a href="${pageContext.request.contextPath}/veterinarian/emr/records" class="btn-reset">
                        Reset
                    </a>
                </form>
            </div>

            <div class="records-card">
                <div class="records-card-header">
                    <div class="records-title">EMR List</div>
                    <div class="records-meta">${filteredCount} record(s)</div>
                </div>

                <c:if test="${empty records}">
                    <div class="empty-state">
                        <i class="fa-regular fa-folder-open"></i>
                        <p>No records match your current filter.</p>
                    </div>
                </c:if>

                <c:if test="${not empty records}">
                    <div class="table-wrap">
                        <table class="records-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Created At</th>
                                    <th>Appointment</th>
                                    <th>Owner &amp; Pet</th>
                                    <th>Status</th>
                                    <th style="text-align:center;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${records}" var="r" varStatus="st">
                                    <tr>
                                        <td>
                                            <div class="record-id">${(currentPage - 1) * 10 + st.index + 1}</div>
                                            <span style="display:none;">${r.recordId}</span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <span style="display:none;">${r.apptId}</span>
                                            <div>Appointment</div>
                                            <div class="sub-text">
                                                <fmt:formatDate value="${r.apptStartTime}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-weight:700;">${r.ownerName}</div>
                                            <div class="sub-text"><i class="fa-solid fa-paw" style="font-size:10px;"></i> ${r.petName}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.apptStatus == 'In-Progress'}">
                                                    <span class="status-badge status-in-progress">
                                                        <i class="fa-solid fa-hourglass-half"></i> In-Progress
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.apptStatus == 'Completed'}">
                                                    <span class="status-badge status-completed">
                                                        <i class="fa-solid fa-circle-check"></i> Completed
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-other">${r.apptStatus}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align:center;">
                                            <a class="btn-view"
                                               href="${pageContext.request.contextPath}/veterinarian/emr/detail?id=${r.recordId}">
                                                <i class="fa-solid fa-arrow-up-right-from-square"></i> Open
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${totalPages > 1}">
                    <div class="pagination-bar">
                        <c:url var="prevPageUrl" value="/veterinarian/emr/records">
                            <c:param name="page" value="${currentPage - 1}" />
                            <c:if test="${not empty keyword}">
                                <c:param name="keyword" value="${keyword}" />
                            </c:if>
                            <c:if test="${statusFilter != 'All'}">
                                <c:param name="status" value="${statusFilter}" />
                            </c:if>
                        </c:url>
                        <a class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" href="${prevPageUrl}">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:url var="pageUrl" value="/veterinarian/emr/records">
                                <c:param name="page" value="${i}" />
                                <c:if test="${not empty keyword}">
                                    <c:param name="keyword" value="${keyword}" />
                                </c:if>
                                <c:if test="${statusFilter != 'All'}">
                                    <c:param name="status" value="${statusFilter}" />
                                </c:if>
                            </c:url>
                            <a class="page-btn ${currentPage == i ? 'active' : ''}" href="${pageUrl}">${i}</a>
                        </c:forEach>

                        <c:url var="nextPageUrl" value="/veterinarian/emr/records">
                            <c:param name="page" value="${currentPage + 1}" />
                            <c:if test="${not empty keyword}">
                                <c:param name="keyword" value="${keyword}" />
                            </c:if>
                            <c:if test="${statusFilter != 'All'}">
                                <c:param name="status" value="${statusFilter}" />
                            </c:if>
                        </c:url>
                        <a class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" href="${nextPageUrl}">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </div>
                </c:if>
            </div>
        </main>
    </body>
</html>

