<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Prescription List</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
    </head>
    <body>
        
         <jsp:include page="nav/navVeterinarian.jsp" />
        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h2>Prescription List</h2>
                    <p>Medical Record</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Medical Record Information</span>
                </div>
                <c:if test="${not empty record}">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <span style="display:none;">${record.recordId}</span>
                        <div><b>Pet:</b> ${record.petName}</div>
                        <div><b>Owner:</b> ${record.ownerName}</div>
                        <div><b>Date:</b> <fmt:formatDate value="${record.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </c:if>

                <div style="display:flex; justify-content:space-between; align-items:center; margin-top: 20px;">
                    <div class="section-title" style="margin:0;">
                        <span>Prescription Items</span>
                    </div>
                    <c:if test="${record.apptStatus != 'Completed'}">
                        <a href="${pageContext.request.contextPath}/veterinarian/prescription/create?recordId=${record.recordId}" 
                           class="btn btn-approve" style="text-decoration:none;">
                            <i class="fa-solid fa-plus"></i> Add Prescription
                        </a>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${empty prescriptions || prescriptions.size() == 0}">
                        <div style="text-align:center; padding:40px; color:#6b7280;">
                            <i class="fa-solid fa-prescription-bottle" style="font-size:48px; margin-bottom:10px;"></i>
                            <p>No prescriptions found for this medical record.</p>
                            <c:if test="${record.apptStatus != 'Completed'}">
                                <a href="${pageContext.request.contextPath}/veterinarian/prescription/create?recordId=${record.recordId}" 
                                   class="btn btn-approve" style="text-decoration:none; margin-top:10px;">
                                    <i class="fa-solid fa-plus"></i> Create Prescription
                                </a>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table style="width:100%; margin-top:15px;">
                            <thead>
                                <tr style="background:#f3f4f6;">
                                    <th style="padding:10px; text-align:left;">STT</th>
                                    <th style="padding:10px; text-align:left;">Medicine</th>
                                    <th style="padding:10px; text-align:left;">Quantity</th>
                                    <th style="padding:10px; text-align:left;">Dosage</th>
                                    <th style="padding:10px; text-align:left;">Unit Price</th>
                                    <th style="padding:10px; text-align:left;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pres" items="${prescriptions}" varStatus="st">
                                    <tr>
                                        <td style="padding:10px;">${st.index + 1}<span style="display:none;">${pres.presId}</span></td>
                                        <td style="padding:10px;">${pres.medicineName}</td>
                                        <td style="padding:10px;">${pres.quantity} ${pres.medicineUnit}</td>
                                        <td style="padding:10px;">${pres.dosage}</td>
                                        <td style="padding:10px;"><fmt:formatNumber value="${pres.medicinePrice}" type="currency" currencySymbol="VND "/></td>
                                        <td style="padding:10px;">
                                            <c:if test="${record.apptStatus != 'Completed'}">
                                                <form method="post" action="${pageContext.request.contextPath}/veterinarian/prescription/delete" 
                                                      style="display:inline;" 
                                                      onsubmit="return confirm('Delete this medicine from prescription?');">
                                                    <input type="hidden" name="presId" value="${pres.presId}">
                                                    <input type="hidden" name="recordId" value="${record.recordId}">
                                                    <button type="submit" class="btn btn-reject" style="padding:5px 10px;">
                                                        <i class="fa-solid fa-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${record.apptStatus == 'Completed'}">
                                                <span style="color:#6b7280; font-style: italic;">Locked</span>
                                            </c:if>       
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
                <c:if test="${record.apptStatus == 'Completed'}">
                    <div style="margin-top: 12px; color:#6b7280; font-style: italic;">
                        Appointment completed. Prescription editing is locked.
                    </div>
                </c:if>
                <div style="display:flex; gap:10px; margin-top: 20px;">
                    <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                       href="${pageContext.request.contextPath}/veterinarian/emr/records">Back to Records</a>
                    <a class="btn btn-approve" style="text-decoration:none;"
                       href="${pageContext.request.contextPath}/veterinarian/emr/detail?recordId=${record.recordId}">View Record Detail</a>
                </div>
            </div>
        </main>
    <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>


