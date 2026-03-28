<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Request Leave</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/staffScheduling.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
        <style>
            .top-bar {
                display: flex;
                justify-content: flex-end;
                align-items: center;
                margin-bottom: 14px;
            }
            .leave-wrap {
                max-width: 700px;
                margin: 0 auto 24px auto;
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 6px 20px rgba(15, 23, 42, 0.05);
            }
            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                text-decoration: none;
                color: #334155;
                font-weight: 600;
                margin-bottom: 14px;
            }
            .back-link:hover {
                color: #10b981;
            }
        </style>
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <div class="top-bar">
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="leave-wrap">
                <a href="${pageContext.request.contextPath}/veterinarian/scheduling" class="back-link">
                    <i class="fa-solid fa-arrow-left"></i> Back to Scheduling
                </a>

                <h2 style="margin-bottom: 18px;">Request For Leave</h2>

                <form action="${pageContext.request.contextPath}/requestLeaveVeterinarian" method="POST">
                    <input type="hidden" name="empId" value="${sessionScope.account.userId}">

                    <div style="margin-bottom: 15px;">
                        <label style="font-weight: bold;">Date of leave requested:</label>
                        <input type="text" value="${param.date}" disabled style="width: 100%; padding: 8px; margin-top: 5px;">
                        <input type="hidden" name="startDate" value="${param.date}">
                        <input type="hidden" name="shiftType" value="${param.shiftType}">
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label style="font-weight: bold;">Reason for leaving:</label>
                        <textarea name="reason" required rows="5" class="form-control"
                                  placeholder="Enter your reason for requesting leave..."></textarea>
                    </div>

                    <div style="text-align: right;">
                        <a href="${pageContext.request.contextPath}/veterinarian/scheduling"
                           class="btn btn-secondary"
                           style="text-decoration: none; padding: 8px 15px; background: #ccc; color: #333; border-radius: 4px;">
                            Cancel
                        </a>
                        <c:if test="${status != 'success'}">
                            <button type="submit" class="btn btn-primary"
                                    style="padding: 8px 15px; background: #10b981; color: white; border: none; border-radius: 4px;">
                                Submit Request
                            </button>
                        </c:if>
                    </div>

                    <c:if test="${not empty message}">
                        <div style="text-align: right; margin-top: 15px; font-weight: bold;
                             color: ${status == 'success' ? '#10b981' : '#dc3545'};">
                            ${message}
                        </div>
                    </c:if>
                </form>
            </div>
        </main>

        <script>
            window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
            window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
    </body>
</html>
