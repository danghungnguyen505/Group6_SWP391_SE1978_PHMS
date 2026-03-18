<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Lab Requests</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
    </head>
    <body>
      <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Lab Requests</h2>
                    <p>Track requested tests and results.</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Requests</span>
                </div>

                <!-- Search -->
                <form method="get" action="${pageContext.request.contextPath}/veterinarian/lab/requests" style="display:flex; gap:8px; margin-bottom:16px;">
                    <input type="text" name="search" placeholder="Search by pet, test type..."
                           value="${search}" style="flex:1; padding:8px 12px; border:1px solid #d1d5db; border-radius:6px;">
                    <input type="hidden" name="filter" value="${filter}">
                    <button type="submit" class="btn btn-approve" style="text-decoration:none;">
                        <i class="fa-solid fa-search"></i> Search
                    </button>
                    <c:if test="${not empty search}">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=${filter}">
                            <i class="fa-solid fa-times"></i> Clear
                        </a>
                    </c:if>
                </form>

                <!-- Filter Tabs -->
                <div style="display:flex; gap:8px; margin-bottom:16px;">
                    <a class="btn ${filter == 'all' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'all' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=all">
                        <i class="fa-solid fa-list"></i> All
                    </a>
                    <a class="btn ${filter == 'requested' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'requested' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=requested">
                        <i class="fa-solid fa-clock"></i> Requested
                    </a>
                    <a class="btn ${filter == 'inprogress' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'inprogress' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=inprogress">
                        <i class="fa-solid fa-spinner"></i> In Progress
                    </a>
                    <a class="btn ${filter == 'completed' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'completed' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=completed">
                        <i class="fa-solid fa-check-circle"></i> Completed
                    </a>
                    <a class="btn ${filter == 'cancelled' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'cancelled' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=cancelled">
                        <i class="fa-solid fa-times-circle"></i> Cancelled
                    </a>
                </div>

                <c:if test="${empty tests}">
                    <div class="empty-state"><p>No lab requests.</p></div>
                </c:if>

                <c:if test="${not empty tests}">
                    <table>
                        <thead>
                            <tr>
                                <th style="display:none;">ID</th>
                                <th>STT</th>
                                <th>Record</th>
                                <th>Pet</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th>Result</th>
                                <th style="text-align:center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${tests}" var="t" varStatus="status">
                                <tr>
                                    <td style="display:none;">${t.testId}</td>
                                    <td>${(currentPage - 1) * 10 + status.index + 1}</td>
                                    <td>#${t.recordId}</td>
                                    <td class="col-pet">${t.petName}</td>
                                    <td class="col-service">${t.testType}</td>
                                    <td>${t.status}</td>
                                    <td>
                                        <c:if test="${empty t.requestNotes}">
                                            <span style="color:#999; font-style:italic;">Pending</span>
                                        </c:if>
                                        <c:if test="${not empty t.requestNotes}">
                                            ${t.requestNotes}
                                        </c:if>
                                    </td>
                                    <td style="text-align:center;">
                                        <c:if test="${t.status != 'Completed' && t.status != 'Cancelled'}">
                                            <form method="post" action="${pageContext.request.contextPath}/veterinarian/lab/cancel" style="display:inline;">
                                                <input type="hidden" name="id" value="${t.testId}">
                                                <button class="btn btn-reject" type="submit"
                                                        onclick="return confirm('Cancel this request?');"
                                                        style="background:#ef4444; color:white;">
                                                    Cancel
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${t.status == 'Cancelled'}">
                                            <span style="color:#94a3b8; font-style:italic;">Cancelled</span>
                                        </c:if>
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

