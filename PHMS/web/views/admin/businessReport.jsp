<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<<<<<<< Updated upstream
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Business Reports</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reports" class="active">Reports</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Business Reports</h2>
                    <p>Revenue and appointment statistics</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Date Range Filter</span>
                </div>
                <form method="get" action="${pageContext.request.contextPath}/admin/reports" style="display:grid; grid-template-columns: 1fr 1fr auto; gap:10px; margin-bottom:20px;">
                    <div>
                        <label><b>Start Date</b></label>
                        <input type="date" name="startDate" value="${startDate}" required style="width:100%; padding:8px;">
                    </div>
                    <div>
                        <label><b>End Date</b></label>
                        <input type="date" name="endDate" value="${endDate}" required style="width:100%; padding:8px;">
                    </div>
                    <div style="display:flex; align-items:end;">
                        <button type="submit" class="btn btn-approve" style="width:100%;">
                            <i class="fa-solid fa-filter"></i> Filter
                        </button>
                    </div>
                </form>

                <!-- Revenue Report -->
                <div class="section-title" style="margin-top:20px;">
                    <span>Revenue Summary</span>
                </div>
                <c:if test="${not empty revenueReport}">
                    <div style="display:grid; grid-template-columns: repeat(4, 1fr); gap:15px; margin-top:15px;">
                        <div style="background:#f0f9ff; padding:15px; border-radius:8px;">
                            <div style="color:#0369a1; font-size:14px;">Total Revenue</div>
                            <div style="font-size:24px; font-weight:bold; color:#0c4a6e;">
                                <fmt:formatNumber value="${revenueReport.totalRevenue}" type="currency" currencySymbol="₫"/>
                            </div>
                        </div>
                        <div style="background:#f0fdf4; padding:15px; border-radius:8px;">
                            <div style="color:#166534; font-size:14px;">Total Invoices</div>
                            <div style="font-size:24px; font-weight:bold; color:#14532d;">
                                ${revenueReport.totalInvoices}
                            </div>
                        </div>
                        <div style="background:#fef3c7; padding:15px; border-radius:8px;">
                            <div style="color:#92400e; font-size:14px;">Paid Invoices</div>
                            <div style="font-size:24px; font-weight:bold; color:#78350f;">
                                ${revenueReport.paidInvoices}
                            </div>
                        </div>
                        <div style="background:#fee2e2; padding:15px; border-radius:8px;">
                            <div style="color:#991b1b; font-size:14px;">Unpaid Invoices</div>
                            <div style="font-size:24px; font-weight:bold; color:#7f1d1d;">
                                ${revenueReport.unpaidInvoices}
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Appointment Statistics -->
                <div class="section-title" style="margin-top:30px;">
                    <span>Appointment Statistics</span>
                </div>
                <c:if test="${not empty appointmentStats}">
                    <table style="width:100%; margin-top:15px;">
                        <thead>
                            <tr style="background:#f3f4f6;">
                                <th style="padding:10px; text-align:left;">Status</th>
                                <th style="padding:10px; text-align:left;">Count</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="entry" items="${appointmentStats}">
                                <tr>
                                    <td style="padding:10px;">${entry.key}</td>
                                    <td style="padding:10px;">${entry.value}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <!-- Top Services -->
                <div class="section-title" style="margin-top:30px;">
                    <span>Top Services by Revenue</span>
                </div>
                <c:if test="${not empty topServices}">
                    <table style="width:100%; margin-top:15px;">
                        <thead>
                            <tr style="background:#f3f4f6;">
                                <th style="padding:10px; text-align:left;">Service</th>
                                <th style="padding:10px; text-align:left;">Usage Count</th>
                                <th style="padding:10px; text-align:left;">Total Revenue</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="service" items="${topServices}">
                                <tr>
                                    <td style="padding:10px;">${service.serviceName}</td>
                                    <td style="padding:10px;">${service.usageCount}</td>
                                    <td style="padding:10px;">
                                        <fmt:formatNumber value="${service.totalRevenue}" type="currency" currencySymbol="₫"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <!-- Monthly Revenue -->
                <div class="section-title" style="margin-top:30px;">
                    <span>Monthly Revenue</span>
                </div>
                <c:if test="${not empty monthlyRevenue}">
                    <table style="width:100%; margin-top:15px;">
                        <thead>
                            <tr style="background:#f3f4f6;">
                                <th style="padding:10px; text-align:left;">Month</th>
                                <th style="padding:10px; text-align:left;">Revenue</th>
                                <th style="padding:10px; text-align:left;">Invoice Count</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="month" items="${monthlyRevenue}">
                                <tr>
                                    <td style="padding:10px;">${month.month}</td>
                                    <td style="padding:10px;">
                                        <fmt:formatNumber value="${month.revenue}" type="currency" currencySymbol="₫"/>
                                    </td>
                                    <td style="padding:10px;">${month.invoiceCount}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </main>
    </body>
