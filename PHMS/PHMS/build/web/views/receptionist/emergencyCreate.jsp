<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo cuộc hẹn cấp cứu - Lễ tân</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
</head>
<body>
    <nav class="sidebar">
        <div class="brand">
            <i class="fa-solid fa-plus-square"></i> VetCare Pro
        </div>
        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/receptionist/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/receptionist/emergency/queue">Emergency Queue</a></li>
            <li><a href="${pageContext.request.contextPath}/receptionist/emergency/create" class="active">Create Emergency</a></li>
        </ul>
    </nav>

    <main class="main-content">
        <div class="top-bar">
            <div class="page-header">
                <h2>Tạo cuộc hẹn cấp cứu</h2>
                <p>Khi chủ thú cưng mang pet đến phòng khám trong tình trạng nguy kịch</p>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
        </div>

        <div class="card">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="background:#fee2e2; color:#991b1b; padding:12px; border-radius:8px; margin-bottom:20px;">
                    <i class="fa-solid fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/receptionist/emergency/create" id="emergencyForm">
                <div style="margin-bottom:15px;">
                    <label><b>Owner ID *</b></label>
                    <input type="number" name="ownerId" id="ownerId" value="${ownerId}" required min="1" 
                           style="width:100%; padding:8px;" placeholder="Nhập ID chủ thú cưng"
                           onchange="loadPets()">
                    <small style="color:#6b7280;">Nhập ID chủ thú cưng để tải danh sách thú cưng</small>
                </div>

                <div style="margin-bottom:15px;">
                    <label><b>Chọn thú cưng *</b></label>
                    <select name="petId" id="petId" required style="width:100%; padding:8px;">
                        <option value="">-- Chọn thú cưng --</option>
                        <c:forEach var="pet" items="${pets}">
                            <option value="${pet.id}">${pet.name} (${pet.species})</option>
                        </c:forEach>
                    </select>
                </div>

                <div style="margin-bottom:15px;">
                    <label><b>Chọn bác sĩ cấp cứu *</b></label>
                    <select name="vetId" required style="width:100%; padding:8px;">
                        <option value="">-- Chọn bác sĩ --</option>
                        <c:forEach var="vet" items="${veterinarians}">
                            <option value="${vet.userId}">${vet.fullName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div style="margin-bottom:15px;">
                    <label><b>Mức độ ưu tiên *</b></label>
                    <select name="conditionLevel" required style="width:100%; padding:8px;">
                        <option value="">-- Chọn mức độ --</option>
                        <option value="Critical" style="background:#fee2e2; color:#991b1b;">Critical - Nguy kịch (Cần xử lý ngay)</option>
                        <option value="High" style="background:#fed7aa; color:#9a3412;">High - Cao (Ưu tiên cao)</option>
                        <option value="Medium" style="background:#fef3c7; color:#92400e;">Medium - Trung bình</option>
                        <option value="Low" style="background:#d1fae5; color:#065f46;">Low - Thấp (Ổn định)</option>
                    </select>
                </div>

                <div style="margin-bottom:15px;">
                    <label><b>Triệu chứng ban đầu *</b></label>
                    <textarea name="initialSymptoms" required rows="4" maxlength="2000" 
                              style="width:100%; padding:8px;" 
                              placeholder="Ghi nhận ngắn gọn các triệu chứng của thú cưng (5-2000 ký tự)..."></textarea>
                </div>

                <div style="margin-bottom:15px;">
                    <label><b>Ghi chú (tùy chọn)</b></label>
                    <textarea name="notes" rows="3" maxlength="1000" 
                              style="width:100%; padding:8px;" 
                              placeholder="Thông tin bổ sung..."></textarea>
                </div>

                <div style="display:flex; gap:10px; margin-top:20px;">
                    <a href="${pageContext.request.contextPath}/receptionist/emergency/queue" 
                       class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;">Hủy</a>
                    <button type="submit" class="btn btn-approve" style="background:#dc2626;">
                        <i class="fa-solid fa-plus-circle"></i> Tạo cuộc hẹn cấp cứu ngay
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script>
        function loadPets() {
            const ownerId = document.getElementById('ownerId').value;
            if (ownerId && ownerId > 0) {
                window.location.href = '${pageContext.request.contextPath}/receptionist/emergency/create?ownerId=' + ownerId;
            }
        }
    </script>
</body>
</html>
