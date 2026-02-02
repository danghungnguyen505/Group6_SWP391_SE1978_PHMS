<%-- 
    Document   : addService
    Created on : Jan 22, 2026, 11:13:10 AM
    Author     : Nguyen Dang Hung
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm dịch vụ mới - VetCare Pro</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/add-service.css">
</head>
<body class="mgmt-page">
    <!-- Nhúng Navbar Admin -->
    <jsp:include page="common/navbar.jsp" />

    <div class="form-wrapper">
        <div class="form-card">
            <div class="form-header">
                <div style="width: 60px; height: 60px; background: var(--primary); border-radius: 1.25rem; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; color: white;">
                    <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4" />
                    </svg>
                </div>
                <h1 class="form-title">Thêm dịch vụ mới</h1>
                <p style="color: var(--text-muted); font-size: 0.875rem; margin-top: 0.5rem;">Cung cấp thêm giải pháp y tế cho thú cưng.</p>
            </div>

            <form action="add-service" method="post">
                <div class="form-group mb-6">
                    <label>Tên dịch vụ</label>
                    <input type="text" name="name" required class="form-input" placeholder="Ví dụ: Khám định kỳ chuyên sâu">
                </div>

                <div class="form-group mb-6">
                    <label>Giá cơ bản ($)</label>
                    <input type="number" name="price" required class="form-input" placeholder="0.00">
                </div>

                <div class="form-group">
                    <label>Mô tả dịch vụ</label>
                    <textarea name="description" class="form-input" placeholder="Mô tả các công việc và lợi ích của dịch vụ này..."></textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary" style="flex: 2;">Thêm dịch vụ</button>
                    <a href="dashboard" class="btn btn-secondary" style="flex: 1;">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
