<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VetCare Pro - ${t_admin_dashboard}</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            :root { --sidebar-width: 280px; --primary-green: #50b498; --bg-body: #f8fafc; --text-main: #0f172a; --text-muted: #718096; --card-shadow: 0 4px 25px -5px rgba(0,0,0,0.05); }
            * { margin: 0; padding: 0; box-sizing: border-box; -webkit-font-smoothing: antialiased; }
            body { font-family: 'Inter', sans-serif; background-color: var(--bg-body); color: var(--text-main); display: flex; min-height: 100vh; }

            /* --- SIDEBAR --- */
            .sidebar { width: var(--sidebar-width); background: #ffffff; height: 100vh; position: fixed; left: 0; top: 0; padding: 35px 25px; display: flex; flex-direction: column; border-right: 1px solid #edf2f7; z-index: 1000; }
            .logo { display: flex; align-items: center; gap: 12px; color: var(--primary-green); font-weight: 800; font-size: 22px; margin-bottom: 50px; padding-left: 10px; }
            .menu-label { color: #a0aec0; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 20px; padding-left: 10px; }
            .nav-menu { list-style: none; }
            .nav-item { margin-bottom: 6px; }
            .nav-link { display: flex; align-items: center; gap: 15px; padding: 12px 18px; text-decoration: none; color: var(--text-muted); font-weight: 500; font-size: 15px; border-radius: 12px; transition: all 0.2s; }
            .nav-link:hover { background: #f7fafc; color: var(--text-main); }
            .nav-link.active { background: #f0fff4; color: var(--primary-green); font-weight: 600; }
            .nav-link i { width: 22px; font-size: 18px; text-align: center; }
            .help-box { margin-top: auto; background: #f8fafc; padding: 20px; border-radius: 16px; border: 1px solid #edf2f7; }
            .help-box p { font-size: 13px; font-weight: 600; margin-bottom: 12px; }
            .btn-support { display: block; background: #0f172a; color: white; text-align: center; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 12px; }

            /* --- MAIN CONTENT --- */
            .main-content { margin-left: var(--sidebar-width); flex: 1; padding: 35px 50px; width: calc(100% - var(--sidebar-width)); }

            .top-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 28px; }
            .title-area h1 { font-size: 26px; font-weight: 900; text-transform: uppercase; letter-spacing: -0.5px; }
            .title-area p { color: var(--text-muted); margin-top: 5px; font-size: 14px; }
            .btn-logout { padding: 10px 20px; border: 1px solid #e2e8f0; background: white; border-radius: 10px; color: var(--text-main); font-weight: 700; font-size: 12px; text-decoration: none; text-transform: uppercase; }

            /* --- FILTER SECTION --- */
            .filter-section { background: white; border-radius: 16px; padding: 20px 24px; margin-bottom: 24px; box-shadow: var(--card-shadow); }
            .filter-row { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
            .filter-label { font-size: 13px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; white-space: nowrap; }
            .filter-btn { padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; border: 1px solid #e2e8f0; background: #fff; color: var(--text-muted); cursor: pointer; transition: 0.2s; text-decoration: none; display: inline-block; }
            .filter-btn:hover { border-color: var(--primary-green); color: var(--primary-green); }
            .filter-btn.active { background: var(--primary-green); color: #fff; border-color: var(--primary-green); }
            .date-inputs { display: flex; align-items: center; gap: 8px; margin-left: auto; }
            .date-input { padding: 8px 12px; border-radius: 8px; border: 1px solid #e2e8f0; font-size: 13px; font-weight: 500; color: var(--text-main); }
            .date-input:focus { outline: none; border-color: var(--primary-green); }
            .filter-submit { padding: 8px 18px; border-radius: 8px; background: var(--primary-green); color: #fff; border: none; font-weight: 700; font-size: 13px; cursor: pointer; transition: 0.2s; }
            .filter-submit:hover { background: #059669; }

            /* --- STATS CARDS --- */
            .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 24px; }
            .stat-card { background: white; padding: 24px; border-radius: 20px; box-shadow: var(--card-shadow); position: relative; }
            .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; margin-bottom: 14px; }
            .stat-icon.green { background: #d1fae5; color: #059669; }
            .stat-icon.blue { background: #dbeafe; color: #2563eb; }
            .stat-icon.orange { background: #fef3c7; color: #d97706; }
            .stat-icon.purple { background: #ede9fe; color: #7c3aed; }
            .stat-value { font-size: 24px; font-weight: 800; margin-bottom: 4px; }
            .stat-label { font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; }

            /* --- DASHBOARD GRID --- */
            .dashboard-grid { display: grid; grid-template-columns: 1.5fr 1fr; gap: 22px; }
            .panel-white { background: white; padding: 28px; border-radius: 22px; box-shadow: var(--card-shadow); }
            .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 22px; }
            .panel-title { font-size: 14px; font-weight: 800; text-transform: uppercase; }
            .view-all { color: var(--primary-green); text-decoration: none; font-size: 12px; font-weight: 700; }

            /* Chart */
            .chart-container { display: flex; align-items: flex-end; justify-content: space-between; height: 180px; padding: 0 5px; border-bottom: 2px solid #f1f5f9; gap: 8px; }
            .chart-col { display: flex; flex-direction: column; align-items: center; gap: 8px; flex: 1; }
            .chart-bar { width: 100%; background: linear-gradient(to top, #10b981, #34d399); border-radius: 6px 6px 0 0; min-height: 4px; transition: 0.3s; }
            .chart-bar:hover { opacity: 0.75; }
            .chart-label { font-size: 10px; font-weight: 700; color: #94a3b8; text-transform: uppercase; }
            .chart-value { font-size: 10px; font-weight: 800; color: var(--text-main); white-space: nowrap; }

            /* Top Services */
            .service-list { display: flex; flex-direction: column; gap: 12px; }
            .service-item { display: flex; align-items: center; gap: 12px; }
            .service-rank { width: 28px; height: 28px; border-radius: 8px; background: #f1f5f9; color: #64748b; font-weight: 800; font-size: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
            .service-rank.top3 { background: #fef3c7; color: #d97706; }
            .service-info { flex: 1; }
            .service-name { font-size: 13px; font-weight: 700; color: var(--text-main); }
            .service-count { font-size: 11px; color: #94a3b8; }
            .service-revenue { font-size: 13px; font-weight: 800; color: #059669; white-space: nowrap; }

            /* Request Items */
            .req-item { display: flex; align-items: center; padding: 14px; background: #f8fafc; border-radius: 14px; margin-bottom: 10px; gap: 14px; }
            .req-avatar { width: 40px; height: 40px; background: white; color: var(--primary-green); display: flex; align-items: center; justify-content: center; font-weight: 800; border-radius: 10px; font-size: 15px; flex-shrink: 0; }
            .req-info { flex: 1; }
            .req-info strong { display: block; font-size: 13px; margin-bottom: 2px; }
            .req-info span { font-size: 11px; color: var(--text-muted); }
            .req-btns { display: flex; gap: 8px; }
            .btn-circle { width: 32px; height: 32px; border-radius: 8px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 12px; transition: 0.2s; }
            .btn-approve { background: var(--primary-green); color: white; }
            .btn-reject  { background: white; color: #a0aec0; border: 1px solid #e2e8f0; }

            /* Action Grid */
            .action-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
            .action-card { background: white; padding: 24px; border-radius: 20px; text-decoration: none; color: inherit; box-shadow: var(--card-shadow); transition: transform 0.2s; }
            .action-card:hover { transform: translateY(-3px); }
            .action-card i { font-size: 20px; color: #a0aec0; margin-bottom: 12px; display: block; }
            .action-card h3 { font-size: 13px; font-weight: 800; text-transform: uppercase; margin-bottom: 4px; }
            .action-card p { font-size: 11px; color: var(--text-muted); }
        </style>
    </head>
    <body>

        <jsp:include page="common/navbar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <main class="main-content">
            <header class="top-header">
                <div class="title-area">
                    <h1>${t_admin_dashboard}</h1>
                    <p>${t_admin_dash_sub}</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">${t_logout}</a>
            </header>

            <!-- Filter Section (Shopee style) -->
            <div class="filter-section">
                <form method="get" action="${pageContext.request.contextPath}/admin/dashboard" id="filterForm">
                    <div class="filter-row">
                        <span class="filter-label">${t_filter_by}:</span>
                        <a href="?filter=today" class="filter-btn ${param.filter == 'today' ? 'active' : ''}">${t_today}</a>
                        <a href="?filter=week" class="filter-btn ${param.filter == 'week' ? 'active' : ''}">${t_this_week}</a>
                        <a href="?filter=month" class="filter-btn ${param.filter == 'month' || empty param.filter ? 'active' : ''}">${t_this_month}</a>
                        <a href="?filter=quarter" class="filter-btn ${param.filter == 'quarter' ? 'active' : ''}">${t_this_quarter}</a>
                        <a href="?filter=year" class="filter-btn ${param.filter == 'year' ? 'active' : ''}">${t_this_year}</a>

                        <div class="date-inputs">
                            <span class="filter-label">${t_from}:</span>
                            <input type="date" name="startDate" class="date-input" value="${startDate}">
                            <span class="filter-label">${t_to}:</span>
                            <input type="date" name="endDate" class="date-input" value="${endDate}">
                            <button type="submit" class="filter-submit"><i class="fa-solid fa-filter"></i> ${t_apply}</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Stats Grid -->
            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fa-solid fa-money-bill-wave"></i></div>
                    <div class="stat-value">
                        <fmt:formatNumber value="${revenueReport.totalRevenue}" pattern="#,###"/>₫
                    </div>
                    <div class="stat-label">${t_total_revenue}</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon blue"><i class="fa-solid fa-calendar-check"></i></div>
                    <div class="stat-value">${not empty appointmentStats ? appointmentStats.totalAppointments : 0}</div>
                    <div class="stat-label">${t_total_appointments}</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon orange"><i class="fa-solid fa-check-circle"></i></div>
                    <div class="stat-value">${not empty appointmentStats ? appointmentStats.completedAppointments : 0}</div>
                    <div class="stat-label">${t_completed}</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon purple"><i class="fa-solid fa-user-md"></i></div>
                    <div class="stat-value">${fn:length(staffAccounts)}</div>
                    <div class="stat-label">${t_total_staff}</div>
                </div>
            </section>

            <div class="dashboard-grid">
                <!-- Left Column -->
                <div style="display: flex; flex-direction: column; gap: 22px;">
                    <!-- Revenue Trend -->
                    <section class="panel-white">
                        <div class="panel-header">
                            <h2 class="panel-title">${t_revenue_trend}</h2>
                        </div>
                        <div class="chart-container">
                            <c:choose>
                                <c:when test="${not empty monthlyRevenue}">
                                    <c:set var="maxRev" value="1" />
                                    <c:forEach var="m" items="${monthlyRevenue}">
                                        <c:if test="${m.revenue > maxRev}"><c:set var="maxRev" value="${m.revenue}" /></c:if>
                                    </c:forEach>
                                    <c:forEach var="month" items="${monthlyRevenue}">
                                        <c:set var="monthNum" value="${fn:substring(month.month, 5, 7)}" />
                                        <div class="chart-col">
                                            <span class="chart-value"><fmt:formatNumber value="${month.revenue}" pattern="#,###"/>₫</span>
                                            <div class="chart-bar" style="height: ${month.revenue > 0 ? (month.revenue / maxRev) * 140 : 4}px;"></div>
                                            <span class="chart-label">T${monthNum}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="width:100%; text-align:center; color:#94a3b8; padding:40px; font-size:13px;">${t_no_data}</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>

                    <!-- Top Services -->
                    <section class="panel-white">
                        <div class="panel-header">
                            <h2 class="panel-title">${t_top_services}</h2>
                        </div>
                        <div class="service-list">
                            <c:choose>
                                <c:when test="${not empty topServices}">
                                    <c:forEach var="svc" items="${topServices}" varStatus="st">
                                        <div class="service-item">
                                            <div class="service-rank ${st.index < 3 ? 'top3' : ''}">${st.index + 1}</div>
                                            <div class="service-info">
                                                <div class="service-name">${svc.serviceName}</div>
                                                <div class="service-count"><fmt:formatNumber value="${svc.price}" pattern="#,###"/>₫ · ${svc.appointmentCount} ${t_appointments}</div>
                                            </div>
                                            <div class="service-revenue">
                                                <fmt:formatNumber value="${svc.totalRevenue}" pattern="#,###"/>₫
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p style="text-align:center; color:#94a3b8; padding:15px; font-size:13px;">${t_no_data}</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>
                </div>

                <!-- Right Column -->
                <div style="display: flex; flex-direction: column; gap: 22px;">
                    <!-- Leave Requests -->
                    <section class="panel-white">
                        <div class="panel-header">
                            <h2 class="panel-title">${t_leave_pending}</h2>
                            <a href="${pageContext.request.contextPath}/admin/leave/pending" class="view-all">${t_view_all}</a>
                        </div>

                        <c:choose>
                            <c:when test="${empty requests}">
                                <p style="text-align:center; color:#a0aec0; padding:20px; font-size:14px;">${t_no_pending_leave}</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${requests}" varStatus="status">
                                    <c:if test="${status.index < 3}">
                                        <div class="req-item">
                                            <div class="req-avatar">${fn:substring(r.empId, 0, 1)}</div>
                                            <div class="req-info">
                                                <strong>${r.empId}</strong>
                                                <span>${r.reason}</span>
                                            </div>
                                            <div class="req-btns">
                                                <form action="${pageContext.request.contextPath}/updateLeaveStatus" method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="${r.leaveId}">
                                                    <input type="hidden" name="action" value="approve">
                                                    <button type="submit" class="btn-circle btn-approve"><i class="fa-solid fa-check"></i></button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/updateLeaveStatus" method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="${r.leaveId}">
                                                    <input type="hidden" name="action" value="reject">
                                                    <button type="submit" class="btn-circle btn-reject"><i class="fa-solid fa-xmark"></i></button>
                                                </form>
                                                    
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <!-- Quick Actions -->
                    <section class="action-grid">
                        <a href="${pageContext.request.contextPath}/admin/services" class="action-card">
                            <i class="fa-solid fa-screwdriver-wrench"></i>
                            <h3>${t_services_mgmt}</h3>
                            <p>${t_services_mgmt_sub}</p>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/medicine/list" class="action-card">
                            <i class="fa-solid fa-pills"></i>
                            <h3>${t_pharmacy_mgmt}</h3>
                            <p>${t_pharmacy_mgmt_sub}</p>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/doctor/schedule/list" class="action-card">
                            <i class="fa-solid fa-calendar-days"></i>
                            <h3>${t_schedule_mgmt}</h3>
                            <p>${t_schedule_mgmt_sub}</p>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/feedback/list" class="action-card">
                            <i class="fa-solid fa-comments"></i>
                            <h3>${t_feedback_mgmt}</h3>
                            <p>${t_feedback_mgmt_sub}</p>
                        </a>
                    </section>
                </div>
            </div>
        </main>

    </body>
</html>
