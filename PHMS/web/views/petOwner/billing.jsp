<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/billing.css">

<div class="page-header">
    <div>
        <h2>Billing & Checkout</h2>
        <p class="sub-text">Review details and complete payment for your recent visit.</p>
    </div>
   <button class="btn-outline" onclick="window.print()">
    <i class="fa-solid fa-print"></i> Print Invoice
</button>
</div>

<div class="billing-layout">

    <!-- INVOICE CARD -->
    <div class="card invoice-card">
        <div class="invoice-header">
            <span class="badge">Invoice Details</span>
            <c:choose>
    <c:when test="${invoice.status eq 'UNPAID'}">
        <span class="status-badge unpaid">UNPAID</span>
    </c:when>
    <c:otherwise>
        <span class="status-badge paid">${invoice.status}</span>
    </c:otherwise>
</c:choose>

        </div>

        <h3>INV-${invoice.invoiceId}</h3>
    

        <div class="invoice-meta">
            <div>
                <label>Owner Name</label>
                <p>${invoice.ownerName}</p>
            </div>
            <div>
                <label>Pet Name</label>
                <p>${invoice.petName}</p>
            </div>
        </div>

        <div class="invoice-table-header">
            <span>Service / Item</span>
            <span>Qty</span>
            <span>Unit Price</span>
            <span>Subtotal</span>
        </div>

        <c:forEach items="${details}" var="d">
            <div class="invoice-row">
                <span>${d.serviceName}</span>
                <span>${d.quantity}</span>
                <span>${d.unitPrice}</span>
                <span class="bold">${d.subtotal}</span>
            </div>
        </c:forEach>

        <div class="invoice-summary">
            <div>
                <span>Subtotal</span>
             
            </div>
            <div>
                <span>Tax (8%)</span>
   
            </div>
            <div class="grand-total">
                <span>Grand Total</span>
                <span>${invoice.totalAmount}</span>
            </div>
        </div>
    </div>

    <!-- CHECKOUT CARD -->
    <div class="card checkout-card">
        <h3>Checkout</h3>

        <p class="section-title">Select Method</p>

        <form action="pay-cash" method="post">
            <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
            <button class="payment-method">
                <i class="fa-solid fa-money-bill"></i>
                <div>
                    <strong>Cash / POS</strong>
                    <p>Pay at the reception desk</p>
                </div>
            </button>
        </form>

        <form action="qr-payment" method="get">
            <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
            <button class="payment-method qr">
                <i class="fa-solid fa-qrcode"></i>
                <div>
                    <strong>Online / VN Pay</strong>
                    <p>Scan QR code instantly</p>
                </div>
            </button>
        </form>

        <div class="discount-box">
            <input type="text" placeholder="Enter code">
            <button class="btn-apply">Apply</button>
        </div>

        <button class="btn-pay">
            Pay ${invoice.totalAmount}
        </button>
    </div>

</div>
