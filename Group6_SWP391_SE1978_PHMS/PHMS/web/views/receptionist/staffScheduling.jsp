<%-- 
    Document   : staffScheduling
    Created on : Jan 25, 2026
    Author     : zoxy4
    Description: Staff Scheduling Interface based on VetCare Pro UI
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Staff Scheduling</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/staffScheduling.css">
    </head>
    <body>

        <!-- LEFT SIDEBAR -->
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>

            <ul class="menu">
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-table-columns"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard" class="text-danger">
                        <i class="fa-solid fa-truck-medical"></i> Emergency Triage
                    </a>
                </li>
                <!-- Active class ở mục Staff Scheduling -->
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/scheduling" class="active">
                        <i class="fa-regular fa-calendar-alt"></i> Staff Scheduling
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/appointment">
                        <i class="fa-regular fa-calendar-check"></i> Appointments
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-paw"></i> My Pets
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-file-medical"></i> Medical Records
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-regular fa-credit-card"></i> Billing
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-gear"></i> Administration
                    </a>
                </li>
            </ul>

            <div class="help-box">
                <div class="help-text">Need help?</div>
                <a href="#" class="btn-contact">Contact Support</a>
            </div>
        </nav>

        <!-- RIGHT MAIN CONTENT -->
        <main class="main-content">

            <!-- Top Header -->
            <div class="header-section">
                <div class="header-text">
                    <h2>STAFF SCHEDULING</h2>
                    <p>Manage team availability and assign daily shifts.</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-outline"><i class="fa-solid fa-plus"></i> Add Shift</button>
                    <button class="btn btn-primary">Publish Schedule</button>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-signout" style="margin-left: 15px;">Sign Out</a>
                </div>
            </div>

            <!-- Filter & Navigation Bar -->
            <div class="controls-bar">
                <div class="date-nav">
                    <button class="nav-arrow"><i class="fa-solid fa-chevron-left"></i></button>
                    <span class="date-range">OCT 23 - OCT 29, 2023</span>
                    <button class="nav-arrow"><i class="fa-solid fa-chevron-right"></i></button>
                </div>
                <div class="role-filter">
                    <span class="filter-label">FILTER ROLE:</span>
                    <button class="filter-btn active">All</button>
                    <button class="filter-btn">Veterinarian</button>
                    <button class="filter-btn">Nurse</button>
                    <button class="filter-btn">Receptionist</button>
                    <button class="filter-btn">Manager</button>
                </div>
            </div>

            <!-- Calendar Grid -->
            <div class="schedule-grid">
                
                <!-- Monday -->
                <div class="day-column">
                    <div class="day-header">
                        <span class="day-name">MONDAY</span>
                        <span class="day-num">23</span>
                    </div>
                    <div class="shift-card">
                        <div class="avatar-circle">D</div>
                        <div class="shift-info">
                            <h4>Dr. Sarah Wilson</h4>
                            <span class="role-badge vet">VETERINARIAN</span>
                            <div class="time"><i class="fa-regular fa-clock"></i> 08:00 - 16:00</div>
                        </div>
                    </div>
                    <div class="shift-card">
                        <div class="avatar-circle">N</div>
                        <div class="shift-info">
                            <h4>Nurse Jackie</h4>
                            <span class="role-badge nurse">NURSE</span>
                            <div class="time"><i class="fa-regular fa-clock"></i> 08:00 - 16:00</div>
                        </div>
                    </div>
                    <div class="shift-card leave-card">
                        <div class="shift-info">
                            <div class="leave-header">
                                <div class="avatar-circle red">D</div>
                                <span class="tag-leave">ON LEAVE</span>
                            </div>
                            <h4>Dr. James Chen</h4>
                            <span class="role-badge vet">VETERINARIAN</span>
                            <div class="time"><i class="fa-regular fa-clock"></i> 12:00 - 20:00</div>
                        </div>
                    </div>
                    <div class="shift-card">
                        <div class="avatar-circle">A</div>
                        <div class="shift-info">
                            <h4>Alice Rec</h4>
                            <span class="role-badge recept">RECEPTIONIST</span>
                            <div class="time"><i class="fa-regular fa-clock"></i> 07:30 - 15:30</div>
                        </div>
                    </div>
                    <div class="add-slot-btn"><i class="fa-solid fa-plus"></i></div>
                </div>

                <!-- Tuesday (Active Day) -->
                <div class="day-column">
                    <div class="day-header active-day">
                        <span class="day-name">TUESDAY</span>
                        <span class="day-num">24</span>
                    </div>
                    <div class="shift-card">
                        <div class="avatar-circle">D</div>
                        <div class="shift-info">
                            <h4>Dr. Sarah Wilson</h4>
                            <span class="role-badge vet">VETERINARIAN</span>
                            <div class="time"><i class="fa-regular fa-clock"></i> 08:00 - 16:00</div>
                        </div>
                    </div>
                    <div class="add-slot-btn"><i class="fa-solid fa-plus"></i></div>
                </div>

                <!-- Wednesday -->
                <div class="day-column">
                    <div class="day-header">
                        <span class="day-name">WEDNESDAY</span>
                        <span class="day-num">25</span>
                    </div>
                    <div class="shift-card">
                        <div class="avatar-circle">N</div>
                        <div class="shift-info">
                            <h4>Nurse Jackie</h4>
                            <span class="role-badge nurse">NURSE</span>
                            <div class="time"><i class="fa-regular fa-clock"></i> 08:00 - 16:00</div>
                        </div>
                    </div>
                     <div class="shift-card">
                        <div class="avatar-circle">D</div>
                        <div class="shift-info">
                            <h4>Dr. James Chen</h4>
                            <span class="role-badge vet">VETERINARIAN</span>
                            <div class="time"><i class="fa-regular fa-clock"></i> 09:00 - 17:00</div>
                        </div>
                    </div>
                    <div class="add-slot-btn"><i class="fa-solid fa-plus"></i></div>
                </div>

                <!-- Thursday -->
                <div class="day-column">
                    <div class="day-header">
                        <span class="day-name">THURSDAY</span>
                        <span class="day-num">26</span>
                    </div>
                    <div class="shift-card">
                        <div class="avatar-circle">D</div>
                        <div class="shift-info">
                            <h4>Dr. Emily Brown</h4>
                            <span class="role-badge vet">VETERINARIAN</span>
                            <div class="time"><i class="fa-regular fa-clock"></i> 08:00 - 16:00</div>
                        </div>
                    </div>
                    <div class="add-slot-btn"><i class="fa-solid fa-plus"></i></div>
                </div>

                <!-- Friday -->
                <div class="day-column">
                    <div class="day-header">
                        <span class="day-name">FRIDAY</span>
                        <span class="day-num">27</span>
                    </div>
                    <div class="shift-card">
                        <div class="avatar-circle">N</div>
                        <div class="shift-info">
                            <h4>Nurse Jackie</h4>
                            <span class="role-badge nurse">NURSE</span>
                            <div class="time"><i class="fa-regular fa-clock"></i> 10:00 - 18:00</div>
                        </div>
                    </div>
                    <div class="add-slot-btn"><i class="fa-solid fa-plus"></i></div>
                </div>

                <!-- Saturday -->
                <div class="day-column">
                    <div class="day-header">
                        <span class="day-name">SATURDAY</span>
                        <span class="day-num">28</span>
                    </div>
                    <div class="empty-slot-marker">
                        <div class="icon-empty"><i class="fa-solid fa-plus-circle"></i></div>
                        <span>EMPTY</span>
                    </div>
                    <div class="add-slot-btn"><i class="fa-solid fa-plus"></i></div>
                </div>

                <!-- Sunday -->
                <div class="day-column">
                    <div class="day-header">
                        <span class="day-name">SUNDAY</span>
                        <span class="day-num">29</span>
                    </div>
                    <div class="empty-slot-marker">
                        <div class="icon-empty"><i class="fa-solid fa-plus-circle"></i></div>
                        <span>EMPTY</span>
                    </div>
                    <div class="add-slot-btn"><i class="fa-solid fa-plus"></i></div>
                </div>

            </div> <!-- End Grid -->
            
            <br>
            <br>

        </main>
        
        <!-- Footer Stats Bar -->
        <div class="footer-stats">
            <div class="stats-group">
                <div class="stat-item">
                    <span class="stat-label">TOTAL STAFF</span>
                    <span class="stat-value">18</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">VETERINARIANS</span>
                    <span class="stat-value text-green">6</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">WEEKLY SHIFTS</span>
                    <span class="stat-value text-blue">42</span>
                </div>
            </div>
            <div class="warning-box">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <div class="warning-text">
                    <strong>Staff Warning</strong>
                    <span>Dr. James Chen is on leave for 3 more days. Triage capacity reduced.</span>
                </div>
            </div>
        </div>

    </body>
</html>