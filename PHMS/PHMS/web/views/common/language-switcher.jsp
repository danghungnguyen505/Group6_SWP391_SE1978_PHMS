<%--
    Language Switcher Component
    Usage: Include this file in any JSP page to show language switcher
    Example: <%@ include file="/views/common/language-switcher.jsp" %>
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Set default bundle if not already set --%>
<c:if test="${empty currentLanguage}">
    <c:set var="currentLanguage" value="vi" />
</c:if>

<div class="language-switcher dropdown">
    <button class="btn btn-sm btn-outline-secondary dropdown-toggle"
            type="button"
            data-bs-toggle="dropdown"
            aria-expanded="false"
            style="min-width: 100px;">
        <i class="fa-solid fa-globe"></i>
        <c:choose>
            <c:when test="${currentLanguage == 'vi'}">
                <span>Tiếng Việt</span>
            </c:when>
            <c:otherwise>
                <span>English</span>
            </c:otherwise>
        </c:choose>
    </button>
    <ul class="dropdown-menu dropdown-menu-end">
        <li>
            <a class="dropdown-item ${currentLanguage == 'vi' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/language?lang=vi&redirect=${requestScope['javax.servlet.forward.request_uri']}">
                <span style="${currentLanguage == 'vi' ? 'font-weight: bold;' : ''}">🇻🇳 Tiếng Việt</span>
            </a>
        </li>
        <li>
            <a class="dropdown-item ${currentLanguage == 'en' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/language?lang=en&redirect=${requestScope['javax.servlet.forward.request_uri']}">
                <span style="${currentLanguage == 'en' ? 'font-weight: bold;' : ''}">🇬🇧 English</span>
            </a>
        </li>
    </ul>
</div>

<%-- Alternative: Simple inline switcher (use one or the other) --%>
<%--
<div class="language-switcher-inline" style="display: flex; gap: 8px; align-items: center;">
    <a href="${pageContext.request.contextPath}/language?lang=vi"
       class="btn btn-sm ${currentLanguage == 'vi' ? 'btn-primary' : 'btn-outline-primary'}"
       title="Tiếng Việt">
        VN
    </a>
    <a href="${pageContext.request.contextPath}/language?lang=en"
       class="btn btn-sm ${currentLanguage == 'en' ? 'btn-primary' : 'btn-outline-primary'}"
       title="English">
        EN
    </a>
</div>
--%>
