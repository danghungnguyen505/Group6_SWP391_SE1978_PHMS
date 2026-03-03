<<<<<<< Updated upstream
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Add Medicine</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/medicine/list" class="active">Medicine</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Add Medicine</h2>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/admin/medicine/add">
                    <div style="margin-bottom:15px;">
                        <label><b>Medicine Name *</b></label>
                        <input type="text" name="name" value="${name}" required maxlength="100" 
                               style="width:100%; padding:8px;" placeholder="Enter medicine name">
                    </div>

                    <div style="margin-bottom:15px;">
                        <label><b>Unit *</b></label>
                        <input type="text" name="unit" value="${unit}" required maxlength="20" 
                               style="width:100%; padding:8px;" placeholder="e.g., tablet, ml, bottle">
                    </div>

                    <div style="margin-bottom:15px;">
                        <label><b>Price (VND) *</b></label>
                        <input type="number" name="price" value="${price}" step="0.01" min="0" required 
                               style="width:100%; padding:8px;" placeholder="0.00">
                    </div>

                    <div style="margin-bottom:15px;">
                        <label><b>Stock Quantity *</b></label>
                        <input type="number" name="stockQuantity" value="${stockQuantity}" min="0" required 
                               style="width:100%; padding:8px;" placeholder="0">
                    </div>

                    <div style="display:flex; gap:10px; margin-top:20px;">
                        <a href="${pageContext.request.contextPath}/admin/medicine/list" 
                           class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;">Cancel</a>
                        <button type="submit" class="btn btn-approve">
                            <i class="fa-solid fa-save"></i> Save Medicine
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>
=======
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - CATALOG NEW MEDICINE</title>
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
        .nav-menu { list-style: none; flex: 1; }
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
            width: 45px; height: 45px;
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

        .form-group { margin-bottom: 25px; }
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

        .form-input::placeholder { color: #cbd5e0; }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
            display: flex; align-items: center; justify-content: center;
            transition: 0.2s;
        }
        .btn-cancel:hover { background: #e2e8f0; color: var(--text-main); }

        .alert-danger {
            background: #fee2e2;
            color: #b91c1c;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 600;
        }

        .help-box { margin-top: auto; background: #f8fafc; padding: 20px; border-radius: 16px; border: 1px solid #edf2f7; }
        .btn-support { display: block; background: #0f172a; color: white; text-align: center; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 12px; margin-top: 10px; }
    </style>
</head>
<body>

    <jsp:include page="common/navbar.jsp">
    <jsp:param name="activePage" value="pharmacy" />
</jsp:include>

    <!-- Main Content -->
    <main class="main-content">
        <header class="page-header">
            <a href="${pageContext.request.contextPath}/admin/medicine/list" class="btn-back">
                <i class="fa-solid fa-chevron-left"></i>
            </a>
            <div class="title-area">
                <h1>Catalog New Medicine</h1>
                <p>Enter the details of the pharmaceutical product below.</p>
            </div>
        </header>

        <div class="form-container">
            <c:if test="${not empty error}">
                <div class="alert-danger">${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/admin/medicine/add">
                <div class="form-group">
                    <label class="form-label">Medicine Name *</label>
                    <input type="text" name="name" value="${name}" required maxlength="100" 
                           class="form-input" placeholder="e.g. Amoxicillin 250mg">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Unit *</label>
                        <input type="text" name="unit" value="${unit}" required maxlength="20" 
                               class="form-input" placeholder="e.g. tablet, ml, bottle">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Price (VND) *</label>
                        <input type="number" name="price" value="${price}" step="0.01" min="0" required 
                               class="form-input" placeholder="e.g. 150000">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Stock Quantity *</label>
                    <input type="number" name="stockQuantity" value="${stockQuantity}" min="0" required 
                           class="form-input" placeholder="e.g. 100">
                </div>

                <div class="form-group">
                    <label class="form-label">Inventory Status</label>
                    <input type="text" class="form-input" value="Hoạt động" readonly style="font-weight: 700;">
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">Add to Inventory</button>
                    <a href="${pageContext.request.contextPath}/admin/medicine/list" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </div>
    </main>
</body>
</html>
>>>>>>> Stashed changes
