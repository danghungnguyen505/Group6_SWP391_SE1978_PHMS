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
                    </header>

                    <!-- Search -->
                    <form method="get" action="${pageContext.request.contextPath}/veterinarian/emergency/queue" style="display:flex; gap:8px; margin-bottom:16px;">
                        <input type="text" name="search" placeholder="Search by pet, owner..."
                               value="${search}" style="flex:1; padding:8px 12px; border:1px solid #d1d5db; border-radius:6px;">
                        <input type="hidden" name="filter" value="${filter}">
                        <button type="submit" class="btn btn-approve">
                            <i class="fa-solid fa-search"></i> Search
                        </button>
                        <c:if test="${not empty search}">
                            <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                               href="${pageContext.request.contextPath}/veterinarian/emergency/queue?filter=${filter}">
                                <i class="fa-solid fa-times"></i> Clear
                            </a>
                        </c:if>
                    </form>

                    <!-- Filter Tabs -->
                    <div style="display:flex; gap:8px; margin-bottom:16px; flex-wrap:wrap;">
                        <a style="padding:8px 16px; border-radius:20px; font-weight:500; text-decoration:none; font-size:13px;
                           ${filter == 'all' ? 'background:#16a34a;color:#fff;' : 'background:#f1f5f9;color:#475569;border:1px solid #e2e8f0;'}"
                           href="${pageContext.request.contextPath}/veterinarian/emergency/queue?filter=all">
                            All
                        </a>
                        <a style="padding:8px 16px; border-radius:20px; font-weight:500; text-decoration:none; font-size:13px;
                           ${filter == 'Pending' ? 'background:#16a34a;color:#fff;' : 'background:#f1f5f9;color:#475569;border:1px solid #e2e8f0;'}"
                           href="${pageContext.request.contextPath}/veterinarian/emergency/queue?filter=Pending">
                            Pending
                        </a>
                        <a style="padding:8px 16px; border-radius:20px; font-weight:500; text-decoration:none; font-size:13px;
                           ${filter == 'Confirmed' ? 'background:#16a34a;color:#fff;' : 'background:#f1f5f9;color:#475569;border:1px solid #e2e8f0;'}"
                           href="${pageContext.request.contextPath}/veterinarian/emergency/queue?filter=Confirmed">
                            Confirmed
                        </a>
                        <a style="padding:8px 16px; border-radius:20px; font-weight:500; text-decoration:none; font-size:13px;
                           ${filter == 'In-Progress' ? 'background:#16a34a;color:#fff;' : 'background:#f1f5f9;color:#475569;border:1px solid #e2e8f0;'}"
                           href="${pageContext.request.contextPath}/veterinarian/emergency/queue?filter=In-Progress">
                            In Progress
                        </a>
                        <a style="padding:8px 16px; border-radius:20px; font-weight:500; text-decoration:none; font-size:13px;
                           ${filter == 'Completed' ? 'background:#16a34a;color:#fff;' : 'background:#f1f5f9;color:#475569;border:1px solid #e2e8f0;'}"
                           href="${pageContext.request.contextPath}/veterinarian/emergency/queue?filter=Completed">
                            Completed
                        </a>
                    </div>

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
                                            <td>${(currentPage - 1) * 10 + loop.index + 1}</td>
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
                                                        <a href="${pageContext.request.contextPath}/veterinarian/emergency/complete?apptId=${a.apptId}"
                                                           class="btn"
                                                           style="padding:6px 12px; font-size:12px; background:#2563eb; color:#fff; border:none; border-radius:6px; text-decoration:none;">
                                                            Complete
                                                        </a>
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
                        <c:set var="searchParam" value="${not empty search ? '&search='.concat(search) : ''}" />
                        <div style="display:flex; gap:6px; justify-content:flex-end; margin-top:12px;">
                            <c:if test="${currentPage > 1}">
                                <a class="btn btn-approve" style="text-decoration:none;" href="?page=${currentPage - 1}${filterParam}${searchParam}">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a class="btn ${currentPage == i ? 'btn-approve' : 'btn-secondary'}"
                                   style="text-decoration:none;"
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
            </div>
        </main>
    </body>
</html>

