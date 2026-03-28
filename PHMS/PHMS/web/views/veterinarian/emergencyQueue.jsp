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

                    <c:if test="${empty appointments}">
                        <p>There are currently no emergency cases in the waiting list.</p>
                    </c:if>

                    <c:if test="${not empty appointments}">
                        <div class="data-table-container">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Pet</th>
                                        <th>Pet Owner</th>
                                        <th>Time</th>
                                        <th>Level</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="a" items="${appointments}">
                                        <c:set var="triage" value="${triageMap[a.apptId]}" />
                                        <tr>
                                            <td>#${a.apptId}</td>
                                            <td>${a.petName}</td>
                                            <td>${a.ownerName}</td>
                                            <td>${a.startTime}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${triage != null && triage.conditionLevel eq 'Red'}">
                                                        <span class="badge badge-active" style="background:#b91c1c;">Red</span>
                                                    </c:when>
                                                    <c:when test="${triage != null && triage.conditionLevel eq 'Yellow'}">
                                                        <span class="badge badge-warning">Yellow</span>
                                                    </c:when>
                                                    <c:when test="${triage != null && triage.conditionLevel eq 'Green'}">
                                                        <span class="badge" style="background:#16a34a;color:#fff;">Green</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-inactive">Chưa triage</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
                                                    <c:choose>
                                                        <c:when test="${a.status eq 'In-Progress'}">
                                                            <span class="badge" style="background:#0ea5e9;color:#fff;">Agreed</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-inactive">${a.status}</span>
                                                            <form method="post"
                                                                  action="${pageContext.request.contextPath}/veterinarian/emergency/agree"
                                                                  style="margin:0;">
                                                                <input type="hidden" name="apptId" value="${a.apptId}" />
                                                                <button type="submit" class="btn btn-secondary"
                                                                        style="padding:6px 10px; line-height:1; border-radius:10px;">
                                                                    Accept
                                                                </button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </body>
</html>

