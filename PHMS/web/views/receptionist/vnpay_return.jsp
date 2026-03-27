<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="controller.vnpayCommon.Config"%>
<%@page import="java.util.*"%>
<%@ page import="java.time.*, java.time.format.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>VNPay Result - VetCare Pro</title>

        <!-- SAME CSS as receptionist dashboard -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>

        <%
            Map fields = new HashMap();
            for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = (String) params.nextElement();
                String fieldValue = request.getParameter(fieldName);
                if (fieldValue != null && fieldValue.length() > 0) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");

            String signValue = Config.hashAllFields(fields);
            boolean validSignature = signValue.equals(vnp_SecureHash);

            String responseCode = request.getParameter("vnp_ResponseCode");
            boolean success = validSignature && "00".equals(responseCode);
        %>

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

        <!-- RIGHT CONTENT -->
        <main class="main-content">

            <div class="top-bar">
                <div class="page-header">
                    <h2>Billing & Checkout</h2>
                    <p>VNPay Payment Result</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card" style="max-width: 700px; margin: 0 auto;">
                <h3 style="margin-bottom: 16px;">
                    <%= success ? "✅ Thanh toán thành công" : "❌ Thanh toán thất bại" %>
                </h3>

                <div class="form-group">
                    <label>Mã giao dịch:</label>
                    <strong><%=request.getParameter("vnp_TxnRef")%></strong>
                </div>

                <div class="form-group">
                    <label>Số tiền:</label>
                    <strong><%=request.getParameter("vnp_Amount")%></strong>
                </div>

                <div class="form-group">
                    <label>Mô tả:</label>
                    <strong><%=request.getParameter("vnp_OrderInfo")%></strong>
                </div>

                <div class="form-group">
                    <label>Mã phản hồi:</label>
                    <strong><%=request.getParameter("vnp_ResponseCode")%></strong>
                </div>

                <div class="form-group">
                    <label>Ngân hàng:</label>
                    <strong><%=request.getParameter("vnp_BankCode")%></strong>
                </div>

                <div class="form-group">
                    <label>Thời gian:</label>
                    <strong>
                        <%
                            String raw = request.getParameter("vnp_PayDate"); // 20260205141158
                            if (raw != null) {
                                DateTimeFormatter inFmt = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
                                DateTimeFormatter outFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
                                LocalDateTime time = LocalDateTime.parse(raw, inFmt);
                                out.print(time.format(outFmt));
                            }
                        %>
                    </strong>
                </div>

                <div style="margin-top: 20px; display:flex; gap:12px;">
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="btn btn-approve">
                        ← Back to Dashboard
                    </a>

                    <c:if test="${not empty param.invoiceId}">
                        <a href="${pageContext.request.contextPath}/receptionist/invoice/detail?invoiceId=${param.invoiceId}"
                           class="btn btn-approve">
                            View Invoice
                        </a>
                    </c:if>
                </div>
            </div>
        </main>

    <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>


