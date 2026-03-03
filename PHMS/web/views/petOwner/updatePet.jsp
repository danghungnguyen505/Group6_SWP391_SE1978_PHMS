<<<<<<< Updated upstream
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Pet - VetCare Pro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/assets/css/pages/myPetOwner.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <div class="container" style="max-width: 720px; padding-top: 30px;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px;">
                <h2 style="margin:0;"><i class="fa-solid fa-pen"></i> Update Pet</h2>
                <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/myPetOwner?selectedPetId=${pet.id}" style="text-decoration:none;">
                    <i class="fa-solid fa-arrow-left"></i> Back
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <c:if test="${empty pet}">
                <div class="alert alert-warning">Pet not found.</div>
            </c:if>

            <c:if test="${not empty pet}">
                <form action="${pageContext.request.contextPath}/pet/update" method="post" class="card p-3">
                    <input type="hidden" name="petId" value="${pet.id}">
                    <div class="mb-3">
                        <label class="form-label">Pet Name</label>
                        <input class="form-control" name="name" value="${pet.name}" maxlength="100" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Species</label>
                        <input class="form-control" name="species" value="${pet.species}" maxlength="50" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">History Summary</label>
                        <textarea class="form-control" name="history" rows="4" maxlength="2000">${pet.historySummary}</textarea>
                    </div>
                    <button class="btn btn-primary" type="submit">
                        <i class="fa-solid fa-save"></i> Save
                    </button>
                </form>
            </c:if>
        </div>
    </body>
</html>

=======
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
                <!-- Nút quay lại truyền selectedPetId để giữ highlight bên trang list -->
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

                            <!-- Hidden ID (QUAN TRỌNG) -->
                            <input type="hidden" name="petId" value="${pet.id}">

                            <!-- 1. Tên thú cưng -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">Pet Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="name" value="${pet.name}" maxlength="100" required>
                            </div>

                            <!-- 2. Loài & Giống (2 cột) -->
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

                            <!-- 3. Giới tính & Ngày sinh (2 cột) -->
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
                                    <!-- Ưu tiên hiển thị rawDob nếu có lỗi nhập liệu, nếu không thì lấy từ DB -->
                                    <input type="date" class="form-control" name="birthDate" 
                                           value="${not empty rawDob ? rawDob : pet.birthDate}" required>
                                </div>
                            </div>

                            <!-- 4. Cân nặng -->
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Weight (kg) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <!-- Ưu tiên hiển thị rawWeight nếu có lỗi -->
                                        <input type="number" step="0.1" min="0.1" class="form-control" name="weight" 
                                               value="${not empty rawWeight ? rawWeight : pet.weight}" required>
                                        <span class="input-group-text">kg</span>
                                    </div>
                                </div>
                            </div>

                            <!-- 5. Tiền sử bệnh -->
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
    </body>
</html>
>>>>>>> Stashed changes
