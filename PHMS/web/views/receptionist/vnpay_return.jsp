<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="controller.vnpayCommon.Config"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard"><i class="fa-solid fa-table-columns"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard" class="text-danger"><i class="fa-solid fa-truck-medical"></i> Emergency Triage</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/scheduling"><i class="fa-solid fa-truck-medical"></i> Staff Scheduling</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/appointment"><i class="fa-regular fa-calendar-check"></i> Appointments</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard"><i class="fa-solid fa-paw"></i> My Pets</a></li>
        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard"><i class="fa-solid fa-file-medical"></i> Medical Records</a></li>

        <!-- Billing ACTIVE -->
        <li>
            <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="active">
                <i class="fa-regular fa-credit-card"></i> Billing
            </a>
        </li>

        <li><a href="${pageContext.request.contextPath}/receptionist/dashboard"><i class="fa-solid fa-gear"></i> Administration</a></li>
    </ul>
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
            <strong><%=request.getParameter("vnp_PayDate")%></strong>
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

</body>
</html>