</html>
=======
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - PHÂN TÍCH HIỆU SUẤT</title>
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

        /* --- SIDEBAR (ĐỒNG BỘ TUYỆT ĐỐI) --- */
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

        .nav-menu { list-style: none; flex: 1; }
        .nav-item { margin-bottom: 6px; }

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

        .nav-link:hover { background: #f7fafc; color: var(--text-main); }
        .nav-link.active { background: #f0fff4; color: var(--primary-green); font-weight: 600; }
        .nav-link i { width: 22px; font-size: 18px; text-align: center; }

        .help-box {
            margin-top: auto;
            background: #f8fafc;
            padding: 20px;
            border-radius: 16px;
            border: 1px solid #edf2f7;
        }
        .help-box p { font-size: 13px; font-weight: 600; margin-bottom: 12px; }
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

        /* --- MAIN CONTENT (FIX LỖI LỆCH) --- */
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 40px 60px;
            width: calc(100% - var(--sidebar-width));
        }

        .top-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 40px;
        }
        .title-area h1 { font-size: 28px; font-weight: 900; text-transform: uppercase; letter-spacing: -0.5px; }
        .title-area p { color: var(--text-muted); margin-top: 5px; font-size: 15px; }
        
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

        /* --- DASHBOARD GRID --- */
        .dashboard-grid { display: grid; grid-template-columns: 1.2fr 1fr; gap: 24px; }

        .card-panel {
            background: white;
            padding: 40px;
            border-radius: 32px;
            box-shadow: var(--card-shadow);
        }

        .panel-title {
            font-size: 13px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 30px;
            color: var(--text-main);
        }

        /* Chart Area */
        .chart-placeholder {
            height: 180px;
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 40px;
            padding: 0 10px;
            border-bottom: 1px solid #f1f5f9;
        }
        .month-col { display: flex; flex-direction: column; align-items: center; gap: 10px; flex: 1; margin-bottom: 10px; }
        .month-label { font-size: 10px; font-weight: 800; color: #cbd5e0; text-transform: uppercase; }

        .revenue-footer {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .rev-total-label { font-size: 12px; font-weight: 800; color: #cbd5e0; text-transform: uppercase; margin-bottom: 5px; }
        .rev-total-val { font-size: 26px; font-weight: 900; color: var(--text-main); }
        .growth-badge { font-size: 18px; font-weight: 800; color: #48bb78; text-align: right; }

        /* Feedback List */
        .feedback-list { display: flex; flex-direction: column; gap: 25px; }
        .fb-item { position: relative; padding-bottom: 10px; border-bottom: 1px solid #f8fafc; }
        .fb-item:last-child { border-bottom: none; }
        .fb-user { font-weight: 800; font-size: 14px; margin-bottom: 5px; display: flex; gap: 8px; align-items: center; }
        .fb-user span { font-weight: 500; color: #cbd5e0; font-size: 12px; }
        .fb-comment { font-size: 13px; color: var(--text-muted); font-style: italic; line-height: 1.6; padding-right: 60px; }
        
        .stars { position: absolute; top: 0; right: 0; color: #f6ad55; font-size: 10px; display: flex; gap: 2px; }
        .star-muted { color: #edf2f7; }

    </style>
</head>
<body>

    <!-- Sidebar (đồng bộ với các trang admin khác) -->
    <jsp:include page="common/navbar.jsp">
        <jsp:param name="activePage" value="revenue" />
    </jsp:include>

    <!-- Main Content -->
    <main class="main-content">
        <header class="top-header">
            <div class="title-area">
                <h1>Phân tích hiệu suất</h1>
                <p>Tăng trưởng doanh thu hàng tháng và chỉ số hài lòng khách hàng</p>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
        </header>

        <div class="dashboard-grid">
            <!-- Left Panel: Revenue Trends -->
            <section class="card-panel">
                <h2 class="panel-title">Xu hướng doanh thu (6 tháng qua)</h2>
                
                <div class="chart-placeholder">
                    <c:choose>
                        <c:when test="${not empty monthlyRevenue}">
                            <c:forEach var="month" items="${monthlyRevenue}">
                                <div class="month-col">
                                    <span class="month-label">Tháng ${month.month}</span>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="width:100%; text-align:center; color:#cbd5e0; font-size:12px; margin-bottom:20px;">Dữ liệu biểu đồ đang được cập nhật...</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="revenue-footer">
                    <div>
                        <p class="rev-total-label">Tổng kỳ hạn</p>
                        <div class="rev-total-val">
                            <c:choose>
                                <c:when test="${not empty revenueReport}">
                                    <fmt:formatNumber value="${revenueReport.totalRevenue}" pattern="#,###"/>₫
                                </c:when>
                                <c:otherwise>0₫</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div>
                        <p class="rev-total-label" style="text-align: right;">Tăng trưởng</p>
                        <div class="growth-badge">+18.4%</div>
                    </div>
                </div>
            </section>

            <!-- Right Panel: Latest Feedback -->
            <section class="card-panel">
                <h2 class="panel-title">Phản hồi khách hàng mới nhất</h2>
                
                <div class="feedback-list">
                    <c:choose>
                        <c:when test="${not empty feedbacks}">
                            <c:forEach var="fb" items="${feedbacks}" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="fb-item">
                                        <div class="fb-user">${fb.customerName} <span>Thú cưng: ${fb.petName}</span></div>
                                        <div class="fb-comment">"${fb.comment}"</div>
                                        <div class="stars">
                                            <c:forEach begin="1" end="${fb.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                            <c:forEach begin="${fb.rating + 1}" end="5"><i class="fa-solid fa-star star-muted"></i></c:forEach>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="text-align:center; color:#cbd5e0; font-size:13px; padding-top:20px;">Chưa có phản hồi nào từ khách hàng.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>
    </main>

</body>
</html>
>>>>>>> Stashed changes
