<<<<<<< Updated upstream
<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="controller.vnpayCommon.Config"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <meta name="description" content="">
        <meta name="author" content="">
        <title>KẾT QUẢ THANH TOÁN</title>
        <!-- Bootstrap core CSS -->
        <link href="/vnpay_jsp/assets/bootstrap.min.css" rel="stylesheet"/>
        <!-- Custom styles for this template -->
        <link href="/vnpay_jsp/assets/jumbotron-narrow.css" rel="stylesheet"> 
        <script src="/vnpay_jsp/assets/jquery-1.11.3.min.js"></script>
    </head>
    <body>
        <%
            //Begin process return from VNPAY
            Map fields = new HashMap();
            for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }
            String signValue = Config.hashAllFields(fields);

        %>
        <!--Begin display -->
        <div class="container">
            <div class="header clearfix">
                <h3 class="text-muted">KẾT QUẢ THANH TOÁN</h3>
            </div>
            <div class="table-responsive">
                <div class="form-group">
                    <label >Mã giao dịch thanh toán:</label>
                    <label><%=request.getParameter("vnp_TxnRef")%></label>
                </div>    
                <div class="form-group">
                    <label >Số tiền:</label>
                    <label><%=request.getParameter("vnp_Amount")%></label>
                </div>  
                <div class="form-group">
                    <label >Mô tả giao dịch:</label>
                    <label><%=request.getParameter("vnp_OrderInfo")%></label>
                </div> 
                <div class="form-group">
                    <label >Mã lỗi thanh toán:</label>
                    <label><%=request.getParameter("vnp_ResponseCode")%></label>
                </div> 
                <div class="form-group">
                    <label >Mã giao dịch tại CTT VNPAY-QR:</label>
                    <label><%=request.getParameter("vnp_TransactionNo")%></label>
                </div> 
                <div class="form-group">
                    <label >Mã ngân hàng thanh toán:</label>
                    <label><%=request.getParameter("vnp_BankCode")%></label>
                </div> 
                <div class="form-group">
                    <label >Thời gian thanh toán:</label>
                    <label><%=request.getParameter("vnp_PayDate")%></label>
                </div> 
                <div class="form-group">
                    <label >Tình trạng giao dịch:</label>
                    <label>
                        <%
                            if (signValue.equals(vnp_SecureHash)) {
                                if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                                    out.print("Thành công");
                                } else {
                                    out.print("Không thành công");
                                }

                            } else {
                                out.print("invalid signature");
                            }
                        %></label>
                </div> 
            </div>
            <p>
                &nbsp;
            </p>
            <footer class="footer">
                <p>&copy; VNPAY 2020</p>
            </footer>
        </div>  
    </body>
</html>
=======
<%@page import="java.net.URLEncoder"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="controller.vnpayCommon.Config"%>
<%@page import="java.util.*"%>
<%@ page import="java.time.*, java.time.format.*" %>
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

    </body>
</html>
>>>>>>> Stashed changes
