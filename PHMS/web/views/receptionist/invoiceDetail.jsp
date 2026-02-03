<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hóa đơn - PHMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Hóa đơn #${invoice.invoiceId}</h1>
            <p class="mgmt-subtitle">
                Cuộc hẹn: #${invoice.apptId} | Tổng tiền: ${invoice.totalAmount} | Trạng thái: ${invoice.status}
            </p>
        </div>
    </header>

    <div class="data-table-container">
        <h2 class="mgmt-title" style="font-size: 1.1rem;">Chi tiết hóa đơn</h2>
        <table class="data-table">
            <thead>
            <tr>
                <th>Loại</th>
                <th>ID</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <c:set var="sum" value="0" />
            <c:forEach var="d" items="${details}">
                <tr>
                    <td>${d.itemType}</td>
                    <td>
                        <c:choose>
                            <c:when test="${d.itemType eq 'Service'}">
                                ${d.serviceId}
                            </c:when>
                            <c:otherwise>
                                ${d.medicineId}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${d.quantity}</td>
                    <td>${d.unitPrice}</td>
                    <td>
                        <c:set var="lineTotal" value="${d.quantity * d.unitPrice}" />
                        ${lineTotal}
                        <c:set var="sum" value="${sum + lineTotal}" />
                    </td>
                </tr>
            </c:forEach>
            </tbody>
            <tfoot>
            <tr>
                <td colspan="4" style="text-align: right; font-weight: 600;">Tổng cộng tính lại:</td>
                <td>${sum}</td>
            </tr>
            </tfoot>
        </table>
    </div>

    <div class="data-table-container" style="margin-top: 1.5rem;">
        <h2 class="mgmt-title" style="font-size: 1.1rem;">Lịch sử thanh toán</h2>
        <c:if test="${empty payments}">
            <p>Chưa có giao dịch thanh toán nào.</p>
        </c:if>
        <c:if test="${not empty payments}">
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Phương thức</th>
                    <th>Số tiền</th>
                    <th>Trạng thái</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${payments}">
                    <tr>
                        <td>#${p.paymentId}</td>
                        <td>${p.method}</td>
                        <td>${p.amount}</td>
                        <td>${p.status}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <c:if test="${invoice.status ne 'Paid'}">
        <form action="${pageContext.request.contextPath}/receptionist/payment/create" method="post"
              style="margin-top: 1.5rem;">
            <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
            <label>Phương thức thanh toán:</label>
            <select name="method" class="form-input" style="width: 200px; display: inline-block; margin-left: 8px;">
                <option value="Cash">Tiền mặt</option>
                <option value="Transfer">Chuyển khoản</option>
            </select>
            <button type="submit" class="btn btn-primary" style="margin-left: 8px;">Xác nhận thanh toán</button>
        </form>
        <div style="margin-top: 0.75rem;">
            <a href="${pageContext.request.contextPath}/payment/vnpay/checkout?invoiceId=${invoice.invoiceId}"
               class="btn btn-secondary">
                Thanh toán qua VNPay
            </a>
        </div>
    </c:if>

    <div style="margin-top: 1.5rem;">
        <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="btn btn-secondary">Về Dashboard</a>
    </div>
</div>
</body>
</html>

