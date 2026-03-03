<%-- 
    Document   : billingPetOwner
    Created on : Feb 3, 2026, 12:14:33 AM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Billing</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/billingPetOwner.css" rel="stylesheet">
    </head>
    <body>
        <!--Dashboard left-->
        <jsp:include page="nav/navPetOwner.jsp" />
        <!-- MAIN CONTENT -->
        <main class="main-content">
            <!-- Top Header (Sign Out) -->
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                    Logout
                </a>
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
                            <h2 class="invoice-number">INV-2026-001</h2>
                            <div class="invoice-date">Date: 2026-03-26</div>
                        </div>
                        <div>
                            <span class="status-badge unpaid">UNPAID</span>
                        </div>
                    </div>
                    <!-- Customer Info -->
                    <div class="customer-info-row">
                        <div class="info-group">
                            <label>OWNER NAME</label>
                            <div class="info-value">John Doe</div>
                        </div>
                        <div class="info-group">
                            <label>PET NAME</label>
                            <div class="info-value">Buddy</div>
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
                            <tr>
                                <td>General Examination</td>
                                <td class="text-center">1</td>
                                <td class="text-right">$75.00</td>
                                <td class="text-right fw-bold">$75.00</td>
                            </tr>
                            <tr>
                                <td>Rabies Vaccination</td>
                                <td class="text-center">1</td>
                                <td class="text-right">$25.00</td>
                                <td class="text-right fw-bold">$25.00</td>
                            </tr>
                            <tr>
                                <td>Deworming Medication</td>
                                <td class="text-center">1</td>
                                <td class="text-right">$15.50</td>
                                <td class="text-right fw-bold">$15.50</td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- Totals Section -->
                    <div class="totals-section">
                        <div class="total-row">
                            <span>Subtotal</span>
                            <span class="amount">$115.50</span>
                        </div>
                        <div class="total-row">
                            <span>Tax (8%)</span>
                            <span class="amount">$9.24</span>
                        </div>
                        <div class="total-row grand-total">
                            <span>Grand Total</span>
                            <span class="amount-green">$124.74</span>
                        </div>
                    </div>
                </div>
                <!-- RIGHT COLUMN: CHECKOUT -->
                <div class="checkout-card">
                    <h3>Checkout</h3>
                    <form action="processPayment" method="POST">
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
                            Pay $124.74
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