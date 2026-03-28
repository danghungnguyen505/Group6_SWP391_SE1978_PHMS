<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${L == 'en' ? 'Invoice Detail' : 'Chi tiết hóa đơn'} - VetCare Pro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assets/css/pages/myAppointment.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="nav/navPetOwner.jsp" />

        <main class="main-content">
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                    ${t_logout}
                </a>
            </header>

            <div class="page-header">
                <div class="page-title">
                    <h1>${L == 'en' ? 'Invoice Detail' : 'Chi tiết hóa đơn'} #${invoice.invoiceId}</h1>
                    <p>${L == 'en' ? 'Review charges for this medical record visit.' : 'Xem chi phí tương ứng với lần khám trong hồ sơ bệnh án.'}</p>
                </div>
                <a href="${pageContext.request.contextPath}/my-medical-records" class="btn btn-outline-secondary" style="text-decoration:none;">
                    <i class="fa-solid fa-arrow-left"></i> ${L == 'en' ? 'Back to Medical Records' : 'Quay lại hồ sơ bệnh án'}
                </a>
            </div>

            <div class="card" style="padding: 16px;">
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 12px;">
                    <div><b>${L == 'en' ? 'Invoice ID' : 'Mã hóa đơn'}:</b> #${invoice.invoiceId}</div>
                    <div><b>${L == 'en' ? 'Status' : 'Trạng thái'}:</b> ${invoice.status}</div>
                    <div><b>${L == 'en' ? 'Pet' : 'Thú cưng'}:</b> ${appt.petName}</div>
                    <div><b>${L == 'en' ? 'Doctor' : 'Bác sĩ'}:</b> ${appt.vetName}</div>
                    <div><b>${L == 'en' ? 'Appointment Time' : 'Thời gian khám'}:</b> <fmt:formatDate value="${appt.startTime}" pattern="dd-MM-yyyy HH:mm"/></div>
                    <div><b>${L == 'en' ? 'Service Type' : 'Loại dịch vụ'}:</b> ${appt.type}</div>
                </div>

                <h5 style="margin: 14px 0 8px 0;">${L == 'en' ? 'Invoice Items' : 'Chi tiết hạng mục'}</h5>
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>${L == 'en' ? 'Item' : 'Hạng mục'}</th>
                                <th style="text-align:center;">${L == 'en' ? 'Qty' : 'SL'}</th>
                                <th style="text-align:right;">${L == 'en' ? 'Unit Price' : 'Đơn giá'}</th>
                                <th style="text-align:right;">${L == 'en' ? 'Subtotal' : 'Thành tiền'}</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty details}">
                                <tr>
                                    <td colspan="4" style="text-align:center; color:#64748b;">
                                        ${L == 'en' ? 'No invoice items found.' : 'Không có chi tiết hóa đơn.'}
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach items="${details}" var="d">
                                <tr>
                                    <td>${d.itemName}</td>
                                    <td style="text-align:center;">${d.quantity}</td>
                                    <td style="text-align:right;"><fmt:formatNumber value="${d.unitPrice}" pattern="#,###"/>&#8363;</td>
                                    <td style="text-align:right;"><fmt:formatNumber value="${d.quantity * d.unitPrice}" pattern="#,###"/>&#8363;</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div style="display:flex; justify-content:flex-end; margin-top: 10px;">
                    <div style="min-width: 280px;">
                        <div style="display:flex; justify-content:space-between; padding:8px 0; border-top:1px solid #e2e8f0;">
                            <strong>${L == 'en' ? 'Total Amount' : 'Tổng tiền'}</strong>
                            <strong><fmt:formatNumber value="${invoice.totalAmount}" pattern="#,###"/>&#8363;</strong>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty payments}">
                    <h5 style="margin: 16px 0 8px 0;">${L == 'en' ? 'Payment History' : 'Lịch sử thanh toán'}</h5>
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>${L == 'en' ? 'Method' : 'Phương thức'}</th>
                                    <th>${L == 'en' ? 'Status' : 'Trạng thái'}</th>
                                    <th style="text-align:right;">${L == 'en' ? 'Amount' : 'Số tiền'}</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${payments}" var="p">
                                    <tr>
                                        <td>#${p.paymentId}</td>
                                        <td>${p.method}</td>
                                        <td>${p.status}</td>
                                        <td style="text-align:right;"><fmt:formatNumber value="${p.amount}" pattern="#,###"/>&#8363;</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </main>
        <script>
            window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
            window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
    </body>
</html>

