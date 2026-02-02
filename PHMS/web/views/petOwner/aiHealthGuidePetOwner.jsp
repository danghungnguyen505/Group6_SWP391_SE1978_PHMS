<%-- 
    Document   : aiHealthGuidePetOwner
    Created on : Feb 3, 2026, 12:15:37 AM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/dashboardLeft.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/petOwner/aiHealthGuide.css" rel="stylesheet">
    </head>
    <body>
        <!--Dashboard left-->
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus"></i> VetCare Pro
            </div>
            <div class="menu-label">Main Menu</div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
                        <i class="fa-solid fa-border-all"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/booking" class="nav-link">
                        <i class="fa-regular fa-calendar-check"></i> Appointments</a></li>
                <li><a href="${pageContext.request.contextPath}/myAppointment"class="nav-link">
                        <i class="fa-solid fa-calendar-check"></i> My Appointments</a>
                </li>
                <li><a href="${pageContext.request.contextPath}/myPetOwner"class="nav-link">
                        <i class="fa-solid fa-paw"></i> My Pets</a></li>
                <li><a href="${pageContext.request.contextPath}/medicalRecords"class="nav-link">
                        <i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
                <li><a href="${pageContext.request.contextPath}/billing"class="nav-link">
                        <i class="fa-regular fa-credit-card"></i> Billing</a></li>
                <li><a href="${pageContext.request.contextPath}/aiHealthGuide"class="nav-link active">
                        <i class="fa-solid fa-bolt"></i> AI Health Guide</a></li>
            </ul>
            <div class="support-box">
                <p>Need help?</p>
                <button class="btn-support">Contact Support</button>
            </div>
        </nav>
    <!-- MAIN CONTENT -->
    <main class="main-content">
        <!-- Top Header (Sign Out) -->
        <header class="top-bar">
            <a href="${pageContext.request.contextPath}/logout" class="btn-signout">
                Sign Out
            </a>
        </header>
        <!-- AI Header Card -->
        <div class="ai-header-card">
            <div class="ai-title-group">
                <div class="ai-icon">
                    <i class="fa-solid fa-bolt"></i>
                </div>
                <div>
                    <h2>AI Pet Health Assistant</h2>
                    <p>Instant advice for your pets, powered by advanced AI.</p>
                </div>
            </div>
            <div class="ai-status">
                <span class="status-dot"></span>
                Gemini AI is Online
            </div>
        </div>
        <!-- Chat Area -->
        <div class="chat-container">
            <!-- Chat History (Messages) -->
            <div class="chat-history" id="chatHistory">
                <!-- Welcome Message -->
                <div class="message bot-message">
                    <div class="message-icon">
                        <i class="fa-solid fa-robot"></i>
                    </div>
                    <div class="message-content">
                        Hello! I'm your Gemini AI Pet Health Guide. How can I help you and your furry friend today?
                    </div>
                </div>
            </div>
            <!-- Input Area -->
            <div class="input-area">
                <div class="input-wrapper">
                    <textarea id="userInput" placeholder="Ask about pet symptoms, diet, or behavior..." rows="1"></textarea>
                    <button class="btn-send" onclick="sendMessage()">
                        <i class="fa-solid fa-arrow-up"></i>
                    </button>
                </div>
                <div class="disclaimer">
                    <i class="fa-solid fa-circle-info"></i> ALWAYS CONSULT A VET FOR EMERGENCIES
                </div>
            </div>
        </div>
    </main>
</body>
</html>