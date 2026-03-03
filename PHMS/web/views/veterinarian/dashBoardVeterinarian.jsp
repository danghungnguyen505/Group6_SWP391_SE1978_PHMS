<<<<<<< Updated upstream
<%-- 
    Document   : dashBoardVeterinarian
    Created on : Feb 1, 2026, 11:29:28 PM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Veterinarian Dashboard</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <!--Dashboard left-->
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/veterinarian/dashboard" class="active">
                        <i class="fa-solid fa-table-columns"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/dashboard" class="text-danger">
                        <i class="fa-solid fa-truck-medical"></i> Emergency Triage</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/scheduling">
                        <i class="fa-solid fa-truck-medical"></i> Staff Scheduling</a>
                </li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/dashboard">
                        <i class="fa-regular fa-calendar-check"></i> Appointments</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/dashboard">
                        <i class="fa-solid fa-paw"></i> My Pets</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/queue">
                        <i class="fa-solid fa-stethoscope"></i> EMR Queue</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/records">
                        <i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/dashboard">
                        <i class="fa-regular fa-credit-card"></i> Billing</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/dashboard">
                        <i class="fa-solid fa-gear"></i> Administration</a></li>
            </ul>
            <div class="help-box">
                <div class="help-text">Need help?</div>
                <a href="#" class="btn-contact">Contact Support</a>
            </div>
        </nav>
        <!--Dashboard right-->  
        <main class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <div class="page-header">
                    <h2>Veterinarian Dashboard</h2>
                    <p>Text</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>
        </main>
    </body>
</html>
=======
<%-- 
    Document   : dashBoardVeterinarian
    Created on : Feb 1, 2026, 11:29:28 PM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Veterinarian Dashboard</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">

    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />
        <!--Dashboard right-->  
        <main class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <div class="page-header">
                    <h2>Veterinarian Dashboard</h2>
                    <p>Text</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>
        </main>
    </body>
</html>
>>>>>>> Stashed changes
