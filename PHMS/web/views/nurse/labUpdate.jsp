<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            <div class="help-box">
                <div class="help-text">Need help?</div>
                <a href="#" class="btn-contact">Contact Support</a>
            </div>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2><c:choose><c:when test="${canUpdate == false}">View Lab Result</c:when><c:otherwise>Update Lab Result</c:otherwise></c:choose></h2>
                    <p>Test #${test.testId}</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <!-- Toast Message -->
            <c:if test="${not empty sessionScope.toastMessage}">
                <c:set var="toast" value="${sessionScope.toastMessage}" />
                <c:choose>
                    <c:when test="${fn:startsWith(toast, 'success|')}">
                        <div style="background:#ecfdf5;border:1px solid #a7f3d0;color:#065f46;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-weight:600;">
                            <i class="fa-solid fa-check-circle" style="margin-right:8px;"></i>
                            ${fn:substringAfter(toast, 'success|')}
                        </div>
                    </c:when>
                    <c:when test="${fn:startsWith(toast, 'error|')}">
                        <div style="background:#fef2f2;border:1px solid #fecaca;color:#991b1b;padding:12px 16px;border-radius:10px;margin-bottom:16px;font-weight:600;">
                            <i class="fa-solid fa-triangle-exclamation" style="margin-right:8px;"></i>
                            ${fn:substringAfter(toast, 'error|')}
                        </div>
                    </c:when>
                </c:choose>
                <c:remove var="toastMessage" scope="session" />
            </c:if>

            <div class="card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <!-- Readonly banner for completed/cancelled tests -->
                <c:if test="${canUpdate == false}">
                    <div style="background:#fee2e2; border:1px solid #fecaca; border-radius:8px; padding:12px; margin-bottom:16px; color:#991b1b;">
                        <i class="fa-solid fa-info-circle"></i>
                        <strong>This lab test is ${test.status}.</strong> You can view the details below but cannot make changes.
                    </div>
                </c:if>

                <c:if test="${not empty test}">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 10px;">
                        <div><b>Type:</b> ${test.testType}</div>
                        <div><b>Status:</b>
                            <c:choose>
                                <c:when test="${test.status == 'Completed'}">
                                    <span style="color:#10b981; font-weight:600;">Completed</span>
                                </c:when>
                                <c:when test="${test.status == 'Cancelled'}">
                                    <span style="color:#94a3b8; font-weight:600;">Cancelled</span>
                                </c:when>
                                <c:when test="${test.status == 'In Progress'}">
                                    <span style="color:#3b82f6; font-weight:600;">In Progress</span>
                                </c:when>
                                <c:otherwise>${test.status}</c:otherwise>
                            </c:choose>
                        </div>
                        <div><b>Pet:</b> ${test.petName}</div>
                        <div><b>Owner:</b> ${test.ownerName}</div>
                        <div><b>Vet:</b> ${test.vetName}</div>
                        <div><b>Request Notes:</b> ${test.requestNotes}</div>
                    </div>

                    <!-- Show result data if exists -->
                    <c:if test="${not empty test.resultData}">
                        <div style="margin-top:16px; padding:12px; background:#f0fdf4; border:1px solid #bbf7d0; border-radius:8px;">
                            <b><i class="fa-solid fa-file-medical"></i> Result:</b>
                            <c:choose>
                                <c:when test="${fn:startsWith(test.resultData, '/uploads/lab/')}">
                                    <a href="${pageContext.request.contextPath}${test.resultData}" target="_blank" class="btn btn-approve" style="text-decoration:none; margin-left:8px;">
                                        <i class="fa-solid fa-download"></i> View File
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <p style="margin-top:8px; white-space:pre-wrap;">${test.resultData}</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/nurse/lab/update" enctype="multipart/form-data">
                    <input type="hidden" name="testId" value="${test.testId}">

                    <div style="margin-top: 10px;">
                        <label><b>Status</b></label>
                        <select name="status" style="width:100%;" ${canUpdate == false ? 'disabled' : ''}>
                            <option value="Requested" ${test.status == 'Requested' ? 'selected' : ''}>Requested</option>
                            <option value="In Progress" ${test.status == 'In Progress' ? 'selected' : ''}>In Progress</option>
                            <option value="Completed" ${test.status == 'Completed' ? 'selected' : ''}>Completed</option>
                        </select>
                    </div>

                    <div style="margin-top: 10px;">
                        <label><b>Result Text</b> (optional)</label>
                        <textarea name="resultText" rows="4" style="width:100%;" maxlength="4000"
                                  placeholder="Enter result text..." ${canUpdate == false ? 'readonly' : ''}><c:if test="${not empty test.resultData && !fn:startsWith(test.resultData, '/uploads/')}">${test.resultData}</c:if></textarea>
                    </div>

                    <div style="display:flex; gap:10px; margin-top: 12px;">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/nurse/lab/queue">Back</a>
                        <c:if test="${canUpdate != false}">
                            <button class="btn btn-approve" type="submit">
                                <i class="fa-solid fa-save"></i> Save
                            </button>
                        </c:if>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>

