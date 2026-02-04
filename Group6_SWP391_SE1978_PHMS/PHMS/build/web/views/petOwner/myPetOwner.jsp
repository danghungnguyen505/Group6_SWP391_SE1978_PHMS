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
                    <a href="#" class="nav-link">
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
                    <a href="${pageContext.request.contextPath}/my-medical-records" class="nav-link">
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
                <form method="get" action="${pageContext.request.contextPath}/myPetOwner">
                    <!-- Giữ lại search khi đổi dropdown -->
                    <c:if test="${not empty searchKeyword}">
                        <input type="hidden" name="search" value="${searchKeyword}">
                    </c:if>

                    <select class="switch-pet-dropdown" name="selectedPetId" onchange="this.form.submit()">
                        <c:if test="${empty allPets}">
                            <option value="">No pets found</option>
                        </c:if>
                        <c:forEach items="${allPets}" var="p">
                            <option value="${p.id}" ${selectedPet != null && selectedPet.id == p.id ? 'selected' : ''}>
                                ${p.name} (${p.species})
                            </option>
                        </c:forEach>
                    </select>
                </form>
            </div>

            <div class="pet-dashboard-grid">

                <!-- Left Column: Selected Pet Details -->
                <div class="left-col">
                    <div class="pet-card">
                        <div style="text-align: right; margin-bottom: -10px;">
                            <c:if test="${not empty selectedPet}">
                                <a href="${pageContext.request.contextPath}/pet/update?id=${selectedPet.id}" style="color: #cbd5e1;" title="Edit pet">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                            </c:if>
                        </div>

                        <div class="pet-avatar-wrapper">
                            <img src="https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60" alt="Buddy" class="pet-avatar">
                            <div class="status-indicator"></div>
                        </div>

                        <c:if test="${empty selectedPet}">
                            <div class="pet-name">No pets</div>
                            <div class="pet-breed">Add a pet or clear search</div>
                        </c:if>
                        <c:if test="${not empty selectedPet}">
                            <div class="pet-name">${selectedPet.name}</div>
                            <div class="pet-breed">${selectedPet.species}</div>
                        </c:if>

                        <div class="stats-grid">
                            <div class="stat-box">
                                <span class="stat-label">Pet ID</span>
                                <div class="stat-value"><c:out value="${selectedPet != null ? selectedPet.id : '-'}"/></div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">Species</span>
                                <div class="stat-value"><c:out value="${selectedPet != null ? selectedPet.species : '-'}"/></div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">Appointments</span>
                                <div class="stat-value">-</div>
                            </div>
                            <div class="stat-box">
                                <span class="stat-label">Status</span>
                                <div class="stat-value">Active</div>
                            </div>
                        </div>

                        <div class="alert-box">
                            <div class="alert-title"><i class="fa-solid fa-notes-medical"></i> History Summary</div>
                            <div class="alert-content">
                                <c:if test="${empty selectedPet || empty selectedPet.historySummary}">
                                    <span style="color:#94a3b8; font-style: italic;">No history summary</span>
                                </c:if>
                                <c:if test="${not empty selectedPet && not empty selectedPet.historySummary}">
                                    <c:out value="${selectedPet.historySummary}"/>
                                </c:if>
                            </div>
                        </div>

                        <c:if test="${not empty selectedPet}">
                            <form action="${pageContext.request.contextPath}/pet/delete" method="post" style="margin-top: 12px;">
                                <input type="hidden" name="id" value="${selectedPet.id}">
                                <button type="submit" class="btn btn-outline-danger btn-sm"
                                        onclick="return confirm('Bạn chắc chắn muốn xóa thú cưng này?');">
                                    <i class="fa-solid fa-trash"></i> Delete Pet
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>

                <!-- Right Column: List & History -->
                <div class="right-col">

                    <div class="history-section" style="margin-bottom: 20px;">

                        <!-- Header with Search -->
                        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                            <h3 style="margin:0;">My Pets List</h3>

                            <div class="d-flex gap-2">
                                <form action="${pageContext.request.contextPath}/myPetOwner" method="get" class="d-flex">
                                    <div class="input-group input-group-sm">
                                        <input type="text" name="search" class="form-control" 
                                               placeholder="Search name/species..." 
                                               value="${searchKeyword}">
                                        <button class="btn btn-outline-primary" type="submit">
                                            <i class="fa-solid fa-magnifying-glass"></i>
                                        </button>
                                        <c:if test="${not empty searchKeyword}">
                                            <a href="${pageContext.request.contextPath}/myPetOwner" class="btn btn-outline-secondary" title="Clear">
                                                <i class="fa-solid fa-xmark"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </form>
                                <a class="btn btn-primary btn-sm d-flex align-items-center" href="${pageContext.request.contextPath}/pet/add">
                                    <i class="fa-solid fa-plus me-1"></i> Add
                                </a>
                            </div>
                        </div>

                        <c:if test="${empty pets}">
                            <div class="empty-state">
                                <p>No pets found.</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty pets}">
                            <table class="history-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Species</th>
                                        <th style="text-align:right;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${pets}" var="p2">
                                        <!-- Giữ param search khi click xem chi tiết -->
                                        <c:set var="searchParam" value="${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}" />

                                        <tr>
                                            <td>#${p2.id}</td>
                                            <td>${p2.name}</td>
                                            <td>${p2.species}</td>
                                            <td style="text-align:right;">
                                                <a class="view-detail-btn" href="${pageContext.request.contextPath}/myPetOwner?selectedPetId=${p2.id}${searchParam}" style="margin-right: 10px;">View</a>
                                                <a class="view-detail-btn" href="${pageContext.request.contextPath}/pet/update?id=${p2.id}" style="margin-right: 10px;">Edit</a>
                                                <form action="${pageContext.request.contextPath}/pet/delete" method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="${p2.id}">
                                                    <button type="submit" class="view-detail-btn" style="border:none; background:none; color:#ef4444;"
                                                            onclick="return confirm('Bạn chắc chắn muốn xóa thú cưng này?');">Delete</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Pagination with Search Param -->
                            <c:if test="${totalPages > 1}">
                                <div style="display:flex; gap:8px; justify-content:flex-end; margin-top: 10px;">
                                    <c:set var="searchParam" value="${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}" />
                                    <c:set var="selectedParam" value="${selectedPet != null ? '&selectedPetId='.concat(selectedPet.id) : ''}" />

                                    <c:if test="${currentPage > 1}">
                                        <a class="view-detail-btn" href="?page=${currentPage - 1}${searchParam}${selectedParam}">Prev</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <a class="view-detail-btn" href="?page=${i}${searchParam}${selectedParam}"
                                           style="${currentPage == i ? 'font-weight:700; background-color:#e2e8f0;' : ''}">${i}</a>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <a class="view-detail-btn" href="?page=${currentPage + 1}${searchParam}${selectedParam}">Next</a>
                                    </c:if>
                                </div>
                            </c:if>
                        </c:if>
                    </div>

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
                                    <td colspan="4" style="color:#94a3b8; font-style: italic;">Medical history (EMR) will be implemented next.</td>
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