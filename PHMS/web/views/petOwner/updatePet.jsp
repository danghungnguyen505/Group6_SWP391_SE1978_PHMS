<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Pet - VetCare Pro</title>
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
                <h2 class="text-primary fw-bold"><i class="fa-solid fa-pen-to-square me-2"></i> Update Pet Profile</h2>
                <!-- NÃƒÂºt quay lÃ¡ÂºÂ¡i truyÃ¡Â»Ân selectedPetId Ã„â€˜Ã¡Â»Æ’ giÃ¡Â»Â¯ highlight bÃƒÂªn trang list -->
                <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/myPetOwner?selectedPetId=${pet.id}" style="text-decoration:none;">
                    <i class="fa-solid fa-arrow-left me-1"></i> Back
                </a>
            </div>

            <!-- Error Notification -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> <strong>Error:</strong> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Case: Pet not found -->
            <c:if test="${empty pet}">
                <div class="alert alert-warning">
                    <i class="fa-solid fa-triangle-exclamation"></i> Pet information not found.
                </div>
            </c:if>

            <!-- Form Update -->
            <c:if test="${not empty pet}">
                <div class="card shadow border-0 rounded-3">
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/pet/update" method="post">

                            <!-- Hidden ID (QUAN TRÃ¡Â»Å’NG) -->
                            <input type="hidden" name="petId" value="${pet.id}">

                            <!-- 1. TÃƒÂªn thÃƒÂº cÃ†Â°ng -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">Pet Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="name" value="${pet.name}" maxlength="100" required>
                            </div>

                            <!-- 2. LoÃƒÂ i & GiÃ¡Â»â€˜ng (2 cÃ¡Â»â„¢t) -->
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Species <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="species" value="${pet.species}" maxlength="50" placeholder="e.g. Dog, Cat" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Breed <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="breed" value="${pet.breed}" maxlength="100" placeholder="e.g. Golden Retriever" required>
                                </div>
                            </div>

                            <!-- 3. GiÃ¡Â»â€ºi tÃƒÂ­nh & NgÃƒÂ y sinh (2 cÃ¡Â»â„¢t) -->
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Gender <span class="text-danger">*</span></label>
                                    <select class="form-select" name="gender" required>
                                        <option value="" disabled>-- Select Gender --</option>
                                        <option value="Male" ${pet.gender == 'Male' ? 'selected' : ''}>Male</option>
                                        <option value="Female" ${pet.gender == 'Female' ? 'selected' : ''}>Female</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Birth Date <span class="text-danger">*</span></label>
                                    <!-- Ã†Â¯u tiÃƒÂªn hiÃ¡Â»Æ’n thÃ¡Â»â€¹ rawDob nÃ¡ÂºÂ¿u cÃƒÂ³ lÃ¡Â»â€”i nhÃ¡ÂºÂ­p liÃ¡Â»â€¡u, nÃ¡ÂºÂ¿u khÃƒÂ´ng thÃƒÂ¬ lÃ¡ÂºÂ¥y tÃ¡Â»Â« DB -->
                                    <input type="date" class="form-control" name="birthDate" 
                                           value="${not empty rawDob ? rawDob : pet.birthDate}" required>
                                </div>
                            </div>

                            <!-- 4. CÃƒÂ¢n nÃ¡ÂºÂ·ng -->
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Weight (kg) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <!-- Ã†Â¯u tiÃƒÂªn hiÃ¡Â»Æ’n thÃ¡Â»â€¹ rawWeight nÃ¡ÂºÂ¿u cÃƒÂ³ lÃ¡Â»â€”i -->
                                        <input type="number" step="0.1" min="0.1" class="form-control" name="weight" 
                                               value="${not empty rawWeight ? rawWeight : pet.weight}" required>
                                        <span class="input-group-text">kg</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 5. TiÃ¡Â»Ân sÃ¡Â»Â­ bÃ¡Â»â€¡nh -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">History Summary</label>
                                <textarea class="form-control" name="history" rows="4" maxlength="2000" placeholder="Medical history notes...">${pet.historySummary}</textarea>
                                <div class="form-text text-muted">Max 2000 characters.</div>
                            </div>

                            <!-- Submit Button -->
                            <div class="d-grid gap-2">
                                <button class="btn btn-primary btn-lg fw-bold" type="submit">
                                    <i class="fa-solid fa-floppy-disk me-2"></i> Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:if>
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