<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thú Cưng Của Tôi - PHMS</title>
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
            h2 {
                color: #333;
                margin-top: 30px;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 2px solid #6f42c1;
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
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #333;
            }
            input[type="text"], textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
                font-size: 14px;
            }
            textarea {
                resize: vertical;
                min-height: 80px;
            }
            button {
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                margin-right: 10px;
            }
            button:hover {
                background-color: #0056b3;
            }
            .btn-success {
                background-color: #28a745;
            }
            .btn-success:hover {
                background-color: #218838;
            }
            .btn-danger {
                background-color: #dc3545;
            }
            .btn-danger:hover {
                background-color: #c82333;
            }
            .btn-secondary {
                background-color: #6c757d;
            }
            .btn-secondary:hover {
                background-color: #5a6268;
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
            .back-link {
                display: inline-block;
                margin-top: 20px;
                color: #007bff;
                text-decoration: none;
            }
            .back-link:hover {
                text-decoration: underline;
            }
            .add-pet-form {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 4px;
                margin-bottom: 30px;
            }
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0,0,0,0.4);
            }
            .modal-content {
                background-color: #fefefe;
                margin: 15% auto;
                padding: 20px;
                border: 1px solid #888;
                width: 80%;
                max-width: 500px;
                border-radius: 8px;
            }
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
            }
            .close:hover {
                color: #000;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Thú Cưng Của Tôi</h1>
            
            <c:if test="${not empty success}">
                <div class="success-message">${success}</div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <h2>Thêm Thú Cưng Mới</h2>
            <div class="add-pet-form">
                <form action="${pageContext.request.contextPath}/my-pets" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label for="name">Tên Thú Cưng:</label>
                        <input type="text" name="name" id="name" required placeholder="Nhập tên thú cưng">
                    </div>
                    <div class="form-group">
                        <label for="species">Loài:</label>
                        <input type="text" name="species" id="species" required placeholder="Ví dụ: Chó Poodle, Mèo Anh Lông Ngắn">
                    </div>
                    <div class="form-group">
                        <label for="historySummary">Lịch Sử Bệnh Án (Tùy chọn):</label>
                        <textarea name="historySummary" id="historySummary" placeholder="Nhập thông tin về lịch sử bệnh án, tiêm chủng, dị ứng..."></textarea>
                    </div>
                    <button type="submit" class="btn-success">Thêm Thú Cưng</button>
                </form>
            </div>
            
            <h2>Danh Sách Thú Cưng</h2>
            <c:choose>
                <c:when test="${not empty pets}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên</th>
                                <th>Loài</th>
                                <th>Lịch Sử Bệnh Án</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pet" items="${pets}">
                                <tr>
                                    <td>${pet.petId}</td>
                                    <td>${pet.name}</td>
                                    <td>${pet.species}</td>
                                    <td>${pet.historySummary != null ? pet.historySummary : 'Chưa có'}</td>
                                    <td>
                                        <button type="button" class="btn-secondary" 
                                                data-pet-id="${pet.petId}"
                                                data-pet-name="${pet.name}"
                                                data-pet-species="${pet.species}"
                                                data-pet-history="<c:out value="${pet.historySummary != null ? pet.historySummary : ''}" />"
                                                onclick="openEditModal(this)">Sửa</button>
                                        <form action="${pageContext.request.contextPath}/my-pets" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="petId" value="${pet.petId}">
                                            <button type="submit" class="btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa thú cưng này?')">Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p>Bạn chưa có thú cưng nào. Hãy thêm thú cưng đầu tiên của bạn!</p>
                </c:otherwise>
            </c:choose>
            
            <a href="${pageContext.request.contextPath}/views/userHome.jsp" class="back-link">← Quay lại Trang Chủ</a>
        </div>
        
        <!-- Edit Modal -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeEditModal()">&times;</span>
                <h2>Sửa Thông Tin Thú Cưng</h2>
                <form action="${pageContext.request.contextPath}/my-pets" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="petId" id="editPetId">
                    <div class="form-group">
                        <label for="editName">Tên Thú Cưng:</label>
                        <input type="text" name="name" id="editName" required>
                    </div>
                    <div class="form-group">
                        <label for="editSpecies">Loài:</label>
                        <input type="text" name="species" id="editSpecies" required>
                    </div>
                    <div class="form-group">
                        <label for="editHistorySummary">Lịch Sử Bệnh Án:</label>
                        <textarea name="historySummary" id="editHistorySummary"></textarea>
                    </div>
                    <button type="submit" class="btn-success">Cập Nhật</button>
                    <button type="button" class="btn-secondary" onclick="closeEditModal()">Hủy</button>
                </form>
            </div>
        </div>
        
        <script>
            function openEditModal(button) {
                var petId = button.getAttribute('data-pet-id');
                var name = button.getAttribute('data-pet-name');
                var species = button.getAttribute('data-pet-species');
                var historySummary = button.getAttribute('data-pet-history') || '';
                
                document.getElementById('editPetId').value = petId;
                document.getElementById('editName').value = name;
                document.getElementById('editSpecies').value = species;
                document.getElementById('editHistorySummary').value = historySummary;
                document.getElementById('editModal').style.display = 'block';
            }
            
            function closeEditModal() {
                document.getElementById('editModal').style.display = 'none';
            }
            
            // Close modal when clicking outside
            window.onclick = function(event) {
                var modal = document.getElementById('editModal');
                if (event.target == modal) {
                    modal.style.display = 'none';
                }
            }
        </script>
    </body>
</html>
