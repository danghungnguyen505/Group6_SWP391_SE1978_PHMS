<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!-- Top Header -->
            <header class="top-bar">
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                        Đăng xuất
                    </a>
            </header>

            <!-- Page Title & Actions -->
            <div class="page-header">
                <div class="page-title">
                    <h1>Book Appointment</h1>
                    <p>Schedule a visit for your beloved pet in just a few clicks.</p>
                </div>
                <button class="btn-cancel">Cancel Booking</button>
            </div>

            <!-- Booking Form Grid -->
            <form action="${pageContext.request.contextPath}/booking" method="post" id="bookingForm" class="booking-grid">

                <!-- Card 1: Visit Details -->
                <div class="card">
                    <div class="section-title">
                        <span class="step-badge">1</span> Visit Details
                    </div>

                    <div class="form-group">
                        <label>Select Pet</label>
                        <select class="form-control" name="petId">
                            <c:forEach items="${pets}" var="p">
                                <option value="${p.id}">${p.name} (${p.species})</option>
                            </c:forEach>
                            <c:if test="${empty pets}">
                                <option value="" disabled>Bạn chưa có thú cưng nào</option>
                            </c:if>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Service Type</label>
                        <select class="form-control" name="serviceType">
                            <option value="general">General Examination ($50 - $120)</option>
                            <option value="vaccination">Vaccination ($30 - $80)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Select Date</label>
                        <input type="date" name="selectedDate" class="form-control" 
                               value="${selectedDateStr}"
                               onchange="this.form.submit()">
                    </div>
                    <div class="form-group">
                        <label>Preferred Veterinarian</label>
                        <select class="form-control" name="vetId" onchange="this.form.submit()">
                            <option value="">-- Chọn bác sĩ --</option>
                            <c:forEach items="${schedules}" var="s">
                                <option value="${s.empId}" ${param.vetId == s.empId ? 'selected' : ''}>${s.vetName}
                                </c:forEach>
                                <c:if test="${empty schedules && not empty param.selectedDate}">
                                <option disabled>Không có bác sĩ nào có lịch vào ngày này</option>
                            </c:if>
                            <c:if test="${empty param.selectedDate}">
                                <option disabled>Vui lòng chọn ngày trước</option>
                            </c:if>
                        </select>
                    </div>
                    <!-- Card 3: Notes -->
                    <div>
                        <div class="notes-header">
                            <div class="section-title" style="margin-bottom:0">Notes & Symptoms</div>
                            <span class="char-count">0/500</span>
                        </div>
                        <div class="form-group" style="margin-top: 15px;">
                            <textarea class="form-control" name="notes" placeholder="Tell us about your pet's symptoms or any specific concerns..."></textarea>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Schedule -->
                <div class="card">
                    <div class="section-title">
                        <span class="step-badge">2</span> Schedule
                    </div>

                    <div class="form-group">
                        <label>Available Time Slots</label>
                        <div class="time-slots-grid">
                            <c:if test="${empty availableSlots}">
                                <p class="text-muted" style="grid-column: span 4; font-size: 0.9em;">
                                    Vui lòng chọn Ngày và Bác sĩ để xem giờ trống.
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
                    <!-- Card 4: Action Button -->
                    <div class="action-card">
                        <button type="submit" name="action" value="book" class="btn-confirm">
                            Confirm Booking <i class="fa-solid fa-arrow-right"></i>
                        </button>
                        <p class="disclaimer">By confirming, you agree to our 24-hour cancellation policy.</p>
                    </div>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                </div>
            </form>
       