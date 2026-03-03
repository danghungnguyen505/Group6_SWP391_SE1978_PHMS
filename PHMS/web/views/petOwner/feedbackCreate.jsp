<<<<<<< Updated upstream
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Submit Feedback</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/petOwnerDashboard.css">
    </head>
    <body>
        <div class="container">
            <h2>Submit Feedback</h2>
            <p>Select an appointment to provide feedback:</p>
            
            <c:if test="${empty appointments || appointments.size() == 0}">
                <div style="text-align:center; padding:40px; color:#6b7280;">
                    <i class="fa-solid fa-comment" style="font-size:48px; margin-bottom:10px;"></i>
                    <p>No completed appointments available for feedback.</p>
                    <a href="${pageContext.request.contextPath}/myAppointment" class="btn btn-primary">Back to Appointments</a>
                </div>
            </c:if>
            
            <c:if test="${not empty appointments && appointments.size() > 0}">
                <table style="width:100%; border-collapse:collapse; margin-top:20px;">
                    <thead>
                        <tr style="background:#f3f4f6;">
                            <th style="padding:10px; text-align:left;">Appointment ID</th>
                            <th style="padding:10px; text-align:left;">Date & Time</th>
                            <th style="padding:10px; text-align:left;">Pet</th>
                            <th style="padding:10px; text-align:left;">Veterinarian</th>
                            <th style="padding:10px; text-align:left;">Service</th>
                            <th style="padding:10px; text-align:left;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appt" items="${appointments}">
                            <tr>
                                <td style="padding:10px;">#${appt.apptId}</td>
                                <td style="padding:10px;"><fmt:formatDate value="${appt.startTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td style="padding:10px;">${appt.petName}</td>
                                <td style="padding:10px;">${appt.vetName}</td>
                                <td style="padding:10px;">${appt.type}</td>
                                <td style="padding:10px;">
                                    <a href="${pageContext.request.contextPath}/feedback/create?apptId=${appt.apptId}" 
                                       class="btn btn-primary">
                                        <i class="fa-solid fa-star"></i> Give Feedback
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            
            <div style="margin-top:20px;">
                <a href="${pageContext.request.contextPath}/myAppointment" class="btn btn-secondary">Back</a>
            </div>
        </div>
    </body>
</html>
=======
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Submit Feedback</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/petOwnerDashboard.css">
    </head>
    <body>
        <div class="container">
            <h2>Submit Feedback</h2>
            <p>Select an appointment to provide feedback:</p>
            
            <c:if test="${empty appointments || appointments.size() == 0}">
                <div style="text-align:center; padding:40px; color:#6b7280;">
                    <i class="fa-solid fa-comment" style="font-size:48px; margin-bottom:10px;"></i>
                    <p>No completed appointments available for feedback.</p>
                    <a href="${pageContext.request.contextPath}/myAppointment" class="btn btn-primary">Back to Appointments</a>
                </div>
            </c:if>
            
            <c:if test="${not empty appointments && appointments.size() > 0}">
                <table style="width:100%; border-collapse:collapse; margin-top:20px;">
                    <thead>
                        <tr style="background:#f3f4f6;">
                            <th style="padding:10px; text-align:left;">Appointment ID</th>
                            <th style="padding:10px; text-align:left;">Date & Time</th>
                            <th style="padding:10px; text-align:left;">Pet</th>
                            <th style="padding:10px; text-align:left;">Veterinarian</th>
                            <th style="padding:10px; text-align:left;">Service</th>
                            <th style="padding:10px; text-align:left;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appt" items="${appointments}">
                            <tr>
                                <td style="padding:10px;">#${appt.apptId}</td>
                                <td style="padding:10px;"><fmt:formatDate value="${appt.startTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td style="padding:10px;">${appt.petName}</td>
                                <td style="padding:10px;">${appt.vetName}</td>
                                <td style="padding:10px;">${appt.type}</td>
                                <td style="padding:10px;">
                                    <a href="${pageContext.request.contextPath}/feedback/create?apptId=${appt.apptId}" 
                                       class="btn btn-primary">
                                        <i class="fa-solid fa-star"></i> Give Feedback
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            
            <div style="margin-top:20px;">
                <a href="${pageContext.request.contextPath}/myAppointment" class="btn btn-secondary">Back</a>
            </div>
        </div>
    </body>
</html>
>>>>>>> Stashed changes
