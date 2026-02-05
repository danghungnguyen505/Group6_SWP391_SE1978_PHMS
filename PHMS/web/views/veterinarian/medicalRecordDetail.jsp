<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Medical Record Detail</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/queue">
                        <i class="fa-solid fa-stethoscope"></i> EMR Queue</a></li>
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
                    <h2>Medical Record Detail</h2>
                    <p>Record #${record.recordId}</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Summary</span>
                </div>

                <c:if test="${empty record}">
                    <div class="empty-state"><p>Record not found.</p></div>
                </c:if>

                <c:if test="${not empty record}">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <div><b>Created:</b> <fmt:formatDate value="${record.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                        <div><b>Appointment:</b> #${record.apptId} (<fmt:formatDate value="${record.apptStartTime}" pattern="dd/MM/yyyy HH:mm"/>)</div>
                        <div><b>Owner:</b> ${record.ownerName}</div>
                        <div><b>Pet:</b> ${record.petName}</div>
                        <div><b>Status:</b> ${record.apptStatus}</div>
                    </div>

                    <hr/>

                    <div>
                        <h4>Diagnosis</h4>
                        <div style="white-space: pre-wrap;">${record.diagnosis}</div>
                    </div>

                    <div style="margin-top: 10px;">
                        <h4>Treatment Plan</h4>
                        <div style="white-space: pre-wrap;">${record.treatmentPlan}</div>
                    </div>

                    <div style="display:flex; gap:10px; margin-top: 12px; flex-wrap: wrap;">
                        <c:if test="${record.apptStatus != 'Completed'}">
                            <a class="btn btn-approve" style="text-decoration:none;"
                               href="${pageContext.request.contextPath}/veterinarian/emr/update?id=${record.recordId}">
                                <i class="fa-solid fa-pen"></i> Edit
                            </a>
                            <a class="btn btn-approve" style="text-decoration:none; background:#111827;"
                               href="${pageContext.request.contextPath}/veterinarian/lab/request?recordId=${record.recordId}">
                                <i class="fa-solid fa-flask"></i> Order Lab Test
                            </a>
                            <a class="btn btn-approve" style="text-decoration:none; background:#0f766e;"
                               href="${pageContext.request.contextPath}/veterinarian/prescription/list?recordId=${record.recordId}">
                                <i class="fa-solid fa-prescription-bottle-medical"></i> Prescribe Medicine
                            </a>
                            <form method="post" action="${pageContext.request.contextPath}/veterinarian/emr/delete" style="display:inline;">
                                <input type="hidden" name="id" value="${record.recordId}">
                                <button class="btn btn-reject" type="submit"
                                        onclick="return confirm('Delete this record?');"
                                        style="background:#ef4444; color:white;">
                                    <i class="fa-solid fa-trash"></i> Delete
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${record.apptStatus == 'In-Progress'}">
                            <form method="post" action="${pageContext.request.contextPath}/veterinarian/appointment/complete" style="display:inline;">
                                <input type="hidden" name="recordId" value="${record.recordId}">
                                <button class="btn btn-approve" type="submit"
                                        onclick="return confirm('Mark this appointment as Completed?');"
                                        style="background:#16a34a;">
                                    <i class="fa-solid fa-circle-check"></i> Completed
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${record.apptStatus == 'Completed'}">
                            <span style="color:#6b7280; font-style: italic;">Appointment completed. Editing is locked.</span>
                        </c:if>
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/veterinarian/emr/records">Back</a>
                    </div>
                </c:if>
            </div>
        </main>
    </body>
</html>

