<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - PHÊ DUYỆT NGHỈ PHÉP</title>
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

        /* --- SIDEBAR (ĐỒNG BỘ) --- */
        .sidebar {
            width: var(--sidebar-width); background: #ffffff; height: 100vh; position: fixed;
            left: 0; top: 0; padding: 35px 25px; display: flex; flex-direction: column;
            border-right: 1px solid #edf2f7; z-index: 1000;
        }
        .logo { display: flex; align-items: center; gap: 12px; color: var(--primary-green); font-weight: 800; font-size: 22px; margin-bottom: 50px; padding-left: 10px; }
        .menu-label { color: #a0aec0; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; margin-bottom: 20px; padding-left: 10px; }
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

        .page-header { margin-bottom: 40px; }
        .page-header h1 { font-size: 28px; font-weight: 900; text-transform: uppercase; letter-spacing: -0.5px; }
        .page-header p { color: var(--text-muted); margin-top: 5px; font-size: 15px; }

        /* --- TABLE CARD --- */
        .table-container {
            background: white;
            border-radius: 24px;
            padding: 10px 40px 30px;
            box-shadow: var(--card-shadow);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th {
            text-align: left;
            padding: 25px 15px;
            font-size: 11px;
            font-weight: 800;
            color: #a0aec0;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border-bottom: 1px solid #f1f5f9;
        }

        .data-table td {
            padding: 25px 15px;
            font-size: 14px;
            border-bottom: 1px solid #f8fafc;
            vertical-align: middle;
        }

        .col-id { color: #cbd5e0; font-weight: 600; width: 120px; text-transform: uppercase; }
        .col-emp { font-weight: 800; color: var(--text-main); font-size: 15px; }
        .col-role { display: block; font-size: 10px; font-weight: 800; color: #cbd5e0; text-transform: uppercase; margin-top: 2px; }
        .col-date { font-weight: 800; color: var(--text-main); }
        .col-reason { color: var(--text-muted); font-size: 13px; }

        /* Badge Styles */
        .badge {
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 9px;
            font-weight: 900;
            text-transform: uppercase;
            display: inline-block;
        }
        .bg-pending { background: #fff7ed; color: #c2410c; } /* Màu cam nhạt */
        .bg-review { background: #eff6ff; color: #1d4ed8; }  /* Màu xanh blue nhạt */
        .bg-approved { background: #f0fdf4; color: #15803d; } /* Màu xanh lá nhạt */

        /* Action Buttons */
        .btn-approve {
            background: var(--primary-green);
            color: white;
            border: none;
            padding: 8px 18px;
            border-radius: 8px;
            font-weight: 800;
            font-size: 10px;
            text-transform: uppercase;
            cursor: pointer;
            transition: 0.2s;
            margin-right: 8px;
        }
        .btn-reject {
            background: white;
            color: #94a3b8;
            border: 1px solid #e2e8f0;
            padding: 8px 18px;
            border-radius: 8px;
            font-weight: 800;
            font-size: 10px;
            text-transform: uppercase;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-approve:hover { opacity: 0.8; }
        .btn-reject:hover { background: #f8fafc; color: var(--text-main); }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: flex-end;
            margin-top: 30px;
            gap: 8px;
        }
        .page-btn {
            padding: 8px 14px;
            background: #f1f5f9;
            color: var(--text-muted);
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            font-size: 12px;
        }
        .page-btn.active { background: var(--primary-green); color: white; }

        .help-box { margin-top: auto; background: #f8fafc; padding: 20px; border-radius: 16px; border: 1px solid #edf2f7; }
        .btn-support { display: block; background: #0f172a; color: white; text-align: center; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 12px; margin-top: 8px; }

    </style>
</head>
<body>

    <jsp:include page="common/navbar.jsp">
    <jsp:param name="activePage" value="leave" />
</jsp:include>

    <!-- Main Content -->
    <main class="main-content">
        <header class="page-header">
            <h1>Phê duyệt nghỉ phép</h1>
            <p>Xem xét và quản lý các yêu cầu vắng mặt của đội ngũ nhân viên</p>
        </header>

        <div class="table-container">
            <c:choose>
                <c:when test="${empty requests}">
                    <div style="text-align:center; padding:60px; color:var(--text-muted);">
                        <i class="fa-solid fa-calendar-xmark" style="font-size: 48px; margin-bottom: 20px; opacity: 0.3;"></i>
                        <p>Hiện không có đơn nghỉ nào đang chờ duyệt.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th class="col-id">Mã yêu cầu</th>
                                <th>Nhân viên</th>
                                <th>Ngày nghỉ</th>
                                <th>Lý do</th>
                                <th>Status</th>
                                <th style="text-align:right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${requests}">
                                <tr>
                                    <td class="col-id">LR-${r.leaveId}</td>
                                    <td>
                                        <div class="col-emp">${r.empId}</div>
                                        <div class="col-role">NHÂN VIÊN</div> <%-- Thay bằng role thật nếu có --%>
                                    </td>
                                    <td class="col-date">${r.startDate}</td>
                                    <td class="col-reason">${r.reason}</td>
                                    <td>
                                        <%-- Logic hiển thị badge dựa trên status (nếu có trường status) --%>
                                        <span class="badge bg-pending">Pending</span>
                                    </td>
                                    <td style="text-align:right;">
                                        <form action="${pageContext.request.contextPath}/admin/leave/update-status" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${r.leaveId}">
                                            <input type="hidden" name="action" value="approve">
                                            <button type="submit" class="btn-approve">Approve</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/leave/update-status" method="post" style="display:inline;">
                                            <input type="hidden" name="id" value="${r.leaveId}">
                                            <input type="hidden" name="action" value="reject">
                                            <button type="submit" class="btn-reject">Reject</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="${pageContext.request.contextPath}/admin/leave/pending?page=${i}"
                                   class="page-btn ${i == currentPage ? 'active' : ''}">
                                    ${i}
                                </a>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</body>
</html>