<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Medicine Management</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/medicine/list" class="active">
                        <i class="fa-solid fa-pills"></i> Medicine</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Medicine Management</h2>
                    <p>Total: ${totalMedicines} medicines</p>
                </div>
                <div style="display:flex; gap:10px;">
                    <a href="${pageContext.request.contextPath}/admin/medicine/add" class="btn btn-approve" style="text-decoration:none;">
                        <i class="fa-solid fa-plus"></i> Add Medicine
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
                </div>
            </div>

            <div class="card">
                <c:choose>
                    <c:when test="${empty medicines || medicines.size() == 0}">
                        <div style="text-align:center; padding:40px;">
                            <p>No medicines found.</p>
                            <a href="${pageContext.request.contextPath}/admin/medicine/add" class="btn btn-approve">Add Medicine</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table style="width:100%; border-collapse:collapse;">
                            <thead>
                                <tr style="background:#f3f4f6;">
                                    <th style="padding:10px; text-align:left;">ID</th>
                                    <th style="padding:10px; text-align:left;">Name</th>
                                    <th style="padding:10px; text-align:left;">Unit</th>
                                    <th style="padding:10px; text-align:left;">Price</th>
                                    <th style="padding:10px; text-align:left;">Stock</th>
                                    <th style="padding:10px; text-align:left;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="med" items="${medicines}">
                                    <tr>
                                        <td style="padding:10px;">#${med.medicineId}</td>
                                        <td style="padding:10px;">${med.name}</td>
                                        <td style="padding:10px;">${med.unit}</td>
                                        <td style="padding:10px;"><fmt:formatNumber value="${med.price}" type="currency" currencySymbol="₫"/></td>
                                        <td style="padding:10px;">${med.stockQuantity}</td>
                                        <td style="padding:10px;">
                                            <a href="${pageContext.request.contextPath}/admin/medicine/update?id=${med.medicineId}" 
                                               class="btn btn-secondary" style="text-decoration:none; padding:5px 10px;">Edit</a>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/medicine/delete" 
                                                  style="display:inline;" 
                                                  onsubmit="return confirm('Bạn có chắc muốn xóa thuốc này?');">
                                                <input type="hidden" name="id" value="${med.medicineId}">
                                                <button type="submit" class="btn btn-reject" style="padding:5px 10px;">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div style="display:flex; justify-content:center; gap:10px; margin-top:20px;">
                                <c:if test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/admin/medicine/list?page=${currentPage - 1}" class="btn btn-secondary">Previous</a>
                                </c:if>
                                <span>Page ${currentPage} of ${totalPages}</span>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/admin/medicine/list?page=${currentPage + 1}" class="btn btn-secondary">Next</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </body>
</html>
