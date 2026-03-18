<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>

<!DOCTYPE html>

<html lang="vi">
    <head>
        <meta charset="UTF-8">

        <title>
            ${L == 'en' ? 'Create Emergency' : 'Tạo cấp cứu'} - Lễ tân
        </title>

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">

        <style>

            .form-grid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:16px;
                margin-bottom:16px;
            }

            .form-group{
                display:flex;
                flex-direction:column;
                gap:6px;
            }

            .form-group label{
                font-weight:600;
                font-size:14px;
            }

            .form-group input,
            .form-group select,
            .form-group textarea{

                padding:10px;
                border:1px solid #d1d5db;
                border-radius:6px;
                font-size:14px;

            }

            .form-group small{
                font-size:12px;
                color:#6b7280;
            }

            .btn{
                padding:10px 16px;
                border-radius:6px;
                border:none;
                cursor:pointer;
                font-weight:600;
            }

            .btn-search{
                background:#2563eb;
                color:white;
            }

            .btn-create{
                background:#dc2626;
                color:white;
            }

            .btn-cancel{
                background:#e5e7eb;
                color:#111827;
                text-decoration:none;
            }

            .form-actions{
                display:flex;
                gap:12px;
                margin-top:20px;
            }

            .owner-info{
                background:#f8fafc;
                padding:12px;
                border-radius:8px;
                margin-bottom:16px;
            }

            .warning-box{
                background:#fff7ed;
                border:1px solid #fed7aa;
                padding:12px;
                border-radius:8px;
                color:#9a3412;
                margin-bottom:16px;
            }

            .alert-danger{
                background:#fee2e2;
                color:#991b1b;
                padding:12px;
                border-radius:8px;
                margin-bottom:16px;
            }

        </style>

    </head>

    <body>

        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>

            <ul class="menu">
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
                        <i class="fa-solid fa-table-columns"></i> ${L == 'en' ? 'Dashboard' : 'Bảng điều khiển'}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/emergency/queue" class="active text-danger">
                        <i class="fa-solid fa-truck-medical"></i> ${L == 'en' ? 'Emergency Triage' : 'Cấp cứu'}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/appointment">
                        <i class="fa-regular fa-calendar-check"></i> ${L == 'en' ? 'Appointments' : 'Cuộc hẹn'}
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/receptionist/invoice/create">
                        <i class="fa-regular fa-credit-card"></i> ${L == 'en' ? 'Billing' : 'Thanh toán'}
                    </a>
                </li>
            </ul>

            <!-- Language Switcher -->
            <div style="padding: 12px; margin-top: auto;">
                <div style="display:flex; background:#f1f5f9; border-radius:8px; padding:3px; gap:2px;">
                    <a href="${pageContext.request.contextPath}/language?lang=vi"
                       style="padding:5px 10px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; flex:1; text-align:center;
                       ${L == 'vi' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">VI</a>
                    <a href="${pageContext.request.contextPath}/language?lang=en"
                       style="padding:5px 10px; border-radius:6px; font-size:11px; font-weight:700; text-decoration:none; flex:1; text-align:center;
                       ${L == 'en' ? 'background:#10b981; color:#fff;' : 'color:#64748b;'}">EN</a>
                </div>
            </div>

            <div class="help-box">
                <div class="help-text">${L == 'en' ? 'Need help?' : 'Cần hỗ trợ?'}</div>
                <a href="#" class="btn-contact">${L == 'en' ? 'Contact Support' : 'Liên hệ hỗ trợ'}</a>
            </div>
        </nav>

        <main class="main-content">

            <div class="top-bar">

                <div class="page-header">

                    <h2>Tạo cuộc hẹn cấp cứu</h2>

                    <p>
                        Khi chủ thú cưng mang pet đến phòng khám trong tình trạng nguy kịch
                    </p>

                </div>

                <a href="${pageContext.request.contextPath}/logout"
                   class="btn-signout">
                    Sign Out </a>

            </div>

            <div class="card">

                <c:if test="${not empty error}">

                    <div class="alert-danger">
                        <i class="fa-solid fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <form method="post"
                      action="${pageContext.request.contextPath}/receptionist/emergency/create">

                    <!-- EMAIL + OWNER -->

                    <div class="form-grid">

                        <div class="form-group">

                            <label>Email chủ pet *</label>

                            <div style="display:flex;gap:8px;">

                                <input type="email"
                                       name="email"
                                       id="email"
                                       value="${email}"
                                       required
                                       placeholder="owner@gmail.com"
                                       style="flex:1;">

                                <button type="button"
                                        class="btn btn-search"
                                        onclick="lookupOwnerByEmail()">

                                    <i class="fa-solid fa-magnifying-glass"></i>
                                    Tra cứu

                                </button>

                            </div>

                            <small>Nhập email rồi bấm Tra cứu để tải chủ & thú cưng</small>

                        </div>

                        <div class="form-group">

                            <label>Chủ pet *</label>

                            <input type="text"
                                   name="ownerFullName"
                                   id="ownerFullName"
                                   value="${not empty owner ? owner.fullName : ''}"
                                   ${not empty owner ? 'readonly' : ''}
                                   ${ownerNotFound == true ? 'required' : ''}
                                   maxlength="100"
                                   placeholder="Tên chủ thú cưng">

                            <small>

                                <c:choose>

                                    <c:when test="${not empty owner}">
                                        Đã tìm thấy tài khoản theo email
                                    </c:when>

                                    <c:otherwise>
                                        Chưa có tài khoản thì nhập tên
                                    </c:otherwise>

                                </c:choose>

                            </small>

                        </div>

                    </div>

                    <!-- OWNER INFO -->

                    <c:if test="${not empty owner}">

                        <div class="owner-info">

                            <b>Chủ pet:</b> ${owner.fullName}
                            | <b>Email:</b> ${owner.email}

                            <input type="hidden"
                                   name="ownerId"
                                   value="${owner.userId}">

                        </div>

                        <div class="form-group">

                            <label>Chọn thú cưng *</label>

                            <select name="petId" required>

                                <option value="">-- Chọn thú cưng --</option>

                                <c:forEach var="pet" items="${pets}">

                                    <option value="${pet.id}">
                                        ${pet.name} (${pet.species})
                                    </option>
                                </c:forEach>

                            </select>

                        </div>

                    </c:if>

                    <!-- OWNER NOT FOUND -->

                    <c:if test="${ownerNotFound == true}">

                        <div class="warning-box">

                            <i class="fa-solid fa-circle-info"></i>

                            Chưa có tài khoản với email này.
                            Vui lòng nhập thông tin để hệ thống tự tạo.

                        </div>

                        <div class="form-grid">

                            <div class="form-group">
                                <label>Tên thú cưng *</label>
                                <input type="text" name="petNameNew" required>
                            </div>

                            <div class="form-group">
                                <label>Species *</label>
                                <input type="text" name="speciesNew" required>
                            </div>

                            <div class="form-group">
                                <label>Breed *</label>
                                <input type="text" name="breedNew" required>
                            </div>

                            <div class="form-group">
                                <label>Giới tính *</label>
                                <select name="genderNew" required>
                                    <option value="">-- Chọn --</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Ngày sinh *</label>
                                <input type="date" name="birthDateNew" required>
                            </div>

                            <div class="form-group">
                                <label>Cân nặng (kg) *</label>
                                <input type="number" name="weightNew" step="0.1" min="0.1" required>
                            </div>

                        </div>

                    </c:if>

                    <!-- VET -->

                    <div class="form-group">

                        <label>Chọn bác sĩ cấp cứu *</label>

                        <select name="vetId" required>

                            <option value="">-- Chọn bác sĩ --</option>

                            <c:forEach var="vet" items="${veterinarians}">

                                <option value="${vet.userId}">
                                    ${vet.fullName}
                                    - ${vetStatusMap[vet.userId]}

                                    <c:if test="${not empty vetShiftMap[vet.userId]}">
                                        (${vetShiftMap[vet.userId]})
                                    </c:if>

                                </option>

                            </c:forEach>

                        </select>

                    </div>

                    <!-- PRIORITY -->

                    <div class="form-group">

                        <label>Mức độ ưu tiên *</label>

                        <select name="conditionLevel"
                                id="conditionLevel"
                                required>

                            <option value="">-- Chọn mức độ --</option>

                            <option value="Critical"
                                    style="background:#fee2e2;color:#991b1b;">
                                Critical - Nguy kịch
                            </option>

                            <option value="High"
                                    style="background:#fed7aa;color:#9a3412;">
                                High - Cao
                            </option>

                            <option value="Medium"
                                    style="background:#fef3c7;color:#92400e;">
                                Medium - Trung bình
                            </option>

                            <option value="Low"
                                    style="background:#d1fae5;color:#065f46;">
                                Low - Thấp
                            </option>

                        </select>

                    </div>

                    <!-- SYMPTOMS -->

                    <div class="form-group">

                        <label>Triệu chứng ban đầu *</label>

                        <textarea name="initialSymptoms"
                                  rows="4"
                                  maxlength="2000"
                                  required></textarea>

                    </div>

                    <div class="form-group">

                        <label>Ghi chú</label>

                        <textarea name="notes"
                                  rows="3"
                                  maxlength="1000"></textarea>

                    </div>

                    <!-- ACTION -->

                    <div class="form-actions">

                        <a class="btn btn-cancel"
                           href="${pageContext.request.contextPath}/receptionist/emergency/queue">
                            Hủy </a>

                        <button type="submit"
                                class="btn btn-create">

                            <i class="fa-solid fa-plus-circle"></i>
                            Tạo cuộc hẹn cấp cứu

                        </button>

                    </div>

                </form>

            </div>

        </main>

        <script>

            function lookupOwnerByEmail() {

                const email = document.getElementById("email").value.trim();

                if (!email)
                    return;

                window.location.href =
                        "${pageContext.request.contextPath}/receptionist/emergency/create?email="
                        + encodeURIComponent(email);

            }

            const levelSelect = document.getElementById("conditionLevel");

            levelSelect?.addEventListener("change", function () {

                const colors = {
                    Critical: "#fee2e2",
                    High: "#fed7aa",
                    Medium: "#fef3c7",
                    Low: "#d1fae5"
                };

                this.style.background = colors[this.value] || "white";

            });

        </script>

    </body>
</html>
