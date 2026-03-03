<<<<<<< Updated upstream
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Medical Records - VetCare Pro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assets/css/pages/myAppointment.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <aside class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus"></i>
                <span>VetCare Pro</span>
            </div>
            <div class="menu-label">Main Menu</div>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/booking" class="nav-link">
                        <i class="fa-regular fa-calendar-check"></i> Appointments
                    </a>
                </li>
                <li class="nav-item" style="font-size: 13px;" >
                    <a href="${pageContext.request.contextPath}/myAppointment" class="nav-link">
                        <i class="fa-solid fa-calendar-check"></i> My Appointments
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/myPetOwner" class="nav-link">
                        <i class="fa-solid fa-paw"></i> My Pets
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/my-medical-records" class="nav-link active">
                        <i class="fa-solid fa-file-medical"></i> Medical Records
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/billing" class="nav-link">
                        <i class="fa-regular fa-credit-card"></i> Billing
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/aiHealthGuide" class="nav-link">
                        <i class="fa-solid fa-bolt"></i> AI Health Guide
                    </a>
                </li>
            </ul>
            <div class="support-box">
                <p>Need help?</p>
                <button class="btn-support">Contact Support</button>
            </div>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                    Logout
                </a>
            </header>

            <div class="page-header">
                <div class="page-title">
                    <h1>Medical Records</h1>
                    <p>View examination results for your pets.</p>
                </div>
            </div>

            <div class="card" style="padding: 16px;">
                <form method="get" action="${pageContext.request.contextPath}/my-medical-records" style="display:flex; gap:10px; align-items:center; margin-bottom: 12px;">
                    <label style="font-weight:600;">Filter by Pet:</label>
                    <select name="petId" class="form-control" style="max-width: 280px;" onchange="this.form.submit()">
                        <option value="">All</option>
                        <c:forEach items="${pets}" var="p">
                            <option value="${p.id}" ${selectedPetId == p.id ? 'selected' : ''}>${p.name} (${p.species})</option>
                        </c:forEach>
                    </select>
                </form>

                <c:if test="${empty records}">
                    <div class="empty-state">No medical records found.</div>
                </c:if>

                <c:if test="${not empty records}">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>#ID</th>
                                <th>Date</th>
                                <th>Pet</th>
                                <th>Doctor</th>
                                <th style="text-align:center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${records}" var="r">
                                <tr>
                                    <td><b>#${r.recordId}</b></td>
                                    <td><fmt:formatDate value="${r.apptStartTime}" pattern="dd-MM-yyyy HH:mm"/></td>
                                    <td>${r.petName}</td>
                                    <td>${r.vetName}</td>
                                    <td style="text-align:center;">
                                        <a class="btn-action btn-reschedule" style="text-decoration:none;"
                                           href="${pageContext.request.contextPath}/my-medical-records/detail?id=${r.recordId}">
                                            View
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <c:if test="${currentPage > 1}">
                            <a href="?page=${currentPage - 1}&petId=${selectedPetId}" class="page-link">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="?page=${i}&petId=${selectedPetId}" class="page-link ${currentPage == i ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}&petId=${selectedPetId}" class="page-link">
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
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Medical Records - VetCare Pro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assets/css/pages/myAppointment.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="nav/navPetOwner.jsp" />

        <main class="main-content">
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                    Logout
                </a>
            </header>

            <div class="page-header">
                <div class="page-title">
                    <h1>Medical Records</h1>
                    <p>View examination results for your pets.</p>
                </div>
            </div>

            <div class="card" style="padding: 16px;">
                <form method="get" action="${pageContext.request.contextPath}/my-medical-records" style="display:flex; gap:10px; align-items:center; margin-bottom: 12px;">
                    <label style="font-weight:600;">Filter by Pet:</label>
                    <select name="petId" class="form-control" style="max-width: 280px;" onchange="this.form.submit()">
                        <option value="">All</option>
                        <c:forEach items="${pets}" var="p">
                            <option value="${p.id}" ${selectedPetId == p.id ? 'selected' : ''}>${p.name} (${p.species})</option>
                        </c:forEach>
                    </select>
                </form>

                <c:if test="${empty records}">
                    <div class="empty-state">No medical records found.</div>
                </c:if>

                <c:if test="${not empty records}">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>#ID</th>
                                <th>Date</th>
                                <th>Pet</th>
                                <th>Doctor</th>
                                <th style="text-align:center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${records}" var="r">
                                <tr>
                                    <td><b>#${r.recordId}</b></td>
                                    <td><fmt:formatDate value="${r.apptStartTime}" pattern="dd-MM-yyyy HH:mm"/></td>
                                    <td>${r.petName}</td>
                                    <td>${r.vetName}</td>
                                    <td style="text-align:center;">
                                        <a class="btn-action btn-reschedule" style="text-decoration:none;"
                                           href="${pageContext.request.contextPath}/my-medical-records/detail?id=${r.recordId}">
                                            <i class="fa-regular fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

            <!--Paging của History-->           
            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <!-- Previous -->
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}" class="page-link">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>
                    </c:if>
                    <!-- Trang 1 -->
                    <a href="?page=1" class="page-link ${currentPage == 1 ? 'active' : ''}">1</a>
                    <!-- Dấu ... bên trái -->
                    <c:if test="${currentPage > 4}">
                        <span class="page-dots">...</span>
                    </c:if>
                    <!-- Vòng lặp các trang ở giữa (Current - 2 đến Current + 2) -->
                    <c:forEach begin="2" end="${totalPages - 1}" var="i">
                        <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                            <a href="?page=${i}" class="page-link ${currentPage == i ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:if>
                    </c:forEach>
                    <!-- Dấu ... bên phải -->
                    <c:if test="${currentPage < totalPages - 3}">
                        <span class="page-dots">...</span>
                    </c:if>
                    <!-- Trang cuối (nếu tổng trang > 1) -->
                    <c:if test="${totalPages > 1}">
                        <a href="?page=${totalPages}" class="page-link ${currentPage == totalPages ? 'active' : ''}">
                            ${totalPages}
                        </a>
                    </c:if>
                    <!-- Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}" class="page-link">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </c:if>   
                </c:if> 
            </div>
        </main>
    </body>
</html>

>>>>>>> Stashed changes
