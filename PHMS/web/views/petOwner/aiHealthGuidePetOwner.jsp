<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
<head>
    <meta charset="UTF-8">
    <title>${t_ai_title} - VetCare Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/assets/css/petOwner/aiHealthGuide.css" rel="stylesheet">
</head>
<body>

    <jsp:include page="nav/navPetOwner.jsp" />

    <main class="main-content">
        <header class="top-bar">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                ${t_logout}
            </a>
        </header>

        <div class="ai-header-card">
            <div class="ai-title-group">
                <div class="ai-icon"><i class="fa-solid fa-bolt"></i></div>
                <div>
                    <h2>${t_ai_title}</h2>
                    <p>${t_ai_subtitle}</p>
                </div>
            </div>
            <div class="ai-status">
                <span class="status-dot"></span>
                <c:choose>
                    <c:when test="${not geminiConfigured}">
                        <span style="color: red;">${t_ai_offline}</span>
                    </c:when>
                    <c:otherwise>
                        ${t_ai_online}
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="chat-container">

            <c:if test="${not empty error}">
                <div class="alert alert-danger mx-3 mt-3">
                    <i class="fa-solid fa-circle-exclamation"></i> ${error}
                </div>
            </c:if>

            <div class="chat-history" id="chatHistory">
                <div class="message bot-message">
                    <div class="message-icon"><i class="fa-solid fa-robot"></i></div>
                    <div class="message-content">
                        ${t_ai_greeting}
                    </div>
                </div>

                <c:if test="${not empty history}">
                    <c:forEach var="log" items="${history}">

                        <div class="message user-message" style="justify-content: flex-end;">
                            <div class="message-content">
                                ${log.questionRaw}
                            </div>
                            <div class="message-icon" style="margin-left: 10px; margin-right: 0;">
                                <i class="fa-solid fa-user"></i>
                            </div>
                        </div>

                        <div class="message bot-message">
                            <div class="message-icon"><i class="fa-solid fa-robot"></i></div>
                            <div class="message-content">
                                <span style="white-space: pre-wrap;">${log.aiResponse}</span>
                            </div>
                        </div>

                    </c:forEach>
                </c:if>

                <div id="loadingBubble" class="loading-bubble">
                    <i class="fa-solid fa-spinner fa-spin"></i> ${t_ai_loading}
                </div>
            </div>

            <div class="input-area">
                <form id="aiChatForm" action="${pageContext.request.contextPath}/aiHealthGuide" method="post" style="width: 100%;">
                    <div class="input-wrapper">
                        <textarea id="userInput" name="question"
                                  placeholder="${t_ai_placeholder}"
                                  rows="1" required></textarea>

                        <button type="submit" class="btn-send" id="btnSend" ${!geminiConfigured ? "disabled" : ""}>
                            <i class="fa-solid fa-paper-plane"></i>
                        </button>
                    </div>
                </form>
                <div class="disclaimer">
                    <i class="fa-solid fa-circle-info"></i> ${t_ai_disclaimer}
                </div>
            </div>
        </div>
    </main>

    <script>
        // Tự động cuộn xuống cuối khi trang tải xong
        window.onload = function() {
            var chatHistory = document.getElementById("chatHistory");
            chatHistory.scrollTop = chatHistory.scrollHeight;
        };

        // Xử lý khi gửi form
        document.getElementById('aiChatForm').addEventListener('submit', function(e) {
            var input = document.getElementById('userInput').value.trim();
            if(input.length < 2) {
                e.preventDefault();
                return;
            }

            // Hiện loading
            document.getElementById('loadingBubble').classList.add('active');
            
            // Cuộn xuống để thấy loading
            var chatHistory = document.getElementById("chatHistory");
            setTimeout(() => {
                chatHistory.scrollTop = chatHistory.scrollHeight;
            }, 100);

            // Disable nút gửi
            var btn = document.getElementById('btnSend');
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';
            btn.style.opacity = '0.7';
            btn.style.pointerEvents = 'none';
        });

        // Xử lý phím Enter để gửi (Shift+Enter để xuống dòng)
        document.getElementById('userInput').addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                document.getElementById('btnSend').click();
            }
        });
    </script>
<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>
