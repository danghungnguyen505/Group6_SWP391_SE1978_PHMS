<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Feedback Management</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <style>
            .rating-display {
                color: #fbbf24;
                font-size: 18px;
            }
        </style>
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/feedback/list" class="active">
                        <i class="fa-solid fa-comment"></i> Feedback</a></li>
            </ul>
            <div class="help-box">
                <div class="help-text">Need help?</div>
                <a href="#" class="btn-contact">Contact Support</a>
            </div>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Customer Feedback</h2>
                    <p>Total: ${totalFeedbacks} feedbacks</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <c:choose>
                    <c:when test="${empty feedbacks || feedbacks.size() == 0}">
                        <div style="text-align:center; padding:40px; color:#6b7280;">
                            <i class="fa-solid fa-comment" style="font-size:48px; margin-bottom:10px;"></i>
                            <p>No feedbacks found.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table style="width:100%; border-collapse:collapse;">
                            <thead>
                                <tr style="background:#f3f4f6;">
                                    <th style="padding:10px; text-align:left;">ID</th>
                                    <th style="padding:10px; text-align:left;">Customer</th>
                                    <th style="padding:10px; text-align:left;">Pet</th>
                                    <th style="padding:10px; text-align:left;">Appointment Date</th>
                                    <th style="padding:10px; text-align:left;">Rating</th>
                                    <th style="padding:10px; text-align:left;">Comment</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="fb" items="${feedbacks}">
                                    <tr>
                                        <td style="padding:10px;">#${fb.feedbackId}</td>
                                        <td style="padding:10px;">${fb.customerName}</td>
                                        <td style="padding:10px;">${fb.petName}</td>
                                        <td style="padding:10px;">${fb.apptDate}</td>
                                        <td style="padding:10px;">
                                            <span class="rating-display">
                                                <c:forEach begin="1" end="${fb.rating}">
                                                    <i class="fa-solid fa-star"></i>
                                                </c:forEach>
                                                <c:forEach begin="${fb.rating + 1}" end="5">
                                                    <i class="fa-regular fa-star"></i>
                                                </c:forEach>
                                            </span>
                                            (${fb.rating}/5)
                                        </td>
                                        <td style="padding:10px;">${fb.comment}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div style="display:flex; justify-content:center; align-items:center; gap:10px; margin-top:20px;">
                                <c:if test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/admin/feedback/list?page=${currentPage - 1}" 
                                       class="btn btn-secondary">Previous</a>
                                </c:if>
                                
                                <span>Page ${currentPage} of ${totalPages}</span>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/admin/feedback/list?page=${currentPage + 1}" 
                                       class="btn btn-secondary">Next</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </body>
</html>
