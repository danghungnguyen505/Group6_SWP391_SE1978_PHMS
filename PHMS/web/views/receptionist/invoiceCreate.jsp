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
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/billingPetOwner.css" rel="stylesheet">

        <style>
            /* Tùy chỉnh thêm cho QR Modal */
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
                    <div class="invoice-top">
                        <div>
                            <span class="invoice-label">INVOICE DETAILS</span>
                            <h2 class="invoice-number">
                                <c:out value="${invoiceNumber != null ? invoiceNumber : 'INV-DRAFT'}"/>
                            </h2>
                            <div class="invoice-date">
                                Date: <c:out value="${invoiceDate != null ? invoiceDate : ''}"/>
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
        <div class="modal fade" id="vietqrModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Thanh toán VietQR</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <p class="mb-3">Vui lòng quét mã QR để thanh toán:<br>
                            <span class="fs-4 fw-bold text-success">
                                <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="VND "/>
                            </span>
                        </p>

                        <div class="qr-wrapper mb-3">
                            <img src="https://img.vietqr.io/image/techcombank-1999992707-compact.png?amount=${grandTotal}&addInfo=DH${param.apptId}&accountName=PHAM CONG HUY" 
                                 alt="VietQR" class="img-fluid" style="width: 280px;">
                        </div>

                        <div class="alert alert-light border-0 small">
                            <div class="payment-info-list">
                                <span class="payment-title-center"> Thông tin thanh toán</span>


                                <div class="payment-item">
                                    <span>Số tiền:</span>
                                    <strong class="text-success">
                                        <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="VND "/>
                                    </strong>
                                </div>

                                <div class="payment-item">
                                    <span>Nội dung CK:</span>
                                    <strong class="text-primary">DH${param.apptId}</strong>
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
                                data-bs-dismiss="modal"
                                onclick="confirmCustomerPaidCreate(event)">
                            Khách hàng đã thanh toán
                        </button>
                        <button type="button" class="btn btn-vnpay-custom w-100 py-2" onclick="submitForm()">
                            Thanh toán qua cổng VNPay <i class="fa-solid fa-chevron-right ms-1"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- SCRIPTS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            function handlePayment() {
                                const method = document.querySelector('input[name="paymentMethod"]:checked').value;

                                if (method === 'vnpay') {
                                    // Nếu chọn Online, hiện Popup QR
                                    var myModal = new bootstrap.Modal(document.getElementById('vietqrModal'));
                                    myModal.show();
                                } else {
                                    // Nếu sau này có Cash/Khác thì submit thẳng
                                    submitForm();
                                }
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