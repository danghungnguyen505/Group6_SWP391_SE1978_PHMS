<%-- 
    Document   : myPetOwner
    Created on : Feb 01, 2026
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Pets - VetCare Pro</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>

        <link href="${pageContext.request.contextPath}/assets/css/pages/myPetOwner.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

        <aside class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus"></i>
                <span>VetCare Pro</span>
            </div>

            <div class="menu-label">Main Menu</div>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fa-solid fa-border-all"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/booking" class="nav-link">
                        <i class="fa-regular fa-calendar-check"></i> Appointments
                    </a>
                </li>
                <li class="nav-item" style="font-size: 13px;" >
                    <a href="${pageContext.request.contextPath}/myAppointment"class="nav-link ">
                        <i class="fa-solid fa-calendar-check"></i> My Appointments
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/myPetOwner"class="nav-link active">
                        <i class="fa-solid fa-paw"></i> My Pets
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/medicalRecords" class="nav-link">
                        <i class="fa-solid fa-file-medical"></i> Medical Records
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/billing" class="nav-link">
                        <i class="fa-regular fa-credit-card"></i> Billing
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/aiHealthGuide" class="nav-link">
                        <i class="fa-solid fa-bolt"></i> AI Health Guide
                    </a>
                </li>
            </ul>

            <div class="support-box">
                <p>Need help?</p>
                <button class="btn-support">Contact Support</button>
            </div>
        </aside>

        <main class="main-content">
            <div style="display: flex; justify-content: flex-end; margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary btn-sm">Sign Out</a>
            </div>

            <div class="pet-header">
                <div>
                    <h1>Pet Profile & History</h1>
                    <p>Comprehensive overview of your pet's health records.</p>
                </div>
                <select class="switch-pet-dropdown">
                    <option>Switch Pet: Buddy</option>
                    <option>Switch Pet: Luna</option>
                    <option>Switch Pet: Max</option>
                </select>
            </div>

            <div class="pet-dashboard-grid">

                <div class="left-col">
                    <div class="pet-card">
                        <div style="text-align: right; margin-bottom: -10px;">
                            <a href="#" style="color: #cbd5e1;"><i class="fa-solid fa-pen"></i></a>
                        </div>

                        <div class="pet-avatar-wrapper">
                            <img src="https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" alt="Buddy" class="pet-avatar">
                            <div class="status-indicator"></div>
                        </div>

                        <div class="pet-name">Buddy</div>
                        <div class="pet-breed">Golden Retriever</div>

                        <div class="stats-grid">
                            <div class="stat-box">
                                <span class="stat-label">Gender</span>
                                <div class="stat-value">Male</div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">Weight</span>
                                <div class="stat-value">28kg</div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">Age</span>
                                <div class="stat-value">3 Years</div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">Type</span>
                                <div class="stat-value">Dog</div>
                            </div>
                        </div>

                        <div class="alert-box">
                            <div class="alert-title"><i class="fa-solid fa-triangle-exclamation"></i> Allergies & Alerts</div>
                            <div class="alert-content">Chicken, Pollen</div>
                        </div>
                    </div>
                </div>

                <div class="right-col">

                    <div class="history-section">
                        <ul class="nav nav-tabs">
                            <li class="nav-item">
                                <a class="nav-link active" href="#">Medical Visits</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Vaccinations</a>
                            </li>
                        </ul>

                        <table class="history-table">
                            <thead>
                                <tr>
                                    <th>Visit Date</th>
                                    <th>Diagnosis</th>
                                    <th>Veterinarian</th>
                                    <th style="text-align: right;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>2023-10-15</td>
                                    <td>Annual Vaccination</td>
                                    <td>Dr. Sarah Wilson</td>
                                    <td><a href="#" class="view-detail-btn">View Detail <i class="fa-solid fa-chevron-right" style="font-size: 10px;"></i></a></td>
                                </tr>
                                <tr>
                                    <td>2023-08-12</td>
                                    <td>Minor Paw Injury</td>
                                    <td>Dr. James Chen</td>
                                    <td><a href="#" class="view-detail-btn">View Detail <i class="fa-solid fa-chevron-right" style="font-size: 10px;"></i></a></td>
                                </tr>
                                <tr>
                                    <td>2023-05-20</td>
                                    <td>Dietary Consultation</td>
                                    <td>Dr. Emily Brown</td>
                                    <td><a href="#" class="view-detail-btn">View Detail <i class="fa-solid fa-chevron-right" style="font-size: 10px;"></i></a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="summary-cards">
                        <div class="summary-card">
                            <div class="icon-box icon-blue">
                                <i class="fa-regular fa-file-lines"></i>
                            </div>
                            <div class="summary-info">
                                <h4>Total Visits</h4>
                                <div>
                                    <span class="big-number">12</span>
                                    <span class="sub-text">Since registration in 2021</span>
                                </div>
                            </div>
                        </div>

                        <div class="summary-card">
                            <div class="icon-box icon-purple">
                                <i class="fa-regular fa-credit-card"></i>
                            </div>
                            <div class="summary-info">
                                <h4>Last Billing</h4>
                                <div>
                                    <span class="big-number">$85.50</span>
                                    <span class="sub-text">Paid on Oct 15, 2023</span>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>