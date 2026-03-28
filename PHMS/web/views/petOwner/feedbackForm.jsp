<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/WEB-INF/jsp/globals/i18n.jsp" %>
<!DOCTYPE html>
<html lang="${L}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetCare Pro - Feedback Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assets/css/pages/menuPetOwner.css" rel="stylesheet" type="text/css"/>
    <style>
        .feedback-wrap {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
        }
        .feedback-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e5e7eb;
            padding: 24px;
        }
        .section-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 16px;
            color: #0f172a;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px 20px;
        }
        .info-item {
            background: #f8fafc;
            border-radius: 10px;
            border: 1px solid #edf2f7;
            padding: 10px 12px;
        }
        .info-label {
            color: #64748b;
            font-size: 12px;
            text-transform: uppercase;
            font-weight: 700;
            margin-bottom: 2px;
        }
        .info-value {
            color: #0f172a;
            font-size: 14px;
            font-weight: 600;
        }
        .rating-stars {
            display: flex;
            gap: 12px;
            margin: 12px 0 8px;
        }
        .star-btn {
            background: transparent;
            border: none;
            padding: 0;
            cursor: pointer;
        }
        .star-btn i {
            font-size: 32px;
            color: #d1d5db;
            transition: color 0.2s ease, transform 0.2s ease;
        }
        .star-btn:hover i {
            transform: scale(1.05);
        }
        .star-btn.active i {
            color: #fbbf24;
        }
        #ratingText {
            color: #64748b;
            font-size: 14px;
            margin: 0;
        }
        .feedback-textarea {
            width: 100%;
            min-height: 140px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            padding: 12px 14px;
            font-size: 14px;
            resize: vertical;
            outline: none;
        }
        .feedback-textarea:focus {
            border-color: #10b981;
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15);
        }
        .hint {
            margin-top: 8px;
            color: #64748b;
            font-size: 12px;
        }
        .actions {
            display: flex;
            gap: 12px;
            margin-top: 16px;
        }
        .btn-feedback {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            border: 1px solid transparent;
        }
        .btn-feedback.secondary {
            color: #334155;
            background: #f8fafc;
            border-color: #e2e8f0;
        }
        .btn-feedback.primary {
            color: #fff;
            background: #10b981;
        }
        .btn-feedback.primary:hover {
            background: #059669;
        }
        .alert {
            border-radius: 10px;
            margin-bottom: 14px;
            padding: 10px 12px;
        }
        @media (max-width: 900px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="nav/navPetOwner.jsp" />

    <main class="main-content">
        <header class="top-bar">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                ${t_logout}
            </a>
        </header>

        <div class="page-header">
            <div class="page-title">
                <h1>${L == 'en' ? 'Submit Feedback' : 'Gửi phản hồi'}</h1>
                <p>${L == 'en' ? 'Share your experience after this appointment.' : 'Chia sẻ trải nghiệm của bạn sau lịch hẹn này.'}</p>
            </div>
            <a class="btn-cancel" style="text-decoration:none;display:inline-flex;align-items:center;" href="${pageContext.request.contextPath}/myAppointment">
                ${L == 'en' ? 'Back' : 'Quay lại'}
            </a>
        </div>

        <div class="feedback-wrap">
            <c:set var="isReadOnly" value="${not empty existingFeedback and not canEdit}" />
            <c:if test="${not empty appt}">
                <section class="feedback-card">
                    <div class="section-title">${L == 'en' ? 'Appointment Information' : 'Thông tin lịch hẹn'}</div>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">${L == 'en' ? 'Appointment ID' : 'Mã lịch hẹn'}</div>
                            <div class="info-value">#${appt.apptId}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">${L == 'en' ? 'Date & Time' : 'Ngày giờ'}</div>
                            <div class="info-value"><fmt:formatDate value="${appt.startTime}" pattern="dd/MM/yyyy HH:mm"/></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">${L == 'en' ? 'Pet' : 'Thú cưng'}</div>
                            <div class="info-value">${appt.petName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">${L == 'en' ? 'Veterinarian' : 'Bác sĩ'}</div>
                            <div class="info-value">${appt.vetName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">${L == 'en' ? 'Service' : 'Dịch vụ'}</div>
                            <div class="info-value">${appt.type}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">${L == 'en' ? 'Receptionist' : 'Lễ tân'}</div>
                            <div class="info-value">${not empty appt.receptionistName ? appt.receptionistName : 'N/A'}</div>
                        </div>
                    </div>
                </section>
            </c:if>

            <section class="feedback-card">
                <div class="section-title">${L == 'en' ? 'Your Review' : 'Đánh giá của bạn'}</div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <c:if test="${not empty infoMessage}">
                    <div class="alert alert-info">${infoMessage}</div>
                </c:if>

                <c:set var="selectedRating" value="${not empty rating ? rating : param.rating}" />
                <c:set var="commentText" value="${not empty comment ? comment : param.comment}" />

                <form method="post" action="${pageContext.request.contextPath}/feedback/create">
                    <input type="hidden" name="apptId" value="${appt.apptId}">

                    <div class="form-group">
                        <label class="form-label"><b>${L == 'en' ? 'Rating' : 'Số sao'} *</b></label>
                        <div class="rating-stars">
                            <button type="button" class="star-btn ${selectedRating == '1' ? 'active' : ''}" onclick="setRating(1)" aria-label="1 star" ${isReadOnly ? 'disabled' : ''}><i class="fa-solid fa-star"></i></button>
                            <button type="button" class="star-btn ${selectedRating == '2' ? 'active' : ''}" onclick="setRating(2)" aria-label="2 stars" ${isReadOnly ? 'disabled' : ''}><i class="fa-solid fa-star"></i></button>
                            <button type="button" class="star-btn ${selectedRating == '3' ? 'active' : ''}" onclick="setRating(3)" aria-label="3 stars" ${isReadOnly ? 'disabled' : ''}><i class="fa-solid fa-star"></i></button>
                            <button type="button" class="star-btn ${selectedRating == '4' ? 'active' : ''}" onclick="setRating(4)" aria-label="4 stars" ${isReadOnly ? 'disabled' : ''}><i class="fa-solid fa-star"></i></button>
                            <button type="button" class="star-btn ${selectedRating == '5' ? 'active' : ''}" onclick="setRating(5)" aria-label="5 stars" ${isReadOnly ? 'disabled' : ''}><i class="fa-solid fa-star"></i></button>
                        </div>
                        <input type="hidden" name="rating" id="ratingInput" value="${selectedRating}" ${isReadOnly ? '' : 'required'}>
                        <p id="ratingText"></p>
                    </div>

                    <div class="form-group">
                        <label class="form-label"><b>${L == 'en' ? 'Comment' : 'Nhận xét'} *</b></label>
                        <textarea name="comment" class="feedback-textarea" maxlength="1000" placeholder="${L == 'en' ? 'Please share your experience...' : 'Hãy chia sẻ trải nghiệm của bạn...'}" ${isReadOnly ? 'readonly' : 'required'}>${commentText}</textarea>
                        <div class="hint">${L == 'en' ? 'Minimum 5 characters, maximum 1000 characters.' : 'Tối thiểu 5 ký tự, tối đa 1000 ký tự.'}</div>
                    </div>

                    <div class="actions">
                        <a href="${pageContext.request.contextPath}/myAppointment" class="btn-feedback secondary">
                            ${L == 'en' ? 'Cancel' : 'Hủy'}
                        </a>
                        <c:if test="${not isReadOnly}">
                            <button type="submit" class="btn-feedback primary">
                                <i class="fa-solid fa-paper-plane"></i> ${L == 'en' ? 'Submit Feedback' : 'Gửi phản hồi'}
                            </button>
                        </c:if>
                    </div>
                </form>
            </section>
        </div>
    </main>

    <script>
        const ratingTextsVi = ["Rất tệ", "Tệ", "Ổn", "Tốt", "Rất tốt"];
        const ratingTextsEn = ["Very Poor", "Poor", "Fair", "Good", "Excellent"];

        function updateRatingText(rating) {
            const isEn = "${L}" === "en";
            const labels = isEn ? ratingTextsEn : ratingTextsVi;
            const text = rating >= 1 && rating <= 5 ? labels[rating - 1] : (isEn ? "Please select a rating" : "Vui lòng chọn số sao");
            document.getElementById("ratingText").textContent = text;
        }

        function setRating(rating) {
            document.getElementById("ratingInput").value = rating;
            const stars = document.querySelectorAll(".star-btn");
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add("active");
                } else {
                    star.classList.remove("active");
                }
            });
            updateRatingText(rating);
        }

        window.addEventListener("DOMContentLoaded", function () {
            const initial = parseInt(document.getElementById("ratingInput").value || "0", 10);
            if (initial >= 1 && initial <= 5) {
                setRating(initial);
            } else {
                updateRatingText(0);
            }
        });
    </script>
<script>
window.__PHMS_ACCOUNT = window.__PHMS_ACCOUNT || {};
window.__PHMS_ACCOUNT.fullName = "${sessionScope.account.fullName}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/account-menu.js"></script>
</body>
</html>

