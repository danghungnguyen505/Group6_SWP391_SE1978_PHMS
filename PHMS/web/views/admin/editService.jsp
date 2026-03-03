<%-- 
    Document   : editService
    Created on : Jan 22, 2026, 10:37:59 AM
    Author     : Nguyen Dang Hung
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật dịch vụ - VetCare Pro</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/edit-service.css">
</head>
<body class="mgmt-page">
    <jsp:include page="common/navbar.jsp" />
    <div class="form-wrapper">
        <div class="form-card">
            <div class="form-header">
                <div style="width: 60px; height: 60px; background: #2563eb; border-radius: 1.25rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; color: white;">
                    <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                    </svg>
                </div>
                <div class="service-id-badge">ID Dịch vụ: #${service.serviceId}</div>
                <h1 class="form-title">Cập nhật dịch vụ</h1>
                <p style="color: var(--text-muted); font-size: 0.875rem; margin-top: 0.5rem;">Chỉnh sửa thông tin và đơn giá dịch vụ hiện có.</p>
            </div>

            <form action="edit-service" method="post">
                <input type="hidden" name="id" value="${s.serviceId}">

                <div class="form-group mb-6">
                    <label>Tên dịch vụ</label>
                    <input type="text" name="name" value="${s.name}" required class="form-input">
                </div>

                <div class="form-group mb-6">
                    <label>Giá cơ bản ($)</label>
                    <input type="number" name="price" value="${s.basePrice}" required class="form-input">
                </div>

                <div class="form-group">
                    <label>Mô tả dịch vụ</label>
                    <textarea name="description" class="form-input">${s.description}</textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-dark" style="flex: 2; background: #2563eb;">Lưu thay đổi</button>
                    <a href="dashboard" class="btn btn-secondary" style="flex: 1;">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
