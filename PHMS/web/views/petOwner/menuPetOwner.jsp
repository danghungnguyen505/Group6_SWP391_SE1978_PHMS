<%--
    Document   : menuPetOwner
    Created on : Jan 24, 2026
    Author     : zoxy4
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VetCare Pro - ${t_book_appt}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <script src="${pageContext.request.contextPath}/assets/js/saveSchedule.js"></script>
    </head>
    <body>
        <jsp:include page="nav/navPetOwner.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                    ${t_logout}
                </a>
            </header>

            <div class="page-header">
                <div class="page-title">
                    <h1>${t_book_appt}</h1>
                    <p>${t_book_subtitle}</p>
                </div>
                <button type="button" class="btn-cancel" onclick="window.location.href='${pageContext.request.contextPath}/home'">
                    ${t_back_home}
                </button>
            </div>

            <form action="${pageContext.request.contextPath}/booking" method="post" id="bookingForm" class="booking-grid">
                <input type="hidden" name="rescheduleId" value="${param.rescheduleId}">
                <div class="card">
                    <div class="section-title">
                        <span class="step-badge">1</span> ${t_visit_details}
                    </div>

                    <div class="form-group">
                        <label>${t_select_pet}</label>
                        <select class="form-control" name="petId">
                            <c:forEach items="${pets}" var="p">
                                <option value="${p.id}" ${param.petId == p.id ? 'selected' : ''}>
                                    ${p.name} (${p.species})</option>
                            </c:forEach>
                            <c:if test="${empty pets}">
                                <option value="" disabled>${t_no_pets}</option>
                            </c:if>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>${t_service_type}</label>
                        <select class="form-control" name="serviceType">
                            <c:if test="${empty services}">
                                <option value="" disabled>${t_no_service}</option>
                            </c:if>
                            <c:forEach items="${services}" var="s">
                                <option value="${s.name}" ${param.serviceType == s.name ? 'selected' : ''}>
                                    ${s.name} - $${s.basePrice}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>${t_select_date}</label>
                        <input type="date" name="selectedDate" class="form-control"
                               value="${selectedDateStr}"
                               onchange="this.form.submit()">
                    </div>
                    <div class="form-group">
                        <label>${t_pref_vet}</label>
                        <select class="form-control" name="vetId" onchange="this.form.submit()">
                            <option value="">${t_choose_vet}</option>
                            <c:forEach items="${schedules}" var="s">
                                <option value="${s.empId}" ${param.vetId == s.empId ? 'selected' : ''}>${s.vetName}</option>
                            </c:forEach>
                            <c:if test="${empty schedules && not empty param.selectedDate}">
                                <option disabled>${t_no_vet_day}</option>
                            </c:if>
                            <c:if test="${empty param.selectedDate}">
                                <option disabled>${t_select_date_first}</option>
                            </c:if>
                        </select>
                    </div>
                    <div>
                        <div class="notes-header">
                            <div class="section-title" style="margin-bottom:0">${t_notes}</div>
                            <span class="char-count"></span>
                        </div>
                        <div class="form-group" style="margin-top: 15px;">
                            <textarea class="form-control" name="notes" maxlength="500"
                                      placeholder="${t_notes_placeholder}">${param.notes}</textarea>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="section-title">
                        <span class="step-badge">2</span> ${t_schedule_title}
                    </div>

                    <div class="form-group">
                        <label>${t_time_slots}</label>
                        <div class="time-slots-grid">
                            <c:if test="${empty availableSlots}">
                                <p style="grid-column: span 4; font-size: 0.9em; color: red">
                                    ${t_no_slots}
                                </p>
                            </c:if>
                            <c:forEach items="${availableSlots}" var="slot">
                                <button type="button"
                                        class="time-btn ${slot.available ? '' : 'disabled'} ${param.timeSlot == slot.timeValue ? 'selected' : ''}"
                                        ${slot.available ? '' : 'disabled'}
                                        onclick="selectTime(this, '${slot.timeValue}')">
                                    ${slot.timeLabel}
                                </button>
                            </c:forEach>
                            <input type="hidden" name="timeSlot" id="selectedTimeSlot" value="${param.timeSlot}">
                        </div>
                    </div>
                    <div class="action-card">
                        <button type="submit"
                                id="btnConfirm"
                                formaction="${pageContext.request.contextPath}/save-appointment"
                                class="btn-confirm">
                            ${t_confirm_booking} <i class="fa-solid fa-arrow-right"></i>
                        </button>
                        <p class="disclaimer">${t_cancel_policy}</p>
                    </div>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                </div>
            </form>
        </main>
    </body>
</html>
