<%-- 
    Document   : userCreate
    Created on : Jan 27, 2026, 11:08:10 AM
    Author     : Nguyen Dang Hung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Thêm nhân viên mới</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
        <style>
            .form-container {
                max-width: 600px;
                margin: 50px auto;
                padding: 30px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
            }
            .form-control {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h2 style="margin-bottom: 20px;">Tạo tài khoản nhân viên</h2>

            <!-- Hiển thị lỗi nếu có -->
            <p style="color: red">${error}</p>

            <form action="user-create" method="post">
                <div class="form-group">
                    <label class="form-label">Tên đăng nhập *</label>
                    <input type="text" name="username" class="form-control" required value="${oldUsername}">
                </div>

                <div class="form-group">
                    <label class="form-label">Mật khẩu *</label>
                    <input type="password" name="password" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" name="phone" class="form-control" placeholder="09xxxx..." required>
                </div>

                <div class="form-group">
                    <label class="form-label">Họ và tên *</label>
                    <input type="text" name="fullName" class="form-control" required value="${oldName}">
                </div>

                <div class="form-group">
                    <label class="form-label">Mã nhân viên (VD: VET01, NUR01) *</label>
                    <input type="text" name="empCode" class="form-control" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Vai trò</label>
                    <select name="role" class="form-control">
                        <option value="Veterinarian">Bác sĩ (Veterinarian)</option>
                        <option value="Nurse">Y tá (Nurse)</option>
                        <option value="Receptionist">Lễ tân (Receptionist)</option>
                        <option value="ClinicManager">Quản lý (Manager)</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Tạo tài khoản</button>
                <a href="users" class="btn btn-outline" style="margin-left: 10px;">Hủy</a>
            </form>
        </div>
    </body>
</html>
