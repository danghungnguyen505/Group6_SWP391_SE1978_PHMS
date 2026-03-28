<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>GÃ¡Â»Â­i Ã„â€˜Ã†Â¡n nghÃ¡Â»â€° - PHMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="form-wrapper">
    <div class="form-card">
        <div class="form-header">
            <h1 class="form-title">GÃ¡Â»Â­i Ã„â€˜Ã†Â¡n nghÃ¡Â»â€°</h1>
            <p style="color: var(--text-muted); font-size: 0.875rem; margin-top: 0.5rem;">
                Ã„ÂÃ„Æ’ng kÃƒÂ½ nghÃ¡Â»â€° 1 ngÃƒÂ y, Ã„â€˜Ã†Â¡n sÃ¡ÂºÂ½ Ã„â€˜Ã†Â°Ã¡Â»Â£c quÃ¡ÂºÂ£n lÃƒÂ½ phÃƒÂª duyÃ¡Â»â€¡t.
            </p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error" style="margin-bottom: 1rem; color: #b91c1c;">
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/leave/request" method="post">
            <div class="form-group mb-6">
                <label>NgÃƒÂ y nghÃ¡Â»â€°</label>
                <input type="date" name="startDate" required class="form-input">
            </div>

            <div class="form-group">
                <label>LÃƒÂ½ do nghÃ¡Â»â€°</label>
                <textarea name="reason" class="form-input" rows="4"
                          placeholder="MÃƒÂ´ tÃ¡ÂºÂ£ lÃƒÂ½ do nghÃ¡Â»â€°... (tÃ¡Â»Â« 5 Ã„â€˜Ã¡ÂºÂ¿n 1000 kÃƒÂ½ tÃ¡Â»Â±)">${reason}</textarea>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary" style="flex: 2;">GÃ¡Â»Â­i Ã„â€˜Ã†Â¡n</button>
                <a href="${pageContext.request.contextPath}/leave/my-requests" class="btn btn-secondary" style="flex: 1;">
                    Xem Ã„â€˜Ã†Â¡n cÃ¡Â»Â§a tÃƒÂ´i
                </a>
            </div>
        </form>
    </div>
</div>
<div class="phms-account-entry" style="position:fixed; top:16px; right:20px; z-index:1200;">
    <a href="${pageContext.request.contextPath}/logout" style="display:inline-flex;align-items:center;gap:6px;padding:8px 14px;border:1px solid #e2e8f0;border-radius:10px;background:#fff;color:#334155;text-decoration:none;font-size:13px;font-weight:700;box-shadow:0 2px 10px rgba(0,0,0,.05);">Sign Out</a>
</div>
<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>

