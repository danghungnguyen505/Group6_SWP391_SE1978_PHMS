<<<<<<< Updated upstream
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hàng đợi cấp cứu - Lễ tân</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Hàng đợi cấp cứu</h1>
            <p class="mgmt-subtitle">Danh sách các ca cấp cứu đang chờ được khám.</p>
        </div>
    </header>

    <c:if test="${empty appointments}">
        <p>Hiện không có ca cấp cứu nào.</p>
    </c:if>

    <c:if test="${not empty appointments}">
        <div class="data-table-container">
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Thú cưng</th>
                    <th>Chủ</th>
                    <th>Bác sĩ</th>
                    <th>Thời gian</th>
                    <th>Mức độ</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="a" items="${appointments}">
                    <c:set var="triage" value="${triageMap[a.apptId]}" />
                    <tr>
                        <td>#${a.apptId}</td>
                        <td>${a.petName}</td>
                        <td>${a.ownerName}</td>
                        <td>${a.vetName}</td>
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
                        <td>${a.status}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/receptionist/emergency/triage?apptId=${a.apptId}"
                               class="btn btn-secondary">Triage</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>
</body>
</html>

=======
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hàng đợi cấp cứu - Lễ tân</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Emergency queue</h1>
            <p class="mgmt-subtitle">List of emergency cases awaiting examination.</p>
        </div>
    </header>

    <c:if test="${empty appointments}">
        <p>There are currently no emergency cases.</p>
    </c:if>

    <c:if test="${not empty appointments}">
        <div class="data-table-container">
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Pets</th>
                    <th>Pet Owner</th>
                    <th>Veterinarian</th>
                    <th>Time</th>
                    <th>Level</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="a" items="${appointments}">
                    <c:set var="triage" value="${triageMap[a.apptId]}" />
                    <tr>
                        <td>#${a.apptId}</td>
                        <td>${a.petName}</td>
                        <td>${a.ownerName}</td>
                        <td>${a.vetName}</td>
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
                                    <span class="badge badge-inactive">Do not triage</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${a.status}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/receptionist/emergency/triage?apptId=${a.apptId}"
                               class="btn btn-secondary">Triage</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>
</body>
</html>

>>>>>>> Stashed changes
