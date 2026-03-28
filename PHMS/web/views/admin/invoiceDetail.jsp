<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetCare Pro - Chi ti&#7871;t h&#243;a &#273;&#417;n</title>
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
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: var(--bg-body); color: var(--text-main); display: flex; min-height: 100vh; }

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

        .main-content { margin-left: var(--sidebar-width); flex: 1; padding: 36px 48px; width: calc(100% - var(--sidebar-width)); }
        .top-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; gap: 12px; }
        .title h1 { font-size: 24px; font-weight: 900; }
        .back-box {
            display: inline-flex;
            margin-top: 10px;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #ffffff;
        }
        .top-actions { display: flex; align-items: center; gap: 10px; }
        .btn-back {
            border: none; background: transparent; text-decoration: none; color: var(--text-main);
            border-radius: 0; font-size: 12px; font-weight: 700; padding: 0;
        }
        .btn-logout {
            border: 1px solid #e2e8f0; background: #fff; text-decoration: none; color: var(--text-main);
            border-radius: 10px; font-size: 12px; font-weight: 700; padding: 10px 16px;
        }

        .grid { display: grid; grid-template-columns: 1.5fr 1fr; gap: 20px; }
        .card { background: #fff; border-radius: 20px; box-shadow: var(--card-shadow); padding: 24px; }

        .info-row { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; margin-bottom: 12px; }
        .info-row > div:last-child { justify-self: end; text-align: right; }
        .label { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; margin-bottom: 3px; }
        .val { font-size: 14px; font-weight: 700; }

        .status { display: inline-block; border-radius: 999px; padding: 4px 10px; font-size: 11px; font-weight: 700; }
        .status.paid { background: #dcfce7; color: #166534; }
        .status.unpaid { background: #fee2e2; color: #991b1b; }
        .status.other { background: #e2e8f0; color: #334155; }

        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { padding: 10px 8px; border-bottom: 1px solid #f1f5f9; font-size: 13px; }
        th { text-align: left; font-size: 11px; color: #94a3b8; text-transform: uppercase; }
        td.right, th.right { text-align: right; }
        .summary { margin-top: 14px; width: 100%; }
        .sum-row { display: flex; justify-content: space-between; gap: 16px; padding: 4px 0; font-size: 14px; }
        .sum-row.total { border-top: 1px solid #e2e8f0; margin-top: 6px; padding-top: 8px; font-size: 16px; font-weight: 800; }
        .sum-row.paid { color: #166534; font-weight: 700; }

        .payment-item {
            border: 1px solid #edf2f7; border-radius: 12px; padding: 10px 12px; margin-bottom: 10px;
            display: flex; justify-content: space-between; gap: 12px;
        }
        .payment-left { min-width: 0; }
        .payment-left .small { font-size: 12px; color: #94a3b8; }
        .payment-right { text-align: right; font-weight: 700; }
        .empty { color: #94a3b8; font-size: 13px; text-align: center; padding: 16px 0; }

        @media (max-width: 1024px) {
            .main-content { margin-left: 0; width: 100%; padding: 20px; }
            .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <jsp:include page="common/navbar.jsp">
        <jsp:param name="activePage" value="revenue" />
    </jsp:include>

    <main class="main-content">
        <header class="top-header">
            <div class="title">
                <h1>Chi ti&#7871;t h&#243;a &#273;&#417;n #${invoice.invoiceId}</h1>
                <div class="back-box">
                    <a class="btn-back" href="${pageContext.request.contextPath}/admin/reports">Quay l&#7841;i b&#225;o c&#225;o</a>
                </div>
            </div>
            <div class="top-actions">
                <a class="btn-logout" href="${pageContext.request.contextPath}/logout">&#272;&#259;ng xu&#7845;t</a>
            </div>
        </header>

        <div class="grid">
            <section class="card">
                <div class="info-row">
                    <div>
                        <div class="label">Owner</div>
                        <div class="val"><c:out value="${appt.ownerName}" default="-" /></div>
                    </div>
                    <div>
                        <div class="label">Pet</div>
                        <div class="val"><c:out value="${appt.petName}" default="-" /></div>
                    </div>
                </div>
                <div class="info-row">
                    <div>
                        <div class="label">Veterinarian</div>
                        <div class="val"><c:out value="${appt.vetName}" default="-" /></div>
                    </div>
                    <div>
                        <div class="label">Status</div>
                        <div class="val">
                            <c:choose>
                                <c:when test="${invoice.status eq 'Paid'}"><span class="status paid">Paid</span></c:when>
                                <c:when test="${invoice.status eq 'Unpaid'}"><span class="status unpaid">Unpaid</span></c:when>
                                <c:otherwise><span class="status other">${invoice.status}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Type</th>
                            <th>Item</th>
                            <th class="right">Qty</th>
                            <th class="right">Unit Price</th>
                            <th class="right">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${details}">
                            <tr>
                                <td>${d.itemType}</td>
                                <td>${d.itemName}</td>
                                <td class="right">${d.quantity}</td>
                                <td class="right"><fmt:formatNumber value="${d.unitPrice}" pattern="#,###"/>&#8363;</td>
                                <td class="right"><fmt:formatNumber value="${d.quantity * d.unitPrice}" pattern="#,###"/>&#8363;</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:set var="paymentTotal" value="0" />
                <c:forEach var="p" items="${payments}">
                    <c:set var="paymentTotal" value="${paymentTotal + p.amount}" />
                </c:forEach>
                <c:set var="invoiceSubtotal" value="${invoice.totalAmount / 1.1}" />
                <c:set var="invoiceVat" value="${invoice.totalAmount - invoiceSubtotal}" />

                <div class="summary">
                    <div class="sum-row">
                        <span>T&#7893;ng ti&#7873;n h&#243;a &#273;&#417;n</span>
                        <span><fmt:formatNumber value="${invoiceSubtotal}" pattern="#,###"/>&#8363;</span>
                    </div>
                    <div class="sum-row">
                        <span>VAT (10%)</span>
                        <span><fmt:formatNumber value="${invoiceVat}" pattern="#,###"/>&#8363;</span>
                    </div>
                    <div class="sum-row">
                        <span>T&#7893;ng sau thu&#7871;</span>
                        <span><fmt:formatNumber value="${invoice.totalAmount}" pattern="#,###"/>&#8363;</span>
                    </div>
                    <div class="sum-row total">
                        <span>T&#7893;ng thanh to&#225;n</span>
                        <span><fmt:formatNumber value="${invoice.totalAmount}" pattern="#,###"/>&#8363;</span>
                    </div>
                    <div class="sum-row paid">
                        <span>&#272;&#227; thanh to&#225;n</span>
                        <span><fmt:formatNumber value="${paymentTotal}" pattern="#,###"/>&#8363;</span>
                    </div>
                </div>
            </section>

            <aside class="card">
                <div style="font-size:13px; font-weight:800; text-transform:uppercase; margin-bottom:14px;">L&#7883;ch s&#7917; thanh to&#225;n</div>
                <c:choose>
                    <c:when test="${not empty payments}">
                        <c:forEach var="p" items="${payments}">
                            <div class="payment-item">
                                <div class="payment-left">
                                    <div style="font-size:13px; font-weight:700;">${p.method}</div>
                                    <div class="small">ID #${p.paymentId} <c:if test="${not empty p.transCode}">- ${p.transCode}</c:if></div>
                                </div>
                                <div class="payment-right">
                                    <div><fmt:formatNumber value="${p.amount}" pattern="#,###"/>&#8363;</div>
                                    <div class="small">${p.status}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty">Ch&#432;a c&#243; giao d&#7883;ch thanh to&#225;n.</div>
                    </c:otherwise>
                </c:choose>
            </aside>
        </div>
    </main>
<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>

