<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>ThÃƒÂªm ThÃƒÂº CÃ†Â°ng - VetCare Pro</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Custom CSS -->
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assets/css/pages/myPetOwner.css" rel="stylesheet" type="text/css"/>
    </head>
    <body class="bg-light">
        <div class="container" style="max-width: 800px; padding-top: 30px; padding-bottom: 50px;">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="text-primary fw-bold"><i class="fa-solid fa-paw me-2"></i> ThÃƒÂªm ThÃƒÂº CÃ†Â°ng</h2>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/myPetOwner">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lÃ¡ÂºÂ¡i
                </a>
            </div>

            <!-- Error Alert -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Form -->
            <div class="card shadow border-0 rounded-3">
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/pet/add" method="post">

                        <!-- 1. TÃƒÂªn -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">TÃƒÂªn thÃƒÂº cÃ†Â°ng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" value="${name}" maxlength="100" placeholder="VÃƒÂ­ dÃ¡Â»Â¥: Milo" required>
                        </div>

                        <!-- 2. LoÃƒÂ i & GiÃ¡Â»â€˜ng (CÃƒÂ¹ng 1 hÃƒÂ ng) -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">ChÃ¡Â»Â§ng loÃ¡ÂºÂ¡i (Species) <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="species" value="${species}" maxlength="50" placeholder="VÃƒÂ­ dÃ¡Â»Â¥: ChÃƒÂ³, MÃƒÂ¨o" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">GiÃ¡Â»â€˜ng loÃƒÂ i (Breed) <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="breed" value="${breed}" maxlength="100" placeholder="VÃƒÂ­ dÃ¡Â»Â¥: Golden, Poodle" required>
                            </div>
                        </div>

                        <!-- 3. GiÃ¡Â»â€ºi tÃƒÂ­nh & NgÃƒÂ y sinh (CÃƒÂ¹ng 1 hÃƒÂ ng) -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">GiÃ¡Â»â€ºi tÃƒÂ­nh <span class="text-danger">*</span></label>
                                <select class="form-select" name="gender" required>
                                    <option value="" disabled ${empty gender ? 'selected' : ''}>-- ChÃ¡Â»Ân giÃ¡Â»â€ºi tÃƒÂ­nh --</option>
                                    <option value="Male" ${gender == 'Male' ? 'selected' : ''}>Male)</option>
                                    <option value="Female" ${gender == 'Female' ? 'selected' : ''}>(Female)</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">NgÃƒÂ y sinh <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" name="birthDate" value="${birthDate}" required>
                            </div>
                        </div>

                        <!-- 4. CÃƒÂ¢n nÃ¡ÂºÂ·ng -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">CÃƒÂ¢n nÃ¡ÂºÂ·ng (kg) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="number" step="0.1" min="0.1" class="form-control" name="weight" value="${weight}" placeholder="0.0" required>
                                    <span class="input-group-text">kg</span>
                                </div>
                            </div>
                        </div>

                        <!-- 5. BÃ¡Â»â€¡nh sÃ¡Â»Â­ -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">TÃƒÂ³m tÃ¡ÂºÂ¯t bÃ¡Â»â€¡nh sÃ¡Â»Â­ (NÃ¡ÂºÂ¿u cÃƒÂ³)</label>
                            <textarea class="form-control" name="history" rows="4" maxlength="2000" placeholder="TiÃ¡Â»Ân sÃ¡Â»Â­ bÃ¡Â»â€¡nh, dÃ¡Â»â€¹ Ã¡Â»Â©ng...">${history}</textarea>
                            <div class="form-text text-muted">TÃ¡Â»â€˜i Ã„â€˜a 2000 kÃƒÂ½ tÃ¡Â»Â±.</div>
                        </div>

                        <!-- Submit Button -->
                        <div class="d-grid gap-2">
                            <button class="btn btn-primary btn-lg fw-bold" type="submit">
                                <i class="fa-solid fa-plus-circle me-2"></i> TÃ¡ÂºÂ¡o hÃ¡Â»â€œ sÃ†Â¡ thÃƒÂº cÃ†Â°ng
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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