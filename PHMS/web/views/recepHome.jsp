<%-- 
    Document   : recepHome
    Created on : Jan 22, 2026, 3:03:42 AM
    Author     : zoxy4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Receptionist Dashboard - PHMS</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f5f5f5;
            }
            .container {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h1 {
                color: #17a2b8;
            }
            .user-info {
                background-color: #e7f3ff;
                padding: 15px;
                border-radius: 4px;
                margin: 20px 0;
            }
            a {
                color: #007bff;
                text-decoration: none;
                padding: 8px 15px;
                background-color: #f0f0f0;
                border-radius: 4px;
                display: inline-block;
                margin-top: 10px;
            }
            a:hover {
                background-color: #e0e0e0;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Chào mừng Receptionist!</h1>
            <p>Đăng nhập thành công.</p>
            
            <c:if test="${not empty sessionScope.account}">
                <div class="user-info">
                    <p><strong>Tên đăng nhập:</strong> ${sessionScope.account.username}</p>
                    <p><strong>Họ tên:</strong> ${sessionScope.account.fullName}</p>
                    <p><strong>Vai trò:</strong> ${sessionScope.account.role}</p>
                    <p><strong>ID:</strong> ${sessionScope.account.id}</p>
                </div>
            </c:if>
            
            <div style="margin-top: 30px;">
                <h2>Chức Năng</h2>
                <ul style="list-style: none; padding: 0;">
                    <li style="margin: 10px 0;">
                        <a href="${pageContext.request.contextPath}/checkin" style="display: inline-block; padding: 10px 20px; background-color: #17a2b8; color: white; text-decoration: none; border-radius: 4px;">
                            Check-in & Queue
                        </a>
                    </li>
                </ul>
            </div>
            
            <a href="${pageContext.request.contextPath}/login?action=logout" style="display: inline-block; margin-top: 20px; color: #dc3545; text-decoration: none;">Đăng xuất</a>
        </div>
    </body>
</html>
