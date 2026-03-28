<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>GÃ¡Â»Â­i tÃƒÂ­n hiÃ¡Â»â€¡u cÃ¡ÂºÂ¥p cÃ¡Â»Â©u - PHMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">TÃƒÂ­n hiÃ¡Â»â€¡u cÃ¡ÂºÂ¥p cÃ¡Â»Â©u (SOS)</h1>
            <p class="mgmt-subtitle">
                DÃƒÂ¹ng trong trÃ†Â°Ã¡Â»Âng hÃ¡Â»Â£p khÃ¡ÂºÂ©n cÃ¡ÂºÂ¥p. Sau khi gÃ¡Â»Â­i, vui lÃƒÂ²ng Ã„â€˜Ã†Â°a thÃƒÂº cÃ†Â°ng tÃ¡Â»â€ºi phÃƒÂ²ng khÃƒÂ¡m ngay lÃ¡ÂºÂ­p tÃ¡Â»Â©c.
            </p>
        </div>
    </header>

    <c:if test="${not empty error}">
        <div class="alert alert-error" style="margin-bottom: 1rem; color: #b91c1c;">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/sos" method="post">
        <div class="form-group mb-6">
            <label>ChÃ¡Â»Ân thÃƒÂº cÃ†Â°ng</label>
            <select name="petId" class="form-input" required>
                <option value="">-- ChÃ¡Â»Ân thÃƒÂº cÃ†Â°ng --</option>
                <c:forEach var="p" items="${pets}">
                    <option value="${p.id}">${p.name} (${p.species})</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>MÃƒÂ´ tÃ¡ÂºÂ£ tÃƒÂ¬nh trÃ¡ÂºÂ¡ng khÃ¡ÂºÂ©n cÃ¡ÂºÂ¥p</label>
            <textarea name="description" class="form-input" rows="4"
                      placeholder="VÃƒÂ­ dÃ¡Â»Â¥: ChÃƒÂ³ bÃ¡Â»â€¹ ngÃ¡Â»â„¢ Ã„â€˜Ã¡Â»â„¢c, nÃƒÂ´n liÃƒÂªn tÃ¡Â»Â¥c, khÃƒÂ³ thÃ¡Â»Å¸..."></textarea>
        </div>

        <div class="form-actions" style="margin-top: 1rem;">
            <button type="submit" class="btn btn-primary">GÃ¡Â»Â­i tÃƒÂ­n hiÃ¡Â»â€¡u cÃ¡ÂºÂ¥p cÃ¡Â»Â©u</button>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">HÃ¡Â»Â§y</a>
        </div>
    </form>
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

