<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Medical Records</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/queue">
                        <i class="fa-solid fa-stethoscope"></i> EMR Queue</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/records" class="active">
                        <i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
            </ul>
            <div class="help-box">
                <div class="help-text">Need help?</div>
                <a href="#" class="btn-contact">Contact Support</a>
            </div>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Medical Records</h2>
                    <p>All examination records created by you.</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Records</span>
                </div>

                <c:if test="${empty records}">
                    <div class="empty-state">
                        <p>No records found.</p>
                    </div>
                </c:if>

                <c:if test="${not empty records}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Created At</th>
                                <th>Appointment</th>
                                <th>Owner</th>
                                <th>Pet</th>
                                <th style="text-align:center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${records}" var="r">
                                <tr>
                                    <td class="col-id">#${r.recordId}</td>
                                    <td><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>#${r.apptId} (<fmt:formatDate value="${r.apptStartTime}" pattern="dd/MM/yyyy HH:mm"/>)</td>
                                    <td>${r.ownerName}</td>
                                    <td class="col-pet">${r.petName}</td>
                                    <td style="text-align:center;">
                                        <a class="btn btn-approve" style="text-decoration:none;"
                                           href="${pageContext.request.contextPath}/veterinarian/emr/detail?id=${r.recordId}">
                                            View
                                        </a>
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

