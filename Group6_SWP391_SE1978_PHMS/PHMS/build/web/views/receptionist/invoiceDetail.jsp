<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết hóa đơn - PHMS</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
        <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/receptionist/nav/navReceptionist.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/billingPetOwner.css" rel="stylesheet">
    </head>
    <body>
        <!-- LEFT SIDEBAR -->
        <c:set var="activePage" value="billing" scope="request" />
        <jsp:include page="nav/navReceptionist.jsp" />

        <!-- MAIN CONTENT -->
        <main class="main-content">
            <!-- Top Header -->
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </header>

            <!-- Page Title Section -->
            <div class="page-header">
                <div class="header-text">
                    <h1>Invoice Details</h1>
                    <p>Viewing records for Invoice #${invoice.invoiceId}</p>
                </div>
                <button class="btn-print" onclick="window.print()">
                    <i class="fa-solid fa-print"></i> Print Invoice
                </button>
            </div>

            <div class="billing-grid">
                <!-- LEFT COLUMN: INVOICE DETAILS -->
                <div class="invoice-card">
                    <div class="invoice-top">
                        <div>
                            <span class="invoice-label">INVOICE STATUS</span>
                            <h2 class="invoice-number">#${invoice.invoiceId}</h2>
                            <div class="invoice-date">Appointment ID: #${invoice.apptId}</div>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${invoice.status eq 'Paid'}">
                                    <span class="status-badge" style="background: #d1fae5; color: #065f46;">PAID</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge unpaid">UNPAID</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Thông tin bổ sung (nếu có trong object invoice) -->
                    <div class="customer-info-row">
                        <div class="info-group">
                            <label>PAYMENT STATUS</label>
                            <div class="info-value">${invoice.status}</div>
                        </div>
                        <div class="info-group">
                            <label>TOTAL AMOUNT</label>
                            <div class="info-value">
                                <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND "/>
                            </div>
                        </div>
                    </div>

                    <!-- Table Chi tiết -->
                    <table class="invoice-table">
                        <thead>
                            <tr>
                                <th>TYPE</th>
                                <th>ITEM ID / NAME</th>
                                <th class="text-center">QTY</th>
                                <th class="text-right">UNIT PRICE</th>
                                <th class="text-right">SUBTOTAL</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="calculatedSum" value="0" />
                            <c:forEach var="d" items="${details}">
                                <tr>
                                    <td><span class="badge ${d.itemType eq 'Service' ? 'bg-info' : 'bg-success'}">${d.itemType}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${d.itemType eq 'Service'}">${d.serviceId}</c:when>
                                            <c:otherwise>${d.medicineId}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">${d.quantity}</td>
                                    <td class="text-right">
                                        <fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol=""/>
                                    </td>
                                    <td class="text-right fw-bold">
                                        <c:set var="lineTotal" value="${d.quantity * d.unitPrice}" />
                                        <fmt:formatNumber value="${lineTotal}" type="currency" currencySymbol=""/>
                                        <c:set var="calculatedSum" value="${calculatedSum + lineTotal}" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="totals-section">
                        <div class="total-row grand-total">
                            <span>Grand Total</span>
                            <span class="amount-green">
                                <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND "/>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- RIGHT COLUMN: CHECKOUT (Chỉ hiện nếu chưa Paid) -->
                <div class="checkout-card">
                    <c:choose>
                        <c:when test="${invoice.status ne 'Paid'}">
                            <h3>Process Payment</h3>
                            <form action="${pageContext.request.contextPath}/payment" method="POST">
                                <input type="hidden" name="apptId" value="${invoice.apptId}"/>
                                <input type="hidden" name="grandTotal" value="${invoice.totalAmount}"/>
                                <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                                <input type="hidden" name="act" value="detail">
                                <div class="method-section">
                                    <label class="section-label">SELECT METHOD</label>

                                    <!-- Cash Option -->
                                    <label class="payment-option disabled">
                                        <input type="radio" name="method" value="Cash" checked>
                                        <div class="option-content">
                                            <div class="icon-box gray"><i class="fa-solid fa-wallet"></i></div>
                                            <div class="text-box">
                                                <span class="method-name">Cash</span>
                                                <span class="method-desc">Pay directly at counter</span>
                                            </div>
                                        </div>
                                    </label>

                                    <!-- Transfer/VNPay Option -->
                                    <label class="payment-option active">
                                        <input type="radio" name="method" value="Transfer">
                                        <div class="option-content">
                                            <div class="icon-box green"><i class="fa-solid fa-qrcode"></i></div>
                                            <div class="text-box">
                                                <span class="method-name">VNPay / Transfer</span>
                                                <span class="method-desc">Online banking or QR Code</span>
                                            </div>
                                        </div>
                                    </label>
                                </div>

                                <button type="submit" class="btn-pay">
                                    Confirm Payment: <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND "/>
                                </button>
                            </form>

                        </c:when>
                        <c:otherwise>
                            <!-- Hiển thị khi đã thanh toán -->
                            <div class="text-center py-4">
                                <div class="icon-box green" style="width: 60px; height: 60px; margin: 0 auto 1rem;">
                                    <i class="fa-solid fa-check-double fa-2x"></i>
                                </div>
                                <h3>Payment Completed</h3>
                                <p class="text-muted">This invoice has been fully settled. No further actions are required.</p>
                                <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="btn btn-secondary w-100">Back to Dashboard</a>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Lịch sử giao dịch bên dưới phần thanh toán -->
                    <div class="info-box mt-4">
                        <h5>Transaction History</h5>
                        <c:if test="${empty payments}">
                            <p class="small text-muted">No transactions recorded yet.</p>
                        </c:if>
                        <c:forEach var="p" items="${payments}">
                            <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                                <div>
                                    <small class="d-block fw-bold">${p.method}</small>
                                    <small class="text-muted">ID: #${p.paymentId}</small>
                                </div>
                                <div class="text-right">
                                    <small class="d-block fw-bold text-success">+ ${p.amount}</small>
                                    <small class="badge bg-light text-dark" style="font-size: 0.7rem;">${p.status}</small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>