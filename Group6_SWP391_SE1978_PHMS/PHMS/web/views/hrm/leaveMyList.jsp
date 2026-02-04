<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn nghỉ của tôi - PHMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Đơn nghỉ của tôi</h1>
            <p class="mgmt-subtitle">Danh sách các đơn nghỉ đã gửi tới quản lý.</p>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/leave/request" class="btn btn-primary">Gửi đơn nghỉ mới</a>
        </div>
    </header>

    <c:if test="${empty requests}">
        <p>Chưa có đơn nghỉ nào.</p>
    </c:if>

    <c:if test="${not empty requests}">
        <div class="data-table-container">
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Ngày nghỉ</th>
                    <th>Lý do</th>
                    <th>Trạng thái</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${requests}">
                    <tr>
                        <td>#${r.leaveId}</td>
                        <td>${r.startDate}</td>
                        <td><small>${r.reason}</small></td>
                        <td>
                            <c:choose>
                                <c:when test="${r.status eq 'Pending'}">
                                    <span class="badge badge-warning">Đang chờ</span>
                                </c:when>
                                <c:when test="${r.status eq 'Approved'}">
                                    <span class="badge badge-active">Đã duyệt</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-inactive">Từ chối</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/leave/my-requests?page=${i}"
                       class="btn ${i == currentPage ? 'btn-primary' : 'btn-secondary'}"
                       style="margin-right: 4px;">
                        ${i}
                    </a>
                </c:forEach>
            </div>
        </c:if>
    </c:if>
</div>
</body>
</html>

