<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - T&#7845;t c&#7843; giao d&#7883;ch</title>
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
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 40px 60px;
            width: calc(100% - var(--sidebar-width));
        }
        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 24px;
        }
        .title-wrap h1 {
            font-size: 40px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: -0.8px;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 12px;
            color: #0f172a;
            text-decoration: none;
            font-size: 13px;
            font-weight: 800;
            border: 1px solid #e2e8f0;
            background: #ffffff;
            border-radius: 10px;
            padding: 10px 14px;
        }
        .title-wrap p {
            color: var(--text-muted);
            margin-top: 8px;
            font-size: 15px;
        }
        .actions { display: flex; gap: 10px; }
        .btn {
            border: 1px solid #e2e8f0;
            background: #fff;
            color: #0f172a;
            font-weight: 700;
            font-size: 13px;
            border-radius: 10px;
            text-decoration: none;
            padding: 10px 14px;
        }
        .btn-primary {
            background: #0f766e;
            border-color: #0f766e;
            color: #fff;
        }
        .panel {
            background: #fff;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            border: 1px solid #edf2f7;
            padding: 20px;
        }
        .filter-row {
            display: grid;
            grid-template-columns: 1fr 190px 170px 170px auto auto;
            gap: 10px;
            align-items: center;
            margin-bottom: 16px;
        }
        .input, .select {
            width: 100%;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 14px;
            color: #0f172a;
            background: #fff;
        }
        .date-filter {
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 0 10px;
            background: #fff;
        }
        .date-filter span {
            font-size: 13px;
            font-weight: 700;
            color: #64748b;
            white-space: nowrap;
        }
        .date-filter .input {
            border: 0;
            padding: 10px 0;
            background: transparent;
        }
        .date-filter .input:focus {
            outline: none;
            box-shadow: none;
        }
        .meta-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 4px 0 12px 0;
            color: #64748b;
            font-size: 13px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 14px;
            border: 1px solid #edf2f7;
        }
        th, td {
            padding: 14px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
            text-align: left;
        }
        th {
            background: #f8fafc;
            font-size: 12px;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: .6px;
            font-weight: 800;
        }
        .status {
            display: inline-block;
            font-size: 11px;
            padding: 5px 10px;
            border-radius: 999px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .status.paid { background: #dcfce7; color: #166534; }
        .status.unpaid { background: #fee2e2; color: #991b1b; }
        .status.other { background: #e2e8f0; color: #334155; }
        .detail-link {
            color: #0f766e;
            text-decoration: none;
            font-weight: 700;
        }
        .empty {
            text-align: center;
            color: #94a3b8;
            font-size: 14px;
            padding: 30px 0;
        }
        .table-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 14px;
            gap: 12px;
            flex-wrap: wrap;
        }
        .page-size-form {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .page-size-label {
            font-size: 13px;
            color: #64748b;
            font-weight: 600;
        }
        .page-size-select {
            width: 100px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 8px 10px;
            font-size: 14px;
            color: #0f172a;
            background: #fff;
        }
        .pagination {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
            flex-wrap: wrap;
        }
        .page-link {
            min-width: 36px;
            text-align: center;
            padding: 8px 10px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            text-decoration: none;
            color: #334155;
            font-weight: 700;
            font-size: 13px;
            background: #fff;
        }
        .page-link.active {
            background: #0f766e;
            border-color: #0f766e;
            color: #fff;
        }
        @media (max-width: 1200px) {
            .filter-row { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>
    <jsp:include page="common/navbar.jsp">
        <jsp:param name="activePage" value="revenue" />
    </jsp:include>

    <main class="main-content">
        <div class="topbar">
            <div class="title-wrap">
                <h1>T&#7845;t c&#7843; giao d&#7883;ch</h1>
                <p>Danh s&#225;ch &#273;&#7847;y &#273;&#7911; h&#243;a &#273;&#417;n trong h&#7879; th&#7889;ng</p>
                <a class="back-link" href="${pageContext.request.contextPath}/admin/reports">
                    <i class="fa-solid fa-arrow-left"></i>
                    Back to report
                </a>
            </div>
            <div class="actions">
                <a class="btn" href="${pageContext.request.contextPath}/logout">&#272;&#259;ng xu&#7845;t</a>
            </div>
        </div>

        <section class="panel">
            <form method="get" action="${pageContext.request.contextPath}/admin/invoice/list" class="filter-row">
                <input class="input" type="text" name="q" value="${q}" placeholder="T&#236;m theo m&#227; h&#243;a &#273;&#417;n, kh&#225;ch h&#224;ng, th&#250; c&#432;ng">
                <select class="select" name="status">
                    <option value="all" ${status == 'all' ? 'selected' : ''}>T&#7845;t c&#7843; tr&#7841;ng th&#225;i</option>
                    <option value="Paid" ${status == 'Paid' ? 'selected' : ''}>Paid</option>
                    <option value="Unpaid" ${status == 'Unpaid' ? 'selected' : ''}>Unpaid</option>
                </select>
                <label class="date-filter">
                    <span>T&#7915;</span>
                    <input class="input" type="date" name="startDate" value="${startDate}">
                </label>
                <label class="date-filter">
                    <span>&#272;&#7871;n</span>
                    <input class="input" type="date" name="endDate" value="${endDate}">
                </label>
                <input type="hidden" name="size" value="${size}">
                <button class="btn btn-primary" type="submit">L&#7885;c</button>
                <a class="btn" href="${pageContext.request.contextPath}/admin/invoice/list">&#272;&#7863;t l&#7841;i</a>
            </form>

            <div class="meta-row">
                <span>T&#7893;ng s&#7889; b&#7843;n ghi: <strong>${totalItems}</strong></span>
                <span>Trang ${page} / ${totalPages}</span>
            </div>

            <c:choose>
                <c:when test="${not empty invoices}">
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Invoice</th>
                                <th>Kh&#225;ch h&#224;ng</th>
                                <th>Th&#250; c&#432;ng</th>
                                <th>Ng&#224;y t&#7841;o</th>
                                <th>T&#7893;ng ti&#7873;n</th>
                                <th>Tr&#7841;ng th&#225;i</th>
                                <th>Chi ti&#7871;t</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="inv" items="${invoices}" varStatus="loop">
                                <tr>
                                    <td>${(page - 1) * size + loop.index + 1}</td>
                                    <td>#${inv.invoiceId}</td>
                                    <td>${inv.ownerName}</td>
                                    <td>${inv.petName}</td>
                                    <td><fmt:formatDate value="${inv.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td><fmt:formatNumber value="${inv.totalAmount}" pattern="#,###"/>&#8363;</td>
                                    <td>
                                        <span class="status ${inv.status eq 'Paid' ? 'paid' : (inv.status eq 'Unpaid' ? 'unpaid' : 'other')}">
                                            ${inv.status}
                                        </span>
                                    </td>
                                    <td>
                                        <a class="detail-link" href="${pageContext.request.contextPath}/admin/invoice/detail?invoiceId=${inv.invoiceId}">Xem</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="table-footer">
                        <form method="get" action="${pageContext.request.contextPath}/admin/invoice/list" class="page-size-form">
                            <span class="page-size-label">Hi&#7875;n th&#7883;</span>
                            <input type="hidden" name="q" value="${q}">
                            <input type="hidden" name="status" value="${status}">
                            <input type="hidden" name="startDate" value="${startDate}">
                            <input type="hidden" name="endDate" value="${endDate}">
                            <input type="hidden" name="page" value="1">
                            <select class="page-size-select" name="size" onchange="this.form.submit()">
                                <option value="5" ${size == 5 ? 'selected' : ''}>5</option>
                                <option value="10" ${size == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${size == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${size == 50 ? 'selected' : ''}>50</option>
                                <option value="100" ${size == 100 ? 'selected' : ''}>100</option>
                            </select>
                        </form>

                        <div class="pagination">
                            <c:if test="${totalPages > 1}">
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:url var="pageUrl" value="/admin/invoice/list">
                                        <c:param name="page" value="${p}" />
                                        <c:param name="q" value="${q}" />
                                        <c:param name="status" value="${status}" />
                                        <c:param name="startDate" value="${startDate}" />
                                        <c:param name="endDate" value="${endDate}" />
                                        <c:param name="size" value="${size}" />
                                    </c:url>
                                    <a class="page-link ${p == page ? 'active' : ''}" href="${pageUrl}">${p}</a>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty">Kh&#244;ng c&#243; h&#243;a &#273;&#417;n ph&#249; h&#7907;p v&#7899;i &#273;i&#7873;u ki&#7879;n t&#236;m ki&#7871;m.</div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

    <script>
        window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
        window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>
