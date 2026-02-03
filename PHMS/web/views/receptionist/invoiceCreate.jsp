<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo hóa đơn - PHMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Tạo hóa đơn cho cuộc hẹn #${appt.apptId}</h1>
            <p class="mgmt-subtitle">
                Thú cưng: ${appt.petName} | Bác sĩ: ${appt.vetName} | Thời gian: ${appt.startTime}
            </p>
        </div>
    </header>

    <c:if test="${not empty error}">
        <div class="alert alert-error" style="margin-bottom: 1rem; color: #b91c1c;">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/receptionist/invoice/create" method="post">
        <input type="hidden" name="apptId" value="${appt.apptId}">

        <div class="data-table-container">
            <h2 class="mgmt-title" style="font-size: 1.1rem;">Dịch vụ</h2>
            <table class="data-table">
                <thead>
                <tr>
                    <th>Chọn</th>
                    <th>Tên dịch vụ</th>
                    <th>Giá cơ bản</th>
                    <th>Số lượng</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="s" items="${services}">
                    <tr>
                        <td>
                            <input type="checkbox" name="serviceId" value="${s.serviceId}">
                        </td>
                        <td>${s.name}</td>
                        <td>${s.basePrice}</td>
                        <td>
                            <input type="number" name="serviceQty" value="1" min="1" max="100"
                                   class="form-input" style="width: 80px;">
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="data-table-container" style="margin-top: 1.5rem;">
            <h2 class="mgmt-title" style="font-size: 1.1rem;">Thuốc</h2>
            <table class="data-table">
                <thead>
                <tr>
                    <th>Chọn</th>
                    <th>Tên thuốc</th>
                    <th>Đơn vị</th>
                    <th>Giá</th>
                    <th>Tồn kho</th>
                    <th>Số lượng</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="m" items="${medicines}">
                    <tr>
                        <td>
                            <input type="checkbox" name="medicineId" value="${m.medicineId}">
                        </td>
                        <td>${m.name}</td>
                        <td>${m.unit}</td>
                        <td>${m.price}</td>
                        <td>${m.stockQuantity}</td>
                        <td>
                            <input type="number" name="medicineQty" value="1" min="1" max="${m.stockQuantity}"
                                   class="form-input" style="width: 80px;">
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="form-actions" style="margin-top: 1.5rem;">
            <button type="submit" class="btn btn-primary">Tạo hóa đơn</button>
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="btn btn-secondary">Hủy</a>
        </div>
    </form>
</div>
</body>
</html>

