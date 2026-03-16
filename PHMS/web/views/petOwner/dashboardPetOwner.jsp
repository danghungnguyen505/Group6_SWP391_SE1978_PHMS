<%-- 
    Document   : dashboardPetOwner
    Created on : Feb 2, 2026, 11:08:10 PM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DashBoard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/dashboardPetOwner.css" rel="stylesheet">
    </head>
    <body>
        <!--Dashboard left-->
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus"></i> VetCare Pro
            </div>
            <div class="menu-label">Main Menu</div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
                        <i class="fa-solid fa-border-all"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/booking" class="nav-link">
                        <i class="fa-regular fa-calendar-check"></i> Appointments</a></li>
                <li><a href="${pageContext.request.contextPath}/myAppointment"class="nav-link">
                        <i class="fa-solid fa-calendar-check"></i> My Appointments</a>
                </li>
                <li><a href="${pageContext.request.contextPath}/myPetOwner"class="nav-link">
                        <i class="fa-solid fa-paw"></i> My Pets</a></li>
                <li><a href="${pageContext.request.contextPath}/my-medical-records"class="nav-link">
                        <i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
                <li><a href="${pageContext.request.contextPath}/billing"class="nav-link">
                        <i class="fa-regular fa-credit-card"></i> Billing</a></li>
                <li><a href="${pageContext.request.contextPath}/aiHealthGuide"class="nav-link">
                        <i class="fa-solid fa-bolt"></i> AI Health Guide</a></li>
                        <li>
    <a href="${pageContext.request.contextPath}/ChatRedirectController" class="nav-link">
        <i class="fa-solid fa-comments"></i> Chat
    </a>
</li>
            </ul>
            <div class="support-box">
                <p>Need help?</p>
                <button class="btn-support">Contact Support</button>
            </div>
        </nav>
        <!-- MAIN CONTENT -->
        <main class="main-content">
            <!-- Header: Welcome & Profile -->
            <header class="dashboard-header">
                <div class="welcome-text">
                    <h1>Hello, Michael Ross! 👋</h1>
                    <p>Here's what's happening with your pets today.</p>
                </div>
                <div class="user-actions">
                    <div class="notification-btn">
                        <i class="fa-regular fa-bell"></i>
                        <span class="badge-dot"></span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
                </div>
            </header>
            <!-- Stats Row (Overview) -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon green-bg"><i class="fa-solid fa-paw"></i></div>
                    <div class="stat-info">
                        <h3>3</h3>
                        <p>Total Pets</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue-bg"><i class="fa-regular fa-calendar-check"></i></div>
                    <div class="stat-info">
                        <h3>1</h3>
                        <p>Upcoming Visit</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange-bg"><i class="fa-solid fa-file-invoice-dollar"></i></div>
                    <div class="stat-info">
                        <h3>$0.00</h3>
                        <p>Unpaid Bills</p>
                    </div>
                </div>
            </div>
            <!-- Dashboard Grid Layout -->
            <div class="dashboard-grid">
                <!-- Left Column (Big Content) -->
                <div class="left-col">
                    <!-- Next Appointment Card (Highlight) -->
                    <div class="section-card highlight-card">
                        <div class="card-header">
                            <h3><i class="fa-solid fa-clock"></i> Next Appointment</h3>
                            <a href="${pageContext.request.contextPath}/myAppointment" class="view-all">View All</a>
                        </div>
                        <div class="appointment-details">
                            <div class="date-box">
                                <span class="month">FEB</span>
                                <span class="day">03</span>
                            </div>
                            <div class="appt-info">
                                <h4>General Examination</h4>
                                <p><i class="fa-solid fa-user-doctor"></i> Dr. Sarah Wilson</p>
                                <p><i class="fa-solid fa-dog"></i> Pet: <strong>Buddy</strong></p>
                            </div>
                            <div class="appt-time">
                                <span class="time-badge">16:00 PM</span>
                            </div>
                        </div>
                    </div>
                    <!-- My Pets Preview -->
                    <div class="section-card">
                        <div class="card-header">
                            <h3>My Pets</h3>
                            <a href="${pageContext.request.contextPath}/myPetOwner" class="add-new-btn"><i class="fa-solid fa-plus"></i> Add Pet</a>
                        </div>
                        <div class="pets-grid">
                            <!-- Pet 1 -->
                            <div class="pet-mini-card">
                                <img src="https://images.unsplash.com/photo-1552053831-71594a27632d?w=100&h=100&fit=crop" alt="Buddy">
                                <div class="pet-mini-info">
                                    <h4>Milu</h4>
                                    <span>Dog</span>
                                </div>
                            </div>
                            <!-- Pet 2 -->
                            <div class="pet-mini-card">
                                <img src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=100&h=100&fit=crop" alt="Luna">
                                <div class="pet-mini-info">
                                    <h4>Luna</h4>
                                    <span>Cat</span>
                                </div>
                            </div>
                            <!-- Pet 3 -->
                            <div class="pet-mini-card">
                                <img src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=100&h=100&fit=crop" alt="Max">
                                <div class="pet-mini-info">
                                    <h4>Max</h4>
                                    <span>Dog</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Right Column (Side Actions) -->
                <div class="right-col">
                    <!-- Quick Actions -->
                    <div class="section-card">
                        <h3>Quick Actions</h3>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/booking" class="btn-action primary">
                                <i class="fa-solid fa-plus-circle"></i> Book Appointment
                            </a>
                            <a href="${pageContext.request.contextPath}/aiHealthGuide" class="btn-action secondary">
                                <i class="fa-solid fa-robot"></i> Ask AI Assistant
                            </a>
                        </div>
                    </div>
                    <!-- Notifications / Alerts -->
                    <div class="section-card">
                        <h3><i class="fa-regular fa-bell"></i> Notifications</h3>
                        <div class="notif-list">
                            <div class="notif-item">
                                <div class="notif-icon warning"><i class="fa-solid fa-syringe"></i></div>
                                <div class="notif-text">
                                    <p><strong>Vaccination Due</strong></p>
                                    <span>Luna needs Rabies shot by Nov 1st.</span>
                                </div>
                            </div>
                            <div class="notif-item">
                                <div class="notif-icon success"><i class="fa-solid fa-check"></i></div>
                                <div class="notif-text">
                                    <p><strong>Payment Successful</strong></p>
                                    <span>Invoice #INV-001 paid.</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>
