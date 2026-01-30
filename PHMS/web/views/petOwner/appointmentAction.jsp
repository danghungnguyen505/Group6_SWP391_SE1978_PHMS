<%-- 
    Document   : appointmentAction
    Created on : Jan 31, 2026, 2:12:03 AM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Action - VetCare Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/pages/appointmentAction.css" rel="stylesheet">
</head>
<body>
    
    <div class="container">
        <div class="action-container">
            
            <h3 class="page-title">
                <c:if test="${actionType == 'cancel'}">
                    <i class="fa-solid fa-calendar-xmark text-danger"></i> Cancel Appointment
                </c:if>
                <c:if test="${actionType == 'reschedule'}">
                    <i class="fa-solid fa-calendar-pen text-primary"></i> Reschedule Appointment
                </c:if>
            </h3>

            <div class="info-card">
                <div class="info-row">
                    <span class="info-label"><i class="fa-solid fa-paw icon-box"></i> Pet Name</span>
                    <span class="info-value">${appt.petName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fa-solid fa-briefcase-medical icon-box"></i> Service</span>
                    <span class="info-value">${appt.type}</span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fa-solid fa-user-doctor icon-box"></i> Doctor</span>
                    <span class="info-value">${appt.vetName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label"><i class="fa-regular fa-clock icon-box"></i> Current Time</span>
                    <span class="info-value text-primary">
                        <fmt:formatDate value="${appt.startTime}" pattern="dd-MM-yyyy HH:mm"/>
                    </span>
                </div>
            </div>

            <c:if test="${!canAction}">
                <div class="alert-locked">
                    <i class="fa-solid fa-lock fa-2x mb-3"></i>
                    <h5>Action Locked</h5>
                    <p class="mb-3">You cannot cancel or reschedule within <strong>5 hours</strong> of the appointment time.</p>
                    <a href="${pageContext.request.contextPath}/myAppointment" class="btn btn-outline-danger">
                        <i class="fa-solid fa-arrow-left"></i> Go Back
                    </a>
                </div>
            </c:if>

            <c:if test="${canAction}">
                <form action="${pageContext.request.contextPath}/appointment-action" method="POST">
                    <input type="hidden" name="apptId" value="${appt.apptId}">
                    
                    <c:if test="${actionType == 'cancel'}">
                        <div class="warning-box">
                            <i class="fa-solid fa-triangle-exclamation fa-lg mt-1"></i>
                            <div>
                                <strong>Are you sure?</strong><br>
                                Canceling this appointment will remove it from your schedule. This action cannot be undone immediately.
                            </div>
                        </div>
                        <input type="hidden" name="action" value="confirm_cancel">
                        
                        <div class="d-flex gap-2 mt-4">
                            <a href="${pageContext.request.contextPath}/my-appointments" class="btn btn-light border flex-fill">
                                <i class="fa-solid fa-xmark"></i> Keep Appointment
                            </a>
                            <button type="submit" class="btn btn-confirm-cancel flex-fill">
                                <i class="fa-solid fa-check"></i> Yes, Cancel It
                            </button>
                        </div>
                    </c:if>

                    <c:if test="${actionType == 'reschedule'}">
                        <input type="hidden" name="action" value="confirm_reschedule">
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label><i class="fa-regular fa-calendar"></i> New Date</label>
                                    <input type="date" name="newDate" class="form-control" required min="<%= new java.sql.Date(System.currentTimeMillis()) %>">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label><i class="fa-regular fa-clock"></i> New Time</label>
                                    <input type="time" name="newTime" class="form-control" required>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex gap-2 mt-4">
                            <a href="${pageContext.request.contextPath}/my-appointments" class="btn btn-light border flex-fill">
                                <i class="fa-solid fa-arrow-left"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-confirm-reschedule flex-fill">
                                <i class="fa-solid fa-paper-plane"></i> Request Change
                            </button>
                        </div>
                    </c:if>
                </form>
            </c:if>
        </div>
    </div>

</body>
</html>

