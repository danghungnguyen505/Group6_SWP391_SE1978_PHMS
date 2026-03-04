<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Billing History</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }
        .paid {
            color: green;
            font-weight: bold;
        }
        .unpaid {
            color: red;
            font-weight: bold;
        }
        .summary-box {
            background: #f4f4f4;
            padding: 15px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<h2>Billing History</h2>

<div class="summary-box">
    <p><strong>Total Invoices:</strong> ${totalInvoices}</p>
    <p><strong>Paid:</strong> ${paidCount}</p>
    <p><strong>Unpaid:</strong> ${unpaidCount}</p>
    <p><strong>Total Spent:</strong> $${totalSpent}</p>
</div>

<c:if test="${empty invoiceList}">
    <p>No invoices available.</p>
</c:if>

<c:if test="${not empty invoiceList}">
    <table>
        <thead>
            <tr>
                <th>Invoice ID</th>
                <th>Total Amount</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="invoice" items="${invoiceList}">
                <tr>
                    <td>INV-${invoice.invoiceId}</td>
                    <td>$${invoice.totalAmount}</td>
                    <td>
                        <c:choose>
                            <c:when test="${invoice.status == 'Paid'}">
                                <span class="paid">Paid</span>
                            </c:when>
                            <c:otherwise>
                                <span class="unpaid">Unpaid</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</c:if>

</body>
</html>