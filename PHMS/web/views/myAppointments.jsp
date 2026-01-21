<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lịch Hẹn Của Tôi - PHMS</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f5f5f5;
            }
            .container {
                background-color: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                max-width: 1200px;
                margin: 0 auto;
            }
            h1 {
                color: #6f42c1;
                margin-bottom: 20px;
            }
            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 15px;
                border: 1px solid #c3e6cb;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            th {
                background-color: #6f42c1;
                color: white;
            }
            tr:hover {
                background-color: #f5f5f5;
            }
            .status {
                padding: 5px 10px;
                border-radius: 4px;
                font-weight: bold;
                display: inline-block;
            }
            .status-pending {
                background-color: #ffc107;
                color: #000;
            }
            .status-confirmed {
                background-color: #28a745;
                color: white;
            }
            .status-completed {
                background-color: #6c757d;
                color: white;
            }
            .status-cancelled {
                background-color: #dc3545;
                color: white;
            }
            .status-pending-payment {
                background-color: #fd7e14;
                color: white;
            }
            .status-checked-in {
                background-color: #17a2b8;
                color: white;
            }
            .back-link {
                display: inline-block;
                margin-top: 20px;
                color: #007bff;
                text-decoration: none;
            }
            .back-link:hover {
                text-decoration: underline;
            }
            .action-link {
                color: #007bff;
                text-decoration: none;
                margin-right: 10px;
            }
            .action-link:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Lịch Hẹn Của Tôi</h1>
            
            <c:if test="${not empty success}">
                <div class="success-message">${success}</div>
            </c:if>
            
            <a href="${pageContext.request.contextPath}/booking" class="action-link">+ Đặt Lịch Mới</a>
            
            <c:choose>
                <c:when test="${not empty appointments}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Thú Cưng</th>
                                <th>Bác Sĩ</th>
                                <th>Thời Gian</th>
                                <th>Loại Khám</th>
                                <th>Trạng Thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appt" items="${appointments}">
                                <tr>
                                    <td>${appt.apptId}</td>
                                    <td>${appt.petName}</td>
                                    <td>${appt.vetName}</td>
                                    <td>
                                        <fmt:formatDate value="${appt.startTime}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>${appt.type}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${appt.status == 'Pending'}">
                                                <span class="status status-pending">Chờ Xác Nhận</span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Confirmed'}">
                                                <span class="status status-confirmed">Đã Xác Nhận</span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Completed'}">
                                                <span class="status status-completed">Hoàn Thành</span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Cancelled'}">
                                                <span class="status status-cancelled">Đã Hủy</span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Pending Payment'}">
                                                <span class="status status-pending-payment">Chờ Thanh Toán</span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Checked-in'}">
                                                <span class="status status-checked-in">Đã Check-in</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status">${appt.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p>Bạn chưa có lịch hẹn nào.</p>
                </c:otherwise>
            </c:choose>
            
            <a href="${pageContext.request.contextPath}/views/userHome.jsp" class="back-link">← Quay lại Trang Chủ</a>
        </div>
    </body>
</html>
