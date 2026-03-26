<%-- 
    Document   : paymentCreate
    Created on : Feb 3, 2026, 7:49:48 PM
    Author     : zoxy4
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán hóa đơn - PHMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/petOwner/billingPetOwner.css" rel="stylesheet">
</head>
<body>
    <nav class="sidebar">
        <div class="brand">
            <i class="fa-solid fa-plus-square"></i> VetCare Pro
        </div>

        <ul class="menu">
            <li>
                <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                    <i class="fa-solid fa-table-columns"></i> ${L == 'en' ? 'Dashboard' : 'Bảng điều khiển'}
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/receptionist/emergency/queue" class="text-danger">
                    <i class="fa-solid fa-truck-medical"></i> ${L == 'en' ? 'Emergency Triage' : 'Cấp cứu'}
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/receptionist/appointment">
                    <i class="fa-regular fa-calendar-check"></i> ${L == 'en' ? 'Appointments' : 'Cuộc hẹn'}
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/receptionist/invoice/create" class="active">
                    <i class="fa-regular fa-credit-card"></i> ${L == 'en' ? 'Billing' : 'Thanh toán'}
                </a>
            </li>
        </ul>

        <!-- Language Switcher -->
        <div style="padding: 12px; margin-top: auto;">
            <div style="display:flex; background:#f1f5f9; border-radius:8px; padding:3px; gap:2px;">
                <a href="${pageContext.request.contextPath}/language?lang=vi"
                   style="padding:5px 10px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; flex:1; text-align:center;
                          ${L == 'vi' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">VI</a>
                <a href="${pageContext.request.contextPath}/language?lang=en"
                   style="padding:5px 10px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; flex:1; text-align:center;
                          ${L == 'en' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">EN</a>
            </div>
        </div>

        <div class="help-box">
            <div class="help-text">${L == 'en' ? 'Need help?' : 'Cần hỗ trợ?'}</div>
            <a href="#" class="btn-contact">${L == 'en' ? 'Contact Support' : 'Liên hệ hỗ trợ'}</a>
        </div>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <div class="header-text">
                <h1>Payment Gateway</h1>
                <p>Select a payment method for Invoice #${invoice.invoiceId}</p>
            </div>
        </div>

        <div class="billing-grid" style="display: flex; justify-content: center;">
            <div class="checkout-card" style="width: 100%; max-width: 600px;">
                
                <div class="alert alert-info">
                    <div class="d-flex justify-content-between">
                        <strong>Invoice ID:</strong>
                        <span>#${invoice.invoiceId}</span>
                    </div>
                    <div class="d-flex justify-content-between mt-2">
                        <strong>Total Amount:</strong>
                        <span class="fs-4 fw-bold text-primary">
                            <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND "/>
                        </span>
                    </div>
                </div>

                <h3>Select Payment Method</h3>
                
                <form action="${pageContext.request.contextPath}/receptionist/payment/create" method="POST">
                    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}"/>
                    
                    <div class="method-section">
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="cash">
                            <div class="option-content">
                                <div class="icon-box gray">
                                    <i class="fa-solid fa-wallet"></i>
                                </div>
                                <div class="text-box">
                                    <span class="method-name">Cash / POS</span>
                                    <span class="method-desc">Pay directly at the counter</span>
                                </div>
                            </div>
                        </label>

                        <label class="payment-option active">
                            <input type="radio" name="paymentMethod" value="vnpay" checked>
                            <div class="option-content">
                                <div class="icon-box green">
                                    <i class="fa-solid fa-qrcode"></i>
                                </div>
                                <div class="text-box">
                                    <span class="method-name">VNPay / Banking</span>
                                    <span class="method-desc">Scan QR Code instantly</span>
                                </div>
                            </div>
                        </label>
                    </div>

                    <button type="submit" class="btn-pay mt-4">
                        Confirm Payment
                    </button>
                </form>
            </div>
        </div>
    </main>
</body>
</html>