<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${L == 'en' ? 'VetCare Pro - Lab Queue' : 'VetCare Pro - Hàng đợi xét nghiệm'}</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/nurse/lab/queue" class="active">
                        <i class="fa-solid fa-flask"></i> ${L == 'en' ? 'Lab Queue' : 'Hàng đợi xét nghiệm'}</a></li>
            </ul>
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

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>${L == 'en' ? 'Lab Test Queue' : 'Hàng đợi xét nghiệm'}</h2>
                    <p>${L == 'en' ? 'Process requested tests and enter results.' : 'Xử lý phiếu xét nghiệm và cập nhật kết quả.'}</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">${L == 'en' ? 'Logout' : 'Đăng xuất'}</a>
            </div>

            <c:if test="${not empty sessionScope.toastMessage}">
                <c:set var="toast" value="${sessionScope.toastMessage}" />
                <c:choose>
                    <c:when test="${fn:startsWith(toast, 'success|')}">
                        <div style="background:#ecfdf5;border:1px solid #a7f3d0;color:#065f46;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-weight:600;">
                            <i class="fa-solid fa-check-circle" style="margin-right:8px;"></i>
                            ${fn:substringAfter(toast, 'success|')}
                        </div>
                    </c:when>
                    <c:when test="${fn:startsWith(toast, 'error|')}">
                        <div style="background:#fef2f2;border:1px solid #fecaca;color:#991b1b;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-weight:600;">
                            <i class="fa-solid fa-triangle-exclamation" style="margin-right:8px;"></i>
                            ${fn:substringAfter(toast, 'error|')}
                        </div>
                    </c:when>
                </c:choose>
                <c:remove var="toastMessage" scope="session" />
            </c:if>

            <div class="card">
                <div class="section-title">
                    <span>${L == 'en' ? 'Lab Tests' : 'Danh sách xét nghiệm'}</span>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/nurse/lab/queue" style="display:flex; gap:8px; margin-bottom:16px;">
                    <input type="text" name="search"
                           placeholder="${L == 'en' ? 'Search by pet, owner, vet, test type...' : 'Tìm theo pet, chủ nuôi, bác sĩ, loại xét nghiệm...'}"
                           value="${search}" style="flex:1; padding:8px 12px; border:1px solid #d1d5db; border-radius:6px;">
                    <input type="hidden" name="filter" value="${filter}">
                    <input type="hidden" name="size" value="${pageSize}">
                    <button type="submit" class="btn btn-approve" style="text-decoration:none;">
                        <i class="fa-solid fa-search"></i> ${L == 'en' ? 'Search' : 'Tìm kiếm'}
                    </button>
                    <c:if test="${not empty search}">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/nurse/lab/queue?filter=${filter}&size=${pageSize}">
                            <i class="fa-solid fa-times"></i> ${L == 'en' ? 'Clear' : 'Xóa lọc'}
                        </a>
                    </c:if>
                </form>

                <div style="display:flex; gap:8px; margin-bottom:16px;">
                    <a class="btn ${filter == 'requested' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'requested' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/nurse/lab/queue?filter=requested&size=${pageSize}">
                        <i class="fa-solid fa-clock"></i> ${L == 'en' ? 'Requested' : 'Đã yêu cầu'}
                    </a>
                    <a class="btn ${filter == 'inprogress' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'inprogress' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/nurse/lab/queue?filter=inprogress&size=${pageSize}">
                        <i class="fa-solid fa-spinner"></i> ${L == 'en' ? 'In Progress' : 'Đang xử lý'}
                    </a>
                    <a class="btn ${filter == 'completed' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'completed' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/nurse/lab/queue?filter=completed&size=${pageSize}">
                        <i class="fa-solid fa-check-circle"></i> ${L == 'en' ? 'Completed' : 'Hoàn thành'}
                    </a>
                    <a class="btn ${filter == 'all' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'all' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/nurse/lab/queue?filter=all&size=${pageSize}">
                        <i class="fa-solid fa-list"></i> ${L == 'en' ? 'All' : 'Tất cả'}
                    </a>
                </div>

                <c:if test="${empty tests}">
                    <div class="empty-state"><p>${L == 'en' ? 'No lab tests found.' : 'Không có phiếu xét nghiệm nào.'}</p></div>
                </c:if>

                <c:if test="${not empty tests}">
                    <table>
                        <thead>
                            <tr>
                                <th style="display:none;">ID</th>
                                <th>STT</th>
                                <th>${L == 'en' ? 'Type' : 'Loại xét nghiệm'}</th>
                                <th>${L == 'en' ? 'Pet' : 'Thú cưng'}</th>
                                <th>${L == 'en' ? 'Owner' : 'Chủ nuôi'}</th>
                                <th>${L == 'en' ? 'Vet' : 'Bác sĩ'}</th>
                                <th>${L == 'en' ? 'Status' : 'Trạng thái'}</th>
                                <th style="text-align:center;">${L == 'en' ? 'Action' : 'Thao tác'}</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${tests}" var="t" varStatus="status">
                                <tr>
                                    <td style="display:none;">${t.testId}</td>
                                    <td>${(currentPage - 1) * pageSize + status.index + 1}</td>
                                    <td class="col-service">${t.testType}</td>
                                    <td class="col-pet">${t.petName}</td>
                                    <td>${t.ownerName}</td>
                                    <td>${t.vetName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'Requested'}">
                                                <span style="color:#f59e0b; font-weight:600;">${L == 'en' ? 'Requested' : 'Đã yêu cầu'}</span>
                                            </c:when>
                                            <c:when test="${t.status == 'In Progress'}">
                                                <span style="color:#3b82f6; font-weight:600;">${L == 'en' ? 'In Progress' : 'Đang xử lý'}</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Completed'}">
                                                <span style="color:#10b981; font-weight:600;">${L == 'en' ? 'Completed' : 'Hoàn thành'}</span>
                                            </c:when>
                                            <c:when test="${t.status == 'Cancelled'}">
                                                <span style="color:#94a3b8; font-weight:600;">${L == 'en' ? 'Cancelled' : 'Đã hủy'}</span>
                                            </c:when>
                                            <c:otherwise>${t.status}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <c:choose>
                                            <c:when test="${t.status == 'Completed' || t.status == 'Cancelled'}">
                                                <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                                                   href="${pageContext.request.contextPath}/nurse/lab/update?id=${t.testId}">
                                                    ${L == 'en' ? 'View' : 'Xem'}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="btn btn-approve" style="text-decoration:none;"
                                                   href="${pageContext.request.contextPath}/nurse/lab/update?id=${t.testId}">
                                                    ${L == 'en' ? 'Update' : 'Cập nhật'}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <c:if test="${totalPages > 1}">
                    <c:set var="filterParam" value="&filter=${filter}" />
                    <c:set var="sizeParam" value="&size=${pageSize}" />
                    <c:set var="searchParam" value="${not empty search ? '&search='.concat(search) : ''}" />
                    <div style="display:flex; gap:6px; justify-content:space-between; margin-top:12px; align-items:center; flex-wrap:wrap;">
                        <form method="get" action="${pageContext.request.contextPath}/nurse/lab/queue" style="display:flex; align-items:center; gap:8px;">
                            <input type="hidden" name="filter" value="${filter}">
                            <input type="hidden" name="search" value="${search}">
                            <span style="font-size:12px; color:#64748b; font-weight:700;">${L == 'en' ? 'Showing' : 'Hiển thị'}</span>
                            <select name="size" onchange="this.form.submit()" style="padding:6px 10px; border:1px solid #d1d5db; border-radius:8px; font-size:12px;">
                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                            </select>
                        </form>
                        <div style="display:flex; gap:6px; justify-content:flex-end;">
                        <c:if test="${currentPage > 1}">
                            <a class="btn btn-approve" style="text-decoration:none;" href="?page=${currentPage - 1}${sizeParam}${filterParam}${searchParam}">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a class="btn ${currentPage == i ? 'btn-approve' : 'btn-reject'}"
                               style="text-decoration:none; ${currentPage == i ? '' : 'background:#e5e7eb;color:#111827;'}"
                               href="?page=${i}${sizeParam}${filterParam}${searchParam}">${i}</a>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a class="btn btn-approve" style="text-decoration:none;" href="?page=${currentPage + 1}${sizeParam}${filterParam}${searchParam}">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </c:if>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>
