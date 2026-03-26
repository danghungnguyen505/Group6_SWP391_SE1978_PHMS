<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>VetCare Pro - EDIT STAFF: ${staff.fullName}</title>
        <!-- Fonts & Icons -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            :root {
                --sidebar-width: 280px;
                --primary-green: #50b498;
                --bg-body: #f8fafc;
                --text-main: #0f172a;
                --text-muted: #718096;
                --input-bg: #f8fafc;
                --card-shadow: 0 4px 25px -5px rgba(0, 0, 0, 0.05);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                -webkit-font-smoothing: antialiased;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--bg-body);
                color: var(--text-main);
                display: flex;
                min-height: 100vh;
            }

            /* --- SIDEBAR --- */
            .sidebar {
                width: var(--sidebar-width);
                background: #ffffff;
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                padding: 35px 25px;
                display: flex;
                flex-direction: column;
                border-right: 1px solid #edf2f7;
                z-index: 1000;
            }
            .logo {
                display: flex;
                align-items: center;
                gap: 12px;
                color: var(--primary-green);
                font-weight: 800;
                font-size: 22px;
                margin-bottom: 50px;
                padding-left: 10px;
            }
            .menu-label {
                color: #a0aec0;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1.2px;
                margin-bottom: 20px;
                padding-left: 10px;
            }
            .nav-menu {
                list-style: none;
                flex: 1;
            }
            .nav-item {
                margin-bottom: 6px;
            }
            .nav-link {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 12px 18px;
                text-decoration: none;
                color: var(--text-muted);
                font-weight: 500;
                font-size: 15px;
                border-radius: 12px;
                transition: 0.2s;
            }
            .nav-link:hover {
                background: #f7fafc;
                color: var(--text-main);
            }
            .nav-link.active {
                background: #f0fff4;
                color: var(--primary-green);
                font-weight: 600;
            }
            .nav-link i {
                width: 22px;
                font-size: 18px;
                text-align: center;
            }

            /* --- MAIN CONTENT --- */
            .main-content {
                margin-left: var(--sidebar-width);
                flex: 1;
                padding: 40px 60px;
            }

            .page-header {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-bottom: 40px;
            }
            .btn-back {
                width: 45px;
                height: 45px;
                background: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                text-decoration: none;
                color: #a0aec0;
                box-shadow: 0 4px 10px rgba(0,0,0,0.03);
                border: 1px solid #edf2f7;
                transition: 0.2s;
            }
            .btn-back:hover {
                transform: translateX(-3px);
                color: var(--text-main);
            }

            .title-area h1 {
                font-size: 26px;
                font-weight: 900;
                text-transform: uppercase;
                letter-spacing: -0.5px;
            }
            .title-area p {
                color: var(--text-muted);
                margin-top: 4px;
                font-size: 15px;
            }

            /* --- FORM CARD --- */
            .form-container {
                max-width: 900px;
                margin: 0 auto;
                background: white;
                border-radius: 32px;
                padding: 50px 70px;
                box-shadow: var(--card-shadow);
            }

            .section-divider {
                position: relative;
                text-align: center;
                margin: 30px 0 25px;
            }
            .section-divider::before {
                content: "";
                position: absolute;
                top: 50%;
                left: 0;
                width: 100%;
                height: 1px;
                background: #f1f5f9;
                z-index: 1;
            }
            .section-divider span {
                position: relative;
                z-index: 2;
                background: white;
                padding: 0 15px;
                color: #cbd5e0;
                font-size: 10px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 2px;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 25px;
                margin-bottom: 20px;
            }
            .form-group {
                margin-bottom: 5px;
            }
            .form-label {
                display: block;
                font-size: 11px;
                font-weight: 800;
                color: #a0aec0;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 10px;
            }

            .form-input {
                width: 100%;
                padding: 18px 25px;
                background-color: var(--input-bg);
                border: 1px solid #f1f5f9;
                border-radius: 16px;
                font-family: 'Inter', sans-serif;
                font-size: 15px;
                color: var(--text-main);
                transition: 0.2s;
            }
            .form-input:focus {
                outline: none;
                background-color: white;
                border-color: var(--primary-green);
                box-shadow: 0 0 0 4px rgba(80, 180, 152, 0.1);
            }
            .form-input[disabled], .form-input[readonly] {
                background-color: #f8fafc;
                color: var(--text-main);
                cursor: not-allowed;
                opacity: 1;
            }

            /* Actions */
            .form-actions {
                display: flex;
                gap: 15px;
                margin-top: 50px;
            }
            .btn-submit {
                flex: 3;
                background: var(--primary-green);
                color: white;
                padding: 20px;
                border: none;
                border-radius: 16px;
                font-weight: 800;
                font-size: 14px;
                text-transform: uppercase;
                cursor: pointer;
                box-shadow: 0 10px 20px -5px rgba(80, 180, 152, 0.4);
                transition: 0.2s;
            }
            .btn-submit:hover {
                opacity: 0.9;
                transform: translateY(-1px);
            }
            .btn-cancel {
                flex: 1;
                padding: 20px;
                background: #f1f5f9;
                color: var(--text-muted);
                border-radius: 16px;
                text-decoration: none;
                font-weight: 800;
                font-size: 12px;
                text-transform: uppercase;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: 0.2s;
            }
            .btn-cancel:hover {
                background: #e2e8f0;
                color: var(--text-main);
            }

            .alert-danger {
                background: #fee2e2;
                color: #b91c1c;
                padding: 15px;
                border-radius: 12px;
                margin-bottom: 25px;
                font-size: 14px;
                font-weight: 600;
            }
            .help-box {
                margin-top: auto;
                background: #f8fafc;
                padding: 20px;
                border-radius: 16px;
                border: 1px solid #edf2f7;
            }
            .btn-support {
                display: block;
                background: #0f172a;
                color: white;
                text-align: center;
                padding: 10px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 700;
                font-size: 12px;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>

        <jsp:include page="common/navbar.jsp">
            <jsp:param name="activePage" value="staff" />
        </jsp:include>

        <!-- Main Content -->
        <main class="main-content">
            <c:if test="${not empty staff}">
                <header class="page-header">
                    <a href="${pageContext.request.contextPath}/admin/staff/list" class="btn-back"><i class="fa-solid fa-chevron-left"></i></a>
                    <div class="title-area">
                        <h1>Edit Staff: ${staff.fullName}</h1>
                        <p>Complete the form below to modify employee details.</p>
                    </div>
                </header>

                <div class="form-container">
                    <c:if test="${not empty error}">
                        <div class="alert-danger">${error}</div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/admin/staff/update">
                        <input type="hidden" name="userId" value="${staff.userId}">

                        <div class="section-divider"><span>Account Credentials</span></div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Username</label>
                                <input type="text" value="${staff.username}" disabled class="form-input">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Reset Password (Optional)</label>
                                <input type="password" name="password" class="form-input" placeholder="********">
                            </div>
                        </div>

                        <div class="section-divider"><span>Personal Information</span></div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Full Name *</label>
                                <input type="text" name="fullName" value="${staff.fullName}" required class="form-input">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Employee Code *</label>
                                <input type="text" name="employeeCode" value="${employeeCode}" required class="form-input">
                            </div>
                        </div>

                        <div class="section-divider"><span>Role & Salary</span></div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Job Role *</label>
                                <select name="role" id="roleSelect" required class="form-input" 
                                        onchange="toggleVetFields()" 
                                        ${staff.role == 'Admin' ? 'disabled' : ''}>
                                    <option value="Veterinarian" ${staff.role == 'Veterinarian' ? 'selected' : ''}>Veterinarian</option>
                                    <option value="Nurse" ${staff.role == 'Nurse' ? 'selected' : ''}>Nurse</option>
                                    <option value="Receptionist" ${staff.role == 'Receptionist' ? 'selected' : ''}>Receptionist</option>
                                    <option value="ClinicManager" ${staff.role == 'ClinicManager' ? 'selected' : ''}>Clinic Manager</option>
                                    <option value="Admin" ${staff.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                </select>

                                <c:if test="${staff.role == 'Admin'}">
                                    <input type="hidden" name="role" value="Admin">
                                </c:if>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Base Salary (VND)</label>
                                <input type="number" name="salaryBase" value="${salaryBase}" class="form-input">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Phone Number *</label>
                                <input type="text" name="phone" value="${staff.phone}" required class="form-input">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Work Status</label>
                                <input type="text" class="form-input" value="Đang làm việc (Active)" readonly style="font-weight: 700;">
                            </div>
                        </div>

                        <!-- Special Fields for Veterinarian -->
                        <div id="specializationGroup">
                            <div class="form-group" style="margin-top: 15px;">
                                <label class="form-label">Specialization (Veterinarian only)</label>
                                <input type="text" name="specialization" value="${specialization}" class="form-input">
                            </div>
                        </div>
                        <div id="licenseGroup">
                            <div class="form-group" style="margin-top: 20px;">
                                <label class="form-label">License Number (Veterinarian only)</label>
                                <input type="text" name="licenseNumber" value="${licenseNumber}" class="form-input">
                            </div>
                        </div>
                        <div id="vetTypeGroup">
                            <div class="form-group" style="margin-top: 20px;">
                                <label class="form-label">Veterinarian Type</label>
                                <select name="vetType" class="form-input">
                                    <option value="Normal" ${vetType == 'Normal' || empty vetType ? 'selected' : ''}>Normal</option>
                                    <option value="Emergency" ${vetType == 'Emergency' ? 'selected' : ''}>Emergency</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn-submit">Update Changes</button>
                            <a href="${pageContext.request.contextPath}/admin/staff/list" class="btn-cancel">Cancel</a>
                        </div>
                    </form>
                </div>
            </c:if>
        </main>

        <script>
            function toggleVetFields() {
                const role = document.getElementById('roleSelect').value;
                const specGroup = document.getElementById('specializationGroup');
                const licenseGroup = document.getElementById('licenseGroup');
                const vetTypeGroup = document.getElementById('vetTypeGroup');

                if (role === 'Veterinarian') {
                    specGroup.style.display = 'block';
                    licenseGroup.style.display = 'block';
                    vetTypeGroup.style.display = 'block';
                } else {
                    specGroup.style.display = 'none';
                    licenseGroup.style.display = 'none';
                    vetTypeGroup.style.display = 'none';
                }
            }
            // Khởi chạy khi load trang
            toggleVetFields();
        </script>
    </body>
</html>
