<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Lab Queue</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/nurse/lab/queue" class="active">
                        <i class="fa-solid fa-flask"></i> Lab Queue</a></li>
            </ul>
            <div class="help-box">
                <div class="help-text">Need help?</div>
                <a href="#" class="btn-contact">Contact Support</a>
            </div>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Lab Test Queue</h2>
                    <p>Process requested tests and enter results.</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <!-- Toast Message -->
            <c:if test="${not empty sessionScope.toastMessage}">
                <c:set var="toast" value="${sessionScope.toastMessage}" />
                <c:choose>
                    <c:when test="${fn:startsWith(toast, 'success|')}">
                        <div style="background:#ecfdf5;border:1px solid #a7f3d0;color:#065f46;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-weight:600;">
                            <i class="fa-solid fa-check-circle" style="margin-right:8px;"></i>
                            ${fn:substringAfter(toast, 'success|')}
                        </div>
                    </c:when>
                    <c:when test="${fn:startsWith(toast, 'error|')}">
                        <div style="background:#fef2f2;border:1px solid #fecaca;color:#991b1b;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-weight:600;">
                            <i class="fa-solid fa-triangle-exclamation" style="margin-right:8px;"></i>
                            ${fn:substringAfter(toast, 'error|')}
                        </div>
                    </c:when>
                </c:choose>
                <c:remove var="toastMessage" scope="session" />
            </c:if>

            <div class="card">
                <div class="section-title">
                    <span>Lab Tests</span>
                </div>

                <!-- Search -->
                <form method="get" action="${pageContext.request.contextPath}/nurse/lab/queue" style="display:flex; gap:8px; margin-bottom:16px;">
                    <input type="text" name="search" placeholder="Search by pet, owner, vet, test type..."
                           value="${search}" style="flex:1; padding:8px 12px; border:1px solid #d1d5db; border-radius:6px;">
                    <input type="hidden" name="filter" value="${filter}">
                    <button type="submit" class="btn btn-approve" style="text-decoration:none;">
                        <i class="fa-solid fa-search"></i> Search
                    </button>
                    <c:if test="${not empty search}">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/nurse/lab/queue?filter=${filter}">
                            <i class="fa-solid fa-times"></i> Clear
                        </a>
                    </c:if>
                </form>

                <!-- Filter Tabs -->
                <div style="display:flex; gap:8px; margin-bottom:16px;">
                    <a class="btn ${filter == 'requested' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'requested' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/nurse/lab/queue?filter=requested">
                        <i class="fa-solid fa-clock"></i> Requested
                    </a>
                    <a class="btn ${filter == 'inprogress' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'inprogress' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/nurse/lab/queue?filter=inprogress">
                        <i class="fa-solid fa-spinner"></i> In Progress
                    </a>
                    <a class="btn ${filter == 'completed' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'completed' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/nurse/lab/queue?filter=completed">
                        <i class="fa-solid fa-check-circle"></i> Completed
                    </a>
                    <a class="btn ${filter == 'all' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'all' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/nurse/lab/queue?filter=all">
                        <i class="fa-solid fa-list"></i> All
                    </a>
                </div>

                <c:if test="${empty tests}">
                    <div class="empty-state"><p>No lab tests found.</p></div>
                </c:if>

                <c:if test="${not empty tests}">
                    <table>
                        <thead>
                            <tr>
                                <th style="display:none;">ID</th>
                                <th>STT</th>
                                <th>Type</th>
                                <th>Pet</th>
                                <th>Owner</th>
                                <th>Vet</th>
                                <th>Status</th>
                                <th style="text-align:center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${tests}" var="t" varStatus="status">
                                <tr>
                                    <td style="display:none;">${t.testId}</td>
                                    <td>${(currentPage - 1) * 10 + status.index + 1}</td>
                                    <td class="col-service">${t.testType}</td>
                                    <td class="col-pet">${t.petName}</td>
                                    <td>${t.ownerName}</td>
                                    <td>${t.vetName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'Requested'}">
                                                <span style="color:#f59e0b; font-weight:600;">Requested</span>
                                            </c:when>
                                            <c:when test="${t.status == 'In Progress'}">
                                                <span style="color:#3b82f6; font-weight:600;">In Progress</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Completed'}">
                                                <span style="color:#10b981; font-weight:600;">Completed</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Cancelled'}">
                                                <span style="color:#94a3b8; font-weight:600;">Cancelled</span>
                                            </c:when>
                                            <c:otherwise>${t.status}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <c:choose>
                                            <c:when test="${t.status == 'Completed' || t.status == 'Cancelled'}">
                                                <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                                                   href="${pageContext.request.contextPath}/nurse/lab/update?id=${t.testId}">
                                                    View
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="btn btn-approve" style="text-decoration:none;"
                                                   href="${pageContext.request.contextPath}/nurse/lab/update?id=${t.testId}">
                                                    Update
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <c:if test="${totalPages > 1}">
                    <c:set var="filterParam" value="&filter=${filter}" />
                    <c:set var="searchParam" value="${not empty search ? '&search='.concat(search) : ''}" />
                    <div style="display:flex; gap:6px; justify-content:flex-end; margin-top:12px;">
                        <c:if test="${currentPage > 1}">
                            <a class="btn btn-approve" style="text-decoration:none;" href="?page=${currentPage - 1}${filterParam}${searchParam}">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a class="btn ${currentPage == i ? 'btn-approve' : 'btn-reject'}"
                               style="text-decoration:none; ${currentPage == i ? '' : 'background:#e5e7eb;color:#111827;'}"
                               href="?page=${i}${filterParam}${searchParam}">${i}</a>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a class="btn btn-approve" style="text-decoration:none;" href="?page=${currentPage + 1}${filterParam}${searchParam}">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </main>
    </body>
</html>

