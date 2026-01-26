<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Billing & Checkout</title>
</head>
<body>

<h2>Billing & Checkout</h2>

<p>Invoice #: ${invoice.invoiceId}</p>
<p>Total: ${invoice.totalAmount}</p>

<form action="vnpay-return" method="get">
    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}" />
    <button type="submit">Pay with VNPay</button>
</form>

</body>
</html>
