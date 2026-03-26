<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>VetCare Pro - MEDICINE INVENTORY</title>
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
                border: none;
                cursor: pointer;
            }

            /* --- TABLE CARD --- */
            .card {
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
                padding: 25px 15px;
                font-size: 14px;
                border-bottom: 1px solid #f8fafc;
                vertical-align: middle;
            }

            .col-id {
                color: #cbd5e0;
                font-weight: 600;
                width: 60px;
            }
            .col-name {
                font-weight: 800;
                color: var(--text-main);
                font-size: 15px;
                width: 200px;
            }
            .col-unit {
                color: var(--text-muted);
                font-style: italic;
                font-size: 13px;
            }
            .col-price {
                font-weight: 800;
                font-size: 16px;
                color: var(--text-main);
            }
            .col-stock {
                font-weight: 600;
            }

            /* Badge Styles */
            .badge {
                padding: 6px 14px;
                border-radius: 8px;
                font-size: 10px;
                font-weight: 800;
                text-transform: uppercase;
                display: inline-block;
            }
            .badge-active {
                background: #dcfce7;
                color: #15803d;
            }
            .badge-inactive {
                background: #fee2e2;
                color: #b91c1c;
            }

            /* Action Buttons */
            .btn-action {
                background: none;
                border: none;
                cursor: pointer;
                font-size: 18px;
                margin-right: 12px;
                transition: 0.2s;
                color: inherit;
            }
            .btn-edit {
                color: #805ad5;
            }
            .btn-reject {
                color: #f6ad55;
            } /* Đổi màu xóa sang cam/vàng cho giống icon stop */
            .btn-action:hover {
                opacity: 0.7;
                transform: scale(1.1);
            }

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

            .btn-signout {
                padding: 10px 20px;
                border: 1px solid #e2e8f0;
                background: white;
                border-radius: 10px;
                color: var(--text-main);
                font-weight: 700;
                font-size: 12px;
                text-decoration: none;
                text-transform: uppercase;
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
    <jsp:param name="activePage" value="pharmacy" />
</jsp:include>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Medicine Inventory</h2>
                    <p>Total: ${totalMedicines} medicines in stock</p>
                </div>
                <div style="display:flex; gap:15px; align-items:center;">
                    <form action="${pageContext.request.contextPath}/admin/medicine/list" method="get" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
                        <input type="text" name="search" placeholder="Search name/unit..." 
                               value="${searchKeyword}" 
                               style="padding:8px 10px; border-radius:8px; border:1px solid #e2e8f0; font-size:13px; min-width:200px;">

                        <select name="status" style="padding:8px 10px; border-radius:8px; border:1px solid #e2e8f0; font-size:13px;">
                            <option value="">All statuses</option>
                            <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>In stock</option>
                            <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Out of stock</option>
                        </select>

                        <button type="submit" class="btn-create" style="padding:8px 14px; text-transform:none;">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                        <c:if test="${not empty searchKeyword || not empty statusFilter}">
                            <a href="${pageContext.request.contextPath}/admin/medicine/list" 
                               style="font-size:12px; color:#a0aec0; text-decoration:none;">Clear</a>
                        </c:if>
                    </form>
                    <a href="${pageContext.request.contextPath}/admin/medicine/add" class="btn-create">
                        <i class="fa-solid fa-plus"></i> Create New
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
                </div>
            </div>

            <div class="card">
                <c:choose>
                    <c:when test="${empty medicines || medicines.size() == 0}">
                        <div style="text-align:center; padding:60px; color: #a0aec0;">
                            <i class="fa-solid fa-box-open" style="font-size: 48px; margin-bottom: 20px;"></i>
                            <p>No medicines found in the inventory.</p>
                            <a href="${pageContext.request.contextPath}/admin/medicine/add" class="btn-create" style="display:inline-block; margin-top:20px;">Add First Medicine</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th class="col-id">STT</th>
                                    <th style="width: 25%;">Medicine Name</th>
                                    <th style="width: 20%;">Unit</th>
                                    <th style="width: 15%;">Price</th>
                                    <th style="width: 15%;">Stock</th>
                                    <th style="width: 15%;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="med" items="${medicines}" varStatus="st">
                                    <tr>
                                        <td class="col-id">${st.index + 1}</td>
                                        <td class="col-name">${med.name}</td>
                                        <td class="col-unit">"${med.unit}"</td>
                                        <td class="col-price">
                                            <fmt:formatNumber value="${med.price}" pattern="#,###"/>₫
                                        </td>
                                        <td>
                                            <span class="badge ${med.stockQuantity > 0 ? 'badge-active' : 'badge-inactive'}">
                                                ${med.stockQuantity > 0 ? 'Hoạt động' : 'Hết hàng'}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/medicine/update?id=${med.medicineId}" 
                                               class="btn-action btn-edit" title="Edit">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/medicine/delete" 
                                                  style="display:inline;" 
                                                  onsubmit="return confirm('Bạn có chắc muốn xóa thuốc này?');">
                                                <input type="hidden" name="id" value="${med.medicineId}">
                                                <button type="submit" class="btn-action btn-reject" title="Delete">
                                                    <i class="fa-solid fa-circle-stop"></i>
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
                                    <a href="${pageContext.request.contextPath}/admin/medicine/list?page=${currentPage - 1}${queryParams}" class="btn-page">Previous</a>
                                </c:if>

                                <span class="page-info">Page ${currentPage} of ${totalPages}</span>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/admin/medicine/list?page=${currentPage + 1}${queryParams}" class="btn-page">Next</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </body>
</html>