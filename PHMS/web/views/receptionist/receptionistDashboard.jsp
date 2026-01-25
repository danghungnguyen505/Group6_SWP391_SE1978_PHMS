<%-- 
    Document   : receptionistDashboard
    Created on : Jan 25, 2026, 1:25:46 AM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Receptionist Dashboard</title>
    </head>
    <body>
        <div class="content">
            <h3>Danh sách chờ duyệt (Pending Requests)</h3>
            <c:if test="${empty pendingList}">
                <p>Không có yêu cầu đặt lịch nào mới.</p>
            </c:if>
            <c:if test="${not empty pendingList}">
                <table border="1" class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Chủ nuôi</th>
                            <th>Thú cưng</th>
                            <th>Dịch vụ</th>
                            <th>Bác sĩ</th>
                            <th>Thời gian</th>
                            <th>Ghi chú</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${pendingList}" var="a">
                            <tr>
                                <td>${a.apptId}</td> <td>${a.ownerName}</td>
                                <td>${a.petName}</td>
                                <td>${a.type}</td>
                                <td>${a.vetName}</td>
                                <td>${a.startTime}</td>
                                <td>${a.notes}</td>
                                <td>
                                    <a href="appointment-action?id=${a.apptId}&status=Confirmed" class="btn btn-success btn-sm">Duyệt</a>
                                    <a href="appointment-action?id=${a.apptId}&status=Cancelled" class="btn btn-danger btn-sm">Hủy</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </body>
</html>
