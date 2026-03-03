<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>VetCare Pro - Feedback Form</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/petOwnerDashboard.css">
        <style>
            .rating-stars {
                display: flex;
                gap: 10px;
                margin: 15px 0;
            }
            .star {
                font-size: 32px;
                color: #d1d5db;
                cursor: pointer;
                transition: color 0.2s;
            }
            .star:hover,
            .star.active {
                color: #fbbf24;
            }
            .rating-input {
                display: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Submit Feedback</h2>
            
            <c:if test="${not empty appt}">
                <div style="background:#f9fafb; padding:15px; border-radius:8px; margin-bottom:20px;">
                    <h3>Appointment Information</h3>
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <div><b>Appointment ID:</b> #${appt.apptId}</div>
                        <div><b>Date & Time:</b> <fmt:formatDate value="${appt.startTime}" pattern="dd/MM/yyyy HH:mm"/></div>
                        <div><b>Pet:</b> ${appt.petName}</div>
                        <div><b>Veterinarian:</b> ${appt.vetName}</div>
                        <div><b>Service:</b> ${appt.type}</div>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form method="post" action="${pageContext.request.contextPath}/feedback/create">
                <input type="hidden" name="apptId" value="${appt.apptId}">
                
                <div style="margin-bottom:20px;">
                    <label><b>Rating *</b></label>
                    <div class="rating-stars">
                        <span class="star" data-rating="1" onclick="setRating(1)"><i class="fa-solid fa-star"></i></span>
                        <span class="star" data-rating="2" onclick="setRating(2)"><i class="fa-solid fa-star"></i></span>
                        <span class="star" data-rating="3" onclick="setRating(3)"><i class="fa-solid fa-star"></i></span>
                        <span class="star" data-rating="4" onclick="setRating(4)"><i class="fa-solid fa-star"></i></span>
                        <span class="star" data-rating="5" onclick="setRating(5)"><i class="fa-solid fa-star"></i></span>
                    </div>
                    <input type="hidden" name="rating" id="ratingInput" required>
                    <p id="ratingText" style="color:#6b7280; margin-top:5px;">Please select a rating</p>
                </div>
                
                <div style="margin-bottom:20px;">
                    <label><b>Comment *</b></label>
                    <textarea name="comment" rows="5" style="width:100%; padding:10px;" 
                              maxlength="1000" placeholder="Please share your experience..." required>${comment}</textarea>
                    <small style="color:#6b7280;">Minimum 5 characters, maximum 1000 characters</small>
                </div>
                
                <div style="display:flex; gap:10px;">
                    <a href="${pageContext.request.contextPath}/feedback/create" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-paper-plane"></i> Submit Feedback
                    </button>
                </div>
            </form>
        </div>
        
        <script>
            function setRating(rating) {
                document.getElementById('ratingInput').value = rating;
                const stars = document.querySelectorAll('.star');
                stars.forEach((star, index) => {
                    if (index < rating) {
                        star.classList.add('active');
                    } else {
                        star.classList.remove('active');
                    }
                });
                const texts = ['Very Poor', 'Poor', 'Fair', 'Good', 'Excellent'];
                document.getElementById('ratingText').textContent = texts[rating - 1];
            }
        </script>
    </body>
</html>
