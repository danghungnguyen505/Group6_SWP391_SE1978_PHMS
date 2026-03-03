<<<<<<< Updated upstream
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gửi tín hiệu cấp cứu - PHMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Tín hiệu cấp cứu (SOS)</h1>
            <p class="mgmt-subtitle">
                Dùng trong trường hợp khẩn cấp. Sau khi gửi, vui lòng đưa thú cưng tới phòng khám ngay lập tức.
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
            <label>Chọn thú cưng</label>
            <select name="petId" class="form-input" required>
                <option value="">-- Chọn thú cưng --</option>
                <c:forEach var="p" items="${pets}">
                    <option value="${p.id}">${p.name} (${p.species})</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>Mô tả tình trạng khẩn cấp</label>
            <textarea name="description" class="form-input" rows="4"
                      placeholder="Ví dụ: Chó bị ngộ độc, nôn liên tục, khó thở..."></textarea>
        </div>

        <div class="form-actions" style="margin-top: 1rem;">
            <button type="submit" class="btn btn-primary">Gửi tín hiệu cấp cứu</button>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Hủy</a>
        </div>
    </form>
</div>
</body>
</html>

=======
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gửi tín hiệu cấp cứu - PHMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Tín hiệu cấp cứu (SOS)</h1>
            <p class="mgmt-subtitle">
                Dùng trong trường hợp khẩn cấp. Sau khi gửi, vui lòng đưa thú cưng tới phòng khám ngay lập tức.
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
            <label>Chọn thú cưng</label>
            <select name="petId" class="form-input" required>
                <option value="">-- Chọn thú cưng --</option>
                <c:forEach var="p" items="${pets}">
                    <option value="${p.id}">${p.name} (${p.species})</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label>Mô tả tình trạng khẩn cấp</label>
            <textarea name="description" class="form-input" rows="4"
                      placeholder="Ví dụ: Chó bị ngộ độc, nôn liên tục, khó thở..."></textarea>
        </div>

        <div class="form-actions" style="margin-top: 1rem;">
            <button type="submit" class="btn btn-primary">Gửi tín hiệu cấp cứu</button>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Hủy</a>
        </div>
    </form>
</div>
</body>
</html>

>>>>>>> Stashed changes
