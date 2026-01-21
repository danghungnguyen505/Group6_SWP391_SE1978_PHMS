<%-- 
    Document   : pet-detail
    Created on : 22 thg 1, 2026, 03:11:52
    Author     : quag
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Pet"%>
<%@page import="model.MedicalRecord"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pet Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .profile-header { background: white; border-radius: 12px; padding: 25px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .nav-tabs .nav-link.active { border-color: #dee2e6 #dee2e6 #fff; color: #0d9488; font-weight: bold; border-top: 3px solid #0d9488; }
        .nav-link { color: #6c757d; }
    </style>
</head>
<body class="bg-light">
    <%
        Pet p = (Pet) request.getAttribute("pet");
        List<MedicalRecord> list = (List<MedicalRecord>) request.getAttribute("emrList");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        
        if (p == null) {
            response.sendRedirect("pets");
            return;
        }
    %>

    <div class="container py-5">
        <!-- Nút quay lại -->
        <a href="pets" class="btn btn-link text-secondary mb-3 ps-0 text-decoration-none">
            <i class="fas fa-arrow-left me-2"></i>Back to My Pets List
        </a>

        <!-- Header thông tin Pet -->
        <div class="profile-header d-flex align-items-center gap-4 mb-4">
            <!-- Ảnh đại diện giả lập -->
            <img src="https://placedog.net/300/300?id=<%= p.getPetId() %>" 
                 class="rounded-circle border border-3 border-success" 
                 style="width: 120px; height: 120px; object-fit: cover;">
            
            <div class="flex-grow-1">
                <h2 class="mb-1"><%= p.getName() %></h2>
                <div class="text-muted mb-2">
                    <span class="badge bg-light text-dark border me-2"><%= p.getSpecies() %></span>
                    <span class="badge bg-light text-dark border">ID: #<%= p.getPetId() %></span>
                </div>
            </div>
            <div>
                <a href="pet-form?id=<%= p.getPetId() %>" class="btn btn-outline-primary">
                    <i class="fas fa-edit me-2"></i>Edit Profile
                </a>
            </div>
        </div>

        <!-- Tabs Chức năng -->
        <ul class="nav nav-tabs mb-3 bg-white px-3 pt-2 rounded-top border-bottom-0">
            <li class="nav-item">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#overview">
                    <i class="fas fa-info-circle me-2"></i>Overview
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#emr">
                    <i class="fas fa-notes-medical me-2"></i>Medical History
                </button>
            </li>
        </ul>

        <div class="tab-content">
            <!-- Tab 1: Tổng quan -->
            <div class="tab-pane fade show active" id="overview">
                <div class="card border-0 shadow-sm p-4">
                    <h5 class="mb-3 text-success">Description / Symptoms</h5>
                    <p class="text-muted" style="font-size: 1.1rem; line-height: 1.6;">
                        <%= p.getHistorySummary() != null ? p.getHistorySummary() : "No description available." %>
                    </p>
                    <hr>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="small text-muted">Species</label>
                            <div class="fw-bold"><%= p.getSpecies() %></div>
                        </div>
                        <div class="col-md-4">
                             <!-- Giả lập dữ liệu vì DB chưa có cột Breed/Weight -->
                            <label class="small text-muted">Breed</label>
                            <div class="fw-bold">Unknown (Update DB to show)</div>
                        </div>
                        <div class="col-md-4">
                            <label class="small text-muted">Weight</label>
                            <div class="fw-bold">-- kg</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tab 2: Lịch sử khám bệnh (Past Diagnoses) -->
            <div class="tab-pane fade" id="emr">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="card-title text-success">Past Diagnoses & Treatments</h5>
                            <button class="btn btn-sm btn-outline-success">Print Records</button>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 20%">Date & Time</th>
                                        <th style="width: 25%">Diagnosis</th>
                                        <th style="width: 35%">Treatment Plan</th>
                                        <th style="width: 20%">Veterinarian</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    if (list != null && !list.isEmpty()) {
                                        for (MedicalRecord r : list) {
                                    %>
                                    <tr>
                                        <td>
                                            <div class="fw-bold"><%= sdf.format(r.getVisitDate()) %></div>
                                        </td>
                                        <td>
                                            <span class="text-danger fw-medium"><%= r.getDiagnosis() %></span>
                                        </td>
                                        <td><%= r.getTreatment() %></td>
                                        <td>
                                            <i class="fas fa-user-md me-1 text-muted"></i>
                                            <%= (r.getVetName() != null) ? r.getVetName() : "Unknown" %>
                                        </td>
                                    </tr>
                                    <% 
                                        }
                                    } else { 
                                    %>
                                    <tr>
                                        <td colspan="4" class="text-center py-5 text-muted">
                                            <i class="fas fa-folder-open fa-2x mb-3"></i><br>
                                            No medical records found for this pet.
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
