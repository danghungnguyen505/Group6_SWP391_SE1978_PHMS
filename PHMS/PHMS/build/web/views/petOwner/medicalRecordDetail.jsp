<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Medical Record Detail - VetCare Pro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assets/css/pages/myAppointment.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <jsp:include page="nav/navPetOwner.jsp" />

        <main class="main-content">
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                    Logout
                </a>
            </header>

            <div class="page-header">
                <div class="page-title">
                    <h1>Medical Record Detail</h1>
                    <p>Record #${record.recordId}</p>
                </div>
                <a href="${pageContext.request.contextPath}/my-medical-records" class="btn btn-outline-secondary" style="text-decoration:none;">
                    <i class="fa-solid fa-arrow-left"></i> Back
                </a>
            </div>

            <div class="card" style="padding: 16px;">
                <c:if test="${empty record}">
                    <div class="empty-state">Record not found.</div>
                </c:if>

                <c:if test="${not empty record}">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <div><b>Appointment Time:</b> <fmt:formatDate value="${record.apptStartTime}" pattern="dd-MM-yyyy HH:mm"/></div>
                        <div><b>Doctor:</b> ${record.vetName}</div>
                        <div><b>Pet:</b> ${record.petName}</div>
                        <div><b>Created At:</b> <fmt:formatDate value="${record.createdAt}" pattern="dd-MM-yyyy HH:mm"/></div>
                    </div>

                    <hr/>
                    <h4>Diagnosis</h4>
                    <div style="white-space: pre-wrap;">${record.diagnosis}</div>

                    <div style="margin-top: 10px;">
                        <h4>Treatment Plan</h4>
                        <div style="white-space: pre-wrap;">${record.treatmentPlan}</div>
                    </div>
                </c:if>
            </div>
        </main>
    </body>
</html>

