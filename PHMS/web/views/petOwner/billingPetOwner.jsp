<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Billing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/petOwner/billingPetOwner.css" rel="stylesheet">
</head>

<body>

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

    <h2>Billing History</h2>
    <p>View all your invoices and payment status.</p>

    <!-- SUMMARY -->
    <div class="summary-box mb-4">
        <p><strong>Total Invoices:</strong> ${totalInvoices}</p>
        <p><strong>Paid:</strong> ${paidCount}</p>
        <p><strong>Unpaid:</strong> ${unpaidCount}</p>
        <p><strong>Total Spent:</strong> $${totalSpent}</p>
    </div>

    <c:if test="${empty invoiceList}">
        <h4>No invoices available.</h4>
    </c:if>

    <c:if test="${not empty invoiceList}">
        <table class="invoice-table">
            <thead>
                <tr>
                    <th>Invoice ID</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="inv" items="${invoiceList}">
                    <tr>
                        <td>INV-${inv.invoiceId}</td>
                        <td>$${inv.totalAmount}</td>
                        <td>
                            <span class="status-badge ${inv.status == 'Paid' ? 'paid' : 'unpaid'}">
                                ${inv.status}
                            </span>
                        </td>
                        <td>
    <a href="${pageContext.request.contextPath}/invoice-details?id=${inv.invoiceId}"
       class="btn btn-sm btn-outline-primary">
        View Details
    </a>
</td>
                    </tr>
                    
                </c:forEach>
            </tbody>
        </table>
    </c:if>

</div>

</main>

</body>
</html>