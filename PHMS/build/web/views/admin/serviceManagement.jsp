<%-- 
    Document   : serviceManagement
    Created on : Jan 22, 2026, 2:43:16 AM
    Author     : Nguyen Dang Hung
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - SERVICE CATALOG</title>
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

        * { margin: 0; padding: 0; box-sizing: border-box; -webkit-font-smoothing: antialiased; }

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
            left: 0; top: 0;
            padding: 35px 25px;
            display: flex;
            flex-direction: column;
            border-right: 1px solid #edf2f7;
            z-index: 1000;
        }
        .logo { display: flex; align-items: center; gap: 12px; color: var(--primary-green); font-weight: 800; font-size: 22px; margin-bottom: 50px; padding-left: 10px; }
        .menu-label { color: #a0aec0; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 20px; padding-left: 10px; }
        .nav-menu { list-style: none; }
        .nav-item { margin-bottom: 6px; }
        .nav-link { display: flex; align-items: center; gap: 15px; padding: 12px 18px; text-decoration: none; color: var(--text-muted); font-weight: 500; font-size: 15px; border-radius: 12px; transition: 0.2s; }
        .nav-link:hover { background: #f7fafc; color: var(--text-main); }
        .nav-link.active { background: #f0fff4; color: var(--primary-green); font-weight: 600; }
        .nav-link i { width: 22px; font-size: 18px; text-align: center; }

        /* --- MAIN CONTENT --- */
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 40px 60px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 40px;
        }
        .title-area h1 { font-size: 28px; font-weight: 900; text-transform: uppercase; letter-spacing: -0.5px; }
        .title-area p { color: var(--text-muted); margin-top: 5px; font-size: 15px; }

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
        .table-container {
            background: white;
            border-radius: 24px;
            padding: 10px 40px;
            box-shadow: var(--card-shadow);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th {
            text-align: left; /* Căn lề trái toàn bộ tiêu đề */
            padding: 25px 15px;
            font-size: 11px;
            font-weight: 800;
            color: #a0aec0;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border-bottom: 1px solid #f1f5f9;
        }

        .data-table td {
            padding: 25px 15px;
            font-size: 14px;
            border-bottom: 1px solid #f8fafc;
            vertical-align: middle;
            text-align: left; /* Đảm bảo dữ liệu mặc định căn trái */
        }

        .col-id { color: #cbd5e0; font-weight: 600; width: 60px; }
        .col-name { font-weight: 800; color: var(--text-main); font-size: 15px; width: 180px; }
        .col-desc { color: var(--text-muted); font-style: italic; font-size: 13px; max-width: 320px; line-height: 1.5; }
        
        /* Chỉnh sửa căn lề trái cho 3 cột cuối */
        .col-price { font-weight: 800; font-size: 16px; color: var(--text-main); width: 160px; }
        .col-status { width: 140px; }
        .col-action { width: 100px; }

        .badge {
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 10px;
            font-weight: 800;
            text-transform: uppercase;
            display: inline-block;
        }
        .badge-active { background: #dcfce7; color: #15803d; }
        .badge-inactive { background: #fee2e2; color: #b91c1c; opacity: 0.8; }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin-top: 30px;
            padding-bottom: 20px;
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

        .btn-action {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 18px;
            margin-right: 12px; /* Khoảng cách giữa 2 icon khi căn trái */
            transition: 0.2s;
        }
        .btn-edit { color: #805ad5; }
        .btn-stop { color: #fc8181; }
        .btn-play { color: #68d391; }

        .help-box { margin-top: auto; background: #f8fafc; padding: 20px; border-radius: 16px; border: 1px solid #edf2f7; }
        .help-box p { font-size: 13px; font-weight: 600; margin-bottom: 12px; }
        .btn-support { display: block; background: #0f172a; color: white; text-align: center; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 12px; }

    </style>
</head>
<body>

    <jsp:include page="common/navbar.jsp">
    <jsp:param name="activePage" value="services" />
</jsp:include>

    <main class="main-content">
        <header class="page-header">
            <div class="title-area">
                <h1>Service Catalog</h1>
                <p>Configure examination types and basic price list. Total: ${totalServices} services</p>
            </div>
            <div style="display:flex; gap:15px; align-items:center;">
                <form action="services" method="get" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
                    <input type="text" name="search" placeholder="Search name/description..." 
                           value="${searchKeyword}" 
                           style="padding:8px 10px; border-radius:8px; border:1px solid #e2e8f0; font-size:13px; min-width:200px;">

                    <select name="status" style="padding:8px 10px; border-radius:8px; border:1px solid #e2e8f0; font-size:13px;">
                        <option value="">All statuses</option>
                        <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                        <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Inactive</option>
                    </select>

                    <button type="submit" class="btn-create" style="padding:8px 14px; text-transform:none;">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                    <c:if test="${not empty searchKeyword || not empty statusFilter}">
                        <a href="services" 
                           style="font-size:12px; color:#a0aec0; text-decoration:none;">Clear</a>
                    </c:if>
                </form>
                <a href="add-service" class="btn-create">Create New</a>
            </div>
        </header>

        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th class="col-id">STT</th>
                        <th class="col-name">Service Name</th>
                        <th class="col-desc">Description</th>
                        <th class="col-price">Base Price (VND)</th>
                        <th class="col-status">Status</th>
                        <th class="col-action">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="service" items="${services}" varStatus="st">
                        <tr>
                            <td class="col-id">${st.index + 1}</td>
                            <td class="col-name">${service.name}</td>
                            <td class="col-desc">"${service.description}"</td>
                            <td class="col-price">
                                <fmt:formatNumber value="${service.basePrice}" pattern="#,###"/>đ
                            </td>
                            <td class="col-status">
                                <span class="badge ${service.isActive ? 'badge-active' : 'badge-inactive'}">
                                    ${service.isActive ? 'Hoạt động' : 'Tạm dừng'}
                                </span>
                            </td>
                            <td class="col-action">
                                <a href="edit-service?id=${service.serviceId}" class="btn-action btn-edit" title="Edit">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </a>
                                <form action="services" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="toggle">
                                    <input type="hidden" name="id" value="${service.serviceId}">
                                    <input type="hidden" name="status" value="${service.isActive}">
                                    <button type="submit" class="btn-action ${service.isActive ? 'btn-stop' : 'btn-play'}" 
                                            onclick="return confirm('Thay đổi trạng thái dịch vụ?');">
                                        <c:choose>
                                            <c:when test="${service.isActive}">
                                                <i class="fa-solid fa-circle-stop"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-circle-play"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Pagination (keep search & status filter) -->
            <c:if test="${totalPages > 1}">
                <c:set var="searchParam" value="${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}" />
                <c:set var="statusParam" value="${not empty statusFilter ? '&status='.concat(statusFilter) : ''}" />
                <c:set var="queryParams" value="${searchParam.concat(statusParam)}" />
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="services?page=${currentPage - 1}${queryParams}" class="btn-page">Previous</a>
                    </c:if>

                    <span class="page-info">Page ${currentPage} of ${totalPages}</span>

                    <c:if test="${currentPage < totalPages}">
                        <a href="services?page=${currentPage + 1}${queryParams}" class="btn-page">Next</a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </main>
</body>
</html>