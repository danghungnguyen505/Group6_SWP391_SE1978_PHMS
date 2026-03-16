<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:forEach var="m" items="${messages}">

<div class="message ${m.senderId == sessionScope.account.userId ? 'sent' : 'received'}">

<div>${m.messageText}</div>

<div style="font-size:11px; opacity:0.7; text-align:right; margin-top:3px;">
<fmt:formatDate value="${m.sentTime}" pattern="HH:mm"/>
</div>

</div>

</c:forEach>