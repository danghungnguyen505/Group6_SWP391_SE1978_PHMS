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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/billingPetOwner.css" rel="stylesheet">
        <style>
            /* Style popup VietQR đồng bộ với trang tạo hóa đơn */
            .qr-wrapper {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 15px;
                border: 2px dashed #dee2e6;
                display: inline-block;
            }
            .modal-content {
                border-radius: 20px;
                border: none;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            }
            .btn-vnpay-custom {
                background-color: #005baa;
                color: white;
                border: none;
            }
            .btn-vnpay-custom:hover {
                background-color: #004480;
                color: white;
            }
            .payment-info-list {
                margin-top: 1.5rem;
            }
            .payment-title-center {
                font-size: 20px; /* Chữ to hơn */
                font-weight: 700;
                text-align: center; /* Căn giữa */
                margin-bottom: 10px;
                display: block; /* Đảm bảo chiếm hết chiều ngang để căn giữa */
            }

            .payment-item {
                display: flex;
                justify-content: space-between; /* Đẩy nội dung sang 2 bên */
                padding: 10px 0;
                border-bottom: 1px solid #eee; /* Đường kẻ mờ giữa các dòng */
            }

            .payment-item:last-child {
                border-bottom: none; /* Dòng cuối không cần gạch chân */
            }

            .payment-item span:first-child {
                color: #666; /* Màu nhạt hơn cho tiêu đề bên trái (tùy chọn) */
            }

            .payment-item strong {
                text-align: right;
            }
        </style>
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
                <li>
                </li>
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
                            <form id="paymentForm"
                                  action="${pageContext.request.contextPath}/receptionist/payment/create"
                                  method="POST">
                                <input type="hidden" name="invoiceId" value="${invoice.invoiceId}"/>
                                <input type="hidden" name="paymentMethod" id="paymentMethodInput" value="vnpay"/>

                                <div class="method-section">
                                    <label class="section-label">SELECT METHOD</label>

                                    <!-- Cash Option (manual confirm sau khi khách quét QR) -->
                                    <label class="payment-option disabled">
                                        <input type="radio" name="paymentMethodRadio" value="cash" disabled>
                                        <div class="option-content">
                                            <div class="icon-box gray"><i class="fa-solid fa-wallet"></i></div>
                                            <div class="text-box">
                                                <span class="method-name">Cash / POS</span>
                                                <span class="method-desc">Pay at the reception</span>
                                            </div>
                                        </div>
                                    </label>

                                    <!-- VNPay / VietQR Option -->
                                    <label class="payment-option active">
                                        <input type="radio" name="paymentMethodRadio" value="vnpay" checked>
                                        <div class="option-content">
                                            <div class="icon-box green"><i class="fa-solid fa-qrcode"></i></div>
                                            <div class="text-box">
                                                <span class="method-name">Online / VietQR / VNPay</span>
                                                <span class="method-desc">Scan QR Code instantly</span>
                                            </div>
                                        </div>
                                    </label>
                                </div>

                                <button type="button" class="btn-pay" onclick="openVietqrModal()">
                                    Pay
                                    <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND "/>
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
        
        <!-- MODAL VIETQR (đồng bộ với trang tạo hóa đơn) -->
        <div class="modal fade" id="vietqrModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Thanh toán VietQR</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <p class="mb-3">
                            Vui lòng quét mã QR để thanh toán:<br>
                            <span class="fs-4 fw-bold text-success">
                                <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND "/>
                            </span>
                        </p>

                        <div class="qr-wrapper mb-3">
                            <img src="https://img.vietqr.io/image/techcombank-1999992707-compact.png?amount=${invoice.totalAmount}&addInfo=INV${invoice.invoiceId}&accountName=PHAM CONG HUY"
                                 alt="VietQR" class="img-fluid" style="width: 280px;">
                        </div>

                        <div class="alert alert-light border-0 small">
                            <div class="payment-info-list">
                                <span class="payment-title-center"> Thông tin thanh toán</span>


                                <div class="payment-item">
                                    <span>Số tiền:</span>
                                    <strong class="text-success">
                                        <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND "/>
                                    </strong>
                                </div>

                                <div class="payment-item">
                                    <span>Nội dung CK:</span>
                                    <strong class="text-primary">INV${invoice.invoiceId}</strong>
                                </div>
                                <div class="payment-item">
                                    <span>Ngân hàng:</span>
                                    <strong>Techcombank</strong>
                                </div>

                                <div class="payment-item">
                                    <span>Số TK:</span>
                                    <strong>1999992707</strong>
                                </div>

                                <div class="payment-item">
                                    <span>Chủ TK:</span>
                                    <strong>PHAM CONG HUY</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 flex-column">
                        <button type="button"
                                class="btn btn-success w-100 py-2 fw-bold"
                                onclick="confirmCustomerPaid()">
                            Khách hàng đã thanh toán
                        </button>
                        <button type="button"
                                class="btn btn-vnpay-custom w-100 py-2"
                                onclick="payWithVnpayGateway()">
                            Thanh toán qua cổng VNPay <i class="fa-solid fa-chevron-right ms-1"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- SCRIPTS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function openVietqrModal() {
                var myModal = new bootstrap.Modal(document.getElementById('vietqrModal'));
                myModal.show();
            }

            function confirmCustomerPaid() {
                // Xác nhận lại để tránh click nhầm
                const ok = window.confirm("Xác nhận khách hàng đã thanh toán đầy đủ cho hóa đơn này?");
                if (!ok) {
                    return;
                }
                // Ghi nhận khách đã thanh toán (Cash/manual) => cập nhật status Paid
                var methodInput = document.getElementById('paymentMethodInput');
                methodInput.value = 'cash';
                document.getElementById('paymentForm').submit();
            }

            function payWithVnpayGateway() {
                // Chuyển qua luồng VNPay chính thức
                var methodInput = document.getElementById('paymentMethodInput');
                methodInput.value = 'vnpay';
                document.getElementById('paymentForm').submit();
            }
        </script>
    </body>
</html>