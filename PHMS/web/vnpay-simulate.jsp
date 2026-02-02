<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>VNPay Payment</title>
    <style>
        body { font-family: Arial; background: #f5f5f5; }
        .box {
            width: 420px;
            margin: 60px auto;
            background: white;
            padding: 20px;
            border-radius: 6px;
            text-align: center;
        }
        img { width: 220px; margin: 15px 0; }
        button {
            background: #0066ff;
            color: white;
            border: none;
            padding: 12px 18px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<div class="box">
    <h2>VNPay Sandbox</h2>
    <p>Invoice #: ${param.invoiceId}</p>

    <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=VNPAY_TEST" />

    <p>Scan QR or select bank</p>
    <p>🏦 Vietcombank • Techcombank • BIDV • ACB</p>

    <form action="${pageContext.request.contextPath}/vnpay-return" method="get">
        <input type="hidden" name="invoiceId" value="${param.invoiceId}">
        <button type="submit">Confirm Payment</button>
    </form>
</div>

</body>
</html>
