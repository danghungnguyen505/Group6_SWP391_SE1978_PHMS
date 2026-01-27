<%-- 
    Document   : userList
    Created on : Jan 27, 2026, 10:58:42 AM
    Author     : Nguyen Dang Hung
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetCare Pro - Quản lý Nhân sự</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
    
    <!-- Nhúng Sidebar Admin -->
    <jsp:include page="common/navbar.jsp" />

    <div class="mgmt-container">
        <header class="mgmt-header">
            <div>
                <h1 class="mgmt-title">Quản lý Nhân sự</h1>
                <p class="mgmt-subtitle">Danh sách đội ngũ bác sĩ, y tá và nhân viên phòng khám</p>
            </div>
            <div>
                <a href="user-create" class="btn btn-primary">
                    <i class="fas fa-plus" style="margin-right: 8px;"></i>
                    Thêm nhân viên mới
                </a>
            </div>
        </header>

        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Mã ID</th>
                        <th>Tên đăng nhập</th>
                        <th>Họ và tên</th>
                        <th>Liên hệ</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th style="text-align: right;">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td class="table-cell-bold">#${u.userId}</td>
                            <td>
                                <span style="font-family: 'Inter', sans-serif; font-weight: 600; color: var(--text-muted);">${u.username}</span>
                            </td>
                            <td class="table-cell-bold">${u.fullName}</td>
                            <td>
                                <div style="display: flex; flex-direction: column; gap: 2px;">
                                    <span style="font-size: 0.875rem; font-weight: 700;">${u.phone}</span>
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.role == 'Admin'}"><span class="badge badge-admin">Quản trị viên</span></c:when>
                                    <c:when test="${u.role == 'Veterinarian'}"><span class="badge badge-vet">Bác sĩ</span></c:when>
                                    <c:when test="${u.role == 'Nurse'}"><span class="badge badge-nurse">Y tá</span></c:when>
                                    <c:when test="${u.role == 'Receptionist'}"><span class="badge badge-rec">Lễ tân</span></c:when>
                                    <c:when test="${u.role == 'ClinicManager'}"><span class="badge badge-manager">Quản lý</span></c:when>
                                    <c:otherwise><span class="badge" style="background: #f1f5f9; color: #64748b;">${u.role}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="status-indicator">
                                    <span class="dot ${u.isActive ? 'dot-active' : 'dot-locked'}"></span>
                                    <span style="font-size: 0.75rem; font-weight: 800; text-transform: uppercase; color: ${u.isActive ? '#16a34a' : '#dc2626'}">
                                        ${u.isActive ? 'Hoạt động' : 'Đã khóa'}
                                    </span>
                                </div>
                            </td>
                            <td style="text-align: right;">
                                <div class="btn-group-sm" style="justify-content: flex-end;">
                                    <a href="user-edit?id=${u.userId}" class="btn-icon-sm" title="Chỉnh sửa">
                                        <i class="fas fa-edit" style="color: #3b82f6;"></i>
                                    </a>
                                    
                                    <c:if test="${u.isActive}">
                                        <a href="users?action=lock&id=${u.userId}" class="btn-icon-sm" title="Khóa tài khoản" 
                                           onclick="return confirm('Bạn có chắc chắn muốn khóa tài khoản này?')">
                                            <i class="fas fa-lock" style="color: #ef4444;"></i>
                                        </a>
                                    </c:if>
                                    <c:if test="${!u.isActive}">
                                        <a href="users?action=unlock&id=${u.userId}" class="btn-icon-sm" title="Mở khóa tài khoản">
                                            <i class="fas fa-unlock" style="color: #22c55e;"></i>
                                        </a>
                                    </c:if>
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
