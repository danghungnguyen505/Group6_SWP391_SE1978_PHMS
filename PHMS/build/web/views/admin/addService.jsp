<%@ page pageEncoding="UTF-8" %>
<%-- 
    Document   : addService
    Created on : Jan 22, 2026, 11:13:10 AM
    Author     : Nguyen Dang Hung
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="${L}">
<head>
    <meta charset="UTF-8">
    <title>${L == 'en' ? 'VetCare Pro - Add New Service' : 'VetCare Pro - Thêm dịch vụ mới'}</title>
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

        /* --- SIDEBAR (Giữ nguyên đồng bộ) --- */
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

        /* Header with Back Button */
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
            max-width: 800px;
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

        textarea.form-input {
            min-height: 150px;
            resize: vertical;
        }

        /* Footer Actions */
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

        /* Sidebar Support Box */
        .help-box { margin-top: auto; background: #f8fafc; padding: 20px; border-radius: 16px; border: 1px solid #edf2f7; }
        .help-box p { font-size: 13px; font-weight: 600; margin-bottom: 12px; }
        .btn-support { display: block; background: #0f172a; color: white; text-align: center; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 12px; }

    </style>
</head>
<body>

    <jsp:include page="common/navbar.jsp">
    <jsp:param name="activePage" value="services" />
</jsp:include>

    <!-- Main Content -->
    <main class="main-content">
        <header class="page-header">
            <a href="services" class="btn-back">
                <i class="fa-solid fa-chevron-left"></i>
            </a>
            <div class="title-area">
                <h1>${L == 'en' ? 'Add New Service' : 'Thêm dịch vụ mới'}</h1>
                <p>${L == 'en' ? 'Update hospital service catalog and base pricing.' : 'Cập nhật danh mục dịch vụ và giá cơ bản của phòng khám.'}</p>
            </div>
        </header>
<c:if test="${not empty error}">
    <div style="background-color: #fee2e2; color: #dc2626; padding: 15px; border-radius: 12px; border: 1px solid #fecaca; margin-bottom: 20px; font-size: 14px; line-height: 1.5;">
        <i class="fa-solid fa-triangle-exclamation" style="margin-right: 8px;"></i>
        <strong>Lỗi:</strong> ${error}
    </div>
</c:if>
        <div class="form-container">
            <form action="add-service" method="post">
                <div class="form-group">
                    <label class="form-label">${L == 'en' ? 'Service Name' : 'Tên dịch vụ'}</label>
                    <input type="text" name="name" class="form-input" required placeholder="${L == 'en' ? 'e.g. General Check-up' : 'Ví dụ: Khám tổng quát'}" value="${name}">
                </div>

                <div class="form-group">
                    <label class="form-label">${L == 'en' ? 'Service Type' : 'Loại dịch vụ'}</label>
                    <select name="serviceType" class="form-input" required>
                        <option value="Basic" ${serviceType == 'Basic' || empty serviceType ? 'selected' : ''}>${L == 'en' ? 'Basic' : 'Cơ bản'}</option>
                        <option value="Emergency" ${serviceType == 'Emergency' ? 'selected' : ''}>${L == 'en' ? 'Emergency' : 'Cấp cứu'}</option>
                        <option value="LabTest" ${serviceType == 'LabTest' ? 'selected' : ''}>${L == 'en' ? 'Lab test' : 'Xét nghiệm'}</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">${L == 'en' ? 'Base Price (VND)' : 'Giá cơ bản (VND)'}</label>
                    <input type="number" name="price" class="form-input" required placeholder="${L == 'en' ? 'e.g. 500000' : 'Ví dụ: 500000'}" value="${price}">
                </div>

                <div class="form-group">
                    <label class="form-label">${L == 'en' ? 'Detailed Description' : 'Mô tả chi tiết'}</label>
                    <textarea name="description" class="form-input" placeholder="${L == 'en' ? 'Describe what the service includes...' : 'Mô tả dịch vụ bao gồm những gì...'}">${description}</textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">${L == 'en' ? 'Current Status' : 'Trạng thái hiện tại'}</label>
                    <input type="text" class="form-input" value="${L == 'en' ? 'Active' : 'Hoạt động'}" readonly style="font-weight: 700;">
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">${L == 'en' ? 'Confirm & Save' : 'Xác nhận & Lưu'}</button>
                    <a href="services" class="btn-cancel">${L == 'en' ? 'Cancel' : 'Hủy'}</a>
                </div>
            </form>
        </div>
    </main>

<div class="phms-account-entry" style="position:fixed; top:16px; right:20px; z-index:1200;">
    <a href="${pageContext.request.contextPath}/logout" style="display:inline-flex;align-items:center;gap:6px;padding:8px 14px;border:1px solid #e2e8f0;border-radius:10px;background:#fff;color:#334155;text-decoration:none;font-size:13px;font-weight:700;box-shadow:0 2px 10px rgba(0,0,0,.05);">${L == 'en' ? 'Logout' : 'Đăng xuất'}</a>
</div>
<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>


