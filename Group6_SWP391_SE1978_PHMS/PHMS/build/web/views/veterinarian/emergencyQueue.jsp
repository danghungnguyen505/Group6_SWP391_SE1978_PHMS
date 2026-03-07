<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hàng đợi cấp cứu - Bác sĩ</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/veterinarian/veterinarianList.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/staffScheduling.css">
    </head>
    <body>
        <c:set var="activePage" value="emergencyQueue" scope="request" />
        <jsp:include page="nav/navVeterinarian.jsp" />
        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>My Emergency Queue</h2>
                    <p>Emergency cases have been triaged and assigned to you.</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Emergency Waiting List</span>
                </div>

                <c:if test="${empty appointments}">
                    <div class="empty-state">
                        <p>There are currently no emergency cases in the waiting list.</p>
                    </div>
                </c:if>

                <c:if test="${not empty appointments}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Pet</th>
                                <th>Pet Owner</th>
                                <th>Time</th>
                                <th>Level</th>
                                <th>Initial symptoms</th>
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
                                            <td style="white-space: pre-wrap;">
                                                <c:if test="${triage != null}">
                                                    <small>${triage.initialSymptoms}</small>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                </c:if>
            </div>
        </main>
    </body>
</html>

