<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Invoice Details</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">

    <link href="${pageContext.request.contextPath}/assets/css/petOwner/billingPetOwner.css" rel="stylesheet">
</head>
<body class="p-4">
<!-- Sidebar -->
<nav class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-plus"></i> VetCare Pro
    </div>

    <div class="menu-label">Main Menu</div>
    <ul class="menu">
        <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                <i class="fa-solid fa-border-all"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/booking" class="nav-link">
                <i class="fa-regular fa-calendar-check"></i> Appointments</a></li>
        <li><a href="${pageContext.request.contextPath}/myAppointment" class="nav-link">
                <i class="fa-solid fa-calendar-check"></i> My Appointments</a></li>
        <li><a href="${pageContext.request.contextPath}/myPetOwner" class="nav-link">
                <i class="fa-solid fa-paw"></i> My Pets</a></li>
        <li><a href="${pageContext.request.contextPath}/my-medical-records" class="nav-link">
                <i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
        <li><a href="${pageContext.request.contextPath}/billing" class="nav-link active">
                <i class="fa-regular fa-credit-card"></i> Billing</a></li>
        <li><a href="${pageContext.request.contextPath}/aiHealthGuide" class="nav-link">
                <i class="fa-solid fa-bolt"></i> AI Health Guide</a></li>
    </ul>

    <div class="support-box">
        <p>Need help?</p>
        <button class="btn-support">Contact Support</button>
    </div>
</nav>
                <!-- MAIN CONTENT -->
<main class="main-content">

<header class="top-bar">
    <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
</header>

<div class="invoice-card">
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
</div>

</main>
</body>
</html>