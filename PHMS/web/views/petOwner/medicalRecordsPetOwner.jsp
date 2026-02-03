<%-- 
    Document   : medicalRecordsPetOwner
    Created on : Feb 3, 2026, 12:12:44 AM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Medical Record</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/medicalRecordsPetOwner.css" rel="stylesheet">
    </head>
    <body>
        <!--Dashboard left-->
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
                <li><a href="${pageContext.request.contextPath}/myAppointment"class="nav-link">
                        <i class="fa-solid fa-calendar-check"></i> My Appointments</a>
                </li>
                <li><a href="${pageContext.request.contextPath}/myPetOwner"class="nav-link">
                        <i class="fa-solid fa-paw"></i> My Pets</a></li>
                <li><a href="${pageContext.request.contextPath}/medicalRecords"class="nav-link active">
                        <i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
                <li><a href="${pageContext.request.contextPath}/billing"class="nav-link">
                        <i class="fa-regular fa-credit-card"></i> Billing</a></li>
                <li><a href="${pageContext.request.contextPath}/aiHealthGuide"class="nav-link">
                        <i class="fa-solid fa-bolt"></i> AI Health Guide</a></li>
            </ul>
            <div class="support-box">
                <p>Need help?</p>
                <button class="btn-support">Contact Support</button>
            </div>
        </nav>
        <!-- MAIN CONTENT -->
        <main class="main-content">
            <!-- Top Bar -->
            <header class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </header>
            <!-- Page Header -->
            <div class="pet-header">
                <div class="header-text">
                    <h1>Pet Profile & History</h1>
                    <p>Comprehensive overview of your pet's health records.</p>
                </div>
                <!-- Dropdown Switch Pet -->
                <div class="dropdown-wrapper">
                    <select class="switch-pet-dropdown">
                        <option value="1">Switch Pet: Buddy</option>
                        <option value="2">Switch Pet: Luna</option>
                        <option value="3">Switch Pet: Max</option>
                    </select>
                    <i class="fa-solid fa-chevron-down dropdown-icon"></i>
                </div>
            </div>
            <!-- Grid Layout -->
            <div class="pet-dashboard-grid">
                <!-- LEFT COLUMN: PET PROFILE CARD -->
                <div class="left-col">
                    <div class="pet-card">
                        <div class="edit-icon">
                            <a href="#"><i class="fa-solid fa-pen"></i></a>
                        </div>
                        <div class="pet-avatar-wrapper">
                            <img src="https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80" alt="Buddy" class="pet-avatar">
                            <div class="status-indicator"></div>
                        </div>
                        <div class="pet-name">Buddy</div>
                        <div class="pet-breed">Golden Retriever</div>
                        <div class="stats-grid">
                            <div class="stat-box">
                                <span class="stat-label">GENDER</span>
                                <div class="stat-value">Male</div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">WEIGHT</span>
                                <div class="stat-value">28kg</div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">AGE</span>
                                <div class="stat-value">3 Years</div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">TYPE</span>
                                <div class="stat-value">Dog</div>
                            </div>
                        </div>
                        <div class="alert-box">
                            <div class="alert-title">
                                <i class="fa-solid fa-triangle-exclamation"></i> ALLERGIES & ALERTS
                            </div>
                            <div class="alert-content">Chicken, Pollen</div>
                        </div>
                    </div>
                </div>
                <!-- RIGHT COLUMN: HISTORY & SUMMARY -->
                <div class="right-col">
                    <!-- History Table Card -->
                    <div class="history-section card-box">
                        <div class="tabs-header">
                            <a href="#" class="tab-link active">Medical Visits</a>
                            <a href="#" class="tab-link">Vaccinations</a>
                        </div>
                        <table class="history-table">
                            <thead>
                                <tr>
                                    <th>VISIT DATE</th>
                                    <th>DIAGNOSIS</th>
                                    <th>VETERINARIAN</th>
                                    <th style="text-align: right;">ACTION</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="fw-bold">2023-10-15</td>
                                    <td>Annual Vaccination</td>
                                    <td class="text-gray">Dr. Sarah Wilson</td>
                                    <td class="text-right">
                                        <a href="#" class="view-detail-btn">
                                            View Detail <i class="fa-solid fa-chevron-right"></i>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold">2023-08-12</td>
                                    <td>Minor Paw Injury</td>
                                    <td class="text-gray">Dr. James Chen</td>
                                    <td class="text-right">
                                        <a href="#" class="view-detail-btn">
                                            View Detail <i class="fa-solid fa-chevron-right"></i>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold">2023-05-20</td>
                                    <td>Dietary Consultation</td>
                                    <td class="text-gray">Dr. Emily Brown</td>
                                    <td class="text-right">
                                        <a href="#" class="view-detail-btn">
                                            View Detail <i class="fa-solid fa-chevron-right"></i>
                                        </a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- Summary Cards Row -->
                    <div class="summary-cards">
                        <!-- Card 1: Total Visits -->
                        <div class="summary-card card-box">
                            <div class="icon-box icon-blue">
                                <i class="fa-regular fa-file-lines"></i>
                            </div>
                            <div class="summary-info">
                                <h4>TOTAL VISITS</h4>
                                <div class="info-details">
                                    <span class="big-number">12</span>
                                    <span class="sub-text">Since registration in 2021</span>
                                </div>
                            </div>
                        </div>
                        <!-- Card 2: Last Billing -->
                        <div class="summary-card card-box">
                            <div class="icon-box icon-purple">
                                <i class="fa-regular fa-credit-card"></i>
                            </div>
                            <div class="summary-info">
                                <h4>LAST BILLING</h4>
                                <div class="info-details">
                                    <span class="big-number">$85.50</span>
                                    <span class="sub-text">Paid on Feb 02, 2026</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>