<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${t_add_pet} - VetCare Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
    <link href="${pageContext.request.contextPath}/assets/css/pages/myPetOwner.css" rel="stylesheet" type="text/css"/>
    <style>
        .add-pet-card {
            max-width: 860px;
            margin: 0 auto;
            border: none;
            border-radius: 14px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, .08);
        }
        .required-mark {
            color: #ef4444;
        }
    </style>
</head>
<body>
    <jsp:include page="nav/navPetOwner.jsp" />

    <main class="main-content">
        <div style="display:flex; justify-content:flex-end; margin-bottom:20px;">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color:#ef4444; border-color:#ef4444;">
                ${t_logout}
            </a>
        </div>

        <div class="page-header">
            <div class="page-title">
                <h1>${t_add_pet}</h1>
                <p>${L == 'en' ? 'Create a profile for your pet.' : 'Tạo hồ sơ mới cho thú cưng của bạn.'}</p>
            </div>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/myPetOwner">
                <i class="fa-solid fa-arrow-left me-1"></i> ${t_back}
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card add-pet-card">
            <div class="card-body p-4 p-lg-5">
                <form action="${pageContext.request.contextPath}/pet/add" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-bold">${L == 'en' ? 'Pet Name' : 'Tên thú cưng'} <span class="required-mark">*</span></label>
                        <input type="text" class="form-control" name="name" value="${name}" maxlength="100"
                               placeholder="${L == 'en' ? 'e.g. Milo' : 'Ví dụ: Milo'}" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">${t_species} <span class="required-mark">*</span></label>
                            <input type="text" class="form-control" name="species" value="${species}" maxlength="50"
                                   placeholder="${L == 'en' ? 'e.g. Dog, Cat' : 'Ví dụ: Chó, Mèo'}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">${t_breed} <span class="required-mark">*</span></label>
                            <input type="text" class="form-control" name="breed" value="${breed}" maxlength="100"
                                   placeholder="${L == 'en' ? 'e.g. Golden, Poodle' : 'Ví dụ: Golden, Poodle'}" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">${t_gender} <span class="required-mark">*</span></label>
                            <select class="form-select" name="gender" required>
                                <option value="" disabled ${empty gender ? 'selected' : ''}>${L == 'en' ? '-- Select gender --' : '-- Chọn giới tính --'}</option>
                                <option value="Male" ${gender == 'Male' ? 'selected' : ''}>${L == 'en' ? 'Male' : 'Đực'}</option>
                                <option value="Female" ${gender == 'Female' ? 'selected' : ''}>${L == 'en' ? 'Female' : 'Cái'}</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">${t_birth_date} <span class="required-mark">*</span></label>
                            <input type="date" class="form-control" name="birthDate" value="${birthDate}" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">${t_weight} (kg) <span class="required-mark">*</span></label>
                            <div class="input-group">
                                <input type="number" step="0.1" min="0.1" class="form-control" name="weight" value="${weight}" placeholder="0.0" required>
                                <span class="input-group-text">kg</span>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">${L == 'en' ? 'Medical History Summary (Optional)' : 'Tóm tắt tiền sử bệnh (Nếu có)'}</label>
                        <textarea class="form-control" name="history" rows="4" maxlength="2000"
                                  placeholder="${L == 'en' ? 'Previous illness history, allergies...' : 'Tiền sử bệnh, dị ứng...'}">${history}</textarea>
                        <div class="form-text text-muted">${L == 'en' ? 'Maximum 2000 characters.' : 'Tối đa 2000 ký tự.'}</div>
                    </div>

                    <div class="d-grid">
                        <button class="btn btn-primary btn-lg fw-bold" type="submit">
                            <i class="fa-solid fa-plus-circle me-2"></i> ${L == 'en' ? 'Create Pet Profile' : 'Tạo hồ sơ thú cưng'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
    window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>
