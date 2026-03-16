<%--
    Document   : forgot-password
    Created on : Jan 22, 2026, 5:46:25 AM
    Author     : Nguyen Dang Hung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setBundle basename="util.messages" />
<!DOCTYPE html>
<html lang="${currentLanguage}">
<head>
    <title><fmt:message key="auth.forgot.title"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/login.css">
</head>
<body>
    <%-- Language Switcher --%>
    <div class="language-switcher-fixed">
        <a href="${pageContext.request.contextPath}/language?lang=vi&redirect=/forgot-password"
           class="lang-btn ${currentLanguage == 'vi' ? 'active' : ''}">VN</a>
        <a href="${pageContext.request.contextPath}/language?lang=en&redirect=/forgot-password"
           class="lang-btn ${currentLanguage == 'en' ? 'active' : ''}">EN</a>
    </div>

    <div class="back-home-floating">
        <a href="${pageContext.request.contextPath}/home" class="back-home-btn">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            <fmt:message key="nav.backToHome"/>
        </a>
    </div>
    <div class="login-wrapper">
        <div class="login-card">
            <h2 class="login-title text-center"><fmt:message key="auth.forgot.title"/></h2>

            <p style="color:red; text-align:center">${error}</p>
            <p style="color:green; text-align:center">${message}</p>
            <p style="color:blue; text-align:center; font-weight:bold">${success}</p>

            <c:if test="${empty success}">
                <form action="forgot-password" method="post">

                    <c:if test="${empty step}">
                        <div class="form-group">
                            <label><fmt:message key="auth.forgot.enterEmail"/></label>
                            <input type="email" name="email" required class="form-input" placeholder="example@gmail.com">
                        </div>
                        <button type="submit" class="btn btn-primary btn-login"><fmt:message key="auth.forgot.sendOtp"/></button>
                    </c:if>

                    <c:if test="${step == '2'}">
                        <div class="form-group">
                            <label><fmt:message key="auth.forgot.enterOtp"/></label>
                            <input type="text" name="otp" required class="form-input">
                        </div>
                        <div class="form-group">
                            <label><fmt:message key="auth.forgot.newPassword"/></label>
                            <input type="password" name="newPass" required class="form-input">
                        </div>
                        <button type="submit" class="btn btn-primary btn-login"><fmt:message key="auth.change.btn"/></button>
                    </c:if>

                </form>
            </c:if>

            <div class="register-prompt" style="margin-top:20px;">
                <a href="login"><fmt:message key="auth.forgot.backToLogin"/></a>
            </div>
        </div>
    </div>
</body>
</html>
