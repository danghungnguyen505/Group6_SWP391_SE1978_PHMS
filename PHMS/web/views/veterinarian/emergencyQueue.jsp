<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hàng đợi cấp cứu - Bác sĩ</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />
        <main class="main-content">
            <div class="mgmt-page">
                <div class="mgmt-container">
                    <header class="mgmt-header">
                        <div>
                            <h1 class="mgmt-title">My emergency queue</h1>
                            <p class="mgmt-subtitle">Emergency cases have been triaged and assigned to you.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout"
                           class="btn"
                           style="padding:8px 14px; border:1px solid #d1d5db; border-radius:8px; text-decoration:none; color:#334155; background:#fff; font-size:13px; font-weight:600;">
                            <i class="fa-solid fa-right-from-bracket"></i> Sign Out
                        </a>
                    </header>

                    <!-- Search -->
                    <form method="get" action="${pageContext.request.contextPath}/veterinarian/emergency/queue" style="display:flex; gap:8px; margin-bottom:16px;">
                        <input type="text" name="search" placeholder="Search by pet, owner..."
                               value="${search}" style="flex:1; padding:8px 12px; border:1px solid #d1d5db; border-radius:6px;">
                        <input type="hidden" name="size" value="${pageSize}">
                        <select name="filter" onchange="this.form.submit()" style="padding:8px 12px; border:1px solid #d1d5db; border-radius:6px; min-width:140px;">
                            <option value="all" ${filter == 'all' ? 'selected' : ''}>All status</option>
                            <option value="Pending" ${filter == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Confirmed" ${filter == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="In-Progress" ${filter == 'In-Progress' ? 'selected' : ''}>In Progress</option>
                            <option value="Completed" ${filter == 'Completed' ? 'selected' : ''}>Completed</option>
                        </select>
                        <select name="level" onchange="this.form.submit()" style="padding:8px 12px; border:1px solid #d1d5db; border-radius:6px; min-width:140px;">
                            <option value="all" ${level == 'all' ? 'selected' : ''}>All levels</option>
                            <option value="Critical" ${level == 'Critical' ? 'selected' : ''}>Critical</option>
                            <option value="High" ${level == 'High' ? 'selected' : ''}>High</option>
                            <option value="Medium" ${level == 'Medium' ? 'selected' : ''}>Medium</option>
                            <option value="Low" ${level == 'Low' ? 'selected' : ''}>Low</option>
                        </select>
                        <button type="submit" class="btn btn-approve">
                            <i class="fa-solid fa-search"></i> Search
                        </button>
                        <c:if test="${not empty search}">
                            <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                               href="${pageContext.request.contextPath}/veterinarian/emergency/queue?filter=${filter}&level=${level}&size=${pageSize}">
                                <i class="fa-solid fa-times"></i> Clear
                            </a>
                        </c:if>
                    </form>

                    <c:if test="${empty appointments}">
                        <p>There are currently no emergency cases in the waiting list.</p>
                    </c:if>

                    <c:if test="${not empty appointments}">
                        <div class="data-table-container">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th style="display:none;">ID</th>
                                        <th>STT</th>
                                        <th>Pet</th>
                                        <th>Pet Owner</th>
                                        <th>Time</th>
                                        <th>Level</th>
                                        <th>Status</th>
                                        <th style="text-align:center;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="a" items="${appointments}" varStatus="loop">
                                        <c:set var="triage" value="${triageMap[a.apptId]}" />
                                        <tr>
                                            <td style="display:none;">${a.apptId}</td>
                                            <td>${(currentPage - 1) * pageSize + loop.index + 1}</td>
                                            <td>${a.petName}</td>
                                            <td>${a.ownerName}</td>
                                            <td>${a.startTime}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${triage != null && triage.conditionLevel eq 'Critical'}">
                                                        <span style="background:#fef2f2;color:#dc2626;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Critical</span>
                                                    </c:when>
                                                    <c:when test="${triage != null && triage.conditionLevel eq 'High'}">
                                                        <span style="background:#fff7ed;color:#ea580c;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">High</span>
                                                    </c:when>
                                                    <c:when test="${triage != null && triage.conditionLevel eq 'Medium'}">
                                                        <span style="background:#fefce8;color:#ca8a04;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Medium</span>
                                                    </c:when>
                                                    <c:when test="${triage != null && triage.conditionLevel eq 'Low'}">
                                                        <span style="background:#f0fdf4;color:#16a34a;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Low</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background:#f1f5f9;color:#64748b;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${a.status eq 'In-Progress'}">
                                                        <span style="background:#e0f2fe;color:#0284c7;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">In Progress</span>
                                                    </c:when>
                                                    <c:when test="${a.status eq 'Completed'}">
                                                        <span style="background:#dcfce7;color:#16a34a;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Completed</span>
                                                    </c:when>
                                                    <c:when test="${a.status eq 'Confirmed'}">
                                                        <span style="background:#dbeafe;color:#2563eb;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Confirmed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="background:#f1f5f9;color:#64748b;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">${a.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align:center;">
                                                <c:choose>
                                                    <c:when test="${a.status eq 'In-Progress'}">
                                                        <div style="display:flex; gap:6px; justify-content:center; flex-wrap:wrap;">
                                                            <c:choose>
                                                                <c:when test="${not empty recordIdMap[a.apptId]}">
                                                                    <a href="${pageContext.request.contextPath}/veterinarian/emr/detail?id=${recordIdMap[a.apptId]}"
                                                                       class="btn"
                                                                       style="padding:6px 12px; font-size:12px; background:#10b981; color:#fff; border:none; border-radius:6px; text-decoration:none;">
                                                                        Open EMR
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="${pageContext.request.contextPath}/veterinarian/emr/submit?apptId=${a.apptId}"
                                                                       class="btn"
                                                                       style="padding:6px 12px; font-size:12px; background:#10b981; color:#fff; border:none; border-radius:6px; text-decoration:none;">
                                                                        Create EMR
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <a href="${pageContext.request.contextPath}/veterinarian/emergency/complete?apptId=${a.apptId}"
                                                               class="btn"
                                                               style="padding:6px 12px; font-size:12px; background:#2563eb; color:#fff; border:none; border-radius:6px; text-decoration:none;">
                                                                Complete
                                                            </a>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${a.status eq 'Completed'}">
                                                        <span style="color:#94a3b8;font-size:12px;">-</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form method="post"
                                                              action="${pageContext.request.contextPath}/veterinarian/emergency/agree"
                                                              style="margin:0;display:inline;">
                                                            <input type="hidden" name="apptId" value="${a.apptId}" />
                                                            <button type="submit" class="btn btn-approve"
                                                                    style="padding:6px 12px; font-size:12px;">
                                                                Accept
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <c:if test="${totalPages > 1}">
                        <c:set var="filterParam" value="&filter=${filter}" />
                        <c:set var="levelParam" value="&level=${level}" />
                        <c:set var="sizeParam" value="&size=${pageSize}" />
                        <c:set var="searchParam" value="${not empty search ? '&search='.concat(search) : ''}" />
                        <div style="display:flex; gap:6px; justify-content:space-between; margin-top:12px; align-items:center; flex-wrap:wrap;">
                            <form method="get" action="${pageContext.request.contextPath}/veterinarian/emergency/queue" style="display:flex; align-items:center; gap:8px;">
                                <input type="hidden" name="filter" value="${filter}">
                                <input type="hidden" name="level" value="${level}">
                                <input type="hidden" name="search" value="${search}">
                                <span style="font-size:12px; color:#64748b; font-weight:700;">Hiển thị</span>
                                <select name="size" onchange="this.form.submit()" style="padding:6px 10px; border:1px solid #d1d5db; border-radius:8px; font-size:12px;">
                                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                    <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                                </select>
                            </form>
                            <div style="display:flex; gap:6px; justify-content:flex-end;">
                            <c:if test="${currentPage > 1}">
                                <a class="btn btn-approve" style="text-decoration:none;" href="?page=${currentPage - 1}${sizeParam}${filterParam}${levelParam}${searchParam}">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a class="btn ${currentPage == i ? 'btn-approve' : 'btn-secondary'}"
                                   style="text-decoration:none;"
                                   href="?page=${i}${sizeParam}${filterParam}${levelParam}${searchParam}">${i}</a>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a class="btn btn-approve" style="text-decoration:none;" href="?page=${currentPage + 1}${sizeParam}${filterParam}${levelParam}${searchParam}">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
        <script>
            window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
            window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
    </body>
</html>

