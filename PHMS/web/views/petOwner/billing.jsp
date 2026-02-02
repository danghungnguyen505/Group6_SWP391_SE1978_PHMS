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

        <c:set var="subtotal" value="0" />
        <c:forEach items="${details}" var="d">
            <div class="invoice-row">
                <span>${d.serviceName}</span>
                <span>${d.quantity}</span>
                <span>$${d.unitPrice}</span>
                <span class="bold">$${d.subtotal}</span>
            </div>
            <c:set var="subtotal" value="${subtotal + d.subtotal}" />
        </c:forEach>

        <c:set var="tax" value="${subtotal * 0.08}" />
        <c:set var="grandTotal" value="${subtotal + tax}" />

        <div class="invoice-summary">
            <div>
                <span>Subtotal</span>
                <span>$${subtotal}</span>
            </div>
            <div>
                <span>Tax (8%)</span>
                <span>$${tax}</span>
            </div>
            <div class="grand-total">
                <span>Grand Total</span>
                <span>$${grandTotal}</span>
            </div>
        </div>
    </div>

    <!-- CHECKOUT CARD -->
    <div class="card checkout-card">
        <h3>Checkout</h3>
        <p class="section-title">Select Method</p>

        <button type="button" class="payment-method" id="cashBtn">
            <i class="fa-solid fa-money-bill"></i>
            <div>
                <strong>Cash / POS</strong>
                <p>Pay at the reception desk</p>
            </div>
        </button>

        <button type="button" class="payment-method" id="qrBtn">
            <i class="fa-solid fa-qrcode"></i>
            <div>
                <strong>Online / VNPay</strong>
                <p>Scan QR code instantly</p>
            </div>
        </button>

        <!-- QR BOX -->
        <div id="qrBox" style="display:none; margin:16px 0; text-align:center;">
            <p style="font-weight:600;">Scan to pay with VNPay</p>
            <div id="qrcode"></div>
        </div>

        <button class="btn-pay" id="payBtn">
            Pay $${grandTotal}
        </button>
    </div>
</div>

<!-- QR LIB -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

<script>
    let selectedMethod = null;

    const cashBtn = document.getElementById("cashBtn");
    const qrBtn = document.getElementById("qrBtn");
    const qrBox = document.getElementById("qrBox");
    const payBtn = document.getElementById("payBtn");

    function resetButtons() {
        cashBtn.classList.remove("selected");
        qrBtn.classList.remove("selected");
        qrBox.style.display = "none";
    }

    cashBtn.onclick = () => {
        resetButtons();
        selectedMethod = "CASH";
        cashBtn.classList.add("selected");
    };

    qrBtn.onclick = () => {
        resetButtons();
        selectedMethod = "QR";
        qrBtn.classList.add("selected");
        qrBox.style.display = "block";

        document.getElementById("qrcode").innerHTML = "";
        new QRCode(document.getElementById("qrcode"), {
            text: "http://192.168.4.198:8080${pageContext.request.contextPath}/vnpay-create?invoiceId=${invoice.invoiceId}",

            width: 220,
            height: 220
        });
    };

    payBtn.onclick = () => {
        if (!selectedMethod) {
            alert("Please select a payment method first");
            return;
        }

        if (selectedMethod === "CASH") {
            window.location.href = "${pageContext.request.contextPath}/pay-cash?invoiceId=${invoice.invoiceId}";
        } else {
            alert("Scan the QR with VNPay app to complete payment.");
        }
    };
</script>
