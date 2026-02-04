<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
