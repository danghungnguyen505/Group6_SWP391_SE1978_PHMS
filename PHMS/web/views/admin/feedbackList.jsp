<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>VetCare Pro - CUSTOMER FEEDBACK</title>
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

        /* --- SIDEBAR --- */
        .sidebar {
            width: var(--sidebar-width); background: #ffffff; height: 100vh; position: fixed;
            left: 0; top: 0; padding: 35px 25px; display: flex; flex-direction: column;
            border-right: 1px solid #edf2f7; z-index: 1000;
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
        .main-content { margin-left: var(--sidebar-width); flex: 1; padding: 40px 60px; }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 40px;
        }
        .page-header h2 { font-size: 28px; font-weight: 900; text-transform: uppercase; letter-spacing: -0.5px; }
        .page-header p { color: var(--text-muted); margin-top: 5px; font-size: 15px; }

        .filter-area { display: flex; align-items: center; gap: 10px; color: var(--text-muted); font-size: 11px; font-weight: 800; text-transform: uppercase; }
        .filter-select { padding: 6px 12px; border-radius: 8px; border: 1px solid #e2e8f0; background: white; font-weight: 700; font-size: 12px; color: var(--text-main); cursor: pointer; }

        /* --- TABLE CARD --- */
        .card {
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

        .col-client { font-weight: 800; color: var(--text-main); }
        .col-pet { font-size: 10px; font-weight: 800; color: #cbd5e0; text-transform: uppercase; margin-top: 2px; }
        
        .stars { color: #f6ad55; font-size: 10px; display: flex; gap: 2px; }
        .star-muted { color: #edf2f7; }

        .col-comment { font-style: italic; color: var(--text-muted); font-size: 13px; line-height: 1.5; max-width: 350px; }
        .col-date { color: var(--text-muted); font-size: 13px; font-weight: 500; }

        /* Status Badges */
        .status-badge {
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 9px;
            font-weight: 900;
            text-transform: uppercase;
        }
        .status-new { background: #dcfce7; color: #15803d; }
        .status-read { background: #f1f5f9; color: #94a3b8; }
        .status-flagged { background: #fee2e2; color: #b91c1c; }

        .btn-action {
            background: none; border: none; cursor: pointer; font-size: 16px; margin-left: 10px; color: #cbd5e0; transition: 0.2s;
        }
        .btn-action:hover { color: var(--text-main); }
        
        .title-area h1 { font-size: 26px; font-weight: 900; text-transform: uppercase; letter-spacing: -0.5px; }
        .title-area p { color: var(--text-muted); margin-top: 4px; font-size: 15px; }

        /* Pagination */
        .pagination { display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 30px; }
        .page-link { 
            padding: 8px 16px; background: #f1f5f9; color: var(--text-muted); text-decoration: none; 
            border-radius: 10px; font-weight: 700; font-size: 12px; transition: 0.2s;
        }
        .page-link:hover { background: #e2e8f0; color: var(--text-main); }

        .help-box { margin-top: auto; background: #f8fafc; padding: 20px; border-radius: 16px; border: 1px solid #edf2f7; }
        .help-box p { font-size: 13px; font-weight: 600; margin-bottom: 12px; }
        .btn-support { display: block; background: #0f172a; color: white; text-align: center; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: 700; font-size: 12px; margin-top: 8px; }
        .btn-signout { padding: 8px 16px; border: 1px solid #e2e8f0; border-radius: 8px; background: white; font-weight: 700; font-size: 11px; text-transform: uppercase; text-decoration: none; color: var(--text-main); }
    </style>
</head>
<body>

    

    <jsp:include page="common/navbar.jsp">
    <jsp:param name="activePage" value="feedback" />
</jsp:include>
    <main class="main-content">
        <div class="top-bar">
            <div class="page-header">
                <h2>Customer Feedback</h2>
                <p>Monitoring client satisfaction and service quality</p>
            </div>
            <div style="display:flex; align-items:center; gap:20px;">
                <form id="filterForm" method="get" style="display:flex; align-items:center; gap:10px;">
                    <input type="hidden" name="size" value="${pageSize}">
                    <div class="filter-area">
                        Rating:
                        <select class="filter-select" name="ratingFilter" onchange="document.getElementById('filterForm').submit()">
                            <option value="all" ${empty ratingFilter || ratingFilter == 'all' ? 'selected' : ''}>All Ratings</option>
                            <option value="5" ${ratingFilter == '5' ? 'selected' : ''}>5 Stars</option>
                            <option value="4" ${ratingFilter == '4' ? 'selected' : ''}>4 Stars</option>
                            <option value="below3" ${ratingFilter == 'below3' ? 'selected' : ''}>Below 3 Stars</option>
                        </select>
                    </div>
                    <div class="filter-area">
                        Status:
                        <select class="filter-select" name="statusFilter" onchange="document.getElementById('filterForm').submit()">
                            <option value="all" ${empty statusFilter || statusFilter == 'all' ? 'selected' : ''}>All Status</option>
                            <option value="New" ${statusFilter == 'New' ? 'selected' : ''}>New</option>
                            <option value="Read" ${statusFilter == 'Read' ? 'selected' : ''}>Read</option>
                            <option value="Flagged" ${statusFilter == 'Flagged' ? 'selected' : ''}>Flagged</option>
                        </select>
                    </div>
                </form>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>
        </div>

        <div class="card">
            <c:choose>
                <c:when test="${empty feedbacks}">
                    <div style="text-align:center; padding:60px; color:var(--text-muted);">
                        <i class="fa-solid fa-comments-slash" style="font-size:48px; margin-bottom:20px; opacity:0.3;"></i>
                        <p>No client feedbacks found at this time.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Client / Pet</th>
                                <th>Rating</th>
                                <th>Comment</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th style="text-align:right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="fb" items="${feedbacks}" varStatus="st">
                                <tr>
                                    <td>${(currentPage - 1) * pageSize + st.index + 1}</td>
                                    <td>
                                        <div class="col-client">${fb.customerName}</div>
                                        <div class="col-pet">PET: ${fb.petName}</div>
                                    </td>
                                    <td>
                                        <div class="stars">
                                            <c:forEach begin="1" end="${fb.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                            <c:forEach begin="${fb.rating + 1}" end="5"><i class="fa-solid fa-star star-muted"></i></c:forEach>
                                        </div>
                                    </td>
                                    <td class="col-comment">"${fb.comment}"</td>
                                    <td class="col-date">${fb.apptDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${fb.status == 'Flagged'}"><span class="status-badge status-flagged">Flagged</span></c:when>
                                            <c:when test="${fb.status == 'Read'}"><span class="status-badge status-read">Read</span></c:when>
                                            <c:otherwise><span class="status-badge status-new">New</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align:right;">
                                        <c:if test="${fb.status != 'Read'}">
                                            <form action="${pageContext.request.contextPath}/admin/feedback/list" method="post" style="display:inline;">
                                                <input type="hidden" name="feedbackId" value="${fb.feedbackId}">
                                                <input type="hidden" name="action" value="markRead">
                                                <button type="submit" class="btn-action" title="Mark as read"><i class="fa-solid fa-check"></i></button>
                                            </form>
                                        </c:if>
                                        <c:if test="${fb.status != 'Flagged'}">
                                            <form action="${pageContext.request.contextPath}/admin/feedback/list" method="post" style="display:inline;">
                                                <input type="hidden" name="feedbackId" value="${fb.feedbackId}">
                                                <input type="hidden" name="action" value="flag">
                                                <button type="submit" class="btn-action" title="Flag review"><i class="fa-solid fa-flag"></i></button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination" style="justify-content:space-between; width:100%;">
                            <form method="get" style="display:flex; align-items:center; gap:8px;">
                                <input type="hidden" name="ratingFilter" value="${ratingFilter}">
                                <input type="hidden" name="statusFilter" value="${statusFilter}">
                                <label style="font-size:12px; font-weight:700; color:var(--text-muted);">Hiển thị</label>
                                <select name="size" class="filter-select" style="padding:6px 10px;" onchange="this.form.submit()">
                                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                    <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                                </select>
                            </form>
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}&size=${pageSize}<c:if test='${not empty ratingFilter}'>&ratingFilter=${ratingFilter}</c:if><c:if test='${not empty statusFilter}'>&statusFilter=${statusFilter}</c:if>" class="page-link">Previous</a>
                            </c:if>
                            <span style="font-size:12px; font-weight:700; color:var(--text-muted);">Page ${currentPage} of ${totalPages}</span>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}&size=${pageSize}<c:if test='${not empty ratingFilter}'>&ratingFilter=${ratingFilter}</c:if><c:if test='${not empty statusFilter}'>&statusFilter=${statusFilter}</c:if>" class="page-link">Next</a>
                            </c:if>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>
