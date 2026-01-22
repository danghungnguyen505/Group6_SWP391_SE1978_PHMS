<%-- 
    Document   : billing
    Created on : Jan 22, 2026, 9:46:40 PM
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
        <h2>Billing & Checkout</h2>
<p>Invoice #: ${invoice.id}</p>
<p>Total: ${invoice.totalAmount}</p>

<form action="vnpay-return" method="post">
    <button>Pay with VNPay</button>
</form>

    </body>
</html>
