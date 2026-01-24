<%-- 
    Document   : menuPetOwner
    Created on : Jan 24, 2026, 7:07:59 PM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VetCare Pro - Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus"></i>
                <span>VetCare Pro</span>
            </div>

            <div class="menu-label">Main Menu</div>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fa-solid fa-border-all"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link active">
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
                    <a href="#" class="nav-link">
                        <i class="fa-regular fa-credit-card"></i> Billing
                    </a>
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

        <!-- Main Content Area -->
        <main class="main-content">
            <!-- Top Header -->
            <header class="top-bar">
                <button class="btn-signout">Sign Out</button>
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
            <form action="submitBooking" method="post" class="booking-grid">

                <!-- Card 1: Visit Details -->
                <div class="card">
                    <div class="section-title">
                        <span class="step-badge">1</span> Visit Details
                    </div>

                    <div class="form-group">
                        <label>Select Pet</label>
                        <select class="form-control" name="petId">
                            <option value="luna">Luna (Cat)</option>
                            <option value="max">Max (Dog)</option>
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
                        <label>Preferred Veterinarian</label>
                        <select class="form-control" name="vetId">
                            <option value="dr_brown">Dr. Emily Brown - Veterinary Surgeon</option>
                            <option value="dr_smith">Dr. John Smith - General Practitioner</option>
                        </select>
                    </div>
                </div>

                <!-- Card 2: Schedule -->
                <div class="card">
                    <div class="section-title">
                        <span class="step-badge">2</span> Schedule
                    </div>

                    <div class="form-group">
                        <label>Select Date</label>
                        <input type="text" class="form-control" value="29/02/2025" name="appointmentDate">
                    </div>

                    <div class="form-group">
                        <label>Available Time Slots</label>
                        <div class="time-slots-grid">
                            <button type="button" class="time-btn">09:00 AM</button>
                            <button type="button" class="time-btn" disabled>09:30 AM</button>
                            <button type="button" class="time-btn">10:00 AM</button>
                            <button type="button" class="time-btn">10:30 AM</button>

                            <button type="button" class="time-btn">11:00 AM</button>
                            <button type="button" class="time-btn" disabled>11:30 AM</button>
                            <button type="button" class="time-btn">02:00 PM</button>
                            <button type="button" class="time-btn">02:30 PM</button>

                            <button type="button" class="time-btn">03:00 PM</button>
                            <button type="button" class="time-btn">03:30 PM</button>
                            <button type="button" class="time-btn selected">04:00 PM</button>
                            <button type="button" class="time-btn">04:30 PM</button>

                            <!-- Input ẩn để lưu giá trị giờ đã chọn -->
                            <input type="hidden" name="timeSlot" value="16:00">
                        </div>
                    </div>
                </div>

                <!-- Card 3: Notes -->
                <div class="card">
                    <div class="notes-header">
                        <div class="section-title" style="margin-bottom:0">Notes & Symptoms</div>
                        <span class="char-count">0/500</span>
                    </div>
                    <div class="form-group" style="margin-top: 15px;">
                        <textarea class="form-control" name="notes" placeholder="Tell us about your pet's symptoms or any specific concerns..."></textarea>
                    </div>
                </div>

                <!-- Card 4: Action Button -->
                <div class="action-card">
                    <button type="submit" class="btn-confirm">
                        Confirm Booking <i class="fa-solid fa-arrow-right"></i>
                    </button>
                    <p class="disclaimer">By confirming, you agree to our 24-hour cancellation policy.</p>
                </div>

            </form>
        </main>
    </body>
</html>