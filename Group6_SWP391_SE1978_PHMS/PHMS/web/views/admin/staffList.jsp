<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Staff Account Management</title>
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
                <li><a href="${pageContext.request.contextPath}/admin/staff/list" class="active">Staff Accounts</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Staff Account Management</h2>
                    <p>Total: ${totalStaff} staff accounts</p>
                </div>
                <div style="display:flex; gap:10px;">
                    <a href="${pageContext.request.contextPath}/admin/staff/create" class="btn btn-approve" style="text-decoration:none;">
                        <i class="fa-solid fa-plus"></i> Add Staff
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
                </div>
            </div>

            <div class="card">
                <c:choose>
                    <c:when test="${empty staffAccounts || staffAccounts.size() == 0}">
                        <div style="text-align:center; padding:40px;">
                            <p>No staff accounts found.</p>
                            <a href="${pageContext.request.contextPath}/admin/staff/create" class="btn btn-approve">Add Staff</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table style="width:100%; border-collapse:collapse;">
                            <thead>
                                <tr style="background:#f3f4f6;">
                                    <th style="padding:10px; text-align:left;">ID</th>
                                    <th style="padding:10px; text-align:left;">Username</th>
                                    <th style="padding:10px; text-align:left;">Full Name</th>
                                    <th style="padding:10px; text-align:left;">Role</th>
                                    <th style="padding:10px; text-align:left;">Phone</th>
                                    <th style="padding:10px; text-align:left;">Employee Code</th>
                                    <th style="padding:10px; text-align:left;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="staff" items="${staffAccounts}">
                                    <tr>
                                        <td style="padding:10px;">#${staff.userId}</td>
                                        <td style="padding:10px;">${staff.username}</td>
                                        <td style="padding:10px;">${staff.fullName}</td>
                                        <td style="padding:10px;">
                                            <span style="padding:4px 8px; border-radius:4px; background:#e0e7ff; color:#3730a3;">
                                                ${staff.role}
                                            </span>
                                        </td>
                                        <td style="padding:10px;">${staff.phone}</td>
                                        <td style="padding:10px;">
                                            <c:if test="${not empty staff.address}">
                                                <%-- Sử dụng fn:split của JSTL để cắt chuỗi --%>
                                                <c:set var="parts" value="${fn:split(staff.address, '|')}" />

                                                <%-- Sử dụng fn:length để kiểm tra độ dài của mảng --%>
                                                <c:if test="${fn:length(parts) > 0}">
                                                    ${parts[0]}
                                                </c:if>
                                            </c:if>
                                        </td>
                                        <td style="padding:10px;">
                                            <a href="${pageContext.request.contextPath}/admin/staff/update?id=${staff.userId}" 
                                               class="btn btn-secondary" style="text-decoration:none; padding:5px 10px;">Edit</a>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/staff/delete" 
                                                  style="display:inline;" 
                                                  onsubmit="return confirm('Bạn có chắc muốn xóa tài khoản này?');">
                                                <input type="hidden" name="id" value="${staff.userId}">
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
                                    <a href="${pageContext.request.contextPath}/admin/staff/list?page=${currentPage - 1}" class="btn btn-secondary">Previous</a>
                                </c:if>
                                <span>Page ${currentPage} of ${totalPages}</span>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/admin/staff/list?page=${currentPage + 1}" class="btn btn-secondary">Next</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </body>
</html>
