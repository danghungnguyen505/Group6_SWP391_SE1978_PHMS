<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VetCare Pro - TRUNG TÂM ĐIỀU KHIỂN ADMIN</title>

        <!-- Google Fonts: Inter -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
        <!-- Font Awesome 6.5.1 -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            :root {
                --sidebar-width: 280px;
                --primary-green: #50b498;
                --bg-body: #f8fafc;
                --text-main: #0f172a;
                --text-muted: #718096;
                --card-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
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

            /* --- SIDEBAR STYLES --- */
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
                transition: all 0.2s;
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

            /* --- MAIN CONTENT STYLES --- */
            .main-content {
                margin-left: var(--sidebar-width);
                flex: 1;
                padding: 40px 60px;
            }

            .top-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 40px;
            }
            .title-area h1 {
                font-size: 28px;
                font-weight: 900;
                text-transform: uppercase;
                letter-spacing: -0.5px;
            }
            .title-area p {
                color: var(--text-muted);
                margin-top: 5px;
                font-size: 15px;
            }

            .btn-logout {
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

            /* --- STATS CARDS --- */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 24px;
                margin-bottom: 40px;
            }
            .stat-card {
                background: white;
                padding: 28px;
                border-radius: 24px;
                box-shadow: var(--card-shadow);
                position: relative;
            }
            .stat-icon {
                font-size: 24px;
                margin-bottom: 18px;
                display: block;
            }
            .stat-value {
                font-size: 24px;
                font-weight: 800;
                margin-bottom: 4px;
            }
            .stat-label {
                font-size: 11px;
                font-weight: 700;
                color: var(--text-muted);
                text-transform: uppercase;
            }

            .badge {
                position: absolute;
                top: 28px;
                right: 28px;
                padding: 4px 10px;
                border-radius: 6px;
                font-size: 10px;
                font-weight: 800;
            }
            .badge-success {
                background: #dcfce7;
                color: #15803d;
            }
            .badge-info {
                background: #eff6ff;
                color: #1d4ed8;
            }
            .badge-pending {
                background: #fee2e2;
                color: #b91c1c;
            }

            /* --- DASHBOARD BOTTOM GRID --- */
            .dashboard-grid {
                display: grid;
                grid-template-columns: 1.6fr 1fr;
                gap: 24px;
            }

            .panel-white {
                background: white;
                padding: 35px;
                border-radius: 24px;
                box-shadow: var(--card-shadow);
            }

            .panel-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
            }
            .panel-title {
                font-size: 16px;
                font-weight: 800;
                text-transform: uppercase;
            }
            .view-all {
                color: var(--primary-green);
                text-decoration: none;
                font-size: 12px;
                font-weight: 800;
            }

            /* Request Items */
            .req-item {
                display: flex;
                align-items: center;
                padding: 16px;
                background: #f8fafc;
                border-radius: 18px;
                margin-bottom: 12px;
                gap: 15px;
            }
            .req-avatar {
                width: 42px;
                height: 42px;
                background: white;
                color: var(--primary-green);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 800;
                border-radius: 12px;
                font-size: 16px;
            }
            .req-info {
                flex: 1;
            }
            .req-info strong {
                display: block;
                font-size: 14px;
                margin-bottom: 2px;
            }
            .req-info span {
                font-size: 11px;
                color: var(--text-muted);
            }

            .req-btns {
                display: flex;
                gap: 8px;
            }
            .btn-circle {
                width: 34px;
                height: 34px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                transition: 0.2s;
            }
            .btn-approve {
                background: var(--primary-green);
                color: white;
            }
            .btn-reject {
                background: white;
                color: #a0aec0;
                border: 1px solid #e2e8f0;
            }

            /* Action Grid */
            .action-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                grid-template-rows: auto auto;
                gap: 16px;
            }
            .action-card {
                background: white;
                padding: 28px;
                border-radius: 24px;
                text-decoration: none;
                color: inherit;
                box-shadow: var(--card-shadow);
                transition: transform 0.2s;
            }
            .action-card:hover {
                transform: translateY(-3px);
            }
            .action-card i {
                font-size: 20px;
                color: #a0aec0;
                margin-bottom: 15px;
                display: block;
            }
            .action-card h3 {
                font-size: 13px;
                font-weight: 800;
                text-transform: uppercase;
                margin-bottom: 4px;
            }
            .action-card p {
                font-size: 11px;
                color: var(--text-muted);
            }

        </style>
    </head>
    <body>

        <jsp:include page="common/navbar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <!-- Main Content -->
        <main class="main-content">
            <header class="top-header">
                <div class="title-area">
                    <h1>Trung tâm điều khiển Admin</h1>
                    <p>Giám sát hoạt động bệnh viện và sức khỏe hệ thống</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
            </header>

            <!-- Stats Grid -->
            <section class="stats-grid">
                <div class="stat-card">
                    <span class="stat-icon">💰</span>
                    <div class="stat-value">
                        <fmt:formatNumber value="${revenueReport.totalRevenue}" type="currency" currencySymbol=""/>đ
                    </div>
                    <div class="stat-label">Doanh thu tháng</div>
                    <span class="badge badge-success">+12.5%</span>
                </div>

                <div class="stat-card">
                    <span class="stat-icon">🧑‍⚕️</span>
                    <div class="stat-value">${fn:length(staffAccounts)}</div>
                    <div class="stat-label">Tổng nhân sự</div>
                    <span class="badge badge-success">HOẠT ĐỘNG</span>
                </div>

                <div class="stat-card">
                    <span class="stat-icon">⭐</span>
                    <div class="stat-value">${fn:length(feedbacks)}</div>
                    <div class="stat-label">Phản hồi mới</div>
                    <span class="badge badge-info">CHƯA ĐỌC</span>
                </div>

                <div class="stat-card">
                    <span class="stat-icon">📅</span>
                    <div class="stat-value">${fn:length(requests)}</div>
                    <div class="stat-label">Yêu cầu nghỉ</div>
                    <span class="badge badge-pending">ĐANG CHỜ</span>
                </div>
            </section>

            <div class="dashboard-grid">
                <!-- Left Panel: Leave Requests -->
                <section class="panel-white">
                    <div class="panel-header">
                        <h2 class="panel-title">Yêu cầu nghỉ phép chờ duyệt</h2>
                        <a href="${pageContext.request.contextPath}/admin/leave/pending" class="view-all">XEM TẤT CẢ</a>
                    </div>

                    <c:choose>
                        <c:when test="${empty requests}">
                            <p style="text-align:center; color:#a0aec0; padding:20px; font-size:14px;">Không có đơn nào đang chờ duyệt.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${requests}" varStatus="status">
                                <c:if test="${status.index < 2}">
                                    <div class="req-item">
                                        <div class="req-avatar">${fn:substring(r.empId, 0, 1)}</div>
                                        <div class="req-info">
                                            <strong>${r.empId}</strong>
                                            <span>${r.reason} • ${r.startDate}</span>
                                        </div>
                                        <div class="req-btns">
                                            <form action="${pageContext.request.contextPath}/admin/leave/update-status" method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="${r.leaveId}"><input type="hidden" name="action" value="approve">
                                                <button type="submit" class="btn-circle btn-approve"><i class="fa-solid fa-check"></i></button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/leave/update-status" method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="${r.leaveId}"><input type="hidden" name="action" value="reject">
                                                <button type="submit" class="btn-circle btn-reject"><i class="fa-solid fa-xmark"></i></button>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </section>

                <!-- Right Panel: Actions -->
                <section class="action-grid">
                    <a href="${pageContext.request.contextPath}/admin/services" class="action-card">
                        <i class="fa-solid fa-screwdriver-wrench"></i>
                        <h3>Dịch vụ</h3>
                        <p>Bảng giá & Danh mục</p>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/medicine/list" class="action-card">
                        <i class="fa-solid fa-pills"></i>
                        <h3>Kho thuốc</h3>
                        <p>Dược phẩm & Giá bán</p>
                    </a>
                    <a href="#" class="action-card">
                        <i class="fa-solid fa-calendar-days"></i>
                        <h3>Lịch làm việc</h3>
                        <p>Phân ca trực nhân viên</p>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/feedback/list" class="action-card">
                        <i class="fa-solid fa-comments"></i>
                        <h3>Phản hồi</h3>
                        <p>Đánh giá khách hàng</p>
                    </a>
                </section>
            </div>
        </main>

    </body>
</html>