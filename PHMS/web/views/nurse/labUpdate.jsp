<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${L == 'en' ? 'VetCare Pro - Update Lab Result' : 'VetCare Pro - Cập nhật kết quả xét nghiệm'}</title>
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
                    <h2>
                        <c:choose>
                            <c:when test="${canUpdate == false}">${L == 'en' ? 'View Lab Result' : 'Xem kết quả xét nghiệm'}</c:when>
                            <c:otherwise>${L == 'en' ? 'Update Lab Result' : 'Cập nhật kết quả xét nghiệm'}</c:otherwise>
                        </c:choose>
                    </h2>
                    <p>${L == 'en' ? 'Test' : 'Phiếu'} #${test.testId}</p>
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
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:if test="${canUpdate == false}">
                    <div style="background:#fee2e2; border:1px solid #fecaca; border-radius:8px; padding:12px; margin-bottom:16px; color:#991b1b;">
                        <i class="fa-solid fa-info-circle"></i>
                        <strong>${L == 'en' ? 'This lab test is' : 'Phiếu xét nghiệm này ở trạng thái'} ${test.status}.</strong>
                        ${L == 'en' ? 'You can view details below but cannot make changes.' : 'Bạn chỉ có thể xem chi tiết, không thể chỉnh sửa.'}
                    </div>
                </c:if>

                <c:if test="${not empty test}">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 10px;">
                        <div><b>${L == 'en' ? 'Type' : 'Loại'}:</b> ${test.testType}</div>
                        <div><b>${L == 'en' ? 'Status' : 'Trạng thái'}:</b>
                            <c:choose>
                                <c:when test="${test.status == 'Completed'}">
                                    <span style="color:#10b981; font-weight:600;">${L == 'en' ? 'Completed' : 'Hoàn thành'}</span>
                                </c:when>
                                <c:when test="${test.status == 'Cancelled'}">
                                    <span style="color:#94a3b8; font-weight:600;">${L == 'en' ? 'Cancelled' : 'Đã hủy'}</span>
                                </c:when>
                                <c:when test="${test.status == 'In Progress'}">
                                    <span style="color:#3b82f6; font-weight:600;">${L == 'en' ? 'In Progress' : 'Đang xử lý'}</span>
                                </c:when>
                                <c:otherwise>${test.status}</c:otherwise>
                            </c:choose>
                        </div>
                        <div><b>${L == 'en' ? 'Pet' : 'Thú cưng'}:</b> ${test.petName}</div>
                        <div><b>${L == 'en' ? 'Owner' : 'Chủ nuôi'}:</b> ${test.ownerName}</div>
                        <div><b>${L == 'en' ? 'Vet' : 'Bác sĩ'}:</b> ${test.vetName}</div>
                        <div><b>${L == 'en' ? 'Request Notes' : 'Ghi chú yêu cầu'}:</b> ${test.requestNotes}</div>
                    </div>

                    <c:if test="${not empty test.resultData}">
                        <div style="margin-top:16px; padding:12px; background:#f0fdf4; border:1px solid #bbf7d0; border-radius:8px;">
                            <b><i class="fa-solid fa-file-medical"></i> ${L == 'en' ? 'Result' : 'Kết quả'}:</b>
                            <c:if test="${not empty existingFilePath}">
                                <a href="${pageContext.request.contextPath}${existingFilePath}" target="_blank" class="btn btn-approve" style="text-decoration:none; margin-left:8px;">
                                    <i class="fa-regular fa-image"></i> ${L == 'en' ? 'View Image' : 'Xem ảnh'}
                                </a>
                                <c:if test="${fn:endsWith(fn:toLowerCase(existingFilePath), '.jpg') || fn:endsWith(fn:toLowerCase(existingFilePath), '.jpeg') || fn:endsWith(fn:toLowerCase(existingFilePath), '.png')}">
                                    <div style="margin-top:10px;">
                                        <img src="${pageContext.request.contextPath}${existingFilePath}" alt="Lab Result Image"
                                             style="max-width:320px; width:100%; border:1px solid #d1d5db; border-radius:10px;">
                                    </div>
                                </c:if>
                            </c:if>
                            <c:if test="${not empty existingResultText}">
                                <p style="margin-top:8px; white-space:pre-wrap;">${existingResultText}</p>
                            </c:if>
                        </div>
                    </c:if>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/nurse/lab/update" enctype="multipart/form-data">
                    <input type="hidden" name="testId" value="${test.testId}">

                    <div style="margin-top: 10px;">
                        <label><b>${L == 'en' ? 'Status' : 'Trạng thái'}</b></label>
                        <select name="status" style="width:100%;" ${canUpdate == false ? 'disabled' : ''}>
                            <option value="Requested" ${test.status == 'Requested' ? 'selected' : ''}>${L == 'en' ? 'Requested' : 'Đã yêu cầu'}</option>
                            <option value="In Progress" ${test.status == 'In Progress' ? 'selected' : ''}>${L == 'en' ? 'In Progress' : 'Đang xử lý'}</option>
                            <option value="Completed" ${test.status == 'Completed' ? 'selected' : ''}>${L == 'en' ? 'Completed' : 'Hoàn thành'}</option>
                        </select>
                    </div>

                    <div style="margin-top: 10px;">
                        <label><b>${L == 'en' ? 'Result Text' : 'Nội dung kết quả'}</b> (${L == 'en' ? 'optional' : 'không bắt buộc'})</label>
                        <textarea name="resultText" rows="4" style="width:100%;" maxlength="4000"
                                  placeholder="${L == 'en' ? 'Enter result text...' : 'Nhập nội dung kết quả...'}" ${canUpdate == false ? 'readonly' : ''}>${existingResultText}</textarea>
                    </div>

                    <div style="margin-top: 10px;">
                        <label><b>${L == 'en' ? 'Upload Result Image' : 'Tải ảnh kết quả'}</b> (${L == 'en' ? 'optional' : 'không bắt buộc'})</label>
                        <input id="resultFileInput" type="file" name="resultFile" accept=".jpg,.jpeg,.png,image/*" style="width:100%;" ${canUpdate == false ? 'disabled' : ''}>
                        <small style="color:#64748b;">${L == 'en' ? 'Allowed: JPG, JPEG, PNG. Max size: 10MB.' : 'Cho phép: JPG, JPEG, PNG. Dung lượng tối đa: 10MB.'}</small>
                        <div id="selectedImagePreviewWrap" style="display:none; margin-top:10px;">
                            <div style="font-weight:600; margin-bottom:6px; color:#334155;">${L == 'en' ? 'Preview before save:' : 'Xem trước trước khi lưu:'}</div>
                            <img id="selectedImagePreview" alt="Selected image preview"
                                 style="max-width:320px; width:100%; border:1px solid #d1d5db; border-radius:10px;">
                        </div>
                    </div>

                    <div style="display:flex; gap:10px; margin-top: 12px;">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/nurse/lab/queue">${L == 'en' ? 'Back' : 'Quay lại'}</a>
                        <c:if test="${canUpdate != false}">
                            <button class="btn btn-approve" type="submit">
                                <i class="fa-solid fa-save"></i> ${L == 'en' ? 'Save' : 'Lưu'}
                            </button>
                        </c:if>
                    </div>
                </form>
            </div>
        </main>
        <script>
            (function () {
                var input = document.getElementById('resultFileInput');
                var previewWrap = document.getElementById('selectedImagePreviewWrap');
                var previewImg = document.getElementById('selectedImagePreview');
                if (!input || !previewWrap || !previewImg) {
                    return;
                }

                input.addEventListener('change', function () {
                    var file = input.files && input.files[0] ? input.files[0] : null;
                    if (!file) {
                        previewWrap.style.display = 'none';
                        previewImg.removeAttribute('src');
                        return;
                    }
                    if (!file.type || file.type.indexOf('image/') !== 0) {
                        previewWrap.style.display = 'none';
                        previewImg.removeAttribute('src');
                        return;
                    }
                    var objectUrl = URL.createObjectURL(file);
                    previewImg.src = objectUrl;
                    previewWrap.style.display = 'block';
                    previewImg.onload = function () {
                        URL.revokeObjectURL(objectUrl);
                    };
                });
            })();
        </script>
    <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>
