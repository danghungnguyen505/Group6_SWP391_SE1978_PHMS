<%-- 
    Document   : serviceManagement
    Created on : Jan 22, 2026, 2:43:16 AM
    Author     : Nguyen Dang Hung
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - Quản lý Dịch vụ</title>
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
                <h1 class="mgmt-title">Hệ thống Dịch vụ</h1>
                <p class="mgmt-subtitle">Quản lý danh mục dịch vụ trong bảng ServiceList</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Về Trang chủ</a>
                <a href="add-service" class="btn btn-primary">Thêm dịch vụ mới</a>
            </div>
        </header>

        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên Dịch vụ</th>
                        <th>Mô tả</th>
                        <th>Giá Cơ Bản</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th> 
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="service" items="${services}">
                        <tr>
                            <td>#${service.serviceId}</td>
                            <td class="table-cell-bold">${service.name}</td>
                            <td><small>${service.description}</small></td>
                            <td class="table-cell-price">
                                $${String.format("%,.0f", service.basePrice)}
                            </td>
                            <td>
                                <span class="badge ${service.isActive ? 'badge-active' : 'badge-inactive'}">
                                    ${service.isActive ? 'Hoạt động' : 'Tạm dừng'}
                                </span>
                            </td>
                            <td>
                                <a href="edit-service?id=${service.serviceId}" style="color: #2563eb; margin-right: 10px;">Sửa</a>

                                <form action="dashboard" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="toggle">
                                    <input type="hidden" name="id" value="${service.serviceId}">
                                    <input type="hidden" name="status" value="${service.isActive}">
                                    <button type="submit" style="background:none; border:none; color: ${service.isActive ? '#ef4444' : '#10b981'}; cursor:pointer;">
                                        ${service.isActive ? 'Đóng' : 'Mở'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>