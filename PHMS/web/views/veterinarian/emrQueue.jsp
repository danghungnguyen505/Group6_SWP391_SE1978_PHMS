<<<<<<< Updated upstream
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - EMR Queue</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/veterinarian/dashboard">
                        <i class="fa-solid fa-table-columns"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/queue" class="active">
                        <i class="fa-solid fa-stethoscope"></i> EMR Queue</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/records">
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
                    <h2>Today's Checked-in Queue</h2>
                    <jsp:useBean id="today" class="java.util.Date" />
                    <p><fmt:formatDate value="${today}" pattern="dd/MM/yyyy"/></p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Checked-in Appointments</span>
                </div>

                <c:if test="${empty queueList}">
                    <div class="empty-state">
                        <p>No checked-in appointments for today.</p>
                    </div>
                </c:if>

                <c:if test="${not empty queueList}">
                    <table>
                        <thead>
                            <tr>
                                <th>Time</th>
                                <th>ID</th>
                                <th>Owner</th>
                                <th>Pet</th>
                                <th>Service</th>
                                <th>Notes</th>
                                <th style="text-align:center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${queueList}" var="a">
                                <tr>
                                    <td><fmt:formatDate value="${a.startTime}" pattern="HH:mm"/></td>
                                    <td class="col-id">#${a.apptId}</td>
                                    <td>${a.ownerName}</td>
                                    <td class="col-pet">${a.petName}</td>
                                    <td class="col-service">${a.type}</td>
                                    <td>
                                        <c:if test="${empty a.notes}">
                                            <span style="color:#999; font-style:italic;">No notes</span>
                                        </c:if>
                                        <c:if test="${not empty a.notes}">
                                            ${a.notes}
                                        </c:if>
                                    </td>
                                    <td style="text-align:center;">
                                        <a class="btn btn-approve" style="text-decoration:none;"
                                           href="${pageContext.request.contextPath}/veterinarian/emr/create?apptId=${a.apptId}">
                                            <i class="fa-solid fa-pen-to-square"></i> Examine
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

=======
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - EMR Queue</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Today's Checked-in Queue</h2>
                    <jsp:useBean id="today" class="java.util.Date" />
                    <p><fmt:formatDate value="${today}" pattern="dd/MM/yyyy"/></p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Checked-in Appointments</span>
                </div>

                <c:if test="${empty queueList}">
                    <div class="empty-state">
                        <p>No checked-in appointments for today.</p>
                    </div>
                </c:if>

                <c:if test="${not empty queueList}">
                    <table>
                        <thead>
                            <tr>
                                <th>Time</th>
                                <th>ID</th>
                                <th>Owner</th>
                                <th>Pet</th>
                                <th>Service</th>
                                <th>Notes</th>
                                <th style="text-align:center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${queueList}" var="a">
                                <tr>
                                    <td><fmt:formatDate value="${a.startTime}" pattern="HH:mm"/></td>
                                    <td class="col-id">#${a.apptId}</td>
                                    <td>${a.ownerName}</td>
                                    <td class="col-pet">${a.petName}</td>
                                    <td class="col-service">${a.type}</td>
                                    <td>
                                        <c:if test="${empty a.notes}">
                                            <span style="color:#999; font-style:italic;">No notes</span>
                                        </c:if>
                                        <c:if test="${not empty a.notes}">
                                            ${a.notes}
                                        </c:if>
                                    </td>
                                    <td style="text-align:center;">
                                        <a class="btn btn-approve" style="text-decoration:none;"
                                           href="${pageContext.request.contextPath}/veterinarian/emr/create?apptId=${a.apptId}">
                                            <i class="fa-solid fa-pen-to-square"></i> Examine
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

>>>>>>> Stashed changes
