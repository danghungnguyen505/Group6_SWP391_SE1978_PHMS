<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>VetCare Pro - EMR Edit</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/views/veterinarian/nav/navVeterinarian.css">
        <style>
            :root {
                --primary: #10b981;
                --primary-light: #d1fae5;
                --bg: #f8fafc;
                --card-shadow: 0 4px 20px -2px rgba(0,0,0,0.06);
                --text-main: #1e293b;
                --text-muted: #64748b;
            }
            body { background: var(--bg); font-family: 'Inter', sans-serif; }
            .main-content { padding: 32px 40px; }

            .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }
            .page-header h2 { font-size: 22px; font-weight: 800; color: var(--text-main); margin-bottom: 4px; }
            .page-header p { color: var(--text-muted); font-size: 14px; }
            .btn-back { display: inline-flex; align-items: center; gap: 8px; padding: 10px 18px; border-radius: 10px; background: #fff; border: 1px solid #e2e8f0; color: var(--text-muted); font-weight: 600; font-size: 13px; text-decoration: none; transition: 0.2s; }
            .btn-back:hover { background: #f1f5f9; color: var(--text-main); }

            .content-grid { display: grid; grid-template-columns: 1fr 1.5fr; gap: 24px; }

            .card { background: #fff; border-radius: 20px; box-shadow: var(--card-shadow); overflow: hidden; }
            .card-header { padding: 20px 24px; border-bottom: 1px solid #f1f5f9; display: flex; align-items: center; gap: 12px; }
            .card-header i { font-size: 20px; color: var(--primary); }
            .card-header h3 { font-size: 15px; font-weight: 800; color: var(--text-main); }
            .card-body { padding: 24px; }

            .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
            .info-item { }
            .info-label { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
            .info-value { font-size: 14px; font-weight: 600; color: var(--text-main); }

            .pet-info { display: flex; align-items: center; gap: 16px; padding: 16px; background: #f8fafc; border-radius: 12px; margin-bottom: 20px; }
            .pet-avatar { width: 56px; height: 56px; border-radius: 50%; background: linear-gradient(135deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: #fff; font-size: 24px; font-weight: 800; }
            .pet-details h4 { font-size: 16px; font-weight: 700; color: var(--text-main); margin-bottom: 2px; }
            .pet-details p { font-size: 13px; color: var(--text-muted); }

            .form-group { margin-bottom: 18px; }
            .form-label { display: block; font-size: 12px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
            .form-input, .form-textarea { width: 100%; padding: 12px 16px; border: 1px solid #e2e8f0; border-radius: 10px; font-family: 'Inter', sans-serif; font-size: 14px; color: var(--text-main); transition: 0.2s; }
            .form-input:focus, .form-textarea:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1); }
            .form-textarea { resize: vertical; min-height: 120px; }

            .btn-group { display: flex; gap: 12px; margin-top: 24px; }
            .btn { display: inline-flex; align-items: center; gap: 8px; padding: 12px 20px; border-radius: 10px; font-size: 13px; font-weight: 700; text-decoration: none; cursor: pointer; transition: 0.2s; border: none; }
            .btn-primary { background: var(--primary); color: #fff; }
            .btn-primary:hover { background: #059669; }
            .btn-secondary { background: #f1f5f9; color: var(--text-muted); }
            .btn-secondary:hover { background: #e2e8f0; }
            .btn-danger { background: #fee2e2; color: #dc2626; }
            .btn-danger:hover { background: #fecaca; }

            .status-badge { display: inline-flex; align-items: center; gap: 6px; padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
            .badge-confirmed { background: #d1fae5; color: #065f46; }
            .badge-checked { background: #dbeafe; color: #1e40af; }
            .badge-progress { background: #fef3c7; color: #92400e; }

            .quick-notes { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
            .quick-note { padding: 6px 12px; background: #f1f5f9; border-radius: 6px; font-size: 12px; color: var(--text-muted); cursor: pointer; transition: 0.2s; }
            .quick-note:hover { background: #e2e8f0; color: var(--text-main); }
        </style>
    </head>
    <body>
        <jsp:include page="nav/navVeterinarian.jsp" />

        <main class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <div class="page-header">
                    <h2><i class="fa-solid fa-file-medical" style="color:#10b981; margin-right:8px;"></i>Edit Appointment</h2>
                    <p>Review and update patient information</p>
                </div>
                <a href="${pageContext.request.contextPath}/veterinarian/emr/queue" class="btn-back">
                    <i class="fa-solid fa-arrow-left"></i> Back to Queue
                </a>
            </div>

            <div class="content-grid">
                <!-- Left: Appointment Info -->
                <div class="card">
                    <div class="card-header">
                        <i class="fa-solid fa-circle-info"></i>
                        <h3>Appointment Information</h3>
                    </div>
                    <div class="card-body">
                        <div class="pet-info">
                            <div class="pet-avatar">
                                <i class="fa-solid fa-paw"></i>
                            </div>
                            <div class="pet-details">
                                <h4>${appt.petName}</h4>
                                <p>Owner: ${appt.ownerName}</p>
                            </div>
                        </div>

                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Appointment ID</div>
                                <div class="info-value">#${appt.apptId}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Service Type</div>
                                <div class="info-value">${appt.type}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Date & Time</div>
                                <div class="info-value"><fmt:formatDate value="${appt.startTime}" pattern="dd/MM/yyyy HH:mm"/></div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Status</div>
                                <div class="info-value">
                                    <span class="status-badge badge-checked">
                                        <i class="fa-solid fa-check"></i> ${appt.status}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Edit Form -->
                <div class="card">
                    <div class="card-header">
                        <i class="fa-solid fa-pen-to-square"></i>
                        <h3>Edit Notes</h3>
                    </div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/veterinarian/emr/queue/edit">
                            <input type="hidden" name="apptId" value="${appt.apptId}" />

                            <div class="form-group">
                                <label class="form-label">Appointment Notes</label>
                                <textarea name="notes" class="form-textarea" placeholder="Enter notes for this appointment...">${appt.notes}</textarea>
                                <div class="quick-notes">
                                    <span class="quick-note" onclick="addNote('General checkup')">General checkup</span>
                                    <span class="quick-note" onclick="addNote('Follow-up visit')">Follow-up</span>
                                    <span class="quick-note" onclick="addNote('Vaccination due')">Vaccination</span>
                                    <span class="quick-note" onclick="addNote('Lab tests required')">Lab tests</span>
                                </div>
                            </div>

                            <div class="btn-group">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa-solid fa-floppy-disk"></i> Save Changes
                                </button>
                                <a href="${pageContext.request.contextPath}/veterinarian/emr/create?apptId=${appt.apptId}" class="btn btn-secondary">
                                    <i class="fa-solid fa-file-medical"></i> Create EMR
                                </a>
                                <a href="${pageContext.request.contextPath}/veterinarian/emr/queue" class="btn btn-secondary">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <script>
            function addNote(text) {
                var textarea = document.querySelector('textarea[name="notes"]');
                textarea.value = textarea.value ? textarea.value + '\n' + text : text;
                textarea.focus();
            }
        </script>
    <div class="phms-account-entry" style="position:fixed; top:16px; right:20px; z-index:1200;">
    <a href="${pageContext.request.contextPath}/logout" style="display:inline-flex;align-items:center;gap:6px;padding:8px 14px;border:1px solid #e2e8f0;border-radius:10px;background:#fff;color:#334155;text-decoration:none;font-size:13px;font-weight:700;box-shadow:0 2px 10px rgba(0,0,0,.05);">Sign Out</a>
</div>
<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>
