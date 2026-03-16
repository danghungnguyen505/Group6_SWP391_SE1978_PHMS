<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:forEach items="${messages}" var="m">

<div class="message ${m.senderId == sessionScope.account.userId ? 'sent' : 'received'}">

${m.messageText}

</div>

</c:forEach>