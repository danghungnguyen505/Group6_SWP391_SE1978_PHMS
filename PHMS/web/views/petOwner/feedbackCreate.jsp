<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetCare Pro - Submit Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
    <style>
        .feedback-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            padding: 24px;
        }
        .table-wrap {
            overflow-x: auto;
        }
        .table-feedback {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            overflow: hidden;
        }
        .table-feedback th, .table-feedback td {
            padding: 12px 14px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
            text-align: left;
            white-space: nowrap;
        }
        .table-feedback thead th {
            background: #f8fafc;
            color: #475569;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.02em;
            font-weight: 700;
        }
        .table-feedback tbody tr:last-child td {
            border-bottom: none;
        }
        .btn-review {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #f59e0b;
            color: #fff;
            border-radius: 999px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            padding: 7px 12px;
        }
        .btn-review:hover {
            background: #d97706;
            color: #fff;
        }
        .empty-state {
            text-align: center;
            padding: 48px 20px;
            color: #64748b;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            background: #f8fafc;
        }
        .empty-state i {
            font-size: 42px;
            color: #94a3b8;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <jsp:include page="nav/navPetOwner.jsp" />

    <main class="main-content">
        <header class="top-bar">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                ${t_logout}
            </a>
        </header>

        <div class="page-header">
            <div class="page-title">
                <h1>${L == 'en' ? 'Submit Feedback' : 'Gửi phản hồi'}</h1>
                <p>${L == 'en' ? 'Select a completed appointment to review.' : 'Chọn lịch hẹn đã hoàn thành để gửi đánh giá.'}</p>
            </div>
            <a href="${pageContext.request.contextPath}/myAppointment" class="btn-cancel" style="text-decoration:none;display:inline-flex;align-items:center;">
                ${L == 'en' ? 'Back to Appointments' : 'Quay lại lịch hẹn'}
            </a>
        </div>

        <section class="feedback-card">
            <c:choose>
                <c:when test="${empty appointments || appointments.size() == 0}">
                    <div class="empty-state">
                        <i class="fa-regular fa-face-smile"></i>
                        <p>${L == 'en' ? 'No completed appointments available for feedback.' : 'Hiện chưa có lịch hẹn hoàn thành để gửi phản hồi.'}</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="table-feedback">
                            <thead>
                                <tr>
                                    <th>#ID</th>
                                    <th>${L == 'en' ? 'Date & Time' : 'Ngày giờ'}</th>
                                    <th>${L == 'en' ? 'Pet' : 'Thú cưng'}</th>
                                    <th>${L == 'en' ? 'Veterinarian' : 'Bác sĩ'}</th>
                                    <th>${L == 'en' ? 'Service' : 'Dịch vụ'}</th>
                                    <th>${L == 'en' ? 'Action' : 'Thao tác'}</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="appt" items="${appointments}">
                                    <tr>
                                        <td><b>#${appt.apptId}</b></td>
                                        <td><fmt:formatDate value="${appt.startTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td>${appt.petName}</td>
                                        <td>${appt.vetName}</td>
                                        <td>${appt.type}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/feedback/create?apptId=${appt.apptId}" class="btn-review">
                                                <i class="fa-solid fa-star"></i> ${L == 'en' ? 'Review' : 'Đánh giá'}
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>

