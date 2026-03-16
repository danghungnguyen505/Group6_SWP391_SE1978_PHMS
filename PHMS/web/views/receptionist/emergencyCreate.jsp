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
                <!-- Email + Owner (keep others unchanged) -->
                <div style="display:flex; gap:12px; flex-wrap:wrap; margin-bottom:15px;">
                    <div style="flex:1; min-width:260px;">
                        <label><b>Email chủ pet *</b></label>
                        <input type="email" name="email" id="email" value="${email}" required
                               style="width:100%; padding:8px;" placeholder="Ví dụ: owner@gmail.com">
                        <small style="color:#6b7280;">Nhập email rồi bấm Tra cứu để tải chủ & thú cưng</small>
                    </div>
                    <div style="flex:1; min-width:260px;">
                        <label><b>Chủ pet *</b></label>
                        <input type="text" name="ownerFullName" id="ownerFullName"
                               value="${not empty owner ? owner.fullName : ''}"
                               ${not empty owner ? 'readonly' : ''} 
                               ${ownerNotFound == true ? 'required' : ''} 
                               maxlength="100"
                               style="width:100%; padding:8px;" placeholder="Tên chủ thú cưng">
                        <small style="color:#6b7280;">
                            <c:choose>
                                <c:when test="${not empty owner}">Đã tìm thấy tài khoản theo email.</c:when>
                                <c:otherwise>Chưa có tài khoản thì nhập tên để hệ thống tự tạo.</c:otherwise>
                            </c:choose>
                        </small>
                    </div>
                    <div style="display:flex; align-items:flex-end;">
                        <button type="button" class="btn btn-approve" style="height:38px;" onclick="lookupOwnerByEmail()">
                            <i class="fa-solid fa-magnifying-glass"></i> Tra cứu
                        </button>
                    </div>
                </div>

                <c:if test="${not empty owner}">
                    <div style="background:#f8fafc; padding:12px; border-radius:8px; margin-bottom:15px;">
                        <b>Chủ pet:</b> ${owner.fullName} &nbsp; | &nbsp; <b>Email:</b> ${owner.email}
                        <input type="hidden" name="ownerId" value="${owner.userId}">
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
                </c:if>

                <c:if test="${ownerNotFound == true}">
                    <div style="background:#fff7ed; border:1px solid #fed7aa; padding:12px; border-radius:8px; margin-bottom:15px; color:#9a3412;">
                        <i class="fa-solid fa-circle-info"></i>
                        Chưa có tài khoản với email này. Vui lòng nhập nhanh thông tin để hệ thống tự tạo tài khoản.
                    </div>

                    <div style="margin-bottom:15px;">
                        <label><b>Tên chủ thú cưng *</b></label>
                        <input type="text" name="ownerFullName" maxlength="100" required
                               style="width:100%; padding:8px;" placeholder="Nhập họ tên chủ thú cưng">
                    </div>

                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px; margin-bottom:15px;">
                        <div>
                            <label><b>Tên thú cưng *</b></label>
                            <input type="text" name="petNameNew" maxlength="50" required
                                   style="width:100%; padding:8px;" placeholder="Ví dụ: Miu, Lucky...">
                        </div>
                        <div>
                            <label><b>Species *</b></label>
                            <input type="text" name="speciesNew" maxlength="50" required
                                   style="width:100%; padding:8px;" placeholder="Ví dụ: Chó, Mèo">
                        </div>
                    </div>

                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px; margin-bottom:15px;">
                        <div>
                            <label><b>Breed *</b></label>
                            <input type="text" name="breedNew" maxlength="100" required
                                   style="width:100%; padding:8px;" placeholder="Ví dụ: Poodle, Golden...">
                        </div>
                        <div>
                            <label><b>Giới tính *</b></label>
                            <select name="genderNew" required style="width:100%; padding:8px;">
                                <option value="">-- Chọn --</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                    </div>

                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px; margin-bottom:15px;">
                        <div>
                            <label><b>Ngày sinh *</b></label>
                            <input type="date" name="birthDateNew" required style="width:100%; padding:8px;">
                        </div>
                        <div>
                            <label><b>Cân nặng (kg) *</b></label>
                            <input type="number" name="weightNew" step="0.1" min="0.1" required
                                   style="width:100%; padding:8px;" placeholder="Ví dụ: 3.5">
                        </div>
                    </div>

                    <div style="margin-bottom:15px;">
                        <label><b>Bệnh sử (tùy chọn)</b></label>
                        <textarea name="historyNew" rows="3" maxlength="2000"
                                  style="width:100%; padding:8px;" placeholder="Tiền sử bệnh, dị ứng..."></textarea>
                    </div>
                </c:if>

                <div style="margin-bottom:15px;">
                    <label><b>Chọn bác sĩ cấp cứu *</b></label>
                    <select name="vetId" required style="width:100%; padding:8px;">
                        <option value="">-- Chọn bác sĩ --</option>
                        <c:forEach var="vet" items="${veterinarians}">
                            <option value="${vet.userId}">
                                ${vet.fullName}
                                - ${vetStatusMap[vet.userId]}
                                <c:if test="${not empty vetShiftMap[vet.userId]}"> (${vetShiftMap[vet.userId]})</c:if>
                            </option>
                        </c:forEach>
                    </select>
                    <div style="margin-top:8px; color:#6b7280; font-size:12px;">
                        Ưu tiên hiển thị: <b>Trống trong ca</b> → <b>Bận trong ca</b> → <b>Ngoài ca</b>.
                    </div>
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
        function lookupOwnerByEmail() {
            const email = (document.getElementById('email')?.value || '').trim();
            if (!email) return;
            window.location.href = '${pageContext.request.contextPath}/receptionist/emergency/create?email=' + encodeURIComponent(email);
        }
    </script>
</body>
</html>
