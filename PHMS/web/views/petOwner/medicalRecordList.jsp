<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${t_medical_records} - VetCare Pro</title>
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
                    ${t_logout}
                </a>
            </header>

            <div class="page-header">
                <div class="page-title">
                    <h1>${t_medical_records}</h1>
                    <p>${t_medical_rec_sub}</p>
                </div>
            </div>

            <div class="card" style="padding: 16px;">
                <form method="get" action="${pageContext.request.contextPath}/my-medical-records" style="display:flex; gap:10px; align-items:center; margin-bottom: 12px;">
                    <label style="font-weight:600;">${t_filter_pet}</label>
                    <select name="petId" class="form-control" style="max-width: 280px;" onchange="this.form.submit()">
                        <option value="">${t_all}</option>
                        <c:forEach items="${pets}" var="p">
                            <option value="${p.id}" ${selectedPetId == p.id ? 'selected' : ''}>${p.name} (${p.species})</option>
                        </c:forEach>
                    </select>
                </form>

                <c:if test="${empty records}">
                    <div class="empty-state">${t_no_records}</div>
                </c:if>

                <c:if test="${not empty records}">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>#ID</th>
                                <th>${t_date}</th>
                                <th>${t_pet}</th>
                                <th>${t_doctor}</th>
                                <th style="text-align:center;">${t_actions}</th>
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

                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <c:if test="${currentPage > 1}">
                            <a href="?page=${currentPage - 1}" class="page-link">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                        </c:if>
                        <a href="?page=1" class="page-link ${currentPage == 1 ? 'active' : ''}">1</a>
                        <c:if test="${currentPage > 4}">
                            <span class="page-dots">...</span>
                        </c:if>
                        <c:forEach begin="2" end="${totalPages - 1}" var="i">
                            <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                <a href="?page=${i}" class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
                            </c:if>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages - 3}">
                            <span class="page-dots">...</span>
                        </c:if>
                        <c:if test="${totalPages > 1}">
                            <a href="?page=${totalPages}" class="page-link ${currentPage == totalPages ? 'active' : ''}">${totalPages}</a>
                        </c:if>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}" class="page-link">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </main>
    </body>
</html>
