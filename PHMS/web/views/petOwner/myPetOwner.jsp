<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>

                <!DOCTYPE html>
                <html lang="${L}">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>${t_my_pets} - VetCare Pro</title>
                    <!-- Bootstrap 5 -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <!-- Font Awesome -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <!-- Custom CSS -->
                    <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet"
                        type="text/css" />
                    <link href="${pageContext.request.contextPath}/assets/css/pages/myPetOwner.css" rel="stylesheet"
                        type="text/css" />

                    <style>
                        /* --- CSS CHO DÒNG ĐANG ĐƯỢC CHỌN --- */
                        .selected-row {
                            background-color: #e0f2fe !important;
                            /* Màu nền xanh nhạt */
                            border-left: 4px solid #0d6efd;
                            /* Viền đậm bên trái */
                        }

                        /* Giữ màu khi hover */
                        .table-hover tbody tr.selected-row:hover {
                            background-color: #bae6fd !important;
                        }

                        /* Chỉnh lại bảng cho đẹp hơn */
                        .table td {
                            vertical-align: middle;
                        }
                    </style>
                </head>

                <body>

                    <!-- SIDEBAR (shared navigation for PetOwner) -->
                    <jsp:include page="nav/navPetOwner.jsp" />

                    <!-- MAIN CONTENT -->
                    <main class="main-content">

                        <!-- Toast Notification -->
                        <c:if test="${not empty toastMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fa-solid fa-check-circle me-2"></i> ${toastMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Error Notification -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fa-solid fa-circle-exclamation me-2"></i> ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <div style="display: flex; justify-content: flex-end; margin-bottom: 20px;">
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark"
                                style="background-color: #ef4444; border-color: #ef4444;">${t_logout}</a>
                        </div>

                        <div class="pet-header">
                            <div>
                                <h1>${t_pet_profile}</h1>
                                <p>${t_pet_profile_sub}</p>
                            </div>

                            <!-- Dropdown chọn nhanh -->
                            <form method="get" action="${pageContext.request.contextPath}/myPetOwner">
                                <c:if test="${not empty search}">
                                    <input type="hidden" name="search" value="${search}">
                                </c:if>
                                <select class="switch-pet-dropdown" name="selectedPetId" onchange="this.form.submit()">
                                    <c:if test="${empty allPets}">
                                        <option value="">${t_no_pets_found}</option>
                                    </c:if>
                                    <c:forEach items="${allPets}" var="p">
                                        <option value="${p.id}" ${selectedPet !=null && selectedPet.id==p.id
                                            ? 'selected' : '' }>
                                            ${p.name} (${p.species})
                                        </option>
                                    </c:forEach>
                                </select>
                            </form>
                        </div>

                        <div class="pet-dashboard-grid">

                            <!-- [LEFT COLUMN] Selected Pet Details -->
                            <div class="left-col">
                                <div class="pet-card">

                                    <!-- Nút Edit nhanh -->
                                    <div style="text-align: right; margin-bottom: -10px;">
                                        <c:if test="${not empty selectedPet}">
                                            <a href="${pageContext.request.contextPath}/pet/update?id=${selectedPet.id}"
                                                class="text-secondary" title="Edit details">
                                                <i class="fa-solid fa-pen-to-square fa-lg"></i>
                                            </a>
                                        </c:if>
                                    </div>

                                    <!-- Avatar -->
                                    <div class="pet-avatar-wrapper">
                                        <img src="https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                                            alt="Pet Avatar" class="pet-avatar">
                                        <div class="status-indicator"></div>
                                    </div>

                                    <!-- Tên & Loài -->
                                    <c:if test="${empty selectedPet}">
                                        <div class="pet-name">${t_no_pets}</div>
                                        <div class="pet-breed">${L == 'en' ? 'Add a pet or clear search' : 'Thêm thú cưng hoặc xóa tìm kiếm'}</div>
                                    </c:if>
                                    <c:if test="${not empty selectedPet}">
                                        <div class="pet-name">${selectedPet.name}</div>
                                        <div class="pet-breed text-primary">${selectedPet.species}</div>
                                    </c:if>

                                    <!-- Thông số chi tiết -->
                                    <div class="stats-grid">
                                        <div class="stat-box">
                                            <span class="stat-label">ID / Code</span>
                                            <div class="stat-value text-primary">#
                                                <c:out value="${selectedPet != null ? selectedPet.id : '-'}" />
                                            </div>
                                        </div>

                                        <div class="stat-box">
                                            <span class="stat-label">${t_breed}</span>
                                            <div class="stat-value">
                                                <c:out value="${selectedPet != null ? selectedPet.breed : '-'}" />
                                            </div>
                                        </div>

                                        <div class="stat-box">
                                            <span class="stat-label">${t_gender}</span>
                                            <div class="stat-value">
                                                <c:choose>
                                                    <c:when test="${selectedPet.gender == 'Male'}"><i
                                                            class="fa-solid fa-mars text-primary"></i> ${L == 'en' ?
                                                        'Male' : 'Đực'}</c:when>
                                                    <c:when test="${selectedPet.gender == 'Female'}"><i
                                                            class="fa-solid fa-venus text-danger"></i> ${L == 'en' ?
                                                        'Female' : 'Cái'}</c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="stat-box">
                                            <span class="stat-label">${t_weight}</span>
                                            <div class="stat-value">
                                                <c:out value="${selectedPet != null ? selectedPet.weight : '0'}" /> kg
                                            </div>
                                        </div>

                                        <div class="stat-box">
                                            <span class="stat-label">${t_birth_date}</span>
                                            <div class="stat-value">
                                                <c:if test="${selectedPet != null && selectedPet.birthDate != null}">
                                                    <fmt:formatDate value="${selectedPet.birthDate}"
                                                        pattern="dd/MM/yyyy" />
                                                </c:if>
                                                <c:if test="${selectedPet == null || selectedPet.birthDate == null}">-
                                                </c:if>
                                            </div>
                                        </div>

                                        <div class="stat-box">
                                            <span class="stat-label">${t_status}</span>
                                            <div class="stat-value text-success">${L == 'en' ? 'Active' : 'Hoạt động'}
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Bệnh sử -->
                                    <div class="alert-box">
                                        <div class="alert-title"><i class="fa-solid fa-notes-medical"></i>
                                            ${t_history_summary}</div>
                                        <div class="alert-content">
                                            <c:if test="${empty selectedPet || empty selectedPet.historySummary}">
                                                <span
                                                    style="color:#94a3b8; font-style: italic;">${t_no_history_sum}</span>
                                            </c:if>
                                            <c:if
                                                test="${not empty selectedPet && not empty selectedPet.historySummary}">
                                                <c:out value="${selectedPet.historySummary}" />
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- Nút Xóa -->
                                    <c:if test="${not empty selectedPet}">
                                        <c:set var="confirmMsg"
                                            value="${L == 'en' ? 'Are you sure you want to delete' : 'Bạn chắc chắn muốn xóa hồ sơ thú cưng'}" />
                                        <form action="${pageContext.request.contextPath}/pet/delete" method="post"
                                            style="margin-top: 15px; text-align: center;">
                                            <input type="hidden" name="id" value="${selectedPet.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger w-100"
                                                onclick="return confirm('${confirmMsg} ${selectedPet.name}?');">
                                                <i class="fa-solid fa-trash-can me-1"></i> ${t_delete_profile}
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>

                            <!-- [RIGHT COLUMN] List & Medical History -->
                            <div class="right-col">

                                <div class="history-section" style="margin-bottom: 20px;">

                                    <!-- Header & Search -->
                                    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                                        <h3 style="margin:0;">${t_pets_list}</h3>

                                        <div class="d-flex gap-2">
                                            <form action="${pageContext.request.contextPath}/myPetOwner" method="get"
                                                class="d-flex">
                                                <div class="input-group input-group-sm">
                                                    <input type="text" name="search" class="form-control"
                                                        placeholder="${t_search}" value="${search}">
                                                    <button class="btn btn-outline-primary" type="submit">
                                                        <i class="fa-solid fa-magnifying-glass"></i>
                                                    </button>
                                                    <c:if test="${not empty search}">
                                                        <a href="${pageContext.request.contextPath}/myPetOwner"
                                                            class="btn btn-outline-secondary" title="${t_cancel}">
                                                            <i class="fa-solid fa-xmark"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </form>
                                            <a class="btn btn-primary btn-sm d-flex align-items-center"
                                                href="${pageContext.request.contextPath}/pet/add">
                                                <i class="fa-solid fa-plus me-1"></i> ${t_add_pet}
                                            </a>
                                        </div>
                                    </div>

                                    <!-- Table List -->
                                    <c:if test="${empty pets}">
                                        <div class="text-center p-4 text-muted border rounded bg-light">
                                            <i class="fa-solid fa-box-open fa-2x mb-2"></i>
                                            <p class="mb-0">${t_no_pets_found}</p>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty pets}">
                                        <div class="table-responsive">
                                            <table class="history-table table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>${L == 'en' ? 'Name' : 'Tên'}</th>
                                                        <th>${t_species}</th>
                                                        <th class="text-end">${t_actions}</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${pets}" var="p">

                                                        <!-- LOGIC QUAN TRỌNG: Thêm class 'selected-row' nếu ID trùng -->
                                                        <tr
                                                            class="${selectedPet != null && selectedPet.id == p.id ? 'selected-row' : ''}">

                                                            <td>#${p.id}</td>
                                                            <td class="fw-bold">${p.name}</td>
                                                            <td>${p.species}</td>

                                                            <td class="text-end">
                                                                <!-- Nút View: Khi bấm vào sẽ reload trang với selectedPetId -->
                                                                <a class="btn btn-sm btn-outline-primary me-1"
                                                                    href="${pageContext.request.contextPath}/myPetOwner?selectedPetId=${p.id}&page=${currentPage}&search=${search}"
                                                                    title="View Details">
                                                                    <i class="fa-solid fa-eye"></i>
                                                                </a>

                                                                <!-- Nút Edit -->
                                                                <a class="btn btn-sm btn-outline-warning me-1"
                                                                    href="${pageContext.request.contextPath}/pet/update?id=${p.id}"
                                                                    title="Edit Info">
                                                                    <i class="fa-solid fa-pen"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Pagination -->
                                        <c:if test="${totalPages > 1}">
                                            <div class="d-flex justify-content-center mt-3">
                                                <nav aria-label="Page navigation">
                                                    <ul class="pagination pagination-sm">
                                                        <!-- Params cho phân trang để giữ highlight và search -->
                                                        <c:set var="searchParam"
                                                            value="${not empty search ? '&search='.concat(search) : ''}" />
                                                        <c:set var="selectedParam"
                                                            value="${selectedPet != null ? '&selectedPetId='.concat(selectedPet.id) : ''}" />

                                                        <c:if test="${currentPage > 1}">
                                                            <li class="page-item">
                                                                <a class="page-link"
                                                                    href="?page=${currentPage - 1}${searchParam}${selectedParam}">Prev</a>
                                                            </li>
                                                        </c:if>

                                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                                <a class="page-link"
                                                                    href="?page=${i}${searchParam}${selectedParam}">${i}</a>
                                                            </li>
                                                        </c:forEach>

                                                        <c:if test="${currentPage < totalPages}">
                                                            <li class="page-item">
                                                                <a class="page-link"
                                                                    href="?page=${currentPage + 1}${searchParam}${selectedParam}">Next</a>
                                                            </li>
                                                        </c:if>
                                                    </ul>
                                                </nav>
                                            </div>
                                        </c:if>
                                    </c:if>
                                </div>

                                <!-- Placeholder for Medical History -->
                                <div class="history-section">
                                    <ul class="nav nav-tabs mb-3">
                                        <li class="nav-item">
                                            <a class="nav-link active" href="#">${t_medical_visits}</a>
                                        </li>
                                    </ul>
                                    <c:if test="${empty medicalRecords}">
                                        <div class="text-center text-muted p-3">
                                            <i class="fa-solid fa-laptop-medical fa-2x mb-2 text-secondary"></i>
                                            <p>${L == 'en' ? 'No medical records found.' : 'Chưa có lịch sử khám nào.'}</p>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty medicalRecords}">
                                        <div class="table-responsive">
                                            <table class="table table-hover table-sm" style="font-size: 0.9rem;">
                                                <thead>
                                                    <tr>
                                                        <th>${L == 'en' ? 'Date' : 'Ngày'}</th>
                                                        <th>${L == 'en' ? 'Veterinarian' : 'Bác sĩ'}</th>
                                                        <th>${L == 'en' ? 'Diagnosis' : 'Chẩn đoán'}</th>
                                                        <th>${L == 'en' ? 'Treatment Plan' : 'Hướng điều trị'}</th>
                                                        <th>${L == 'en' ? 'Prescription' : 'Đơn thuốc'}</th>
                                                        <th class="text-center">${L == 'en' ? 'Actions' : 'Thao tác'}</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${medicalRecords}" var="mr">
                                                        <tr>
                                                            <td><fmt:formatDate value="${mr.apptStartTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                            <td>${mr.vetName}</td>
                                                            <td><c:out value="${mr.diagnosis}"/></td>
                                                            <td><c:out value="${mr.treatmentPlan}"/></td>
                                                            <td>
                                                                <c:set var="presList" value="${recordPrescriptions[mr.recordId]}" />
                                                                <c:if test="${empty presList}">
                                                                    <span class="text-muted">-</span>
                                                                </c:if>
                                                                <c:if test="${not empty presList}">
                                                                    <ul style="padding-left: 15px; margin-bottom: 0; font-size: 0.85rem;">
                                                                        <c:forEach items="${presList}" var="pres">
                                                                            <li><strong>${pres.medicineName}</strong> (${pres.quantity} ${pres.medicineUnit}) - <em>${pres.dosage}</em></li>
                                                                        </c:forEach>
                                                                    </ul>
                                                                </c:if>
                                                            </td>
                                                            <td class="text-center">
                                                                <a class="btn btn-sm btn-outline-info" 
                                                                   href="${pageContext.request.contextPath}/my-medical-records/detail?id=${mr.recordId}" 
                                                                   title="${L == 'en' ? 'View Details & Prescription' : 'Xem chi tiết / Đơn thuốc'}">
                                                                    <i class="fa-solid fa-file-medical"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                </div>

                            </div> <!-- End Right Col -->
                        </div> <!-- End Grid -->
                    </main>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>

                </html>
