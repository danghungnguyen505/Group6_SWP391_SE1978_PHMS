<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tạo hóa đơn - PHMS</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
        <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/billingPetOwner.css" rel="stylesheet">
    </head>
    <body>
        <!-- LEFT SIDEBAR -->
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>

            <ul class="menu">
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="active">
                        <i class="fa-solid fa-table-columns"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="text-danger">
                        <i class="fa-solid fa-truck-medical"></i> Emergency Triage
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/scheduling">
                        <i class="fa-solid fa-truck-medical"></i> Staff Scheduling
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/appointment">
                        <i class="fa-regular fa-calendar-check"></i> Appointments
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-paw"></i> My Pets
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-file-medical"></i> Medical Records
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-regular fa-credit-card"></i> Billing
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-gear"></i> Administration
                    </a>
                </li>
            </ul>

            <div class="help-box">
                <div class="help-text">Need help?</div>
                <a href="#" class="btn-contact">Contact Support</a>
            </div>
        </nav>
        <!-- MAIN CONTENT -->
        <main class="main-content">
            <!-- Top Header (Sign Out) -->
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </header>
            <!-- Page Title Section -->
            <div class="page-header">
                <div class="header-text">
                    <h1>Billing & Checkout</h1>
                    <p>Review details and complete payment for your recent visit.</p>
                </div>
                <button class="btn-print">
                    <i class="fa-solid fa-print"></i> Print Invoice
                </button>
            </div>
            <!-- Layout Grid -->
            <div class="billing-grid">
                <!-- LEFT COLUMN: INVOICE DETAILS -->
                <div class="invoice-card">

                    <!-- Invoice Header -->
                    <div class="invoice-top">
                        <div>
                            <span class="invoice-label">INVOICE DETAILS</span>
                            <h2 class="invoice-number">
                                <c:out value="${invoiceNumber != null ? invoiceNumber : 'INV-DRAFT'}"/>
                            </h2>
                            <div class="invoice-date">
                                Date:
                                <c:out value="${invoiceDate != null ? invoiceDate : ''}"/>
                            </div>
                        </div>
                        <div>
                            <span class="status-badge unpaid">UNPAID</span>
                        </div>
                    </div>
                    <!-- Customer Info -->
                    <div class="customer-info-row">
                        <div class="info-group">
                            <label>OWNER NAME</label>
                            <div class="info-value">
                                <c:out value="${appt.ownerName}"/>
                            </div>
                        </div>
                        <div class="info-group">
                            <label>PET NAME</label>
                            <div class="info-value">
                                <c:out value="${appt.petName}"/>
                            </div>
                        </div>
                    </div>
                    <!-- Line Items Table -->
                    <table class="invoice-table">
                        <thead>
                            <tr>
                                <th style="width: 50%;">SERVICE / ITEM</th>
                                <th style="text-align: center;">QTY</th>
                                <th style="text-align: right;">UNIT PRICE</th>
                                <th style="text-align: right;">SUBTOTAL</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty mainService}">
                                    <tr>
                                        <td>
                                            <c:out value="${mainService.name}"/>
                                        </td>
                                        <td class="text-center">1</td>
                                        <td class="text-right">
                                            <fmt:formatNumber value="${mainService.basePrice}" type="currency" currencySymbol="$"/>
                                        </td>
                                        <td class="text-right fw-bold">
                                            <fmt:formatNumber value="${mainService.basePrice}" type="currency" currencySymbol="$"/>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" style="text-align:center; color:#6b7280;">
                                            No billable service found for this appointment type.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>

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

    </body>
</html>

