<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page - PHMS</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
                background-color: #f5f5f5;
            }
            .login-container {
                background-color: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                width: 350px;
            }
            h2 {
                text-align: center;
                color: #333;
                margin-bottom: 25px;
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
            }
            td {
                padding: 10px 0;
            }
            input[type="text"], input[type="password"] {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }
            button {
                width: 100%;
                padding: 10px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                margin-top: 10px;
            }
            button:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <h2>Đăng Nhập Hệ Thống PHMS</h2>
            
            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 15px; border: 1px solid #c3e6cb;">
                    ${message}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/login" method="post">
                <table>
                    <tr>
                        <td>Tài Khoản</td>
                    </tr>
                    <tr>
                        <td><input type="text" name="user" required placeholder="Nhập tên đăng nhập"></td>
                    </tr>
                    <tr>
                        <td>Mật Khẩu</td>
                    </tr>
                    <tr>
                        <td><input type="password" name="pass" required placeholder="Nhập mật khẩu"></td>
                    </tr>
                </table>
                <button type="submit">Đăng nhập</button>
            </form>
        </div>
    </body>
</html>
