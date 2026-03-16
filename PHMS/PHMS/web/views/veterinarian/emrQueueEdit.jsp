<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Edit Queue Appointment</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Edit Checked-in Appointment</h2>
                    <p>#${appt.apptId}</p>
                </div>
                <a href="${pageContext.request.contextPath}/veterinarian/emr/queue" class="btn-signout" style="background:#e5e7eb;color:#111827;">
                    Back to Queue
                </a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Appointment Information</span>
                </div>

                <div style="display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px;margin-bottom:20px;">
                    <div>
                        <label style="font-weight:600;color:#374151;">Owner</label>
                        <p>${appt.ownerName}</p>
                    </div>
                    <div>
                        <label style="font-weight:600;color:#374151;">Pet</label>
                        <p>${appt.petName}</p>
                    </div>
                    <div>
                        <label style="font-weight:600;color:#374151;">Time</label>
                        <p><fmt:formatDate value="${appt.startTime}" pattern="HH:mm dd/MM/yyyy"/></p>
                    </div>
                    <div>
                        <label style="font-weight:600;color:#374151;">Type</label>
                        <p>${appt.type}</p>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/veterinarian/emr/queue/edit" style="display:flex;flex-direction:column;gap:12px;">
                    <input type="hidden" name="apptId" value="${appt.apptId}" />

                    <label for="notes" style="font-weight:600;color:#374151;">Notes</label>
                    <textarea id="notes" name="notes" rows="4"
                              style="padding:8px 10px;border-radius:6px;border:1px solid #d1d5db;font-family:inherit;">${appt.notes}</textarea>

                    <div style="margin-top:16px;display:flex;gap:10px;">
                        <button type="submit" class="btn btn-approve">
                            <i class="fa-solid fa-floppy-disk"></i> Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/veterinarian/emr/create?apptId=${appt.apptId}"
                           class="btn btn-approve" style="text-decoration:none;">
                            <i class="fa-solid fa-pen-to-square"></i> Go to EMR
                        </a>
                        <a href="${pageContext.request.contextPath}/veterinarian/emr/queue"
                           class="btn btn-reject" style="text-decoration:none;">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>

