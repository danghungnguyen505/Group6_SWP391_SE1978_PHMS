<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Triage cấp cứu - Lễ tân</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Triage ca cấp cứu #${appt.apptId}</h1>
            <p class="mgmt-subtitle">
                Thú cưng: ${appt.petName} | Chủ: ${appt.ownerName} | Bác sĩ: ${appt.vetName}
            </p>
        </div>
    </header>

    <c:if test="${not empty error}">
        <div class="alert alert-error" style="margin-bottom: 1rem; color: #b91c1c;">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/receptionist/emergency/triage" method="post">
        <input type="hidden" name="apptId" value="${appt.apptId}">

        <div class="form-group mb-6">
            <label>Mức độ ưu tiên</label>
            <select name="conditionLevel" class="form-input" required>
                <option value="">-- Chọn mức độ --</option>
                <option value="Critical" ${triage != null && triage.conditionLevel == 'Critical' ? 'selected' : ''}>Critical - Nguy kịch</option>
                <option value="High" ${triage != null && triage.conditionLevel == 'High' ? 'selected' : ''}>High - Khẩn</option>
                <option value="Medium" ${triage != null && triage.conditionLevel == 'Medium' ? 'selected' : ''}>Medium - Trung bình</option>
                <option value="Low" ${triage != null && triage.conditionLevel == 'Low' ? 'selected' : ''}>Low - Ổn định</option>
            </select>
        </div>

        <div class="form-group">
            <label>Triệu chứng ban đầu</label>
            <textarea name="initialSymptoms" class="form-input" rows="4"
                      placeholder="Ghi nhận ngắn gọn các triệu chứng của thú cưng...">${triage != null ? triage.initialSymptoms : ''}</textarea>
        </div>

        <div class="form-actions" style="margin-top: 1rem;">
            <button type="submit" class="btn btn-primary">Lưu triage</button>
            <a href="${pageContext.request.contextPath}/receptionist/emergency/queue" class="btn btn-secondary">Hủy</a>
        </div>
    </form>
</div>
</body>
</html>

