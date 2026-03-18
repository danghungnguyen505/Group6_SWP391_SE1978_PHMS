<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tạo hóa đơn - PHMS</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
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
            .payment-info-list {
                margin-top: 1.5rem;
            }

            /* Fix alignment: pet name & type thẳng hàng */
            .customer-info-row .info-group:first-child {
                flex: 0 0 25%;
            }
            .customer-info-row .info-group:last-child {
                flex: 0 0 auto;
            }
            .customer-info-row {
                gap: 0px !important;
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
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </header>

            <div class="page-header">
                <div class="header-text">
                    <h1>Billing & Checkout</h1>
                    <p>Review details and complete payment for your recent visit.</p>
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
                            <span class="invoice-label">INVOICE DETAILS</span>
                            <!-- Invoice number, Date, Staff, Time - chỉ hiện khi in -->
                            <div class="invoice-date print-only">
                                <h2 class="invoice-number">
                                    <c:out value="${invoiceNumber != null ? invoiceNumber : 'INV-DRAFT'}"/>
                                </h2>
                            </div>
                            <div class="invoice-date print-only">
                                Date: <c:out value="${invoiceDate != null ? invoiceDate : ''}"/>
                            </div>
                            <div class="invoice-date print-only">
                                ${L == 'en' ? 'Staff' : 'Nhân viên'}: <c:out value="${staffName != null ? staffName : 'Receptionist'}"/> |
                                ${L == 'en' ? 'Time' : 'Giờ'}: <c:out value="${invoiceTime != null ? invoiceTime : ''}"/>
                            </div>
                        </div>
                        <div><span class="status-badge unpaid">UNPAID</span></div>
                    </div>

                    <div class="customer-info-row">
                        <div class="info-group">
                            <label>OWNER NAME</label>
                            <div class="info-value"><c:out value="${appt.ownerName}"/></div>
                        </div>
                        <div class="info-group">
                            <label>PET NAME</label>
                            <div class="info-value"><c:out value="${appt.petName}"/></div>
                        </div>
                    </div>
                    <div class="customer-info-row" style="margin-top:10px;">
                        <div class="info-group">
                            <label>VETERINARIAN</label>
                            <div class="info-value"><c:out value="${appt.vetName}"/></div>
                        </div>
                        <div class="info-group">
                            <label>TYPE</label>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${appt.type == 'Urgent'}">
                                        <span style="color:#dc2626; font-weight:600;">Emergency</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${appt.type}"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

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
                                        <td><c:out value="${mainService.name}"/></td>
                                        <td class="text-center">1</td>
                                        <td class="text-right"><fmt:formatNumber value="${mainService.basePrice}" type="currency" currencySymbol="VND "/></td>
                                        <td class="text-right fw-bold"><fmt:formatNumber value="${mainService.basePrice}" type="currency" currencySymbol="VND "/></td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="4" class="text-center text-muted">No billable service found.</td></tr>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty prescriptions}">
                                <c:forEach var="p" items="${prescriptions}">
                                    <tr>
                                        <td><c:out value="${p.medicineName}"/></td>
                                        <td class="text-center"><c:out value="${p.quantity}"/></td>
                                        <td class="text-right"><fmt:formatNumber value="${p.medicinePrice}" type="currency" currencySymbol="VND "/></td>
                                        <td class="text-right fw-bold"><fmt:formatNumber value="${p.quantity * p.medicinePrice}" type="currency" currencySymbol="VND "/></td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                        </tbody>
                    </table>

                    <div class="totals-section">
                        <div class="total-row"><span>Subtotal</span><span class="amount"><fmt:formatNumber value="${subtotal != null ? subtotal : 0}" type="currency" currencySymbol="VND "/></span></div>
                        <div class="total-row"><span>Tax (8%)</span><span class="amount"><fmt:formatNumber value="${tax != null ? tax : 0}" type="currency" currencySymbol="VND "/></span></div>
                        <div class="total-row grand-total"><span>Grand Total</span><span class="amount-green"><fmt:formatNumber value="${grandTotal != null ? grandTotal : 0}" type="currency" currencySymbol="VND "/></span></div>
                    </div>
                </div>

                <!-- RIGHT COLUMN: CHECKOUT -->
                <div class="checkout-card">
                    <h3>Checkout</h3>
                    <form id="paymentForm" action="${pageContext.request.contextPath}/payment" method="POST">
                        <input type="hidden" name="apptId" value="${param.apptId}"/>
                        <input type="hidden" name="grandTotal" value="${grandTotal}"/>
                        <input type="hidden" name="act" value="create">
                        <input type="hidden" name="manualPaid" id="manualPaid" value="false">

                        <div class="method-section">
                            <label class="section-label">SELECT METHOD</label>
                            <label class="payment-option disabled">
                                <input type="radio" name="paymentMethod" value="cash" disabled>
                                <div class="option-content">
                                    <div class="icon-box gray"><i class="fa-solid fa-wallet"></i></div>
                                    <div class="text-box"><span class="method-name">Cash / POS</span><span class="method-desc">Pay at the reception</span></div>
                                </div>
                            </label>
                            <label class="payment-option active">
                                <input type="radio" name="paymentMethod" value="vnpay" checked>
                                <div class="option-content">
                                    <div class="icon-box green"><i class="fa-solid fa-qrcode"></i></div>
                                    <div class="text-box"><span class="method-name">Online / VietQR / VNPay</span><span class="method-desc">Scan QR Code instantly</span></div>
                                </div>
                            </label>
                        </div>

                        <div class="discount-section">
                            <label class="section-label">DISCOUNT CODE</label>
                            <div class="input-group">
                                <input type="text" placeholder="Enter code" class="discount-input">
                                <button type="button" class="btn-apply">Apply</button>
                            </div>
                        </div>

                        <button type="button" class="btn-pay" onclick="handlePayment()">
                            Pay <fmt:formatNumber value="${grandTotal != null ? grandTotal : 0}" type="currency" currencySymbol="VND "/>
                        </button>
                    </form>

                    <div class="info-box mt-4">
                        <h5>Need an Installment Plan?</h5>
                        <p>We offer 0% interest payment plans for large bills.</p>
                        <a href="#">Learn more &rarr;</a>
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
                                <img src="https://img.vietqr.io/image/techcombank-1999992707-compact.png?amount=${grandTotal}&addInfo=DH${param.apptId}&accountName=PHAM CONG HUY"
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
                                    <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="VND "/>
                                </strong>
                            </div>

                            <div class="payment-item">
                                <span>Nội dung chuyển khoản</span>
                                <strong class="ref-highlight">DH${param.apptId}</strong>
                            </div>
                        </div>

                    </div>

                    <!-- FOOTER -->
                    <div class="modal-footer">
                        <button type="button"
                                class="btn btn-confirm-paid"
                                onclick="confirmCustomerPaidCreate(event)">
                            Khách hàng đã thanh toán
                        </button>

                        <button type="button"
                                class="btn btn-vnpay-custom"
                                onclick="submitForm()">
                            Thanh toán qua VNPay
                        </button>
                    </div>

                </div>
            </div>
        </div>

        <!-- SCRIPTS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            var vietqrModalEl = document.getElementById('vietqrModal');
                            var vietqrModal = new bootstrap.Modal(vietqrModalEl);

                            function handlePayment() {
                                const method = document.querySelector('input[name="paymentMethod"]:checked').value;

                                if (method === 'vnpay') {
                                    // Nếu chọn Online, hiện Popup QR
                                    vietqrModal.show();
                                } else {
                                    // Nếu sau này có Cash/Khác thì submit thẳng
                                    submitForm();
                                }
                            }

                            function closeVietqrModal() {
                                vietqrModal.hide();
                            }

                            function submitForm() {
                                document.getElementById('paymentForm').submit();
                            }

                            // Xác nhận khi receptionist bấm "Khách hàng đã thanh toán" ở màn tạo hóa đơn
                            function confirmCustomerPaidCreate(event) {
                                const ok = window.confirm("Xác nhận khách hàng đã thanh toán đầy đủ cho hóa đơn này?");
                                if (!ok) {
                                    // Chặn đóng modal nếu người dùng chọn Hủy
                                    if (event) {
                                        event.preventDefault();
                                        event.stopPropagation();
                                    }
                                    return false;
                                }
                                // Nếu OK: gắn flag manualPaid và submit form để tạo hóa đơn + payment và chuyển trạng thái Paid
                                const manualPaidInput = document.getElementById('manualPaid');
                                if (manualPaidInput) {
                                    manualPaidInput.value = 'true';
                                }
                                document.getElementById('paymentForm').submit();
                                return true;
                            }
        </script>
    </body>
</html>