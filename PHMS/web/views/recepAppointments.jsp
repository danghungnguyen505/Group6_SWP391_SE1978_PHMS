<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản Lý Lịch Hẹn - Receptionist</title>
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
                max-width: 1400px;
                margin: 0 auto;
            }
            h1 {
                color: #17a2b8;
                margin-bottom: 20px;
            }
            h2 {
                color: #333;
                margin-top: 30px;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 2px solid #17a2b8;
            }
            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 15px;
                border: 1px solid #c3e6cb;
            }
            .error-message {
                background-color: #fee;
                color: #c33;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 15px;
                border: 1px solid #fcc;
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
                background-color: #17a2b8;
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
            .btn {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
                margin-right: 5px;
            }
            .btn-approve {
                background-color: #28a745;
                color: white;
            }
            .btn-approve:hover {
                background-color: #218838;
            }
            .btn-reject {
                background-color: #dc3545;
                color: white;
            }
            .btn-reject:hover {
                background-color: #c82333;
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
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Quản Lý Lịch Hẹn - Receptionist</h1>
            
            <c:if test="${not empty success}">
                <div class="success-message">${success}</div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <h2>Danh Sách Cuộc Hẹn Chờ Phê Duyệt</h2>
            <c:choose>
                <c:when test="${not empty pendingAppointments}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Thú Cưng</th>
                                <th>Bác Sĩ</th>
                                <th>Thời Gian</th>
                                <th>Loại Khám</th>
                                <th>Trạng Thái</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appt" items="${pendingAppointments}">
                                <tr>
                                    <td>${appt.apptId}</td>
                                    <td>${appt.petName}</td>
                                    <td>${appt.vetName}</td>
                                    <td>
                                        <fmt:formatDate value="${appt.startTime}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>${appt.type}</td>
                                    <td>
                                        <span class="status status-pending">Chờ Xác Nhận</span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/recep-appointments" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="apptId" value="${appt.apptId}">
                                            <button type="submit" class="btn btn-approve">Phê Duyệt</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/recep-appointments" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="apptId" value="${appt.apptId}">
                                            <button type="submit" class="btn btn-reject">Từ Chối</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/recep-appointments" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="apptId" value="${appt.apptId}">
                                            <button type="submit" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa cuộc hẹn này?')">Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p>Không có cuộc hẹn nào chờ phê duyệt.</p>
                </c:otherwise>
            </c:choose>
            
            <h2>Danh Sách Cuộc Hẹn Đã Thực Hiện</h2>
            <c:choose>
                <c:when test="${not empty completedAppointments}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Thú Cưng</th>
                                <th>Bác Sĩ</th>
                                <th>Thời Gian</th>
                                <th>Loại Khám</th>
                                <th>Trạng Thái</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appt" items="${completedAppointments}">
                                <tr>
                                    <td>${appt.apptId}</td>
                                    <td>${appt.petName}</td>
                                    <td>${appt.vetName}</td>
                                    <td>
                                        <fmt:formatDate value="${appt.startTime}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>${appt.type}</td>
                                    <td>
                                        <span class="status status-completed">Đã Hoàn Thành</span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/recep-appointments" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="apptId" value="${appt.apptId}">
                                            <button type="submit" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa cuộc hẹn này?')">Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p>Chưa có cuộc hẹn nào đã hoàn thành.</p>
                </c:otherwise>
            </c:choose>
            
            <a href="${pageContext.request.contextPath}/views/recepHome.jsp" class="back-link">← Quay lại Trang Chủ</a>
        </div>
    </body>
</html>
