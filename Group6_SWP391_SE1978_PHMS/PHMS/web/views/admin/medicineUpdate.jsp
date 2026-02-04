<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Update Medicine</title>
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
                    <h2>Update Medicine</h2>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:if test="${not empty medicine}">
                    <form method="post" action="${pageContext.request.contextPath}/admin/medicine/update">
                        <input type="hidden" name="medicineId" value="${medicine.medicineId}">
                        
                        <div style="margin-bottom:15px;">
                            <label><b>Medicine ID</b></label>
                            <input type="text" value="#${medicine.medicineId}" disabled 
                                   style="width:100%; padding:8px; background:#f3f4f6;">
                        </div>

                        <div style="margin-bottom:15px;">
                            <label><b>Medicine Name *</b></label>
                            <input type="text" name="name" value="${medicine.name}" required maxlength="100" 
                                   style="width:100%; padding:8px;" placeholder="Enter medicine name">
                        </div>

                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:15px;">
                            <div>
                                <label><b>Unit *</b></label>
                                <input type="text" name="unit" value="${medicine.unit}" required maxlength="20" 
                                       style="width:100%; padding:8px;" placeholder="e.g., tablet, ml, bottle">
                            </div>
                            <div>
                                <label><b>Price (VND) *</b></label>
                                <input type="number" name="price" value="${medicine.price}" step="0.01" min="0" required 
                                       style="width:100%; padding:8px;" placeholder="0.00">
                            </div>
                        </div>

                        <div style="margin-bottom:15px;">
                            <label><b>Stock Quantity *</b></label>
                            <input type="number" name="stockQuantity" value="${medicine.stockQuantity}" min="0" required 
                                   style="width:100%; padding:8px;" placeholder="0">
                        </div>

                        <div style="display:flex; gap:10px; margin-top:20px;">
                            <a href="${pageContext.request.contextPath}/admin/medicine/list" 
                               class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;">Cancel</a>
                            <button type="submit" class="btn btn-approve">
                                <i class="fa-solid fa-save"></i> Update Medicine
                            </button>
                        </div>
                    </form>
                </c:if>
            </div>
        </main>
    </body>
</html>
