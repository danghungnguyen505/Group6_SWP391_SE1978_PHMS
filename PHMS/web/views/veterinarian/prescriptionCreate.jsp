<<<<<<< Updated upstream
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Create Prescription</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <style>
            .prescription-item {
                border: 1px solid #e5e7eb;
                padding: 15px;
                margin-bottom: 15px;
                border-radius: 8px;
                background: #f9fafb;
            }
            .prescription-item-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
            }
            .btn-remove-item {
                background: #ef4444;
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 4px;
                cursor: pointer;
            }
            .btn-add-item {
                background: #10b981;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/queue">
                        <i class="fa-solid fa-stethoscope"></i> EMR Queue</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/records">
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
                    <h2>Create Prescription</h2>
                    <p>Prescribe medicines for medical record #${record.recordId}</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Medical Record Information</span>
                </div>
                <c:if test="${not empty record}">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <div><b>Record ID:</b> #${record.recordId}</div>
                        <div><b>Pet:</b> ${record.petName}</div>
                        <div><b>Owner:</b> ${record.ownerName}</div>
                        <div><b>Date:</b> <fmt:formatDate value="${record.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </c:if>

                <c:if test="${not empty existingPrescriptions && existingPrescriptions.size() > 0}">
                    <div style="margin-top: 20px;">
                        <div class="section-title">
                            <span>Existing Prescriptions</span>
                        </div>
                        <table style="width:100%; margin-top:10px;">
                            <thead>
                                <tr style="background:#f3f4f6;">
                                    <th style="padding:8px; text-align:left;">Medicine</th>
                                    <th style="padding:8px; text-align:left;">Quantity</th>
                                    <th style="padding:8px; text-align:left;">Dosage</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pres" items="${existingPrescriptions}">
                                    <tr>
                                        <td style="padding:8px;">${pres.medicineName}</td>
                                        <td style="padding:8px;">${pres.quantity} ${pres.medicineUnit}</td>
                                        <td style="padding:8px;">${pres.dosage}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-top: 10px;">${error}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/veterinarian/prescription/create" id="prescriptionForm" style="margin-top: 20px;">
                    <input type="hidden" name="recordId" value="${record.recordId}">

                    <div class="section-title">
                        <span>Add Prescription Items</span>
                    </div>

                    <div id="prescriptionItems">
                        <div class="prescription-item" data-index="0">
                            <div class="prescription-item-header">
                                <strong>Medicine #1</strong>
                                <button type="button" class="btn-remove-item" onclick="removeItem(this)" style="display:none;">Remove</button>
                            </div>
                            <div style="display:grid; grid-template-columns: 2fr 1fr 2fr; gap: 10px;">
                                <div>
                                    <label><b>Medicine</b></label>
                                    <select name="medicineId" class="medicine-select" required style="width:100%; padding:8px;">
                                        <option value="">-- Select Medicine --</option>
                                        <c:forEach var="med" items="${medicines}">
                                            <option value="${med.medicineId}" data-stock="${med.stockQuantity}">${med.name} (Stock: ${med.stockQuantity} ${med.unit})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label><b>Quantity</b></label>
                                    <input type="number" name="quantity" min="1" max="1000" required style="width:100%; padding:8px;" placeholder="Qty">
                                </div>
                                <div>
                                    <label><b>Dosage</b></label>
                                    <input type="text" name="dosage" maxlength="100" required style="width:100%; padding:8px;" placeholder="e.g., 1 tablet, 2 times/day">
                                </div>
                            </div>
                        </div>
                    </div>

                    <button type="button" class="btn-add-item" onclick="addItem()">
                        <i class="fa-solid fa-plus"></i> Add Another Medicine
                    </button>

                    <div style="display:flex; gap:10px; margin-top: 20px;">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/veterinarian/emr/records">Back</a>
                        <button type="submit" class="btn btn-approve">
                            <i class="fa-solid fa-save"></i> Save Prescription
                        </button>
                    </div>
                </form>
            </div>
        </main>

        <script>
            let itemCount = 1;
            
            function addItem() {
                const container = document.getElementById('prescriptionItems');
                const newItem = document.createElement('div');
                newItem.className = 'prescription-item';
                newItem.setAttribute('data-index', itemCount);
                newItem.innerHTML = `
                    <div class="prescription-item-header">
                        <strong>Medicine #${itemCount + 1}</strong>
                        <button type="button" class="btn-remove-item" onclick="removeItem(this)">Remove</button>
                    </div>
                    <div style="display:grid; grid-template-columns: 2fr 1fr 2fr; gap: 10px;">
                        <div>
                            <label><b>Medicine</b></label>
                            <select name="medicineId" class="medicine-select" required style="width:100%; padding:8px;">
                                <option value="">-- Select Medicine --</option>
                                <c:forEach var="med" items="${medicines}">
                                    <option value="${med.medicineId}" data-stock="${med.stockQuantity}">${med.name} (Stock: ${med.stockQuantity} ${med.unit})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label><b>Quantity</b></label>
                            <input type="number" name="quantity" min="1" max="1000" required style="width:100%; padding:8px;" placeholder="Qty">
                        </div>
                        <div>
                            <label><b>Dosage</b></label>
                            <input type="text" name="dosage" maxlength="100" required style="width:100%; padding:8px;" placeholder="e.g., 1 tablet, 2 times/day">
                        </div>
                    </div>
                `;
                container.appendChild(newItem);
                itemCount++;
            }
            
            function removeItem(btn) {
                const item = btn.closest('.prescription-item');
                item.remove();
            }
            
            document.getElementById('prescriptionForm').addEventListener('submit', function(e) {
                const items = document.querySelectorAll('.prescription-item');
                if (items.length === 0) {
                    e.preventDefault();
                    alert('Vui lòng thêm ít nhất một loại thuốc.');
                    return;
                }
            });
        </script>
    </body>
</html>
=======
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Create Prescription</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/receptionistDashboard.css">
        <style>
            .prescription-item {
                border: 1px solid #e5e7eb;
                padding: 15px;
                margin-bottom: 15px;
                border-radius: 8px;
                background: #f9fafb;
            }
            .prescription-item-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
            }
            .btn-remove-item {
                background: #ef4444;
                color: white;
                border: none;
                padding: 5px 10px;
                border-radius: 4px;
                cursor: pointer;
            }
            .btn-add-item {
                background: #10b981;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-plus-square"></i> VetCare Pro
            </div>
            <ul class="menu">
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/queue">
                        <i class="fa-solid fa-stethoscope"></i> EMR Queue</a></li>
                <li><a href="${pageContext.request.contextPath}/veterinarian/emr/records">
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
                    <h2>Create Prescription</h2>
                    <p>Prescribe medicines for medical record #${record.recordId}</p>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-signout">Sign Out</a>
            </div>

            <div class="card">
                <div class="section-title">
                    <span>Medical Record Information</span>
                </div>
                <c:if test="${not empty record}">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <div><b>Record ID:</b> #${record.recordId}</div>
                        <div><b>Pet:</b> ${record.petName}</div>
                        <div><b>Owner:</b> ${record.ownerName}</div>
                        <div><b>Date:</b> <fmt:formatDate value="${record.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </c:if>

                <c:if test="${not empty existingPrescriptions && existingPrescriptions.size() > 0}">
                    <div style="margin-top: 20px;">
                        <div class="section-title">
                            <span>Existing Prescriptions</span>
                        </div>
                        <table style="width:100%; margin-top:10px;">
                            <thead>
                                <tr style="background:#f3f4f6;">
                                    <th style="padding:8px; text-align:left;">Medicine</th>
                                    <th style="padding:8px; text-align:left;">Quantity</th>
                                    <th style="padding:8px; text-align:left;">Dosage</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pres" items="${existingPrescriptions}">
                                    <tr>
                                        <td style="padding:8px;">${pres.medicineName}</td>
                                        <td style="padding:8px;">${pres.quantity} ${pres.medicineUnit}</td>
                                        <td style="padding:8px;">${pres.dosage}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-top: 10px;">${error}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/veterinarian/prescription/create" id="prescriptionForm" style="margin-top: 20px;">
                    <input type="hidden" name="recordId" value="${record.recordId}">

                    <div class="section-title">
                        <span>Add Prescription Items</span>
                    </div>

                    <div id="prescriptionItems">
                        <div class="prescription-item" data-index="0">
                            <div class="prescription-item-header">
                                <strong>Medicine #1</strong>
                                <button type="button" class="btn-remove-item" onclick="removeItem(this)" style="display:none;">Remove</button>
                            </div>
                            <div style="display:grid; grid-template-columns: 2fr 1fr 2fr; gap: 10px;">
                                <div>
                                    <label><b>Medicine</b></label>
                                    <select name="medicineId" class="medicine-select" required style="width:100%; padding:8px;">
                                        <option value="">-- Select Medicine --</option>
                                        <c:forEach var="med" items="${medicines}">
                                            <option value="${med.medicineId}" data-stock="${med.stockQuantity}">${med.name} (Stock: ${med.stockQuantity} ${med.unit})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label><b>Quantity</b></label>
                                    <input type="number" name="quantity" min="1" max="1000" required style="width:100%; padding:8px;" placeholder="Qty">
                                </div>
                                <div>
                                    <label><b>Dosage</b></label>
                                    <input type="text" name="dosage" maxlength="100" required style="width:100%; padding:8px;" placeholder="e.g., 1 tablet, 2 times/day">
                                </div>
                            </div>
                        </div>
                    </div>

                    <button type="button" class="btn-add-item" onclick="addItem()">
                        <i class="fa-solid fa-plus"></i> Add Another Medicine
                    </button>

                    <div style="display:flex; gap:10px; margin-top: 20px;">
                        <a class="btn btn-reject" style="text-decoration:none; background:#e5e7eb;color:#111827;"
                           href="${pageContext.request.contextPath}/veterinarian/emr/records">Back</a>
                        <button type="submit" class="btn btn-approve">
                            <i class="fa-solid fa-save"></i> Save Prescription
                        </button>
                    </div>
                </form>
            </div>
        </main>

        <script>
            let itemCount = 1;
            
            function addItem() {
                const container = document.getElementById('prescriptionItems');
                const newItem = document.createElement('div');
                newItem.className = 'prescription-item';
                newItem.setAttribute('data-index', itemCount);
                newItem.innerHTML = `
                    <div class="prescription-item-header">
                        <strong>Medicine #${itemCount + 1}</strong>
                        <button type="button" class="btn-remove-item" onclick="removeItem(this)">Remove</button>
                    </div>
                    <div style="display:grid; grid-template-columns: 2fr 1fr 2fr; gap: 10px;">
                        <div>
                            <label><b>Medicine</b></label>
                            <select name="medicineId" class="medicine-select" required style="width:100%; padding:8px;">
                                <option value="">-- Select Medicine --</option>
                                <c:forEach var="med" items="${medicines}">
                                    <option value="${med.medicineId}" data-stock="${med.stockQuantity}">${med.name} (Stock: ${med.stockQuantity} ${med.unit})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label><b>Quantity</b></label>
                            <input type="number" name="quantity" min="1" max="1000" required style="width:100%; padding:8px;" placeholder="Qty">
                        </div>
                        <div>
                            <label><b>Dosage</b></label>
                            <input type="text" name="dosage" maxlength="100" required style="width:100%; padding:8px;" placeholder="e.g., 1 tablet, 2 times/day">
                        </div>
                    </div>
                `;
                container.appendChild(newItem);
                itemCount++;
            }
            
            function removeItem(btn) {
                const item = btn.closest('.prescription-item');
                item.remove();
            }
            
            document.getElementById('prescriptionForm').addEventListener('submit', function(e) {
                const items = document.querySelectorAll('.prescription-item');
                if (items.length === 0) {
                    e.preventDefault();
                    alert('Vui lòng thêm ít nhất một loại thuốc.');
                    return;
                }
            });
        </script>
    </body>
</html>
>>>>>>> Stashed changes
