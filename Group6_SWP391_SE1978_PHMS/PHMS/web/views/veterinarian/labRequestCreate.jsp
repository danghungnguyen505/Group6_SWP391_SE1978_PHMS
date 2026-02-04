<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Lab Request</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/records">
                        <i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/lab/requests" class="active">
                        <i class="fa-solid fa-flask"></i> Lab Requests</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Create Lab Request</h2>
                    <p>Order lab test for nursing team.</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:if test="${not empty record}">
                    <div style="margin-bottom: 10px;">
                        <b>Record:</b> #${record.recordId} |
                        <b>Appointment:</b> #${record.apptId} (<fmt:formatDate value="${record.apptStartTime}" pattern="dd/MM/yyyy HH:mm"/>) |
                        <b>Pet:</b> ${record.petName}
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/veterinarian/lab/request">
                    <input type="hidden" name="recordId" value="${param.recordId != null ? param.recordId : record.recordId}">

                    <div style="margin-top: 10px;">
                        <label><b>Test Type</b></label>
                        <select name="testType" style="width:100%;">
                            <option value="Blood Test" ${testType == 'Blood Test' ? 'selected' : ''}>Blood Test</option>
                            <option value="X-Ray" ${testType == 'X-Ray' ? 'selected' : ''}>X-Ray</option>
                            <option value="Ultrasound" ${testType == 'Ultrasound' ? 'selected' : ''}>Ultrasound</option>
                            <option value="Other" ${testType == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div style="margin-top: 10px;">
                        <label><b>Request Notes</b></label>
                        <textarea name="requestNotes" rows="4" style="width:100%;" maxlength="4000"
                                  placeholder="Notes for nursing team...">${requestNotes}</textarea>
                    </div>

                    <div style="display:flex; gap:10px; margin-top: 12px;">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/veterinarian/emr/records">Back</a>
                        <button class="btn btn-approve" type="submit">
                            <i class="fa-solid fa-paper-plane"></i> Submit Request
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>

