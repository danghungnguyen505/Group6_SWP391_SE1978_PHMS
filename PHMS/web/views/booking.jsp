<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt Lịch Hẹn - PHMS</title>
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
                max-width: 800px;
                margin: 0 auto;
            }
            h1 {
                color: #6f42c1;
                margin-bottom: 20px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #333;
            }
            select, input[type="datetime-local"], input[type="text"] {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 14px;
            }
            button {
                background-color: #007bff;
                color: white;
                padding: 12px 30px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
            }
            button:hover {
                background-color: #0056b3;
            }
            .error-message {
                background-color: #fee;
                color: #c33;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 15px;
                border: 1px solid #fcc;
            }
            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 15px;
                border: 1px solid #c3e6cb;
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
            <h1>Đặt Lịch Hẹn</h1>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="success-message">${success}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/booking" method="post">
                <div class="form-group">
                    <label for="petId">Chọn Thú Cưng:</label>
                    <select name="petId" id="petId" required>
                        <option value="">-- Chọn thú cưng --</option>
                        <c:forEach var="pet" items="${pets}">
                            <option value="${pet.petId}">${pet.name} - ${pet.species}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="serviceId">Chọn Dịch Vụ:</label>
                    <select name="serviceId" id="serviceId" required>
                        <option value="">-- Chọn dịch vụ --</option>
                        <c:forEach var="service" items="${services}">
                            <option value="${service.serviceId}">${service.name} - ${service.basePrice} VNĐ</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="vetId">Chọn Bác Sĩ:</label>
                    <select name="vetId" id="vetId" required>
                        <option value="">-- Chọn bác sĩ --</option>
                        <c:forEach var="vet" items="${veterinarians}">
                            <option value="${vet.empId}">${vet.fullName} - ${vet.specialization}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="dateTime">Thời Gian Hẹn:</label>
                    <input type="datetime-local" name="dateTime" id="dateTime" required>
                </div>
                
                <div class="form-group">
                    <label for="type">Loại Khám:</label>
                    <select name="type" id="type" required>
                        <option value="Checkup">Khám Thường</option>
                        <option value="Surgery">Phẫu Thuật</option>
                        <option value="Urgent">Khẩn Cấp</option>
                    </select>
                </div>
                
                <button type="submit">Đặt Lịch</button>
            </form>
            
            <a href="${pageContext.request.contextPath}/views/userHome.jsp" class="back-link">← Quay lại Trang Chủ</a>
        </div>
        
        <script>
            // Set minimum date to today
            var today = new Date().toISOString().slice(0, 16);
            document.getElementById("dateTime").setAttribute("min", today);
        </script>
    </body>
</html>
