<%-- 
    Document   : examination
    Created on : Jan 27, 2026, 2:24:31 AM
    Author     : thanh
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Examination Workspace</title>
    <style>
        body { font-family: Arial; background: #f6f8fb; }
        .box { background: white; padding: 20px; width: 600px; margin: 40px auto; border-radius: 10px; }
        textarea { width: 100%; height: 100px; margin-bottom: 10px; }
        button { padding: 10px 15px; }
        .error { color: red; }
    </style>
</head>
<body>

<div class="box">
    <h2>Examination Workspace</h2>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/examination">
        <input type="hidden" name="apptId" value="${apptId}" />

        <label>Diagnosis *</label>
        <textarea name="diagnosis" required></textarea>

        <label>Treatment Plan / Clinical Notes</label>
        <textarea name="treatmentPlan"></textarea>

        <button type="submit">Finish Examination</button>
    </form>
</div>

</body>
</html>

