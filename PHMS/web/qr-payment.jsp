<%-- 
    Document   : qr-payment
    Created on : Jan 29, 2026, 4:54:34 PM
    Author     : TrungNguyen2002
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2>Scan QR to Pay</h2>

<img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=INVOICE_${param.invoiceId}" />

<p>Invoice ID: ${param.invoiceId}</p>

<form action="vnpay-return" method="get">
    <input type="hidden" name="invoiceId" value="${param.invoiceId}">
    <button type="submit">Simulate VNPay Success</button>
</form>

    </body>
</html>
