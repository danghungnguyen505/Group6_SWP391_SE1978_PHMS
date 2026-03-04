<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Invoice Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">

<h2>Invoice Details</h2>

<c:if test="${invoice != null}">

    <p><strong>Invoice ID:</strong> INV-${invoice.invoiceId}</p>
    <p><strong>Status:</strong> ${invoice.status}</p>
    <p><strong>Total Amount:</strong> $${invoice.totalAmount}</p>

    <hr>

    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Service / Item</th>
            <th>Quantity</th>
            <th>Unit Price</th>
            <th>Subtotal</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="d" items="${detailList}">
            <tr>
                <td>${d.itemType}</td>
                <td>${d.quantity}</td>
                <td>$${d.unitPrice}</td>
                <td>$${d.quantity * d.unitPrice}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</c:if>

<a href="${pageContext.request.contextPath}/billing" class="btn btn-secondary">
    Back to Billing
</a>

</body>
</html>