<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Triage cấp cứu - Lễ tân</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
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
                <h2>Triage ca cấp cứu #${appt.apptId}</h2>
                <p>Thú cưng: ${appt.petName} | Chủ: ${appt.ownerName} | Bác sĩ: ${appt.vetName}</p>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
        </div>

        <div class="card">
            <c:if test="${not empty error}">
                <div class="alert alert-error" style="margin-bottom: 1rem; color: #b91c1c;">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/receptionist/emergency/triage" method="post">
                <input type="hidden" name="apptId" value="${appt.apptId}">

                <div class="form-group" style="margin-bottom: 16px;">
                    <label style="font-weight:600; margin-bottom:6px; display:block;">${L == 'en' ? 'Priority Level' : 'Mức độ ưu tiên'}</label>
                    <select name="conditionLevel" style="width:100%; padding:8px; border-radius:8px; border:1px solid #e2e8f0;" required>
                        <option value="">${L == 'en' ? '-- Select level --' : '-- Chọn mức độ --'}</option>
                        <option value="Critical" ${triage != null && triage.conditionLevel == 'Critical' ? 'selected' : ''}>${L == 'en' ? 'Critical - Critical condition' : 'Critical - Nguy kịch'}</option>
                        <option value="High" ${triage != null && triage.conditionLevel == 'High' ? 'selected' : ''}>${L == 'en' ? 'High - Urgent' : 'High - Khẩn'}</option>
                        <option value="Medium" ${triage != null && triage.conditionLevel == 'Medium' ? 'selected' : ''}>${L == 'en' ? 'Medium - Moderate' : 'Medium - Trung bình'}</option>
                        <option value="Low" ${triage != null && triage.conditionLevel == 'Low' ? 'selected' : ''}>${L == 'en' ? 'Low - Stable' : 'Low - Ổn định'}</option>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label style="font-weight:600; margin-bottom:6px; display:block;">${L == 'en' ? 'Initial Symptoms' : 'Triệu chứng ban đầu'}</label>
                    <textarea name="initialSymptoms" rows="4"
                              style="width:100%; padding:8px; border-radius:8px; border:1px solid #e2e8f0;"
                              placeholder="${L == 'en' ? 'Briefly describe the pet symptoms...' : 'Ghi nhận ngắn gọn các triệu chứng của thú cưng...'}">${triage != null ? triage.initialSymptoms : ''}</textarea>
                </div>

                <div style="display:flex; gap:10px; margin-top:16px;">
                    <button type="submit" class="btn btn-approve">${L == 'en' ? 'Save' : 'Lưu'}</button>
                    <a href="${pageContext.request.contextPath}/receptionist/emergency/queue" class="btn btn-reject">${L == 'en' ? 'Cancel' : 'Hủy'}</a>
                </div>
            </form>
        </div>
    </main>
</body>
</html>
