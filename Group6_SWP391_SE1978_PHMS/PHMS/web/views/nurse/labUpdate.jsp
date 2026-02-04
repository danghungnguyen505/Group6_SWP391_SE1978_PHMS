<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Update Lab Result</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/nurse/lab/queue" class="active">
                        <i class="fa-solid fa-flask"></i> Lab Queue</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Update Lab Result</h2>
                    <p>Test #${test.testId}</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:if test="${not empty test}">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 10px;">
                        <div><b>Type:</b> ${test.testType}</div>
                        <div><b>Status:</b> ${test.status}</div>
                        <div><b>Pet:</b> ${test.petName}</div>
                        <div><b>Owner:</b> ${test.ownerName}</div>
                        <div><b>Vet:</b> ${test.vetName}</div>
                        <div><b>Request Notes:</b> ${test.requestNotes}</div>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/nurse/lab/update" enctype="multipart/form-data">
                    <input type="hidden" name="testId" value="${test.testId}">

                    <div style="margin-top: 10px;">
                        <label><b>Status</b></label>
                        <select name="status" style="width:100%;">
                            <option value="Requested" ${test.status == 'Requested' ? 'selected' : ''}>Requested</option>
                            <option value="In Progress" ${test.status == 'In Progress' ? 'selected' : ''}>In Progress</option>
                            <option value="Completed" ${test.status == 'Completed' ? 'selected' : ''}>Completed</option>
                        </select>
                    </div>

                    <div style="margin-top: 10px;">
                        <label><b>Result Text</b> (optional)</label>
                        <textarea name="resultText" rows="4" style="width:100%;" maxlength="4000"
                                  placeholder="Enter result text..."></textarea>
                    </div>

                    <div style="margin-top: 10px;">
                        <label><b>Upload Result File</b> (optional: JPG/PNG/DICOM .dcm)</label>
                        <input type="file" name="resultFile" class="form-control">
                    </div>

                    <div style="display:flex; gap:10px; margin-top: 12px;">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/nurse/lab/queue">Back</a>
                        <button class="btn btn-approve" type="submit">
                            <i class="fa-solid fa-save"></i> Save
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>

