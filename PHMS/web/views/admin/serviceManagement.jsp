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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary" style="margin-right: 10px;">Về Trang chủ</a>
                <a href="add-service" class="btn btn-primary">
                    <i class="fas fa-plus" style="margin-right: 8px;"></i> Thêm dịch vụ mới
                </a>
            </div>
        </header>

        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Mã ID</th>
                        <th>Tên Dịch vụ</th>
                        <th>Mô tả</th>
                        <th>Giá Cơ Bản</th>
                        <th>Trạng thái</th>
                        <th style="text-align: right;">Hành động</th> 
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="service" items="${services}">
                        <tr>
                            <td class="table-cell-bold">#${service.serviceId}</td>
                            <td class="table-cell-bold">${service.name}</td>
                            <td><small style="color: var(--text-muted); font-weight: 500;">${service.description}</small></td>
                            <td class="table-cell-bold" style="color: var(--primary);">
                                $${String.format("%,.0f", service.basePrice)}
                            </td>
                            <td>
                                <div class="status-indicator">
                                    <span class="dot ${service.isActive ? 'dot-active' : 'dot-locked'}"></span>
                                    <span style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: ${service.isActive ? '#16a34a' : '#dc2626'}">
                                        ${service.isActive ? 'Hoạt động' : 'Tạm dừng'}
                                    </span>
                                </div>
                            </td>
                            <td style="text-align: right;">
                                <div class="btn-group-sm" style="justify-content: flex-end;">
                                    <a href="edit-service?id=${service.serviceId}" class="btn-icon-sm" title="Chỉnh sửa dịch vụ">
                                        <i class="fas fa-edit" style="color: #3b82f6;"></i>
                                    </a>

                                    <form action="dashboard" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="toggle">
                                        <input type="hidden" name="id" value="${service.serviceId}">
                                        <input type="hidden" name="status" value="${service.isActive}">
                                        
                                        <button type="submit" class="btn-icon-sm" style="border: none; background: none;"
                                                title="${service.isActive ? 'Tạm dừng dịch vụ' : 'Kích hoạt dịch vụ'}"
                                                onclick="return confirm('Bạn có chắc chắn muốn ${service.isActive ? 'tạm dừng' : 'kích hoạt'} dịch vụ này?')">
                                            <c:choose>
                                                <c:when test="${service.isActive}">
                                                    <i class="fas fa-eye-slash" style="color: #ef4444;"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-eye" style="color: #10b981;"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <footer style="margin-top: 2rem; text-align: center; color: var(--text-light); font-size: 0.75rem; font-weight: 600;">
            Hệ thống Quản lý VetCare Pro &copy; 2026 - Bảo mật theo tiêu chuẩn PHMS
        </footer>
    </div>
</body>
</html>
