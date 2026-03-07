<%-- 
    Document   : doctorScheduleAdd
    Created on : Jan 22, 2026
    Author     : Auto
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - THÊM LỊCH LÀM VIỆC BÁC SĨ</title>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        :root {
            --sidebar-width: 280px;
            --primary-green: #50b498;
            --bg-body: #f8fafc;
            --text-main: #0f172a;
            --text-muted: #718096;
            --input-bg: #f8fafc;
            --card-shadow: 0 4px 25px -5px rgba(0, 0, 0, 0.05);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; -webkit-font-smoothing: antialiased; }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-body);
            color: var(--text-main);
            display: flex;
            min-height: 100vh;
        }

        /* --- SIDEBAR --- */
        .sidebar {
            width: var(--sidebar-width);
            background: #ffffff;
            height: 100vh;
            position: fixed;
            left: 0; top: 0;
            padding: 35px 25px;
            display: flex;
            flex-direction: column;
            border-right: 1px solid #edf2f7;
            z-index: 1000;
        }
        .logo { display: flex; align-items: center; gap: 12px; color: var(--primary-green); font-weight: 800; font-size: 22px; margin-bottom: 50px; padding-left: 10px; }
        .menu-label { color: #a0aec0; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 20px; padding-left: 10px; }
        .nav-menu { list-style: none; }
        .nav-item { margin-bottom: 6px; }
        .nav-link { display: flex; align-items: center; gap: 15px; padding: 12px 18px; text-decoration: none; color: var(--text-muted); font-weight: 500; font-size: 15px; border-radius: 12px; transition: 0.2s; }
        .nav-link:hover { background: #f7fafc; color: var(--text-main); }
        .nav-link.active { background: #f0fff4; color: var(--primary-green); font-weight: 600; }
        .nav-link i { width: 22px; font-size: 18px; text-align: center; }

        /* --- MAIN CONTENT --- */
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 40px 60px;
        }

        .page-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 40px;
        }

        .btn-back {
            width: 45px;
            height: 45px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            color: #a0aec0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
            border: 1px solid #edf2f7;
            transition: 0.2s;
        }
        .btn-back:hover { transform: translateX(-3px); color: var(--text-main); }

        .title-area h1 { font-size: 26px; font-weight: 900; text-transform: uppercase; letter-spacing: -0.5px; }
        .title-area p { color: var(--text-muted); margin-top: 4px; font-size: 15px; }

        /* --- FORM CARD --- */
        .form-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 32px;
            padding: 50px 60px;
            box-shadow: var(--card-shadow);
        }

        .form-group {
            margin-bottom: 30px;
        }

        .form-label {
            display: block;
            font-size: 11px;
            font-weight: 800;
            color: #a0aec0;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 12px;
        }

        .form-input {
            width: 100%;
            padding: 18px 25px;
            background-color: var(--input-bg);
            border: 1px solid #f1f5f9;
            border-radius: 16px;
            font-family: 'Inter', sans-serif;
            font-size: 15px;
            color: var(--text-main);
            transition: 0.2s;
        }

        .form-input:focus {
            outline: none;
            background-color: white;
            border-color: var(--primary-green);
            box-shadow: 0 0 0 4px rgba(80, 180, 152, 0.1);
        }

        .form-input::placeholder {
            color: #cbd5e0;
        }

        select.form-input {
            appearance: none;
            cursor: pointer;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23718096' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 20px center;
            padding-right: 50px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
        }

        .repeat-options {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .repeat-option {
            flex: 1;
            min-width: 120px;
        }

        .repeat-option input[type="radio"] {
            display: none;
        }

        .repeat-option label {
            display: block;
            padding: 15px 20px;
            background: var(--input-bg);
            border: 2px solid #f1f5f9;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: 0.2s;
            font-weight: 600;
            font-size: 14px;
            color: var(--text-muted);
        }

        .repeat-option input[type="radio"]:checked + label {
            background: #f0fff4;
            border-color: var(--primary-green);
            color: var(--primary-green);
        }

        .repeat-option label:hover {
            border-color: var(--primary-green);
        }

        .repeat-end-date-group {
            display: none;
            margin-top: 20px;
            padding: 20px;
            background: #f8fafc;
            border-radius: 12px;
            border: 1px solid #edf2f7;
        }

        .repeat-end-date-group.show {
            display: block;
        }

        .info-text {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 8px;
            font-style: italic;
        }

        /* --- SLOT PICKER --- */
        .slot-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 10px;
        }
        .slot-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .btn-mini {
            padding: 8px 12px;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
            background: white;
            color: var(--text-muted);
            font-weight: 800;
            font-size: 11px;
            text-transform: uppercase;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-mini:hover {
            border-color: var(--primary-green);
            color: var(--text-main);
        }
        .slot-grid {
            margin-top: 12px;
            padding: 15px;
            border-radius: 16px;
            border: 1px solid #edf2f7;
            background: #f8fafc;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 10px;
            max-height: 320px;
            overflow: auto;
        }
        .slot-item input[type="checkbox"] {
            display: none;
        }
        .slot-item label {
            display: block;
            padding: 10px 12px;
            border-radius: 12px;
            background: white;
            border: 2px solid #f1f5f9;
            text-align: center;
            font-weight: 800;
            font-size: 12px;
            color: #64748b;
            cursor: pointer;
            transition: 0.2s;
            user-select: none;
        }
        .slot-item label:hover {
            border-color: var(--primary-green);
            transform: translateY(-1px);
        }
        .slot-item input[type="checkbox"]:checked + label {
            background: #f0fff4;
            border-color: var(--primary-green);
            color: var(--primary-green);
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 40px;
        }

        .btn-submit {
            flex: 1;
            background: var(--primary-green);
            color: white;
            padding: 18px;
            border: none;
            border-radius: 16px;
            font-weight: 800;
            font-size: 14px;
            text-transform: uppercase;
            cursor: pointer;
            box-shadow: 0 10px 20px -5px rgba(80, 180, 152, 0.4);
            transition: 0.2s;
        }
        .btn-submit:hover { opacity: 0.9; transform: translateY(-1px); }

        .btn-cancel {
            padding: 18px 35px;
            background: #f1f5f9;
            color: var(--text-muted);
            border-radius: 16px;
            text-decoration: none;
            font-weight: 800;
            font-size: 12px;
            text-transform: uppercase;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.2s;
        }
        .btn-cancel:hover { background: #e2e8f0; color: var(--text-main); }

        .alert-danger {
            background: #fee2e2;
            color: #dc2626;
            padding: 15px;
            border-radius: 12px;
            border: 1px solid #fecaca;
            margin-bottom: 25px;
            font-size: 14px;
            line-height: 1.5;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            padding: 15px;
            border-radius: 12px;
            border: 1px solid #a7f3d0;
            margin-bottom: 25px;
            font-size: 14px;
            line-height: 1.5;
        }

        .help-box { margin-top: auto; background: #f8fafc; padding: 20px; border-radius: 16px; border: 1px solid #edf2f7; }
        .help-box p { font-size: 13px; font-weight: 600; margin-bottom: 12px; }
        .btn-support { display: block; background: #0f172a; color: white; text-align: center; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 12px; }
    </style>
</head>
<body>

    <jsp:include page="common/navbar.jsp">
        <jsp:param name="activePage" value="scheduling" />
    </jsp:include>

    <!-- Main Content -->
    <main class="main-content">
        <header class="page-header">
            <a href="${pageContext.request.contextPath}/admin/doctor/schedule/list" class="btn-back">
                <i class="fa-solid fa-chevron-left"></i>
            </a>
            <div class="title-area">
                <h1>Thêm Lịch Làm Việc</h1>
                <p>Thêm lịch làm việc cho bác sĩ với tùy chọn lặp lại</p>
            </div>
        </header>

        <c:if test="${not empty error}">
            <div class="alert-danger">
                <i class="fa-solid fa-triangle-exclamation" style="margin-right: 8px;"></i>
                <strong>Lỗi:</strong> ${error}
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.toastMessage}">
            <c:set var="toast" value="${sessionScope.toastMessage}" />
            <c:choose>
                <c:when test="${fn:startsWith(toast, 'success|')}">
                    <div class="alert-success">
                        <i class="fa-solid fa-check-circle" style="margin-right: 8px;"></i>
                        ${fn:substringAfter(toast, 'success|')}
                    </div>
                </c:when>
            </c:choose>
            <c:remove var="toastMessage" scope="session" />
        </c:if>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/admin/doctor/schedule/add" method="post" id="scheduleForm">
                <div class="form-group">
                    <label class="form-label">Chọn Bác Sĩ *</label>
                    <select name="doctorId" class="form-input" required>
                        <option value="">-- Chọn bác sĩ --</option>
                        <c:forEach var="vet" items="${veterinarians}">
                            <option value="${vet.userId}">${vet.fullName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Ngày Bắt Đầu *</label>
                        <input type="date" name="startDate" class="form-input" required value="${prefillDate}">
                        <p class="info-text">Ngày bắt đầu làm việc</p>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ngày Kết Thúc (Tùy chọn)</label>
                        <input type="date" name="endDate" class="form-input" id="endDate">
                        <p class="info-text">Để trống nếu chỉ thêm 1 ngày</p>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Chọn Slot Làm Việc *</label>
                    <p class="info-text">Chọn buổi làm việc (Sáng: 09:00 - 12:00, Chiều: 14:00 - 17:00).</p>

                    <div class="shift-selector" style="display: flex; gap: 20px; margin-top: 15px;">
                        <div class="shift-option" style="flex: 1;">
                            <input type="checkbox" id="shiftMorning" class="shift-checkbox" style="display:none;">
                            <label for="shiftMorning" class="shift-label" style="display:block; padding: 20px; border: 2px solid #edf2f7; border-radius: 12px; text-align: center; cursor: pointer; font-weight: 700; color: #64748b; transition: 0.2s;">
                                <i class="fa-solid fa-sun" style="font-size: 24px; color: #fbbf24; margin-bottom: 10px; display: block;"></i>
                                Buổi Sáng<br>
                                <span style="font-size: 11px; font-weight: 500;">09:00 AM - 12:00 PM</span>
                            </label>
                        </div>
                        <div class="shift-option" style="flex: 1;">
                            <input type="checkbox" id="shiftAfternoon" class="shift-checkbox" style="display:none;">
                            <label for="shiftAfternoon" class="shift-label" style="display:block; padding: 20px; border: 2px solid #edf2f7; border-radius: 12px; text-align: center; cursor: pointer; font-weight: 700; color: #64748b; transition: 0.2s;">
                                <i class="fa-solid fa-cloud-moon" style="font-size: 24px; color: #818cf8; margin-bottom: 10px; display: block;"></i>
                                Buổi Chiều<br>
                                <span style="font-size: 11px; font-weight: 500;">02:00 PM - 05:00 PM</span>
                            </label>
                        </div>
                    </div>
                    <style>
                        .shift-checkbox:checked + .shift-label {
                            border-color: var(--primary-green) !important;
                            background: #f0fff4 !important;
                            color: var(--primary-green) !important;
                        }
                    </style>

                    <div class="slot-toolbar" style="display:none;">
                        <div class="slot-actions">
                            <button type="button" class="btn-mini" id="btnSelectAll">Chọn tất cả</button>
                            <button type="button" class="btn-mini" id="btnClearAll">Bỏ chọn</button>
                        </div>
                        <div class="info-text" id="slotCounter" style="margin-top:0;">Đã chọn: 0 slot</div>
                    </div>

                    <div class="slot-grid" id="slotGrid" style="display:none;">
                        <c:forEach var="slot" items="${timeSlots}" varStatus="st">
                            <div class="slot-item">
                                <input type="checkbox" name="slots" value="${slot}" id="slot_${st.index}" class="hidden-slot-cb" data-time="${slot}">
                                <label for="slot_${st.index}">${slot}</label>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Lặp Lại</label>
                    <div class="repeat-options">
                        <div class="repeat-option">
                            <input type="radio" name="repeatType" value="none" id="repeatNone" checked>
                            <label for="repeatNone">Không lặp</label>
                        </div>
                        <div class="repeat-option">
                            <input type="radio" name="repeatType" value="daily" id="repeatDaily">
                            <label for="repeatDaily">Hàng Ngày</label>
                        </div>
                        <div class="repeat-option">
                            <input type="radio" name="repeatType" value="weekly" id="repeatWeekly">
                            <label for="repeatWeekly">Hàng Tuần</label>
                        </div>
                        <div class="repeat-option">
                            <input type="radio" name="repeatType" value="monthly" id="repeatMonthly">
                            <label for="repeatMonthly">Hàng Tháng</label>
                        </div>
                    </div>
                </div>

                <div class="repeat-end-date-group" id="repeatEndDateGroup">
                    <div class="form-group">
                        <label class="form-label">Lặp Đến Ngày *</label>
                        <input type="date" name="repeatEndDate" class="form-input" id="repeatEndDate">
                        <p class="info-text">Lịch sẽ được tạo tự động đến ngày này</p>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">Thêm Lịch Làm Việc</button>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-cancel">Hủy</a>
                </div>
            </form>
        </div>
    </main>

    <script>
        // Show/hide repeat end date based on repeat type
        const repeatRadios = document.querySelectorAll('input[name="repeatType"]');
        const repeatEndDateGroup = document.getElementById('repeatEndDateGroup');
        const repeatEndDate = document.getElementById('repeatEndDate');
        const endDate = document.getElementById('endDate');

        repeatRadios.forEach(radio => {
            radio.addEventListener('change', function() {
                if (this.value !== 'none') {
                    repeatEndDateGroup.classList.add('show');
                    repeatEndDate.required = true;
                    // Hide endDate when repeat is selected
                    if (endDate) {
                        endDate.closest('.form-group').style.display = 'none';
                    }
                } else {
                    repeatEndDateGroup.classList.remove('show');
                    repeatEndDate.required = false;
                    // Show endDate when no repeat
                    if (endDate) {
                        endDate.closest('.form-group').style.display = 'block';
                    }
                }
            });
        });

        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        document.querySelector('input[name="startDate"]').setAttribute('min', today);
        if (endDate) {
            endDate.setAttribute('min', today);
        }
        if (repeatEndDate) {
            repeatEndDate.setAttribute('min', today);
        }

        // Update endDate min when startDate changes
        document.querySelector('input[name="startDate"]').addEventListener('change', function() {
            const startDateValue = this.value;
            if (endDate && startDateValue) {
                endDate.setAttribute('min', startDateValue);
            }
            if (repeatEndDate && startDateValue) {
                repeatEndDate.setAttribute('min', startDateValue);
            }
        });

        // Slot selection helpers
        const slotGrid = document.getElementById('slotGrid');
        const hiddenSlots = document.querySelectorAll('.hidden-slot-cb');
        
        document.getElementById('shiftMorning').addEventListener('change', function() {
            const isChecked = this.checked;
            hiddenSlots.forEach(cb => {
                const timeStr = cb.getAttribute('data-time');
                // Morning slots are 09:xx AM, 10:xx AM, 11:xx AM
                if (timeStr.includes('AM') && !timeStr.startsWith('12')) {
                    cb.checked = isChecked;
                }
            });
        });

        document.getElementById('shiftAfternoon').addEventListener('change', function() {
            const isChecked = this.checked;
            hiddenSlots.forEach(cb => {
                const timeStr = cb.getAttribute('data-time');
                // Afternoon slots are 02:xx PM, 03:xx PM, 04:xx PM
                if (timeStr.includes('PM') && !timeStr.startsWith('12') && !timeStr.startsWith('01')) {
                    cb.checked = isChecked;
                }
            });
        });

        // Validate at least one slot selected
        const scheduleForm = document.getElementById('scheduleForm');
        if (scheduleForm) {
            scheduleForm.addEventListener('submit', (e) => {
                const checked = document.querySelectorAll('input[name="slots"]:checked').length;
                if (checked === 0) {
                    e.preventDefault();
                    alert('Vui lòng chọn ít nhất 1 slot làm việc!');
                }
            });
        }
    </script>

</body>
</html>
