<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Duyệt đơn nghỉ - PHMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<jsp:include page="common/navbar.jsp" />
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Đơn nghỉ chờ duyệt</h1>
            <p class="mgmt-subtitle">Clinic Manager xem và phê duyệt đơn nghỉ của nhân viên.</p>
        </div>
    </header>

    <c:if test="${empty requests}">
        <p>Hiện không có đơn nghỉ nào đang chờ duyệt.</p>
    </c:if>

    <c:if test="${not empty requests}">
        <div class="data-table-container">
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nhân viên</th>
                    <th>Ngày nghỉ</th>
                    <th>Lý do</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${requests}">
                    <tr>
                        <td>#${r.leaveId}</td>
                        <td>${r.empId}</td>
                        <td>${r.startDate}</td>
                        <td><small>${r.reason}</small></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/leave/update-status" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${r.leaveId}">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="btn btn-primary" style="margin-right: 4px;">Duyệt</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/leave/update-status" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${r.leaveId}">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" class="btn btn-secondary">Từ chối</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/admin/leave/pending?page=${i}"
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

