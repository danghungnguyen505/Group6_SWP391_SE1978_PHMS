<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hàng đợi cấp cứu - Lễ tân</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
    <style>
        .mgmt-container { margin-left: 0; padding: 20px; }
    </style>
</head>
<body>
    <!-- LEFT SIDEBAR -->
    <nav class="sidebar">
        <div class="brand">
            <i class="fa-solid fa-plus-square"></i> VetCare Pro
        </div>

        <ul class="menu">
            <li>
                <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                    <i class="fa-solid fa-table-columns"></i> ${L == 'en' ? 'Dashboard' : 'Bảng điều khiển'}
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/receptionist/emergency/queue" class="active text-danger">
                    <i class="fa-solid fa-truck-medical"></i> ${L == 'en' ? 'Emergency Triage' : 'Cấp cứu'}
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/receptionist/appointment">
                    <i class="fa-regular fa-calendar-check"></i> ${L == 'en' ? 'Appointments' : 'Cuộc hẹn'}
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/receptionist/invoice/create">
                    <i class="fa-regular fa-credit-card"></i> ${L == 'en' ? 'Billing' : 'Thanh toán'}
                </a>
            </li>
        </ul>

        <!-- Language Switcher -->
        <div style="padding: 12px; margin-top: auto;">
            <div style="display:flex; background:#f1f5f9; border-radius:8px; padding:3px; gap:2px;">
                <a href="${pageContext.request.contextPath}/language?lang=vi"
                   style="padding:5px 10px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; flex:1; text-align:center;
                          ${L == 'vi' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">VI</a>
                <a href="${pageContext.request.contextPath}/language?lang=en"
                   style="padding:5px 10px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; flex:1; text-align:center;
                          ${L == 'en' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">EN</a>
            </div>
        </div>

        <div class="help-box">
            <div class="help-text">${L == 'en' ? 'Need help?' : 'Cần hỗ trợ?'}</div>
            <a href="#" class="btn-contact">${L == 'en' ? 'Contact Support' : 'Liên hệ hỗ trợ'}</a>
        </div>
    </nav>

    <!-- RIGHT MAIN CONTENT -->
    <main class="main-content">
        <div class="top-bar">
            <div class="page-header">
                <h2>${L == 'en' ? 'Emergency Queue' : 'Hàng đợi cấp cứu'}</h2>
                <p>${L == 'en' ? 'List of emergency cases awaiting examination.' : 'Danh sách các ca cấp cứu đang chờ khám.'}</p>
            </div>
            <div style="display:flex; gap:10px; align-items:center;">
                <a href="${pageContext.request.contextPath}/receptionist/emergency/create"
                   style="padding:8px 16px; background:#ef4444; color:#fff; border-radius:8px; text-decoration:none; font-size:13px; font-weight:600;">
                    <i class="fa-solid fa-plus"></i> ${L == 'en' ? 'Create Emergency' : 'Tạo cấp cứu'}
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">${L == 'en' ? 'Sign Out' : 'Đăng xuất'}</a>
            </div>
        </div>

        <!-- Search & Filter Bar -->
        <div class="card" style="margin-bottom: 20px; padding: 15px;">
            <form method="get" action="${pageContext.request.contextPath}/receptionist/emergency/queue" style="display:flex; gap:10px; flex-wrap:wrap; align-items:center;">
                <!-- Search -->
                <div style="flex:1; min-width:200px;">
                    <input type="text" name="search" value="${param.search}" placeholder="${L == 'en' ? 'Search by pet name, owner...' : 'Tìm theo tên pet, chủ...'}"
                           style="width:100%; padding:8px 12px; border:1px solid #e2e8f0; border-radius:8px; font-size:13px;">
                </div>
                <!-- Filter Status -->
                <div style="min-width:150px;">
                    <select name="status" style="padding:8px 12px; border:1px solid #e2e8f0; border-radius:8px; font-size:13px; width:100%;">
                        <option value="">${L == 'en' ? 'All Status' : 'Tất cả trạng thái'}</option>
                        <option value="In-Progress" ${param.status == 'In-Progress' ? 'selected' : ''}>${L == 'en' ? 'In Progress' : 'Đang xử lý'}</option>
                        <option value="Completed" ${param.status == 'Completed' ? 'selected' : ''}>${L == 'en' ? 'Completed' : 'Hoàn thành'}</option>
                        <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>${L == 'en' ? 'Cancelled' : 'Đã hủy'}</option>
                    </select>
                </div>
                <!-- Filter Level -->
                <div style="min-width:150px;">
                    <select name="level" style="padding:8px 12px; border:1px solid #e2e8f0; border-radius:8px; font-size:13px; width:100%;">
                        <option value="">${L == 'en' ? 'All Levels' : 'Tất cả mức độ'}</option>
                        <option value="Critical" ${param.level == 'Critical' ? 'selected' : ''} style="color:#b91c1c; font-weight:bold;">Critical</option>
                        <option value="High" ${param.level == 'High' ? 'selected' : ''} style="color:#f97316; font-weight:bold;">High</option>
                        <option value="Medium" ${param.level == 'Medium' ? 'selected' : ''} style="color:#ca8a04; font-weight:bold;">Medium</option>
                        <option value="Low" ${param.level == 'Low' ? 'selected' : ''} style="color:#16a34a; font-weight:bold;">Low</option>
                        <option value="None" ${param.level == 'None' ? 'selected' : ''}>${L == 'en' ? 'Not triaged' : 'Chưa phân loại'}</option>
                    </select>
                </div>
                <!-- Buttons -->
                <button type="submit" style="padding:8px 16px; background:#10b981; color:#fff; border:none; border-radius:8px; font-size:13px; font-weight:600; cursor:pointer;">
                    <i class="fa-solid fa-search"></i> ${L == 'en' ? 'Search' : 'Tìm kiếm'}
                </button>
                <a href="${pageContext.request.contextPath}/receptionist/emergency/queue" style="padding:8px 16px; background:#f1f5f9; color:#64748b; border:none; border-radius:8px; font-size:13px; font-weight:600; text-decoration:none;">
                    <i class="fa-solid fa-rotate-left"></i> ${L == 'en' ? 'Reset' : 'Đặt lại'}
                </a>
            </form>
        </div>

        <c:if test="${empty appointments}">
            <div class="card">
                <p style="text-align:center; color:#64748b; padding:40px;">
                    <i class="fa-solid fa-clipboard-list" style="font-size:40px; margin-bottom:10px; display:block; opacity:0.5;"></i>
                    ${L == 'en' ? 'There are currently no emergency cases.' : 'Hiện không có ca cấp cứu nào.'}
                </p>
            </div>
        </c:if>

        <c:if test="${not empty appointments}">
            <div class="card">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
                    <span style="font-size:13px; color:#64748b;">
                        ${L == 'en' ? 'Showing' : 'Hiển thị'} ${appointments.size()} ${L == 'en' ? 'result(s)' : 'kết quả'}
                    </span>
                </div>
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>${L == 'en' ? 'No.' : 'STT'}</th>
                        <th>${L == 'en' ? 'Pets' : 'Thú cưng'}</th>
                        <th>${L == 'en' ? 'Pet Owner' : 'Chủ thú cưng'}</th>
                        <th>${L == 'en' ? 'Veterinarian' : 'Bác sĩ'}</th>
                        <th>${L == 'en' ? 'Time' : 'Thời gian'}</th>
                        <th>${L == 'en' ? 'Level' : 'Mức độ'}</th>
                        <th>${L == 'en' ? 'Status' : 'Trạng thái'}</th>
                        <th>${L == 'en' ? 'Action' : 'Hành động'}</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="a" items="${appointments}" varStatus="loop">
                        <c:set var="triage" value="${triageMap[a.apptId]}" />
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${a.petName}</td>
                            <td>${a.ownerName}</td>
                            <td>${a.vetName}</td>
                            <td>${a.startTime}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${triage != null && triage.conditionLevel eq 'Critical'}">
                                        <span class="badge" style="background:#dc2626;color:#fff;">Critical</span>
                                    </c:when>
                                    <c:when test="${triage != null && triage.conditionLevel eq 'High'}">
                                        <span class="badge" style="background:#ea580c;color:#fff;">High</span>
                                    </c:when>
                                    <c:when test="${triage != null && triage.conditionLevel eq 'Medium'}">
                                        <span class="badge" style="background:#ca8a04;color:#fff;">Medium</span>
                                    </c:when>
                                    <c:when test="${triage != null && triage.conditionLevel eq 'Low'}">
                                        <span class="badge" style="background:#16a34a;color:#fff;">Low</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-inactive">${L == 'en' ? 'Not triaged' : 'Chưa phân loại'}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${a.status == 'In-Progress'}">
                                        <span class="badge" style="background:#dbeafe; color:#1e40af;">${L == 'en' ? 'In Progress' : 'Đang xử lý'}</span>
                                    </c:when>
                                    <c:when test="${a.status == 'Completed'}">
                                        <span class="badge" style="background:#d1fae5; color:#065f46;">${L == 'en' ? 'Completed' : 'Hoàn thành'}</span>
                                    </c:when>
                                    <c:when test="${a.status == 'Cancelled'}">
                                        <span class="badge" style="background:#fee2e2; color:#991b1b;">${L == 'en' ? 'Cancelled' : 'Đã hủy'}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge">${a.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${a.status == 'Completed'}">
                                        <c:choose>
                                            <c:when test="${invoiceMap[a.apptId] != null && invoiceMap[a.apptId].status == 'Paid'}">
                                                <a href="${pageContext.request.contextPath}/receptionist/invoice/detail?invoiceId=${invoiceMap[a.apptId].invoiceId}"
                                                   class="btn btn-approve" style="font-size:12px;">
                                                    <i class="fa-solid fa-eye"></i> ${L == 'en' ? 'View Invoice' : 'Xem hóa đơn'}
                                                </a>
                                            </c:when>
                                            <c:when test="${invoiceMap[a.apptId] != null && invoiceMap[a.apptId].status == 'Unpaid'}">
                                                <a href="${pageContext.request.contextPath}/receptionist/invoice/detail?invoiceId=${invoiceMap[a.apptId].invoiceId}"
                                                   class="btn btn-approve" style="font-size:12px; background:#f59e0b; border-color:#f59e0b;">
                                                    <i class="fa-solid fa-credit-card"></i> ${L == 'en' ? 'Pay Invoice' : 'Thanh toán'}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/receptionist/invoice/create?apptId=${a.apptId}"
                                                   class="btn btn-approve" style="font-size:12px;">
                                                    <i class="fa-solid fa-file-invoice-dollar"></i> ${L == 'en' ? 'Create Invoice' : 'Tạo hóa đơn'}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/receptionist/emergency/triage?apptId=${a.apptId}"
                                           class="btn btn-secondary"><i class="fa-solid fa-pen-to-square"></i> ${L == 'en' ? 'Edit' : 'Sửa'}</a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div style="display:flex; justify-content:center; gap:6px; margin-top:20px; align-items:center;">
                        <c:if test="${currentPage > 1}">
                            <a href="?page=${currentPage - 1}&search=${param.search}&status=${param.status}&level=${param.level}"
                               style="padding:6px 12px; border:1px solid #e2e8f0; border-radius:6px; text-decoration:none; color:#64748b; font-size:13px;">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="?page=${i}&search=${param.search}&status=${param.status}&level=${param.level}"
                               style="padding:6px 12px; border-radius:6px; text-decoration:none; font-size:13px; font-weight:600;
                                      ${i == currentPage ? 'background:#10b981; color:#fff; border-color:#10b981;' : 'border:1px solid #e2e8f0; color:#64748b;'}">
                                ${i}
                            </a>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}&search=${param.search}&status=${param.status}&level=${param.level}"
                               style="padding:6px 12px; border:1px solid #e2e8f0; border-radius:6px; text-decoration:none; color:#64748b; font-size:13px;">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </c:if>
    </main>
</body>
</html>
