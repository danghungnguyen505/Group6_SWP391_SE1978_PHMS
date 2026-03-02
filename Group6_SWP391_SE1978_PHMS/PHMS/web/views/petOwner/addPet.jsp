<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Pet - VetCare Pro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assets/css/pages/myPetOwner.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <div class="container" style="max-width: 720px; padding-top: 30px;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
                <h2 style="margin:0;"><i class="fa-solid fa-paw"></i> Add Pet</h2>
                <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/myPetOwner" style="text-decoration:none;">
                    <i class="fa-solid fa-arrow-left"></i> Back
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/pet/add" method="post" class="card p-3">
                <div class="mb-3">
                    <label class="form-label">Pet Name</label>
                    <input class="form-control" name="name" value="${name}" maxlength="100" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Species</label>
                    <input class="form-control" name="species" value="${species}" maxlength="50" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">History Summary</label>
                    <textarea class="form-control" name="history" rows="4" maxlength="2000">${history}</textarea>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">Gender</label>
                    <input type="radio" name="gender" value="${gender}" maxlength="100" required>{}
                </div>
                <button class="btn btn-primary" type="submit">
                    <i class="fa-solid fa-plus"></i> Create
                </button>
            </form>
        </div>
    </body>
</html>

