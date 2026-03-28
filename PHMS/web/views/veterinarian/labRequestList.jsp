<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Lab Requests</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
    </head>
    <body>
      <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Lab Requests</h2>
                    <p>Track requested tests and results.</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Requests</span>
                </div>

                <!-- Search -->
                <form method="get" action="${pageContext.request.contextPath}/veterinarian/lab/requests" style="display:flex; gap:8px; margin-bottom:16px;">
                    <input type="text" name="search" placeholder="Search by pet, test type..."
                           value="${search}" style="flex:1; padding:8px 12px; border:1px solid #d1d5db; border-radius:6px;">
                    <input type="hidden" name="filter" value="${filter}">
                    <input type="hidden" name="size" value="${pageSize}">
                    <button type="submit" class="btn btn-approve" style="text-decoration:none;">
                        <i class="fa-solid fa-search"></i> Search
                    </button>
                    <c:if test="${not empty search}">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=${filter}&size=${pageSize}">
                            <i class="fa-solid fa-times"></i> Clear
                        </a>
                    </c:if>
                </form>

                <!-- Filter Tabs -->
                <div style="display:flex; gap:8px; margin-bottom:16px;">
                    <a class="btn ${filter == 'all' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'all' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=all&size=${pageSize}">
                        <i class="fa-solid fa-list"></i> All
                    </a>
                    <a class="btn ${filter == 'requested' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'requested' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=requested&size=${pageSize}">
                        <i class="fa-solid fa-clock"></i> Requested
                    </a>
                    <a class="btn ${filter == 'inprogress' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'inprogress' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=inprogress&size=${pageSize}">
                        <i class="fa-solid fa-spinner"></i> In Progress
                    </a>
                    <a class="btn ${filter == 'completed' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'completed' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=completed&size=${pageSize}">
                        <i class="fa-solid fa-check-circle"></i> Completed
                    </a>
                    <a class="btn ${filter == 'cancelled' ? 'btn-approve' : 'btn-reject'}"
                       style="text-decoration:none; ${filter == 'cancelled' ? '' : 'background:#e5e7eb;color:#111827;'}"
                       href="${pageContext.request.contextPath}/veterinarian/lab/requests?filter=cancelled&size=${pageSize}">
                        <i class="fa-solid fa-times-circle"></i> Cancelled
                    </a>
                </div>

                <c:if test="${empty tests}">
                    <div class="empty-state"><p>No lab requests.</p></div>
                </c:if>

                <c:if test="${not empty tests}">
                    <table>
                        <thead>
                            <tr>
                                <th style="display:none;">ID</th>
                                <th>STT</th>
                                <th style="display:none;">Record</th>
                                <th>Pet</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th>Result</th>
                                <th style="text-align:center;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${tests}" var="t" varStatus="status">
                                <tr>
                                    <td style="display:none;">${t.testId}</td>
                                    <td>${(currentPage - 1) * pageSize + status.index + 1}</td>
                                    <td style="display:none;">${t.recordId}</td>
                                    <td class="col-pet">${t.petName}</td>
                                    <td class="col-service">${t.testType}</td>
                                    <td>${t.status}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty labResultImageMap[t.testId] || not empty labResultTextMap[t.testId]}">
                                                <div style="display:flex; gap:6px; flex-wrap:wrap;">
                                                    <c:if test="${not empty labResultImageMap[t.testId]}">
                                                        <button type="button" class="btn btn-approve"
                                                                onclick="openImageModal('${pageContext.request.contextPath}${labResultImageMap[t.testId]}', 'Lab Result Image')">
                                                            <i class="fa-regular fa-image"></i> View Image
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${not empty labResultTextMap[t.testId]}">
                                                        <button type="button" class="btn btn-reject"
                                                                style="background:#e5e7eb; color:#111827;"
                                                                onclick="openNoteModal('lab-note-${t.testId}', 'Lab Result Note')">
                                                            <i class="fa-regular fa-eye"></i> View Note
                                                        </button>
                                                        <textarea id="lab-note-${t.testId}" style="display:none;">${labResultTextMap[t.testId]}</textarea>
                                                    </c:if>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:#999; font-style:italic;">Pending</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:center;">
                                        <c:if test="${t.status != 'Completed' && t.status != 'Cancelled'}">
                                            <form method="post" action="${pageContext.request.contextPath}/veterinarian/lab/cancel" style="display:inline;">
                                                <input type="hidden" name="id" value="${t.testId}">
                                                <button class="btn btn-reject" type="submit"
                                                        onclick="return confirm('Cancel this request?');"
                                                        style="background:#ef4444; color:white;">
                                                    Cancel
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${t.status == 'Cancelled'}">
                                            <span style="color:#94a3b8; font-style:italic;">Cancelled</span>
                                        </c:if>
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
                        <form method="get" action="${pageContext.request.contextPath}/veterinarian/lab/requests" style="display:flex; align-items:center; gap:8px;">
                            <input type="hidden" name="filter" value="${filter}">
                            <input type="hidden" name="search" value="${search}">
                            <span style="font-size:12px; color:#64748b; font-weight:700;">Hiển thị</span>
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

        <div id="noteModal" style="display:none; position:fixed; z-index:2000; left:0; top:0; width:100%; height:100%; background:rgba(2,6,23,0.4);">
            <div style="background:#fff; max-width:760px; margin:7% auto; border-radius:14px; overflow:hidden; box-shadow:0 20px 60px rgba(15,23,42,0.3);">
                <div style="padding:13px 16px; border-bottom:1px solid #f1f5f9; display:flex; justify-content:space-between; align-items:center;">
                    <div id="noteModalTitle" style="font-size:14px; font-weight:800; color:#1e293b;">Note</div>
                    <span style="font-size:22px; color:#64748b; cursor:pointer; line-height:1;" onclick="closeNoteModal()">&times;</span>
                </div>
                <div style="padding:16px; max-height:440px; overflow-y:auto;">
                    <div id="noteContent" style="white-space:pre-wrap; color:#334155; font-size:14px; line-height:1.5;"></div>
                </div>
            </div>
        </div>

        <div id="imageModal" style="display:none; position:fixed; z-index:2100; left:0; top:0; width:100%; height:100%; background:rgba(2,6,23,0.65);">
            <div style="position:relative; max-width:960px; margin:4% auto; background:#fff; border-radius:14px; overflow:hidden; box-shadow:0 20px 60px rgba(15,23,42,0.35);">
                <div style="padding:13px 16px; border-bottom:1px solid #f1f5f9; display:flex; justify-content:space-between; align-items:center;">
                    <div id="imageModalTitle" style="font-size:14px; font-weight:800; color:#1e293b;">Image</div>
                    <span style="font-size:22px; color:#64748b; cursor:pointer; line-height:1;" onclick="closeImageModal()">&times;</span>
                </div>
                <div style="padding:16px; text-align:center; background:#f8fafc;">
                    <img id="imageModalContent" alt="Lab result image"
                         style="max-width:100%; max-height:75vh; border:1px solid #d1d5db; border-radius:10px;">
                </div>
            </div>
        </div>

        <script>
            function openNoteModal(sourceId, title) {
                var source = document.getElementById(sourceId);
                var content = document.getElementById('noteContent');
                var modal = document.getElementById('noteModal');
                var modalTitle = document.getElementById('noteModalTitle');
                content.textContent = source ? source.value : '';
                modalTitle.textContent = title || 'Note';
                modal.style.display = 'block';
            }

            function closeNoteModal() {
                document.getElementById('noteModal').style.display = 'none';
            }

            function openImageModal(imageUrl, title) {
                var modal = document.getElementById('imageModal');
                var image = document.getElementById('imageModalContent');
                var modalTitle = document.getElementById('imageModalTitle');
                image.src = imageUrl || '';
                modalTitle.textContent = title || 'Image';
                modal.style.display = 'block';
            }

            function closeImageModal() {
                var modal = document.getElementById('imageModal');
                var image = document.getElementById('imageModalContent');
                modal.style.display = 'none';
                image.removeAttribute('src');
            }

            window.onclick = function (event) {
                var noteModal = document.getElementById('noteModal');
                var imageModal = document.getElementById('imageModal');
                if (event.target === noteModal) {
                    closeNoteModal();
                }
                if (event.target === imageModal) {
                    closeImageModal();
                }
            };
        </script>
    <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>


