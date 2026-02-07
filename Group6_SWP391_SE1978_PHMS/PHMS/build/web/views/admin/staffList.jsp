<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>VetCare Pro - STAFF MANAGEMENT</title>
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

            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 40px;
            }
            .page-header h2 {
                font-size: 28px;
                font-weight: 900;
                text-transform: uppercase;
                letter-spacing: -0.5px;
            }
            .page-header p {
                color: var(--text-muted);
                margin-top: 5px;
                font-size: 15px;
            }

            .btn-create {
                background: var(--primary-green);
                color: white;
                padding: 12px 24px;
                border-radius: 10px;
                font-weight: 800;
                text-decoration: none;
                font-size: 13px;
                text-transform: uppercase;
                box-shadow: 0 4px 15px rgba(80, 180, 152, 0.2);
                transition: 0.2s;
            }

            /* --- TABLE CARD --- */
            .card {
                background: white;
                border-radius: 24px;
                padding: 10px 40px 30px;
                box-shadow: var(--card-shadow);
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
            }

            .data-table th {
                text-align: left;
                padding: 25px 15px;
                font-size: 11px;
                font-weight: 800;
                color: #a0aec0;
                text-transform: uppercase;
                letter-spacing: 0.8px;
                border-bottom: 1px solid #f1f5f9;
            }

            .data-table td {
                padding: 20px 15px;
                font-size: 14px;
                border-bottom: 1px solid #f8fafc;
                vertical-align: middle;
            }

            .col-id {
                color: #cbd5e0;
                font-weight: 600;
                width: 60px;
            }
            .col-username {
                color: var(--primary-green);
                font-weight: 700;
            }
            .col-fullname {
                font-weight: 800;
                color: var(--text-main);
            }
            .col-empcode {
                font-weight: 700;
                color: #cbd5e0;
                letter-spacing: 1px;
            }

            /* Role Badges */
            .role-badge {
                padding: 5px 12px;
                border-radius: 6px;
                font-size: 10px;
                font-weight: 800;
                text-transform: uppercase;
            }
            .role-vet {
                background: #e0e7ff;
                color: #4338ca;
            }
            .role-nurse {
                background: #f0f9ff;
                color: #0369a1;
            }
            .role-recep {
                background: #f5f3ff;
                color: #5b21b6;
            }

            /* Status Badges */
            .status-badge {
                padding: 6px 14px;
                border-radius: 20px;
                font-size: 10px;
                font-weight: 800;
                text-transform: uppercase;
            }
            .status-active {
                background: #dcfce7;
                color: #15803d;
            }
            .status-inactive {
                background: #f1f5f9;
                color: #94a3b8;
            }

            .btn-action {
                background: none;
                border: none;
                cursor: pointer;
                font-size: 16px;
                margin-right: 12px;
                transition: 0.2s;
                color: #805ad5;
            }
            .btn-lock {
                color: #cbd5e0;
            }
            .btn-locked {
                color: #f6ad55;
            }

            /* Pagination (unified with medicine & services) */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 15px;
                margin-top: 30px;
                padding-bottom: 10px;
            }
            .btn-page {
                padding: 8px 16px;
                background: #f1f5f9;
                color: var(--text-muted);
                border-radius: 10px;
                text-decoration: none;
                font-weight: 700;
                font-size: 12px;
                transition: 0.2s;
            }
            .btn-page:hover {
                background: #e2e8f0;
                color: var(--text-main);
            }
            .page-info {
                font-size: 13px;
                font-weight: 600;
                color: var(--text-muted);
            }

            .note-text {
                font-size: 11px;
                color: #cbd5e0;
                font-style: italic;
                margin-top: 25px;
                font-weight: 600;
            }

            /* Need help? box in sidebar */
            .help-box {
                margin-top: auto;
                background: #f8fafc;
                padding: 20px;
                border-radius: 16px;
                border: 1px solid #edf2f7;
            }
            .help-box p {
                font-size: 13px;
                font-weight: 600;
                margin-bottom: 12px;
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
            }
        </style>
    </head>
    <body>

        <jsp:include page="common/navbar.jsp">
            <jsp:param name="activePage" value="staff" />
        </jsp:include>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Staff Management</h2>
                    <p>Manage employee accounts, credentials and working status</p>
                </div>
                <div style="display:flex; gap:15px; align-items:center;">
                    <form action="${pageContext.request.contextPath}/admin/staff/list" method="get" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
                        <input type="text" name="search" placeholder="Search name/username/phone/code..." 
                               value="${searchKeyword}" 
                               style="padding:8px 10px; border-radius:8px; border:1px solid #e2e8f0; font-size:13px; min-width:200px;">

                        <select name="role" style="padding:8px 10px; border-radius:8px; border:1px solid #e2e8f0; font-size:13px;">
                            <option value="">All roles</option>
                            <option value="Veterinarian" ${roleFilter == 'Veterinarian' ? 'selected' : ''}>Veterinarian</option>
                            <option value="Nurse" ${roleFilter == 'Nurse' ? 'selected' : ''}>Nurse</option>
                            <option value="Receptionist" ${roleFilter == 'Receptionist' ? 'selected' : ''}>Receptionist</option>
                            <option value="ClinicManager" ${roleFilter == 'ClinicManager' ? 'selected' : ''}>Clinic Manager</option>
                            <option value="Admin" ${roleFilter == 'Admin' ? 'selected' : ''}>Admin</option>
                        </select>

                        <select name="status" style="padding:8px 10px; border-radius:8px; border:1px solid #e2e8f0; font-size:13px;">
                            <option value="">All statuses</option>
                            <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                            <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Locked</option>
                        </select>

                        <button type="submit" class="btn-create" style="padding:8px 14px; text-transform:none;">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                        <c:if test="${not empty searchKeyword || not empty roleFilter || not empty statusFilter}">
                            <a href="${pageContext.request.contextPath}/admin/staff/list" 
                               style="font-size:12px; color:#a0aec0; text-decoration:none;">Clear</a>
                        </c:if>
                    </form>
                    <a href="${pageContext.request.contextPath}/admin/staff/create" class="btn-create">Create New</a>
                </div>
            </div>

            <div class="card">
                <c:choose>
                    <c:when test="${empty staffAccounts}">
                        <div style="text-align:center; padding:60px; color:#cbd5e0;">
                            <i class="fa-solid fa-users-slash" style="font-size:48px; margin-bottom:20px;"></i>
                            <p>No staff accounts found.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th class="col-id">ID</th>
                                    <th>Username</th>
                                    <th>Full Name</th>
                                    <th>Role</th>
                                    <th>Phone</th>
                                    <th>Employee Code</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="staff" items="${staffAccounts}">
                                    <tr>
                                        <td class="col-id">#${staff.userId}</td>
                                        <td class="col-username">${staff.username}</td>
                                        <td class="col-fullname">${staff.fullName}</td>
                                        <td>
                                            <c:set var="roleClass" value="role-recep" />
                                            <c:if test="${staff.role == 'Veterinarian'}"><c:set var="roleClass" value="role-vet" /></c:if>
                                            <c:if test="${staff.role == 'Nurse'}"><c:set var="roleClass" value="role-nurse" /></c:if>
                                            <span class="role-badge ${roleClass}">${staff.role}</span>
                                        </td>
                                        <td>${staff.phone}</td>
                                        <td class="col-empcode">
                                            <c:if test="${not empty staff.address}">
                                                <c:set var="parts" value="${fn:split(staff.address, '|')}" />
                                                <c:if test="${fn:length(parts) > 0}">${parts[0]}</c:if>
                                            </c:if>
                                        </td>
                                        <!-- Tách chuỗi address thành mảng parts -->
                                        <c:set var="parts" value="${fn:split(staff.address, '|')}" />

                                        <td>
                                            <%-- parts[0]: Code, parts[1]: Dept, parts[2]: Salary, parts[3]: Active --%>
                                            <c:choose>
                                                <c:when test="${parts[3] == '1'}">
                                                    <span class="status-badge status-active">Đang làm việc</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-inactive">Đã khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/staff/update?id=${staff.userId}" class="btn-action" title="Edit">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>

                                            <form method="post" action="${pageContext.request.contextPath}/admin/staff/lock" style="display:inline;" 
                                                  onsubmit="return confirm('Bạn có chắc chắn muốn thay đổi trạng thái tài khoản này?');">
                                                <input type="hidden" name="id" value="${staff.userId}">

                                                <c:choose>
                                                    <c:when test="${parts[3] == '1'}">
                                                        <button type="submit" class="btn-action btn-lock" title="Khóa tài khoản">
                                                            <i class="fa-solid fa-lock"></i>
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="submit" class="btn-action btn-unlock" title="Mở khóa tài khoản">
                                                            <i class="fa-solid fa-lock-open"></i>
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <div class="note-text">
                            * NOTE: LOCKED ACCOUNTS CANNOT ACCESS THE SYSTEM UNTIL UNLOCKED BY AN ADMINISTRATOR.
                            <c:if test="${not empty searchKeyword || not empty roleFilter || not empty statusFilter}">
                                <br/>Filter:
                                <c:if test="${not empty searchKeyword}">
                                    keyword "<c:out value="${searchKeyword}"/>" 
                                </c:if>
                                <c:if test="${not empty roleFilter}">
                                    | role: <c:out value="${roleFilter}"/>
                                </c:if>
                                <c:if test="${not empty statusFilter}">
                                    | status: <c:out value="${statusFilter}"/>
                                </c:if>
                            </c:if>
                        </div>

                        <!-- Pagination (unified style, keep search & filters) -->
                        <c:if test="${totalPages > 1}">
                            <c:set var="searchParam" value="${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}" />
                            <c:set var="roleParam" value="${not empty roleFilter ? '&role='.concat(roleFilter) : ''}" />
                            <c:set var="statusParam" value="${not empty statusFilter ? '&status='.concat(statusFilter) : ''}" />
                            <c:set var="queryParams" value="${searchParam.concat(roleParam).concat(statusParam)}" />
                            <div class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}${queryParams}" class="btn-page">Previous</a>
                                </c:if>

                                <span class="page-info">Page ${currentPage} of ${totalPages}</span>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}${queryParams}" class="btn-page">Next</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </body>
</html>