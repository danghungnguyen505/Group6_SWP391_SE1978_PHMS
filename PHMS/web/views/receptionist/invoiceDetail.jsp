<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết hóa đơn - PHMS</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/billingPetOwner.css" rel="stylesheet">
        <style>
            /* ===== MODAL VIETQR - BANKING APP STYLE ===== */
#vietqrModal {
    padding: 0 !important;
}

#vietqrModal .modal-dialog {
    max-width: 2000px;
    width: 95%;
    margin: 0;
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}

#vietqrModal .modal-backdrop {
    position: fixed;
}

#vietqrModal .modal-content {
    border-radius: 20px;
    border: none;
    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
}

/* ===== HEADER ===== */
#vietqrModal .modal-header {
    background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
    color: white;
    padding: 20px 40px 20px 25px;
    border-bottom: none;
    border-radius: 20px 20px 0 0;
    position: relative;
}

#vietqrModal .modal-header .modal-title {
    font-size: 28px;
    font-weight: 700;
    width: 100%;
    text-align: center;
    color: #ffffff;
}

#vietqrModal .qr-modal-close {
    position: absolute;
    right: 15px;
    top: 50%;
    transform: translateY(-50%);
    width: 36px;
    height: 36px;
    padding: 0;
    background: rgba(255,255,255,0.25);
    border-radius: 50%;
    border: none;
    cursor: pointer;
    font-size: 24px;
    color: white;
    line-height: 36px;
    text-align: center;
    z-index: 1;
}

#vietqrModal .qr-modal-close:hover {
    background: rgba(255,255,255,0.4);
}

/* ===== BODY LAYOUT 2 CỘT ===== */
#vietqrModal .modal-body {
    display: flex;
    gap: 30px;
    padding: 20px;
    min-height: 50vh;
}

/* ===== LEFT: QR ===== */
#vietqrModal .qr-section {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 20px;
    border-radius: 16px;
}

#vietqrModal .qr-wrapper {
    background: white;
    padding: 20px;
    border-radius: 16px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

#vietqrModal .qr-wrapper img {
    width: 300px;
    height: 300px;
    display: block;
}

#vietqrModal .qr-note {
    margin-top: -30px;
    font-size: 14px;
    color: #495057;
    font-weight: 500;
}

/* ===== RIGHT: INFO ===== */
#vietqrModal .info-section {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 10px;
}

#vietqrModal .payment-title-center {
    font-size: 22px;
    font-weight: 700;
    text-align: center;
    margin-bottom: 25px;
    color: #1a73e8;
}

#vietqrModal .payment-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 0;
    border-bottom: 1px solid #e9ecef;
}

#vietqrModal .payment-item:last-child {
    border-bottom: none;
}

#vietqrModal .payment-item span:first-child {
    color: #6c757d;
    font-size: 15px;
    font-weight: 500;
}

#vietqrModal .payment-item strong {
    font-size: 16px;
    color: #212529;
    text-align: right;
}

#vietqrModal .payment-item .amount-highlight {
    color: #198754 !important;
    font-size: 16px !important;
    font-weight: 700;
    text-align: right;
    white-space: nowrap;
}

#vietqrModal .payment-item .ref-highlight {
    color: #1a73e8 !important;
    font-weight: 600;
    text-align: right;
}

/* ===== FOOTER ===== */
#vietqrModal .modal-footer {
    padding: 20px 40px;
    background: #f8f9fa;
    border-top: 1px solid #e9ecef;
    border-radius: 0 0 20px 20px;
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    gap: 20px;
}

#vietqrModal .modal-footer .btn {
    flex: 1;
    border-radius: 12px;
    padding: 14px 24px;
    font-weight: 600;
    font-size: 15px;
    white-space: nowrap;
    text-align: center;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* ===== BUTTONS ===== */
#vietqrModal .btn-confirm-paid {
    background-color: #198754;
    color: white;
    border: none;
}

#vietqrModal .btn-confirm-paid:hover {
    background-color: #157347;
}

#vietqrModal .btn-vnpay-custom {
    background-color: #1a73e8;
    color: white;
    border: none;
}

#vietqrModal .btn-vnpay-custom:hover {
    background-color: #1557b0;
}

