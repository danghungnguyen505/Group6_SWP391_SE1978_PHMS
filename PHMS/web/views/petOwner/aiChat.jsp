<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>AI Chat - Tư vấn thú cưng</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/service-management.css">
</head>
<body class="mgmt-page">
<div class="mgmt-container">
    <header class="mgmt-header">
        <div>
            <h1 class="mgmt-title">Trò chuyện với AI thú y</h1>
            <p class="mgmt-subtitle">
                Đặt câu hỏi về chăm sóc thú cưng (ăn uống, tiêm phòng, hành vi...), AI sẽ hỗ trợ bạn.
            </p>
        </div>
    </header>

    <c:if test="${not geminiConfigured}">
        <div class="alert alert-error" style="margin-bottom: 1rem; color: #b91c1c;">
            Hệ thống AI chưa được cấu hình khóa API. Vui lòng liên hệ quản trị hệ thống.
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-error" style="margin-bottom: 1rem; color: #b91c1c;">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/ai/chat" method="post" style="margin-bottom: 1.5rem;">
        <label for="question">Câu hỏi của bạn</label>
        <textarea id="question" name="question" class="form-input" rows="4"
                  placeholder="Ví dụ: Chó con 3 tháng tuổi nên tiêm những vaccine gì?">${question}</textarea>
        <div class="form-actions" style="margin-top: 0.75rem;">
            <button type="submit" class="btn btn-primary" ${!geminiConfigured ? "disabled" : ""}>Gửi câu hỏi</button>
        </div>
    </form>

    <c:if test="${not empty answer}">
        <div class="data-table-container" style="margin-bottom: 1.5rem;">
            <h2 class="mgmt-title" style="font-size: 1.1rem;">Trả lời mới nhất</h2>
            <div style="background: #ffffff; border-radius: 0.75rem; padding: 1rem; border: 1px solid #e5e7eb;">
                <p style="white-space: pre-wrap;">${answer}</p>
            </div>
        </div>
    </c:if>

    <div class="data-table-container">
        <h2 class="mgmt-title" style="font-size: 1.1rem;">Lịch sử trò chuyện gần đây</h2>
        <c:if test="${empty history}">
            <p>Chưa có cuộc trò chuyện nào.</p>
        </c:if>
        <c:if test="${not empty history}">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Thời gian</th>
                    <th>Câu hỏi</th>
                    <th>Câu trả lời</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="log" items="${history}">
                    <tr>
                        <td>${log.createdAt}</td>
                        <td style="white-space: pre-wrap;"><small>${log.questionRaw}</small></td>
                        <td style="white-space: pre-wrap;"><small>${log.aiResponse}</small></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>
</body>
</html>

