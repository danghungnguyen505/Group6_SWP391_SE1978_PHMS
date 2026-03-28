<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Update Medical Record</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/records" class="active">
                        <i class="fa-solid fa-file-medical"></i> Medical Records</a></li>
            </ul>
            <div class="help-box">
                <div class="help-text">Need help?</div>
                <a href="#" class="btn-contact">Contact Support</a>
            </div>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Update Medical Record</h2>
                    <p>Record</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-bottom: 10px;">${error}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/veterinarian/emr/update">
                    <input type="hidden" name="recordId" value="${record != null ? record.recordId : recordId}">

                    <c:if test="${not empty record}">
                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 10px;">
                            <div><b>Appointment:</b> #${record.apptId}</div>
                            <div><b>Pet:</b> ${record.petName}</div>
                        </div>
                    </c:if>

                    <div style="margin-top: 10px;">
                        <label><b>Diagnosis</b></label>
                        <textarea name="diagnosis" rows="4" style="width:100%;" maxlength="4000"
                                  placeholder="Enter diagnosis..."><c:out value="${record != null ? record.diagnosis : diagnosis}"/></textarea>
                    </div>

                    <div style="margin-top: 10px;">
                        <label><b>Treatment Plan</b></label>
                        <textarea name="treatmentPlan" rows="4" style="width:100%;" maxlength="4000"
                                  placeholder="Enter treatment plan..."><c:out value="${record != null ? record.treatmentPlan : treatmentPlan}"/></textarea>
                    </div>

                    <div style="display:flex; gap:10px; margin-top: 12px;">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/veterinarian/emr/detail?id=${record != null ? record.recordId : recordId}">Cancel</a>
                        <button type="submit" class="btn btn-approve">
                            <i class="fa-solid fa-save"></i> Save
                        </button>
                    </div>
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


