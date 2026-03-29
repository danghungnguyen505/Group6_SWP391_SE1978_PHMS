<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="${L}">
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
            <div class="pagination" style="display:flex; justify-content:space-between; align-items:center; gap:8px; flex-wrap:wrap;">
                <form method="get" action="${pageContext.request.contextPath}/leave/my-requests" style="display:flex; align-items:center; gap:8px;">
                    <span style="font-size:12px; color:#64748b; font-weight:700;">${L == 'en' ? 'Showing' : 'Hiển thị'}</span>
                    <select name="size" onchange="this.form.submit()" style="padding:6px 10px; border:1px solid #d1d5db; border-radius:8px; font-size:12px;">
                        <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                        <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                    </select>
                </form>
                <div>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/leave/my-requests?page=${i}&size=${pageSize}"
                       class="btn ${i == currentPage ? 'btn-primary' : 'btn-secondary'}"
                       style="margin-right: 4px;">
                        ${i}
                    </a>
                </c:forEach>
                </div>
            </div>
        </c:if>
    </c:if>
</div>
<div class="phms-account-entry" style="position:fixed; top:16px; right:20px; z-index:1200;">
    <a href="${pageContext.request.contextPath}/logout" style="display:inline-flex;align-items:center;gap:6px;padding:8px 14px;border:1px solid #e2e8f0;border-radius:10px;background:#fff;color:#334155;text-decoration:none;font-size:13px;font-weight:700;box-shadow:0 2px 10px rgba(0,0,0,.05);">${L == 'en' ? 'Logout' : 'Đăng xuất'}</a>
</div>
<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>


