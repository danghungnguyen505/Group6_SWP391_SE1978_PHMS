<%-- 
    Document   : payment_history
    Created on : Mar 5, 2026, 3:27:13 AM
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
        <table border="1">
    <tr>
        <th>ID</th>
        <th>Invoice</th>
        <th>Amount</th>
        <th>Method</th>
        <th>Status</th>
        <th>Transaction Code</th>
    </tr>

    <c:forEach var="p" items="${payments}">
        <tr>
            <td>${p.paymentId}</td>
            <td>${p.invoiceId}</td>
            <td>${p.amount}</td>
            <td>${p.method}</td>
            <td>${p.status}</td>
            <td>${p.transCode}</td>
        </tr>
    </c:forEach>
</table>
    </body>
</html>