/* ===== RESPONSIVE ===== */
@media (max-width: 768px) {
    #vietqrModal .modal-body {
        flex-direction: column;
        padding: 20px;
    }

    #vietqrModal .qr-section {
        padding: 15px;
    }

    #vietqrModal .qr-wrapper img {
        width: 220px;
        height: 220px;
    }
}

            /* Fix alignment: pet name, type, total amount thẳng hàng với ITEM NAME (cột 2) */
            .customer-info-row .info-group:first-child {
                flex: 0 0 25% !important;
            }
            .customer-info-row .info-group:last-child {
                flex: 0 0 25% !important;
            }

            /* Fix grand total lùi hết trái */
            .totals-section {
                padding-left: 0 !important;
                align-items: flex-start !important;
            }
            .total-row {
                width: 100% !important;
                justify-content: space-between !important;
            }

            /* Print-only: ẩn khi xem, hiện khi in */
            .print-only {
                display: none;
            }

            /* PRINT STYLES - Chỉ in main content */
            @media print {
                body {
                    background: white !important;
                    margin: 0 !important;
                    padding: 0 !important;
                }
                .sidebar, .top-bar, .page-header, .checkout-card, .btn-print,
                .modal, .modal-backdrop, nav.sidebar, header.top-bar {
                    display: none !important;
                    visibility: hidden !important;
                }
                .main-content {
                    margin: 0 !important;
                    padding: 40px !important;
                    width: 100% !important;
                    max-width: 100% !important;
                    box-shadow: none !important;
                }
                .billing-grid {
                    display: block !important;
                    padding: 0 !important;
                }
                .invoice-card {
                    box-shadow: none !important;
                    border: none !important;
                    border-radius: 0 !important;
                    break-inside: avoid;
                }
                .print-header {
                    display: block !important;
                    border-bottom: 3px solid #10b981 !important;
                    padding-bottom: 15px !important;
                }
                .print-only {
                    display: block !important;
                }
                .invoice-top {
                    background: #f8f9fa !important;
                    padding: 15px !important;
                    border-radius: 8px !important;
                    border-bottom: none !important;
                    margin-bottom: 15px !important;
                    -webkit-print-color-adjust: exact !important;
                    print-color-adjust: exact !important;
                }
                .invoice-number {
                    font-size: 24px !important;
                }
                .invoice-date {
                    font-size: 14px !important;
                }
                .invoice-table {
                    font-size: 12px !important;
                }
                .invoice-table th, .invoice-table td {
                    padding: 10px 8px !important;
                }
                .totals-section {
                    page-break-inside: avoid;
                    margin-top: 20px !important;
                    padding-left: 0 !important;
                    align-items: flex-start !important;
                }
                .total-row {
                    width: 100% !important;
                    justify-content: space-between !important;
                }
                .grand-total {
                    font-size: 20px !important;
                    padding-top: 10px !important;
                    border-top: 2px solid #10b981 !important;
                }
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
                    <!-- Print-only: VetCare Pro + HÓA ĐƠN header -->
                    <div class="print-header" style="text-align:center; margin-bottom:20px; display:none;">
                        <div style="font-size:28px; font-weight:800; color:#10b981; letter-spacing:1px;">
                            <i class="fa-solid fa-plus-square"></i> VetCare Pro
                        </div>
                        <div style="font-size:32px; font-weight:700; margin:10px 0 0 0; text-transform:uppercase;">
                            ${L == 'en' ? 'INVOICE' : 'HÓA ĐƠN'}
                        </div>
                    </div>

                    <div class="invoice-top">
                        <div>
                            <span class="invoice-label">INVOICE STATUS</span>
                            <h2 class="invoice-number">#${invoice.invoiceId}</h2>
                            <div class="invoice-date print-only">Appointment ID: #${invoice.apptId}</div>
                            <div class="invoice-date print-only">
                                ${L == 'en' ? 'Staff' : 'Nhân viên'}: <c:out value="${staffName}"/> |
                                Date: <c:out value="${invoiceDate}"/> |
                                ${L == 'en' ? 'Time' : 'Giờ'}: <c:out value="${invoiceTime}"/>
                            </div>
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
                            <label>OWNER NAME</label>
                            <div class="info-value"><c:out value="${appt.ownerName}" default="-"/></div>
                        </div>
                        <div class="info-group">
                            <label>PET NAME</label>
                            <div class="info-value"><c:out value="${appt.petName}" default="-"/></div>
                        </div>
                    </div>
                    <div class="customer-info-row" style="margin-top:10px;">
                        <div class="info-group">
                            <label>VETERINARIAN</label>
                            <div class="info-value"><c:out value="${appt.vetName}" default="-"/></div>
                        </div>
                        <div class="info-group">
                            <label>TYPE</label>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${appt.type == 'Urgent'}">
                                        <span style="color:#dc2626; font-weight:600;">Emergency</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${appt.type}" default="-"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <div class="customer-info-row" style="margin-top:10px;">
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
                                <th>ITEM NAME</th>
                                <th style="text-align: right;">QTY</th>
                                <th style="text-align: right;">UNIT PRICE</th>
                                <th style="text-align: right;">SUBTOTAL</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="calculatedSum" value="0" />
                            <c:forEach var="d" items="${details}">
                                <tr>
                                    <td><span class="badge ${d.itemType eq 'Service' ? 'bg-info' : 'bg-success'}">${d.itemType}</span></td>
                                    <td>${d.itemName}</td>
                                    <td class="text-right">${d.quantity}</td>
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

                    <c:set var="invoiceSubtotal" value="${invoice.totalAmount / 1.1}" />
                    <c:set var="invoiceVat" value="${invoice.totalAmount - invoiceSubtotal}" />
                    <div class="totals-section">
                        <div class="total-row"><span>Subtotal</span><span class="amount"><fmt:formatNumber value="${invoiceSubtotal}" type="currency" currencySymbol="VND "/></span></div>
                        <div class="total-row"><span>VAT (10%)</span><span class="amount"><fmt:formatNumber value="${invoiceVat}" type="currency" currencySymbol="VND "/></span></div>
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
                                    <i class="fa-solid fa-circle-check fa-2x text-success"></i>
                                </div>
                                <h3>Payment Completed</h3>
                                <p class="text-muted">This invoice has been fully settled.<br>No further actions are required.</p>
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
        
        <!-- MODAL VIETQR -->
        <div class="modal fade" id="vietqrModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">

                    <!-- HEADER -->
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Thanh toán VietQR</h5>
                        <button type="button" class="qr-modal-close" data-bs-dismiss="modal" aria-label="Close">&times;</button>
                    </div>

                    <!-- BODY -->
                    <div class="modal-body">

                        <!-- LEFT QR -->
                        <div class="qr-section">
                            <div class="qr-wrapper">
                                <img src="https://img.vietqr.io/image/techcombank-1999992707-compact.png?amount=${invoice.totalAmount}&addInfo=INV${invoice.invoiceId}&accountName=PHAM CONG HUY"
                                     alt="QR">
                            </div>
                            <div class="qr-note">Quét mã QR để thanh toán</div>
                        </div>

                        <!-- RIGHT INFO -->
                        <div class="info-section">
                            <div class="payment-title-center">Thông tin thanh toán</div>

                            <div class="payment-item">
                                <span>Ngân hàng</span>
                                <strong>Techcombank</strong>
                            </div>

                            <div class="payment-item">
                                <span>Số tài khoản</span>
                                <strong>1999992707</strong>
                            </div>

                            <div class="payment-item">
                                <span>Chủ tài khoản</span>
                                <strong>PHAM CONG HUY</strong>
                            </div>

                            <div class="payment-item">
                                <span>Số tiền</span>
                                <strong class="amount-highlight">
                                    <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND "/>
                                </strong>
                            </div>

                            <div class="payment-item">
                                <span>Nội dung chuyển khoản</span>
                                <strong class="ref-highlight">INV${invoice.invoiceId}</strong>
                            </div>
                        </div>

                    </div>

                    <!-- FOOTER -->
                    <div class="modal-footer">
                        <button type="button"
                                class="btn btn-confirm-paid"
                                onclick="confirmCustomerPaid(event)">
                            Khách hàng đã thanh toán
                        </button>

                        <button type="button"
                                class="btn btn-vnpay-custom"
                                onclick="payWithVnpayGateway()">
                            Thanh toán qua VNPay
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

            function confirmCustomerPaid(event) {
                const ok = window.confirm("Xác nhận khách hàng đã thanh toán đầy đủ cho hóa đơn này?");
                if (!ok) {
                    // Chặn đóng modal nếu người dùng chọn Hủy
                    if (event) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    return false;
                }
                var methodInput = document.getElementById('paymentMethodInput');
                methodInput.value = 'cash';
                document.getElementById('paymentForm').submit();
                return true;
            }

            function payWithVnpayGateway() {
                var methodInput = document.getElementById('paymentMethodInput');
                methodInput.value = 'vnpay';
                document.getElementById('paymentForm').submit();
            }
        </script>
    <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>


