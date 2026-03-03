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

<<<<<<< Updated upstream
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
=======
                            <c:if test="${not empty prescriptions}">
                                <c:forEach var="p" items="${prescriptions}">
                                    <tr>
                                        <td>
                                            <c:out value="${p.medicineName}"/>
                                        </td>
                                        <td class="text-center">
                                            <c:out value="${p.quantity}"/>
                                        </td>
                                        <td class="text-right">
                                            <fmt:formatNumber value="${p.medicinePrice}" type="currency" currencySymbol="$"/>
                                        </td>
                                        <td class="text-right fw-bold">
                                            <fmt:formatNumber value="${p.quantity * p.medicinePrice}" type="currency" currencySymbol="$"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                        </tbody>
                    </table>
                    <!-- Totals Section -->
                    <div class="totals-section">
                        <div class="total-row">
                            <span>Subtotal</span>
                            <span class="amount">
                                <c:choose>
                                    <c:when test="${subtotal != null}">
                                        <fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="$"/>
                                    </c:when>
                                    <c:otherwise>$0.00</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="total-row">
                            <span>Tax (8%)</span>
                            <span class="amount">
                                <c:choose>
                                    <c:when test="${tax != null}">
                                        <fmt:formatNumber value="${tax}" type="currency" currencySymbol="$"/>
                                    </c:when>
                                    <c:otherwise>$0.00</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="total-row grand-total">
                            <span>Grand Total</span>
                            <span class="amount-green">
                                <c:choose>
                                    <c:when test="${grandTotal != null}">
                                        <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="$"/>
                                    </c:when>
                                    <c:otherwise>$0.00</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>
                <!-- RIGHT COLUMN: CHECKOUT -->
                <div class="checkout-card">
                    <h3>Checkout</h3>${grandTotal}a${param.apptId}
                    <form action="${pageContext.request.contextPath}/payment" method="POST">
                        <input type="hidden" name="apptId" value="${param.apptId}"/>
                        <input type="hidden" name="grandTotal" value="${grandTotal}"/>
                        <div class="method-section">
                            <label class="section-label">SELECT METHOD</label>
                            <!-- Option 1: Cash (Disabled/Gray) -->
                            <label class="payment-option disabled">
                                <input type="radio" name="paymentMethod" value="cash" disabled>
                                <div class="option-content">
                                    <div class="icon-box gray">
                                        <i class="fa-solid fa-wallet"></i>
                                    </div>
                                    <div class="text-box">
                                        <span class="method-name">Cash / POS</span>
                                        <span class="method-desc">Pay at the reception desk</span>
                                    </div>
                                </div>
                            </label>
                            <!-- Option 2: Online / VNPay (Active) -->
                            <label class="payment-option active">
                                <input type="radio" name="paymentMethod" value="vnpay" checked>
                                <div class="option-content">
                                    <div class="icon-box green">
                                        <i class="fa-solid fa-qrcode"></i>
                                    </div>
                                    <div class="text-box">
                                        <span class="method-name">Online / VN Pay</span>
                                        <span class="method-desc">Scan QR Code instantly</span>
                                    </div>
                                </div>
                            </label>
                        </div>
                        <!-- Discount Code -->
                        <div class="discount-section">
                            <label class="section-label">DISCOUNT CODE</label>
                            <div class="input-group">
                                <input type="text" placeholder="Enter code" class="discount-input">
                                <button type="button" class="btn-apply">Apply</button>
                            </div>
                        </div>
                        <!-- Pay Button -->
                        <button type="submit" class="btn-pay">
                            Pay
                            <c:choose>
                                <c:when test="${grandTotal != null}">
                                    <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="$"/>
                                </c:when>
                                <c:otherwise>$0.00</c:otherwise>
                            </c:choose>
                        </button>
                    </form>
                    <!-- Installment Info -->
                    <div class="info-box">
                        <h5>Need an Installment Plan?</h5>
                        <p>We offer 0% interest payment plans for surgeries over $500. Talk to our staff to learn more.</p>
                        <a href="#">Learn more &rarr;</a>
                    </div>
                </div>
            </div> <!-- End Grid -->
        </main>
>>>>>>> Stashed changes

        <div class="form-actions" style="margin-top: 1.5rem;">
            <button type="submit" class="btn btn-primary">Tạo hóa đơn</button>
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="btn btn-secondary">Hủy</a>
        </div>
    </form>
</div>
</body>
</html>

