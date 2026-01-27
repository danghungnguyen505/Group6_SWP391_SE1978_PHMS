<%-- 
    Document   : userEdit
    Created on : Jan 27, 2026, 11:08:37 AM
    Author     : Nguyen Dang Hung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cập nhật thông tin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">

    <style>
        .form-container { max-width: 600px; margin: 50px auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; margin-bottom: 8px; font-weight: 600; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Cập nhật thông tin User</h2>
        <form action="user-edit" method="post">
            <input type="hidden" name="userId" value="${user.userId}">

            <div class="form-group">
                <label class="form-label">Username (Không thể sửa)</label>
                <input type="text" class="form-control" value="${user.username}" disabled style="background: #f1f1f1;">
            </div>

            <div class="form-group">
                <label class="form-label">Họ và tên</label>
                <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
            </div>

            <div class="form-group">
                <label class="form-label">Số điện thoại</label>
                <input type="text" name="phone" class="form-control" value="${user.phone}">
            </div>

            <div class="form-group">
                <label class="form-label">Vai trò</label>
                <select name="role" class="form-control">
                    <option value="Veterinarian" ${user.role == 'Veterinarian' ? 'selected' : ''}>Bác sĩ</option>
                    <option value="Nurse" ${user.role == 'Nurse' ? 'selected' : ''}>Y tá</option>
                    <option value="Receptionist" ${user.role == 'Receptionist' ? 'selected' : ''}>Lễ tân</option>
                    <option value="PetOwner" ${user.role == 'PetOwner' ? 'selected' : ''}>Khách hàng</option>
                    <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                </select>
            </div>
            
            <!-- Nếu là PetOwner thì hiện thêm địa chỉ -->
            <c:if test="${user.role == 'PetOwner'}">
                <div class="form-group">
                    <label class="form-label">Địa chỉ (Chỉ dành cho Khách hàng)</label>
                    <input type="text" name="address" class="form-control" value="${user.address}">
                </div>
            </c:if>

            <button type="submit" class="btn btn-warning">Lưu thay đổi</button>
            <a href="users" class="btn btn-outline" style="margin-left: 10px;">Quay lại</a>
        </form>
    </div>
</body>
</html>