<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>AI Health Guide - VetCare Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/petOwner/aiHealthGuide.css" rel="stylesheet">
    
    <style>
        /* Hiệu ứng loading */
        .loading-bubble {
            display: none;
            align-items: center;
            gap: 10px;
            padding: 10px 15px;
            background: #f0f0f0;
            border-radius: 15px;
            width: fit-content;
            margin-bottom: 15px;
        }
        .loading-bubble.active { display: flex; }
        
        /* Bong bóng chat của User (cần thêm vào CSS gốc) */
        .message.user-message {
            flex-direction: row-reverse;
            align-self: flex-end;
        }
        .message.user-message .message-content {
            background-color: #0d6efd; /* Màu xanh Bootstrap */
            color: white;
            border-bottom-right-radius: 0;
        }
        
        /* Ẩn thanh cuộn nhưng vẫn cuộn được */
        .chat-history::-webkit-scrollbar { width: 6px; }
        .chat-history::-webkit-scrollbar-thumb { background: #ccc; border-radius: 4px; }
    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="brand">
            <i class="fa-solid fa-plus"></i> VetCare Pro
        </div>
        <div class="menu-label">Main Menu</div>
        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link"><i class="fa-solid fa-border-all"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/booking" class="nav-link"><i class="fa-regular fa-calendar-check"></i> Appointments</a></li>
            <li><a href="${pageContext.request.contextPath}/myAppointment" class="nav-link"><i class="fa-solid fa-calendar-check"></i> My Appointments</a></li>
            <li><a href="${pageContext.request.contextPath}/myPetOwner" class="nav-link"><i class="fa-solid fa-paw"></i> My Pets</a></li>
            <li><a href="${pageContext.request.contextPath}/medicalRecords" class="nav-link"><i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
            <li><a href="${pageContext.request.contextPath}/billing" class="nav-link"><i class="fa-regular fa-credit-card"></i> Billing</a></li>
            <li><a href="${pageContext.request.contextPath}/aiHealthGuide" class="nav-link active"><i class="fa-solid fa-bolt"></i> AI Health Guide</a></li>
        </ul>
        <div class="support-box">
            <p>Need help?</p>
            <button class="btn-support">Contact Support</button>
        </div>
    </nav>

    <main class="main-content">
        <header class="top-bar">
            <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
        </header>

        <div class="ai-header-card">
            <div class="ai-title-group">
                <div class="ai-icon"><i class="fa-solid fa-bolt"></i></div>
                <div>
                    <h2>AI Pet Health Assistant</h2>
                    <p>Instant advice for your pets, powered by advanced AI.</p>
                </div>
            </div>
            <div class="ai-status">
                <span class="status-dot"></span>
                <c:choose>
                    <c:when test="${not geminiConfigured}">
                        <span style="color: red;">AI Offline (Config Error)</span>
                    </c:when>
                    <c:otherwise>
                        Gemini AI is Online
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
                        Xin chào! Tôi là trợ lý AI VetCare. Tôi có thể giúp gì cho sức khỏe thú cưng của bạn hôm nay?
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

                <c:if test="${not empty answer}">
                     <div class="message user-message" style="justify-content: flex-end;">
                        <div class="message-content">${question}</div> <div class="message-icon" style="margin-left: 10px;"><i class="fa-solid fa-user"></i></div>
                    </div>
                    <div class="message bot-message">
                        <div class="message-icon"><i class="fa-solid fa-robot"></i></div>
                        <div class="message-content" style="white-space: pre-wrap;">${answer}</div>
                    </div>
                </c:if>

                <div id="loadingBubble" class="loading-bubble">
                    <i class="fa-solid fa-spinner fa-spin"></i> AI đang soạn câu trả lời...
                </div>
            </div>

            <div class="input-area">
                <form id="aiChatForm" action="${pageContext.request.contextPath}/aiHealthGuide" method="post" style="width: 100%;">
                    <div class="input-wrapper">
                        <textarea id="userInput" name="question" 
                                  placeholder="Hỏi về triệu chứng, chế độ ăn uống..." 
                                  rows="1" required></textarea>
                        
                        <button type="submit" class="btn-send" id="btnSend" ${!geminiConfigured ? "disabled" : ""}>
                            <i class="fa-solid fa-paper-plane"></i>
                        </button>
                    </div>
                </form>
                <div class="disclaimer">
                    <i class="fa-solid fa-circle-info"></i> LUÔN HỎI BÁC SĨ THÚ Y TRONG TRƯỜNG HỢP KHẨN CẤP
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
</body>
</html>