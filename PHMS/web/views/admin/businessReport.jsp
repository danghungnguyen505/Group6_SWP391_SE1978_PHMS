<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        .panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 20px;
        }
        .panel-head .panel-title {
            margin-bottom: 0;
        }
        .panel-head-link {
            text-decoration: none;
            color: #0f766e;
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .4px;
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

        /* Transaction List */
        .txn-list { display: flex; flex-direction: column; gap: 12px; }
        .txn-item {
            border: 1px solid #edf2f7;
            border-radius: 14px;
            padding: 12px 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }
        .txn-main { min-width: 0; }
        .txn-title { font-weight: 800; font-size: 14px; color: #0f172a; margin-bottom: 4px; }
        .txn-meta { font-size: 12px; color: #94a3b8; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .txn-right { text-align: right; }
        .txn-amount { font-size: 14px; font-weight: 800; color: #0f172a; margin-bottom: 6px; }
        .txn-actions { display: flex; justify-content: flex-end; align-items: center; gap: 8px; }
        .txn-status {
            font-size: 11px;
            padding: 4px 8px;
            border-radius: 999px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .txn-status.paid { background: #dcfce7; color: #166534; }
        .txn-status.unpaid { background: #fee2e2; color: #991b1b; }
        .txn-status.other { background: #e2e8f0; color: #334155; }
        .txn-link {
            font-size: 12px;
            text-decoration: none;
            color: #0f766e;
            font-weight: 700;
        }

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
                            <c:set var="maxRev" value="1" />
                            <c:forEach var="m" items="${monthlyRevenue}">
                                <c:if test="${m.revenue > maxRev}"><c:set var="maxRev" value="${m.revenue}" /></c:if>
                            </c:forEach>
                            <c:forEach var="month" items="${monthlyRevenue}">
                                <div class="month-col">
                                    <span class="month-value" style="font-size:11px; font-weight:700; color:#0f172a;"><fmt:formatNumber value="${month.revenue}" pattern="#,###"/>₫</span>
                                    <div style="width:30px; background:linear-gradient(to top, #10b981, #34d399); border-radius:4px 4px 0 0; height: ${month.revenue > 0 ? (month.revenue / maxRev) * 120 : 4}px;"></div>
                                    <span class="month-label">Tháng ${fn:substring(month.month, 5, 7)}</span>
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
                        <div class="growth-badge">
                            <c:choose>
                                <c:when test="${not empty revenueGrowth}">
                                    <c:set var="growth" value="${revenueGrowth.growthPercentage}" />
                                    <c:choose>
                                        <c:when test="${growth >= 0}">+<fmt:formatNumber value="${growth}" pattern="#.0"/>%</c:when>
                                        <c:otherwise><fmt:formatNumber value="${growth}" pattern="#.0"/>%</c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>0%</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Right Panel: Transaction History -->
            <section class="card-panel">
                <div class="panel-head">
                    <h2 class="panel-title">Lịch sử giao dịch gần đây</h2>
                    <a class="panel-head-link" href="${pageContext.request.contextPath}/admin/invoice/list">Xem tất cả</a>
                </div>
                
                <div class="txn-list">
                    <c:choose>
                        <c:when test="${not empty recentInvoices}">
                            <c:forEach var="inv" items="${recentInvoices}">
                                <div class="txn-item">
                                    <div class="txn-main">
                                        <div class="txn-title">Hóa đơn #${inv.invoiceId}</div>
                                        <div class="txn-meta">
                                            ${inv.ownerName} - Thú cưng: ${inv.petName}
                                            <span style="margin:0 4px;">|</span>
                                            <fmt:formatDate value="${inv.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                    </div>
                                    <div class="txn-right">
                                        <div class="txn-amount"><fmt:formatNumber value="${inv.totalAmount}" pattern="#,###"/>₫</div>
                                        <div class="txn-actions">
                                            <c:choose>
                                                <c:when test="${inv.status eq 'Paid'}">
                                                    <span class="txn-status paid">Paid</span>
                                                </c:when>
                                                <c:when test="${inv.status eq 'Unpaid'}">
                                                    <span class="txn-status unpaid">Unpaid</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="txn-status other">${inv.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <a class="txn-link" href="${pageContext.request.contextPath}/admin/invoice/detail?invoiceId=${inv.invoiceId}">Xem</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="text-align:center; color:#cbd5e0; font-size:13px; padding-top:20px;">Chưa có hóa đơn nào để hiển thị.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>
    </main>

<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>
