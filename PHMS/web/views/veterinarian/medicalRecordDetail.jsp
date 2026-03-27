<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Medical Record Detail</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
        <style>
            :root {
                --primary: #10b981;
                --primary-dark: #059669;
                --primary-light: #d1fae5;
                --blue-light: #dbeafe;
                --orange-light: #fef3c7;
                --bg: #f8fafc;
                --text-main: #1e293b;
                --text-muted: #64748b;
                --border-soft: #e2e8f0;
                --card-shadow: 0 4px 20px -2px rgba(0,0,0,0.06);
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
                margin-bottom: 24px;
                gap: 14px;
                flex-wrap: wrap;
            }

            .page-header h2 {
                font-size: 23px;
                color: var(--text-main);
                font-weight: 800;
                margin-bottom: 4px;
            }

            .page-header p {
                color: var(--text-muted);
                font-size: 14px;
            }

            .btn-signout {
                display: inline-flex;
                align-items: center;
                gap: 7px;
                padding: 9px 14px;
                border-radius: 9px;
                border: 1px solid var(--border-soft);
                background: #fff;
                color: var(--text-main);
                text-decoration: none;
                font-size: 13px;
                font-weight: 700;
                transition: 0.2s;
            }

            .btn-signout:hover {
                border-color: #fecaca;
                color: #dc2626;
            }

            .layout {
                display: grid;
                grid-template-columns: 1.3fr 1fr;
                gap: 20px;
            }

            .card {
                background: #fff;
                border-radius: 18px;
                box-shadow: var(--card-shadow);
                overflow: hidden;
            }

            .card-header {
                padding: 18px 22px;
                border-bottom: 1px solid #f1f5f9;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
            }

            .card-title {
                font-size: 15px;
                font-weight: 800;
                color: var(--text-main);
            }

            .card-body {
                padding: 18px 22px;
            }

            .info-grid {
                display: grid;
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 12px;
            }

            .info-item {
                background: #f8fafc;
                border: 1px solid #eef2f7;
                border-radius: 12px;
                padding: 12px 14px;
            }

            .info-label {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #94a3b8;
                margin-bottom: 4px;
            }

            .info-value {
                font-size: 14px;
                color: var(--text-main);
                font-weight: 600;
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
                background: var(--orange-light);
                color: #92400e;
            }

            .status-completed {
                background: #dcfce7;
                color: #166534;
            }

            .status-other {
                background: var(--blue-light);
                color: #1e40af;
            }

            .text-block {
                background: #f8fafc;
                border: 1px solid #eef2f7;
                border-radius: 12px;
                padding: 12px 14px;
                min-height: 74px;
                font-size: 14px;
                color: #334155;
                white-space: pre-wrap;
            }

            .label-top {
                font-size: 12px;
                font-weight: 700;
                color: #64748b;
                margin-bottom: 8px;
            }

            .table-wrap {
                overflow-x: auto;
            }

            .custom-table {
                width: 100%;
                border-collapse: collapse;
                min-width: 540px;
            }

            .custom-table thead th {
                padding: 12px 10px;
                background: #f8fafc;
                border-bottom: 1px solid #edf2f7;
                color: #94a3b8;
                font-size: 11px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                text-align: left;
            }

            .custom-table tbody td {
                padding: 12px 10px;
                border-bottom: 1px solid #f8fafc;
                color: #334155;
                font-size: 14px;
            }

            .custom-table tbody tr:last-child td {
                border-bottom: none;
            }

            .btn-view {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                border: 1px solid #bfdbfe;
                background: #eff6ff;
                color: #1d4ed8;
                border-radius: 8px;
                padding: 6px 10px;
                font-size: 12px;
                font-weight: 700;
                cursor: pointer;
            }

            .btn-view:hover {
                background: #dbeafe;
                border-color: #93c5fd;
            }

            .no-note {
                color: #94a3b8;
                font-style: italic;
                font-size: 13px;
            }

            .form-grid {
                display: grid;
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .form-label {
                font-size: 12px;
                font-weight: 700;
                color: #64748b;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .form-textarea {
                width: 100%;
                border: 1px solid var(--border-soft);
                border-radius: 10px;
                min-height: 130px;
                padding: 11px 12px;
                font-size: 14px;
                color: #1e293b;
                resize: vertical;
                font-family: inherit;
            }

            .form-textarea:focus {
                outline: none;
                border-color: #34d399;
                box-shadow: 0 0 0 3px #d1fae5;
            }

            .form-input,
            .form-select {
                width: 100%;
                border: 1px solid var(--border-soft);
                border-radius: 10px;
                padding: 10px 12px;
                font-size: 14px;
                color: #1e293b;
                background: #fff;
            }

            .form-input:focus,
            .form-select:focus {
                outline: none;
                border-color: #34d399;
                box-shadow: 0 0 0 3px #d1fae5;
            }

            .btn-row {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                margin-top: 12px;
            }

            .btn-action {
                display: inline-flex;
                align-items: center;
                gap: 7px;
                padding: 9px 13px;
                border-radius: 9px;
                font-size: 13px;
                font-weight: 700;
                text-decoration: none;
                border: none;
                cursor: pointer;
                transition: 0.2s;
            }

            .btn-save {
                background: var(--primary);
                color: #fff;
            }

            .btn-save:hover {
                background: var(--primary-dark);
            }

            .btn-order {
                background: #111827;
                color: #fff;
            }

            .btn-order:hover {
                background: #0b1220;
            }

            .btn-prescribe {
                background: #0f766e;
                color: #fff;
            }

            .btn-prescribe:hover {
                background: #115e59;
            }

            .btn-add-medicine {
                background: #22c55e;
                color: #fff;
            }

            .btn-add-medicine:hover {
                background: #16a34a;
            }

            .btn-complete {
                background: #2563eb;
                color: #fff;
            }

            .btn-complete:hover {
                background: #1d4ed8;
            }

            .btn-disabled {
                background: #e2e8f0;
                color: #64748b;
                cursor: not-allowed;
            }

            .btn-cancel-lab {
                background: #ef4444;
                color: #fff;
            }

            .btn-cancel-lab:hover {
                background: #dc2626;
            }

            .btn-back {
                background: #fff;
                color: #475569;
                border: 1px solid var(--border-soft);
            }

            .btn-back:hover {
                border-color: #cbd5e1;
                color: #1e293b;
            }

            .hint {
                margin-top: 8px;
                color: #b45309;
                background: #fffbeb;
                border: 1px solid #fef3c7;
                border-radius: 8px;
                font-size: 12px;
                padding: 9px 10px;
            }

            .section-subtitle {
                color: #64748b;
                font-size: 13px;
                margin-bottom: 12px;
            }

            .prescription-builder-title {
                font-size: 30px;
                font-weight: 800;
                color: #0f172a;
                margin-bottom: 12px;
            }

            .prescription-items {
                display: flex;
                flex-direction: column;
                gap: 14px;
            }

            .prescription-item {
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                background: #f8fafc;
                padding: 14px;
            }

            .prescription-item-head {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                gap: 12px;
            }

            .prescription-item-name {
                font-size: 15px;
                font-weight: 800;
                color: #334155;
            }

            .prescription-remove-btn {
                border: none;
                border-radius: 8px;
                background: #ef4444;
                color: #fff;
                font-size: 13px;
                font-weight: 700;
                padding: 7px 12px;
                cursor: pointer;
            }

            .prescription-remove-btn:hover {
                background: #dc2626;
            }

            .prescription-item-grid {
                display: grid;
                grid-template-columns: 1.4fr 0.7fr 1.4fr;
                gap: 10px;
                align-items: end;
            }

            .locked-note {
                margin-top: 8px;
                color: #64748b;
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 13px;
                padding: 10px 11px;
                font-style: italic;
            }

            .empty-state {
                text-align: center;
                color: #94a3b8;
                padding: 34px 10px;
                font-size: 14px;
            }

            .history-pagination {
                display: flex;
                gap: 6px;
                justify-content: flex-end;
                align-items: center;
                margin-top: 12px;
            }

            .history-page-btn {
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

            .history-page-btn:hover {
                border-color: var(--primary);
                color: var(--primary);
                background: #f0fdf4;
            }

            .history-page-btn.active {
                border-color: var(--primary);
                background: var(--primary);
                color: #fff;
            }

            .history-page-btn.disabled {
                opacity: 0.4;
                pointer-events: none;
            }

            .note-modal {
                display: none;
                position: fixed;
                z-index: 2000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(2, 6, 23, 0.4);
            }

            .note-modal-content {
                background: #fff;
                max-width: 760px;
                margin: 7% auto;
                border-radius: 14px;
                overflow: hidden;
                box-shadow: 0 20px 60px rgba(15, 23, 42, 0.3);
            }

            .note-modal-header {
                padding: 13px 16px;
                border-bottom: 1px solid #f1f5f9;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .note-modal-title {
                font-size: 14px;
                font-weight: 800;
                color: #1e293b;
            }

            .note-close {
                font-size: 22px;
                color: #64748b;
                cursor: pointer;
                line-height: 1;
            }

            .note-modal-body {
                padding: 16px;
                max-height: 440px;
                overflow-y: auto;
            }

            .note-content {
                white-space: pre-wrap;
                color: #334155;
                font-size: 14px;
                line-height: 1.5;
            }

            @media (max-width: 1200px) {
                .layout {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 860px) {
                .info-grid {
                    grid-template-columns: 1fr;
                }

                .prescription-item-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
                <div class="top-bar">
                    <div class="page-header">
                        <h2><i class="fa-solid fa-file-medical" style="color:#10b981; margin-right:8px;"></i>Medical Record Detail</h2>
                    <p>Medical record information</p>
                    </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">
                    <i class="fa-solid fa-right-from-bracket"></i> Sign Out
                </a>
            </div>

            <c:if test="${empty record}">
                <div class="card">
                    <div class="empty-state">Record not found.</div>
                </div>
            </c:if>

            <c:if test="${not empty record}">
                <div class="layout">
                    <div style="display:flex; flex-direction:column; gap:20px;">
                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Patient & Appointment Information</div>
                                <c:choose>
                                    <c:when test="${record.apptStatus == 'In-Progress'}">
                                        <span class="status-badge status-in-progress">
                                            <i class="fa-solid fa-hourglass-half"></i> In-Progress
                                        </span>
                                    </c:when>
                                    <c:when test="${record.apptStatus == 'Completed'}">
                                        <span class="status-badge status-completed">
                                            <i class="fa-solid fa-circle-check"></i> Completed
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-other">${record.apptStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-label">Pet Name</div>
                                        <div class="info-value">${record.petName}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Owner</div>
                                        <div class="info-value">${record.ownerName}</div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Owner Phone</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${not empty record.ownerPhone}">${record.ownerPhone}</c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Pet Weight</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${record.petWeight > 0}">
                                                    <fmt:formatNumber value="${record.petWeight}" minFractionDigits="1" maxFractionDigits="2"/> kg
                                                </c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Appointment</div>
                                        <div class="info-value">
                                            <span style="display:none;">${record.apptId}</span>
                                            Appointment
                                            <span style="color:#64748b; font-weight:500;">
                                                (<fmt:formatDate value="${record.apptStartTime}" pattern="dd/MM/yyyy HH:mm"/>)
                                            </span>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Create Time</div>
                                        <div class="info-value">
                                            <fmt:formatDate value="${record.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            <span style="color:#94a3b8;"> | Now: <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm"/></span>
                                        </div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Appointment Status</div>
                                        <div class="info-value">${record.apptStatus}</div>
                                    </div>
                                </div>

                                <div style="margin-top:12px;">
                                    <div class="label-top">Pet History Summary</div>
                                    <div class="text-block">
                                        <c:choose>
                                            <c:when test="${not empty record.petHistorySummary}">${record.petHistorySummary}</c:when>
                                            <c:otherwise>No history summary.</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Lab Test Notes (From Nurse)</div>
                            </div>
                            <div class="card-body">
                                <div class="table-wrap">
                                    <table class="custom-table">
                                        <thead>
                                            <tr>
                                                <th>STT</th>
                                                <th>Test Type</th>
                                                <th>Status</th>
                                                <th>Request Note</th>
                                                <th>Result Note</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty labTests}">
                                                <tr>
                                                    <td colspan="6" class="no-note">No lab request.</td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${labTests}" var="t" varStatus="st">
                                                <tr>
                                                    <td>${st.index + 1}<span style="display:none;">${t.testId}</span></td>
                                                    <td>${t.testType}</td>
                                                    <td>${t.status}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty t.requestNotes}">
                                                                <button type="button" class="btn-view" onclick="openNoteModal('lab-request-${t.testId}', 'Lab Request Note')">
                                                                    <i class="fa-regular fa-eye"></i> View
                                                                </button>
                                                                <textarea id="lab-request-${t.testId}" style="display:none;">${t.requestNotes}</textarea>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="no-note">No</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty labResultImageMap[t.testId] || not empty labResultTextMap[t.testId]}">
                                                                <div style="display:flex; gap:6px; flex-wrap:wrap;">
                                                                    <c:if test="${not empty labResultImageMap[t.testId]}">
                                                                        <button type="button" class="btn-view"
                                                                                onclick="openImageModal('${pageContext.request.contextPath}${labResultImageMap[t.testId]}', 'Lab Result Image')">
                                                                            <i class="fa-regular fa-image"></i> View Image
                                                                        </button>
                                                                    </c:if>
                                                                    <c:if test="${not empty labResultTextMap[t.testId]}">
                                                                        <button type="button" class="btn-view" onclick="openNoteModal('lab-note-${t.testId}', 'Lab Test Note')">
                                                                            <i class="fa-regular fa-eye"></i> View Note
                                                                        </button>
                                                                        <textarea id="lab-note-${t.testId}" style="display:none;">${labResultTextMap[t.testId]}</textarea>
                                                                    </c:if>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="no-note">No</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${record.apptStatus != 'Completed' && t.status != 'Completed' && t.status != 'Cancelled'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/veterinarian/lab/cancel" style="display:inline;">
                                                                <input type="hidden" name="id" value="${t.testId}">
                                                                <input type="hidden" name="recordId" value="${record.recordId}">
                                                                <input type="hidden" name="source" value="detail">
                                                                <button type="submit" class="btn-action btn-cancel-lab"
                                                                        onclick="return confirm('Cancel this lab request?');">
                                                                    <i class="fa-solid fa-xmark"></i> Cancel
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${record.apptStatus == 'Completed' || t.status == 'Completed' || t.status == 'Cancelled'}">
                                                            <span class="no-note">Locked</span>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Pet Medical History Notes</div>
                            </div>
                            <div class="card-body">
                                <div class="table-wrap">
                                    <table class="custom-table">
                                        <thead>
                                            <tr>
                                                <th>STT</th>
                                                <th>Date</th>
                                                <th>Vet</th>
                                                <th>Note</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty petHistory}">
                                                <tr>
                                                    <td colspan="4" class="no-note">No previous medical history.</td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${petHistory}" var="h" varStatus="st">
                                                <tr>
                                                    <td>${(historyCurrentPage - 1) * 3 + st.index + 1}<span style="display:none;">${h.recordId}</span></td>
                                                    <td><fmt:formatDate value="${h.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                    <td>${h.vetName}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty h.diagnosis || not empty h.treatmentPlan}">
                                                                <button type="button" class="btn-view" onclick="openNoteModal('history-note-${h.recordId}', 'History Note')">
                                                                    <i class="fa-regular fa-eye"></i> View
                                                                </button>
                                                                <textarea id="history-note-${h.recordId}" style="display:none;">Diagnosis: ${h.diagnosis}

Doctor Note: ${h.treatmentPlan}</textarea>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="no-note">No</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <c:if test="${historyTotalPages > 1}">
                                    <div class="history-pagination">
                                        <c:url var="historyPrevUrl" value="/veterinarian/emr/detail">
                                            <c:param name="id" value="${record.recordId}" />
                                            <c:param name="historyPage" value="${historyCurrentPage - 1}" />
                                        </c:url>
                                        <a class="history-page-btn ${historyCurrentPage <= 1 ? 'disabled' : ''}" href="${historyPrevUrl}">
                                            <i class="fa-solid fa-chevron-left"></i>
                                        </a>

                                        <c:forEach begin="1" end="${historyTotalPages}" var="i">
                                            <c:url var="historyPageUrl" value="/veterinarian/emr/detail">
                                                <c:param name="id" value="${record.recordId}" />
                                                <c:param name="historyPage" value="${i}" />
                                            </c:url>
                                            <a class="history-page-btn ${historyCurrentPage == i ? 'active' : ''}" href="${historyPageUrl}">${i}</a>
                                        </c:forEach>

                                        <c:url var="historyNextUrl" value="/veterinarian/emr/detail">
                                            <c:param name="id" value="${record.recordId}" />
                                            <c:param name="historyPage" value="${historyCurrentPage + 1}" />
                                        </c:url>
                                        <a class="history-page-btn ${historyCurrentPage >= historyTotalPages ? 'disabled' : ''}" href="${historyNextUrl}">
                                            <i class="fa-solid fa-chevron-right"></i>
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div style="display:flex; flex-direction:column; gap:20px;">
                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Doctor Note (Editable)</div>
                            </div>
                            <div class="card-body">
                                <div class="form-grid">
                                    <c:if test="${record.apptStatus != 'Completed'}">
                                        <form method="post" action="${pageContext.request.contextPath}/veterinarian/emr/update">
                                            <input type="hidden" name="recordId" value="${record.recordId}">
                                            <input type="hidden" name="source" value="detail">

                                            <label class="form-label">Diagnosis</label>
                                            <textarea name="diagnosis" class="form-textarea" maxlength="4000" required>${record.diagnosis}</textarea>

                                            <label class="form-label" style="margin-top:8px;">Doctor Note</label>
                                            <textarea name="treatmentPlan" class="form-textarea" maxlength="4000" required>${record.treatmentPlan}</textarea>

                                            <div class="btn-row">
                                                <button type="submit" class="btn-action btn-save">
                                                    <i class="fa-solid fa-floppy-disk"></i> Save
                                                </button>
                                                <c:choose>
                                                    <c:when test="${hasPendingLabTests}">
                                                        <button type="button" class="btn-action btn-disabled" title="Waiting for lab result">
                                                            <i class="fa-solid fa-hourglass-half"></i> Complete Examination
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="submit" formaction="${pageContext.request.contextPath}/veterinarian/appointment/complete"
                                                                formmethod="post"
                                                                class="btn-action btn-complete"
                                                                onclick="return confirm('Mark this appointment as Completed?');">
                                                            <i class="fa-solid fa-circle-check"></i> Complete Examination
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                                <a class="btn-action btn-back"
                                                   href="${pageContext.request.contextPath}/veterinarian/emr/records">
                                                    <i class="fa-solid fa-arrow-left"></i> Back
                                                </a>
                                            </div>
                                        </form>
                                    </c:if>

                                    <c:if test="${record.apptStatus == 'Completed'}">
                                        <div class="label-top">Diagnosis</div>
                                        <div class="text-block">${record.diagnosis}</div>

                                        <div class="label-top" style="margin-top:10px;">Doctor Note</div>
                                        <div class="text-block">${record.treatmentPlan}</div>

                                        <div class="locked-note">
                                            Appointment completed. Record editing is locked.
                                        </div>

                                        <div class="btn-row">
                                            <a class="btn-action btn-back"
                                               href="${pageContext.request.contextPath}/veterinarian/emr/records">
                                                <i class="fa-solid fa-arrow-left"></i> Back
                                            </a>
                                        </div>
                                    </c:if>
                                </div>

                                <c:if test="${record.apptStatus != 'Completed' && hasPendingLabTests}">
                                    <div class="hint">
                                        Lab test has been requested and is still <b>Requested/In Progress</b>. You can continue Save/Prescribe, but cannot Complete until lab returns result or request is cancelled.
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Order Lab Test (At Detail Page)</div>
                            </div>
                            <div class="card-body">
                                <p class="section-subtitle">Create lab request directly here. No need to switch to another page.</p>
                                <c:if test="${record.apptStatus != 'Completed'}">
                                    <form method="post" action="${pageContext.request.contextPath}/veterinarian/lab/request">
                                        <input type="hidden" name="recordId" value="${record.recordId}">
                                        <input type="hidden" name="source" value="detail">

                                        <label class="form-label">Test Type</label>
                                        <c:choose>
                                            <c:when test="${not empty labTestTypes}">
                                                <select class="form-select" name="testType" required>
                                                    <option value="">-- Select test type --</option>
                                                    <c:forEach items="${labTestTypes}" var="tt">
                                                        <option value="${tt}">${tt}</option>
                                                    </c:forEach>
                                                </select>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="text" class="form-input" name="testType" maxlength="100"
                                                       placeholder="Blood test, X-ray, Ultrasound..." required>
                                            </c:otherwise>
                                        </c:choose>

                                        <label class="form-label" style="margin-top:10px;">Request Note</label>
                                        <textarea class="form-textarea" name="requestNotes" maxlength="4000"
                                                  placeholder="Additional note for nurse/lab..."></textarea>

                                        <div class="btn-row">
                                            <button type="submit" class="btn-action btn-order">
                                                <i class="fa-solid fa-flask"></i> Order Lab Test
                                            </button>
                                        </div>
                                    </form>
                                </c:if>
                                <c:if test="${record.apptStatus == 'Completed'}">
                                    <div class="locked-note">Appointment completed. Lab request is locked.</div>
                                </c:if>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Prescribe Medicine (At Detail Page)</div>
                            </div>
                            <div class="card-body">
                                <c:if test="${record.apptStatus != 'Completed'}">
                                    <form id="prescriptionForm" method="post" action="${pageContext.request.contextPath}/veterinarian/prescription/create">
                                        <input type="hidden" name="recordId" value="${record.recordId}">
                                        <input type="hidden" name="source" value="detail">

                                        <div class="prescription-builder-title">Add Prescription Items</div>
                                        <div id="prescriptionItemsContainer" class="prescription-items">
                                            <div class="prescription-item">
                                                <div class="prescription-item-head">
                                                    <div class="prescription-item-name">Medicine #1</div>
                                                    <button type="button" class="prescription-remove-btn" style="display:none;" onclick="removePrescriptionItem(this)">
                                                        Remove
                                                    </button>
                                                </div>
                                                <div class="prescription-item-grid">
                                                    <div>
                                                        <label class="form-label">Medicine</label>
                                                        <select class="form-select" name="medicineId" required>
                                                            <option value="">-- Select medicine --</option>
                                                            <c:forEach items="${medicines}" var="m">
                                                                <option value="${m.medicineId}">
                                                                    ${m.name} (${m.unit}) - Stock: ${m.stockQuantity}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div>
                                                        <label class="form-label">Quantity</label>
                                                        <input type="number" class="form-input" name="quantity" min="1" max="1000" placeholder="Qty" required>
                                                    </div>
                                                    <div>
                                                        <label class="form-label">Dosage</label>
                                                        <input type="text" class="form-input" name="dosage" maxlength="100" placeholder="e.g. 1 tablet, 2 times/day" required>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <template id="prescriptionItemTemplate">
                                            <div class="prescription-item">
                                                <div class="prescription-item-head">
                                                    <div class="prescription-item-name">Medicine #1</div>
                                                    <button type="button" class="prescription-remove-btn" onclick="removePrescriptionItem(this)">
                                                        Remove
                                                    </button>
                                                </div>
                                                <div class="prescription-item-grid">
                                                    <div>
                                                        <label class="form-label">Medicine</label>
                                                        <select class="form-select" name="medicineId" required>
                                                            <option value="">-- Select medicine --</option>
                                                            <c:forEach items="${medicines}" var="m">
                                                                <option value="${m.medicineId}">
                                                                    ${m.name} (${m.unit}) - Stock: ${m.stockQuantity}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div>
                                                        <label class="form-label">Quantity</label>
                                                        <input type="number" class="form-input" name="quantity" min="1" max="1000" placeholder="Qty" required>
                                                    </div>
                                                    <div>
                                                        <label class="form-label">Dosage</label>
                                                        <input type="text" class="form-input" name="dosage" maxlength="100" placeholder="e.g. 1 tablet, 2 times/day" required>
                                                    </div>
                                                </div>
                                            </div>
                                        </template>

                                        <div class="btn-row">
                                            <button type="button" class="btn-action btn-add-medicine" onclick="addPrescriptionItem()">
                                                <i class="fa-solid fa-plus"></i> Add Another Medicine
                                            </button>
                                        </div>

                                        <div class="btn-row" style="margin-top:10px;">
                                            <button type="submit" class="btn-action btn-prescribe">
                                                <i class="fa-solid fa-floppy-disk"></i> Save Prescription
                                            </button>
                                        </div>
                                    </form>
                                </c:if>
                                <c:if test="${record.apptStatus == 'Completed'}">
                                    <div class="locked-note">Appointment completed. Prescription editing is locked.</div>
                                </c:if>

                                <div style="margin-top:14px;">
                                    <div class="label-top">Current Prescriptions</div>
                                    <div class="table-wrap">
                                        <table class="custom-table">
                                            <thead>
                                                <tr>
                                                    <th>Medicine</th>
                                                    <th>Quantity</th>
                                                    <th>Dosage</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${empty prescriptions}">
                                                    <tr>
                                                        <td colspan="4" class="no-note">No prescription yet.</td>
                                                    </tr>
                                                </c:if>
                                                <c:forEach items="${prescriptions}" var="p">
                                                    <tr>
                                                        <td>${p.medicineName}</td>
                                                        <td>${p.quantity} ${p.medicineUnit}</td>
                                                        <td>${p.dosage}</td>
                                                        <td>
                                                            <c:if test="${record.apptStatus != 'Completed'}">
                                                                <form method="post" action="${pageContext.request.contextPath}/veterinarian/prescription/delete" style="display:inline;">
                                                                    <input type="hidden" name="presId" value="${p.presId}">
                                                                    <input type="hidden" name="recordId" value="${record.recordId}">
                                                                    <input type="hidden" name="source" value="detail">
                                                                    <button type="submit" class="btn-action btn-cancel-lab"
                                                                            onclick="return confirm('Delete this prescription item?');">
                                                                        <i class="fa-solid fa-trash"></i> Delete
                                                                    </button>
                                                                </form>
                                                            </c:if>
                                                            <c:if test="${record.apptStatus == 'Completed'}">
                                                                <span class="no-note">Locked</span>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </c:if>
        </main>

        <div id="noteModal" class="note-modal">
            <div class="note-modal-content">
                <div class="note-modal-header">
                    <div id="noteModalTitle" class="note-modal-title">Note</div>
                    <span class="note-close" onclick="closeNoteModal()">&times;</span>
                </div>
                <div class="note-modal-body">
                    <div id="noteContent" class="note-content"></div>
                </div>
            </div>
        </div>

        <div id="imageModal" class="note-modal" style="z-index:2100; background:rgba(2, 6, 23, 0.65);">
            <div class="note-modal-content" style="max-width:960px; margin:4% auto;">
                <div class="note-modal-header">
                    <div id="imageModalTitle" class="note-modal-title">Image</div>
                    <span class="note-close" onclick="closeImageModal()">&times;</span>
                </div>
                <div class="note-modal-body" style="text-align:center; background:#f8fafc;">
                    <img id="imageModalContent" alt="Lab result image"
                         style="max-width:100%; max-height:75vh; border:1px solid #d1d5db; border-radius:10px;">
                </div>
            </div>
        </div>

        <script>
            function openNoteModal(sourceId, title) {
                var source = document.getElementById(sourceId);
                var content = document.getElementById('noteContent');
                var modal = document.getElementById('noteModal');
                var modalTitle = document.getElementById('noteModalTitle');
                content.textContent = source ? source.value : '';
                modalTitle.textContent = title || 'Note';
                modal.style.display = 'block';
            }

            function closeNoteModal() {
                document.getElementById('noteModal').style.display = 'none';
            }

            function openImageModal(imageUrl, title) {
                var modal = document.getElementById('imageModal');
                var image = document.getElementById('imageModalContent');
                var modalTitle = document.getElementById('imageModalTitle');
                image.src = imageUrl || '';
                modalTitle.textContent = title || 'Image';
                modal.style.display = 'block';
            }

            function closeImageModal() {
                var modal = document.getElementById('imageModal');
                var image = document.getElementById('imageModalContent');
                modal.style.display = 'none';
                image.removeAttribute('src');
            }

            function updatePrescriptionItemLabels() {
                var items = document.querySelectorAll('#prescriptionItemsContainer .prescription-item');
                items.forEach(function (item, index) {
                    var title = item.querySelector('.prescription-item-name');
                    if (title) {
                        title.textContent = 'Medicine #' + (index + 1);
                    }
                    var removeBtn = item.querySelector('.prescription-remove-btn');
                    if (removeBtn) {
                        removeBtn.style.display = index === 0 ? 'none' : 'inline-flex';
                    }
                });
            }

            function addPrescriptionItem() {
                var template = document.getElementById('prescriptionItemTemplate');
                var container = document.getElementById('prescriptionItemsContainer');
                if (!template || !container) {
                    return;
                }
                var node = template.content.cloneNode(true);
                container.appendChild(node);
                updatePrescriptionItemLabels();
            }

            function removePrescriptionItem(button) {
                var container = document.getElementById('prescriptionItemsContainer');
                if (!container) {
                    return;
                }
                var item = button ? button.closest('.prescription-item') : null;
                if (!item) {
                    return;
                }
                if (container.querySelectorAll('.prescription-item').length <= 1) {
                    return;
                }
                item.remove();
                updatePrescriptionItemLabels();
            }

            document.addEventListener('DOMContentLoaded', function () {
                updatePrescriptionItemLabels();
            });

            window.onclick = function (event) {
                var noteModal = document.getElementById('noteModal');
                var imageModal = document.getElementById('imageModal');
                if (event.target === noteModal) {
                    closeNoteModal();
                }
                if (event.target === imageModal) {
                    closeImageModal();
                }
            };
        </script>
    <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>


