<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

                <c:if test="${empty tests}">
                    <div class="empty-state"><p>No lab requests.</p></div>
                </c:if>

                <c:if test="${not empty tests}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Record</th>
                                <th>Pet</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th>Result</th>
                                <th style="text-align:center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${tests}" var="t">
                                <tr>
                                    <td class="col-id">#${t.testId}</td>
                                    <td>#${t.recordId}</td>
                                    <td class="col-pet">${t.petName}</td>
                                    <td class="col-service">${t.testType}</td>
                                    <td>${t.status}</td>
                                    <td>
                                        <c:if test="${empty t.resultData}">
                                            <span style="color:#999; font-style:italic;">Pending</span>
                                        </c:if>
                                        <c:if test="${not empty t.resultData}">
                                            <c:choose>
                                                <c:when test="${t.resultData.startsWith('/uploads/lab/')}">
                                                    <a href="${pageContext.request.contextPath}${t.resultData}" target="_blank">View file</a>
                                                </c:when>
                                                <c:otherwise>
                                                    ${t.resultData}
                                                </c:otherwise>
                                            </c:choose>
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
                    <div style="display:flex; gap:6px; justify-content:flex-end; margin-top:12px;">
                        <c:if test="${currentPage > 1}">
                            <a class="btn btn-approve" style="text-decoration:none;" href="?page=${currentPage - 1}">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a class="btn ${currentPage == i ? 'btn-approve' : 'btn-reject'}"
                               style="text-decoration:none; ${currentPage == i ? '' : 'background:#e5e7eb;color:#111827;'}"
                               href="?page=${i}">${i}</a>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a class="btn btn-approve" style="text-decoration:none;" href="?page=${currentPage + 1}">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </main>
    </body>
</html>

