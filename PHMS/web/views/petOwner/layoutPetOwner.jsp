<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetCare Pro</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet">
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-plus"></i>
        <span>VetCare Pro</span>
    </div>

    <div class="menu-label">Main Menu</div>
    <ul class="nav-menu">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/petOwner/menuPetOwner" class="nav-link">
                <i class="fa-solid fa-border-all"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/petOwner/menuPetOwner" class="nav-link">
                <i class="fa-regular fa-calendar-check"></i> Appointments
            </a>
        </li>
        <li class="nav-item">
            <a href="#" class="nav-link">
                <i class="fa-solid fa-paw"></i> My Pets
            </a>
        </li>
        <li class="nav-item">
            <a href="#" class="nav-link">
                <i class="fa-solid fa-file-medical"></i> Medical Records
            </a>
        </li>

        <li class="nav-item">
    <c:choose>
       <c:when test="${latestInvoiceId != null}">
    <a href="${pageContext.request.contextPath}/billing" class="nav-link">

                <i class="fa-solid fa-receipt"></i> Billing
            </a>
        </c:when>
        <c:otherwise>
            <a class="nav-link disabled">
                <i class="fa-solid fa-receipt"></i> Billing (no invoice)
            </a>
        </c:otherwise>
    </c:choose>
</li>


        <li class="nav-item">
            <a href="#" class="nav-link">
                <i class="fa-solid fa-bolt"></i> AI Health Guide
            </a>
        </li>
        <li class="nav-item">
            <a href="#" class="nav-link">
                <i class="fa-solid fa-gear"></i> Administration
            </a>
        </li>
    </ul>

    <div class="support-box">
        <p>Need help?</p>
        <button class="btn-support">Contact Support</button>
    </div>
</aside>


<main class="main-content">
    <jsp:include page="${contentPage}" />
</main>

</body>
</html>
