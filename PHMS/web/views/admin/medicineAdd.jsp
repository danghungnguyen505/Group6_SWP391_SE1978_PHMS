<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Add Medicine</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/medicine/list" class="active">Medicine</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Add Medicine</h2>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/admin/medicine/add">
                    <div style="margin-bottom:15px;">
                        <label><b>Medicine Name *</b></label>
                        <input type="text" name="name" value="${name}" required maxlength="100" 
                               style="width:100%; padding:8px;" placeholder="Enter medicine name">
                    </div>

                    <div style="margin-bottom:15px;">
                        <label><b>Unit *</b></label>
                        <input type="text" name="unit" value="${unit}" required maxlength="20" 
                               style="width:100%; padding:8px;" placeholder="e.g., tablet, ml, bottle">
                    </div>

                    <div style="margin-bottom:15px;">
                        <label><b>Price (VND) *</b></label>
                        <input type="number" name="price" value="${price}" step="0.01" min="0" required 
                               style="width:100%; padding:8px;" placeholder="0.00">
                    </div>

                    <div style="margin-bottom:15px;">
                        <label><b>Stock Quantity *</b></label>
                        <input type="number" name="stockQuantity" value="${stockQuantity}" min="0" required 
                               style="width:100%; padding:8px;" placeholder="0">
                    </div>

                    <div style="display:flex; gap:10px; margin-top:20px;">
                        <a href="${pageContext.request.contextPath}/admin/medicine/list" 
                           class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;">Cancel</a>
                        <button type="submit" class="btn btn-approve">
                            <i class="fa-solid fa-save"></i> Save Medicine
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>
