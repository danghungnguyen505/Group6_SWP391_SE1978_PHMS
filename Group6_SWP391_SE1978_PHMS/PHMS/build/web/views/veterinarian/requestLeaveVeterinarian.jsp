<%-- 
    Document   : requestLeaveVeterinarian
    Created on : Mar 2, 2026, 9:03:28 PM
    Author     : zoxy4
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Xin Nghỉ Phép</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/staffScheduling.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap.min.css">
        <link rel="stylesheet" href="/PHMS/assets/buttonBack.css">
    </head>
    <body>
        <div class="container">
            <div class="back-home-floating">
                <a href="/PHMS/veterinarian/scheduling" class="back-home-btn">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                    Back to Scheduling
                </a>
            </div>
            <div class="main-content" style="max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px;">
                <h2>Request For Leave</h2>  
                <form action="${pageContext.request.contextPath}/requestLeaveVeterinarian" method="POST">
                    <input type="hidden" name="empId" value="${sessionScope.account.userId}">

                    <div style="margin-bottom: 15px;">
                        <label style="font-weight: bold;">Date of leave requested:</label>
                        <input type="text" value="${param.date}" disabled style="width: 100%; padding: 8px; margin-top: 5px;">
                        <input type="hidden" name="startDate" value="${param.date}">
                    </div>
<!--                    <div style="margin-bottom: 15px;">
                        <label style="font-weight: bold;">Shift:</label>
                        <input type="text"
                               value="${param.shiftType == 'morning' ? 'Morning (08:00 - 12:00)' :
                                       param.shiftType == 'afternoon' ? 'Afternoon (14:00 - 17:00)' : 'Custom shift'}"
                               style="width: 100%; padding: 8px; margin-top: 5px;">
                        <input type="hidden" name="shiftType" value="${param.shiftType}">
                    </div>-->
<!--                    <div style="margin-bottom: 15px;">
                        <label style="font-weight: bold;">Shift:</label>
                        <input type="text"
                               value="${param.shiftType == 'morning' ? 'Morning (08:00 - 12:00)' :
                                       param.shiftType == 'afternoon' ? 'Afternoon (14:00 - 17:00)' : 'Custom shift'}"
                               disabled
                               style="width: 100%; padding: 8px; margin-top: 5px;">
                        <input type="hidden" name="shiftType" value="${param.shiftType}">
                    </div>-->

                    <div style="margin-bottom: 15px;">
                        <label style="font-weight: bold;">Reason for leaving:</label>
                        <textarea name="reason" required rows="5" class="form-control"
                                  placeholder="Enter your reason for requesting leave..."></textarea>
                    </div>

                    <div style="text-align: right;">
                        <a href="${pageContext.request.contextPath}/veterinarian/scheduling"
                           class="btn btn-secondary" 
                           style="text-decoration: none; padding: 8px 15px; background: #ccc; color: #333; border-radius: 4px;"
                           >Cancel
                        </a>
                        <c:if test="${status != 'success'}">
                            <button type="submit" class="btn btn-primary" 
                                    style="padding: 8px 15px; background: #10b981; color: white; border: none; border-radius: 4px;"
                                    >Submit Request
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
        </div>
    </body>
</html>