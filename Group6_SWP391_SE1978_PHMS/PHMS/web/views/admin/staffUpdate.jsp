<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Update Staff Account</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <style>
            #specializationGroup, #licenseGroup {
                display: none;
            }
        </style>
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff/list" class="active">Staff Accounts</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Update Staff Account</h2>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:if test="${not empty staff}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/staff/update">
                        <input type="hidden" name="userId" value="${staff.userId}">
                        
                        <div style="margin-bottom:15px;">
                            <label><b>Username</b></label>
                            <input type="text" value="${staff.username}" disabled 
                                   style="width:100%; padding:8px; background:#f3f4f6;">
                            <small style="color:#6b7280;">Username cannot be changed</small>
                        </div>

                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:15px;">
                            <div>
                                <label><b>Full Name *</b></label>
                                <input type="text" name="fullName" value="${staff.fullName}" required maxlength="100" 
                                       style="width:100%; padding:8px;">
                            </div>
                            <div>
                                <label><b>Phone *</b></label>
                                <input type="text" name="phone" value="${staff.phone}" required maxlength="20" 
                                       style="width:100%; padding:8px;">
                            </div>
                        </div>

                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:15px;">
                            <div>
                                <label><b>Role *</b></label>
                                <select name="role" id="roleSelect" required style="width:100%; padding:8px;" onchange="toggleVetFields()">
                                    <option value="Veterinarian" ${staff.role == 'Veterinarian' ? 'selected' : ''}>Veterinarian</option>
                                    <option value="Nurse" ${staff.role == 'Nurse' ? 'selected' : ''}>Nurse</option>
                                    <option value="Receptionist" ${staff.role == 'Receptionist' ? 'selected' : ''}>Receptionist</option>
                                    <option value="ClinicManager" ${staff.role == 'ClinicManager' ? 'selected' : ''}>Clinic Manager</option>
                                    <option value="Admin" ${staff.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                </select>
                            </div>
                            <div>
                                <label><b>Employee Code *</b></label>
                                <input type="text" name="employeeCode" value="${employeeCode}" required maxlength="20" 
                                       style="width:100%; padding:8px;">
                            </div>
                        </div>

                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:15px;">
                            <div>
                                <label><b>Department</b></label>
                                <input type="text" name="department" value="${department}" maxlength="100" 
                                       style="width:100%; padding:8px;">
                            </div>
                            <div>
                                <label><b>Salary Base (VND)</b></label>
                                <input type="number" name="salaryBase" value="${salaryBase}" step="0.01" min="0" 
                                       style="width:100%; padding:8px;">
                            </div>
                        </div>

                        <div id="specializationGroup" style="margin-bottom:15px;">
                            <label><b>Specialization (Veterinarian only)</b></label>
                            <input type="text" name="specialization" value="${specialization}" maxlength="100" 
                                   style="width:100%; padding:8px;">
                        </div>

                        <div id="licenseGroup" style="margin-bottom:15px;">
                            <label><b>License Number (Veterinarian only)</b></label>
                            <input type="text" name="licenseNumber" value="${licenseNumber}" maxlength="50" 
                                   style="width:100%; padding:8px;">
                        </div>

                        <div style="display:flex; gap:10px; margin-top:20px;">
                            <a href="${pageContext.request.contextPath}/admin/staff/list" 
                               class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;">Cancel</a>
                            <button type="submit" class="btn btn-approve">
                                <i class="fa-solid fa-save"></i> Update Staff Account
                            </button>
                        </div>
                    </form>
                </c:if>
            </div>
        </main>

        <script>
            function toggleVetFields() {
                const role = document.getElementById('roleSelect').value;
                const specGroup = document.getElementById('specializationGroup');
                const licenseGroup = document.getElementById('licenseGroup');
                
                if (role === 'Veterinarian') {
                    specGroup.style.display = 'block';
                    licenseGroup.style.display = 'block';
                } else {
                    specGroup.style.display = 'none';
                    licenseGroup.style.display = 'none';
                }
            }
            
            toggleVetFields();
        </script>
    </body>
</html>
