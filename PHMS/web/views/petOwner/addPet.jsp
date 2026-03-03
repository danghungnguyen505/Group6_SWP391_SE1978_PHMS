<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Thú Cưng - VetCare Pro</title>
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
                <h2 class="text-primary fw-bold"><i class="fa-solid fa-paw me-2"></i> Thêm Thú Cưng</h2>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/myPetOwner">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại
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

                        <!-- 1. Tên -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên thú cưng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" value="${name}" maxlength="100" placeholder="Ví dụ: Milo" required>
                        </div>

                        <!-- 2. Loài & Giống (Cùng 1 hàng) -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Chủng loại (Species) <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="species" value="${species}" maxlength="50" placeholder="Ví dụ: Chó, Mèo" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Giống loài (Breed) <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="breed" value="${breed}" maxlength="100" placeholder="Ví dụ: Golden, Poodle" required>
                            </div>
                        </div>

                        <!-- 3. Giới tính & Ngày sinh (Cùng 1 hàng) -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Giới tính <span class="text-danger">*</span></label>
                                <select class="form-select" name="gender" required>
                                    <option value="" disabled ${empty gender ? 'selected' : ''}>-- Chọn giới tính --</option>
                                    <option value="Male" ${gender == 'Male' ? 'selected' : ''}>Male)</option>
                                    <option value="Female" ${gender == 'Female' ? 'selected' : ''}>(Female)</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Ngày sinh <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" name="birthDate" value="${birthDate}" required>
                            </div>
                        </div>

                        <!-- 4. Cân nặng -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Cân nặng (kg) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="number" step="0.1" min="0.1" class="form-control" name="weight" value="${weight}" placeholder="0.0" required>
                                    <span class="input-group-text">kg</span>
                                </div>
                            </div>
                        </div>

                        <!-- 5. Bệnh sử -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Tóm tắt bệnh sử (Nếu có)</label>
                            <textarea class="form-control" name="history" rows="4" maxlength="2000" placeholder="Tiền sử bệnh, dị ứng...">${history}</textarea>
                            <div class="form-text text-muted">Tối đa 2000 ký tự.</div>
                        </div>

                        <!-- Submit Button -->
                        <div class="d-grid gap-2">
                            <button class="btn btn-primary btn-lg fw-bold" type="submit">
                                <i class="fa-solid fa-plus-circle me-2"></i> Tạo hồ sơ thú cưng
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>