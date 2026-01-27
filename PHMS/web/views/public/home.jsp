<%-- 
    Document   : home
    Created on : Jan 22, 2026, 1:18:21 AM
    Author     : Nguyen Dang Hung
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VetCare Pro - Chăm sóc Thú cưng Chuyên nghiệp</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/home.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-logo">
            <div class="logo-icon">
                <svg width="24" height="24" fill="none" stroke="white" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4" />
                </svg>
            </div>
            <span class="logo-text">VetCare Pro</span>
        </div>
        <div class="nav-links">
            <a href="#">Trang chủ</a>
            <a href="#services">Dịch vụ</a>
            <a href="#doctors">Bác sĩ</a>
            <a href="#testimonials">Về chúng tôi</a>
            <!-- Link Dashboard dành cho từng role (Tùy chọn) -->
            <c:if test="${not empty sessionScope.account}">
                <c:choose>
                    <c:when test="${sessionScope.account.role == 'PetOwner'}">
                        <a href="${pageContext.request.contextPath}/petOwner/menuPetOwner">Đặt lịch</a>
                    </c:when>
                    <c:when test="${sessionScope.account.role == 'Veterinarian'}">
                        <a href="${pageContext.request.contextPath}/doctor/schedule">Lịch làm việc</a>
                    </c:when>
                    <c:when test="${sessionScope.account.role == 'ClinicManager'}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">Quản trị</a>
                    </c:when>
                </c:choose>
            </c:if> 
        </div>
        <div>
            <!-- LOGIC HIỂN THỊ NÚT ĐĂNG NHẬP / USER PROFILE -->
            <c:choose>
                <%-- TRƯỜNG HỢP 1: CHƯA ĐĂNG NHẬP --%>
                <c:when test="${empty sessionScope.account}">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-dark">
                        Đăng nhập
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-dark" style="margin-left: 10px; color: white; border-color: white;">
                        Đăng ký
                    </a>
                </c:when>

                <%-- TRƯỜNG HỢP 2: ĐÃ ĐĂNG NHẬP --%>
                <c:otherwise>
                    <div style="display: inline-flex; align-items: center; gap: 10px;">
                        <span class="btn btn-dark">
                           <i class="fa-solid fa-user" style="color: greenyellow;padding-right: 10px"></i> 
                             <a href="${pageContext.request.contextPath}/profile">${sessionScope.account.fullName}</a>
                        </span>
                        
                        <!-- Nút Logout -->
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark" style="background-color: #ef4444; border-color: #ef4444;">
                            Đăng xuất
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <section class="hero">
        <img src="https://images.unsplash.com/photo-1584132967334-10e028bd69f7?auto=format&fit=crop&w=1200&q=80" 
             class="hero-image" alt="Clinic Interior">
        <div class="container hero-content">
            <span class="hero-badge">PHMS - HỆ THỐNG QUẢN LÝ Y TẾ</span>
            <h1>Chăm sóc Toàn diện <br/> <span>Cho Thú cưng.</span></h1>
            <p>Sử dụng công nghệ hiện đại và lòng tận tâm để bảo vệ sức khỏe cho người bạn nhỏ của bạn.</p>
            <div class="hero-actions">
                
                <!-- SỬA LINK NÚT "ĐẶT LỊCH NGAY" -->
                <c:choose>
                    <c:when test="${not empty sessionScope.account and sessionScope.account.role == 'PetOwner'}">
                        <a href="${pageContext.request.contextPath}/petOwner/menuPetOwner" class="btn btn-primary">Đặt lịch ngay</a>
                    </c:when>
                    <c:otherwise>
                        <!-- Nếu chưa login hoặc không phải PetOwner thì trỏ về Login -->
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Đặt lịch ngay</a>
                    </c:otherwise>
                </c:choose>

                <button class="btn btn-outline">Tìm hiểu thêm</button>
            </div>
        </div>
    </section>

    <section id="services" class="section-padding">
        <div class="container">
            <div class="text-center mb-10">
                <h2 class="section-title">Dịch vụ Chuyên môn</h2>
                <div class="section-divider"></div>
            </div>
            
            <div class="services-grid">
                <c:forEach var="service" items="${topServices}">
                    <div class="card card-hover service-card">
                        <div class="service-icon-wrapper">
                            <svg width="32" height="32" stroke="var(--primary)" fill="none" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                            </svg>
                        </div>
                        <h3 class="mb-4 service-title">${service.name}</h3>
                        <p class="mb-8 service-description">${service.description}</p>
                        <p class="service-price-tag">Từ $${service.basePrice}</p>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <section id="doctors" class="section-padding bg-muted">
        <div class="container">
            <div class="text-center mb-10">
                <h2 class="section-title">Đội ngũ Chuyên gia</h2>
                <div class="section-divider"></div>
                <p class="section-subtitle">Các bác sĩ giàu kinh nghiệm, tận tâm với mọi loài vật nuôi.</p>
            </div>
            
            <div class="doctors-grid">
                <c:forEach var="doctor" items="${topDoctors}">
                    <div class="doctor-card card-hover">
                        <img src="${doctor.image}" alt="${doctor.fullName}" class="doctor-avatar">
                        <h3 class="doctor-name">${doctor.fullName}</h3>
                        <p class="doctor-spec">${doctor.specialization}</p>
                        
                        <button class="btn-profile">Xem hồ sơ</button>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
    
    <section id="testimonials" class="section-padding">
        <div class="container">
            <div class="text-center mb-10">
                <h2 class="section-title">Ý kiến Khách hàng</h2>
                <div class="section-divider"></div>
                <p class="section-subtitle">Những câu chuyện thật từ cộng đồng yêu thú cưng của chúng tôi.</p>
            </div>

            <div class="testimonials-grid">
                <c:forEach var="t" items="${feedbacks}">
                    <div class="testimonial-card">
                        <div class="quote-icon">
                            <svg width="40" height="40" viewBox="0 0 24 24" fill="#a7f3d0">
                                <path d="M14.017 21L14.017 18C14.017 16.8954 14.9124 16 16.017 16H19.017C19.5693 16 20.017 15.5523 20.017 15V9C20.017 8.44772 19.5693 8 19.017 8H15.017C14.4647 8 14.017 8.44772 14.017 9V11C14.017 11.5523 13.5693 12 13.017 12H12.017V5H22.017V15C22.017 18.3137 19.3307 21 16.017 21H14.017ZM5.0166 21L5.0166 18C5.0166 16.8954 5.91203 16 7.0166 16H10.0166C10.5689 16 11.0166 15.5523 11.0166 15V9C11.0166 8.44772 10.5689 8 10.0166 8H6.0166C5.46432 8 5.0166 8.44772 5.0166 9V11C5.0166 11.5523 4.56889 12 4.0166 12H3.0166V5H13.0166V15C13.0166 18.3137 10.3303 21 7.0166 21H5.0166Z" fill="currentColor"/>
                            </svg>
                        </div>
                        <p class="testimonial-text">"${t.comment}"</p>
                        <div class="testimonial-author">
                            <div class="author-avatar-small"></div>
                            <div>
                                <h4 class="author-name">${t.customerName}</h4>
                                <div class="rating-stars small">
                                    <c:forEach begin="1" end="${t.rating}">
                                        <svg width="12" height="12" fill="#fbbf24" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" /></svg>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container footer-grid">
            <div class="footer-brand">
                <h3>VetCare Pro</h3>
                <p>Nâng tầm tiêu chuẩn chăm sóc sức khỏe thú cưng tại Việt Nam bằng công nghệ và sự tận tâm.</p>
            </div>
            <div>
                <h4 class="footer-title">Liên kết</h4>
                <ul class="footer-list">
                    <li><a href="#">Dịch vụ cấp cứu</a></li>
                    <li><a href="#">Nhà thuốc thú y</a></li>
                    <li><a href="#">Chăm sóc Spa</a></li>
                </ul>
            </div>
            <div>
                <h4 class="footer-title">Liên hệ</h4>
                <ul class="footer-list">
                    <li>123 Đường Thú Cưng, TP. Hà Nội</li>
                    <li>+84 (123) 456-789</li>
                    <li>contact@vetcarepro.vn</li>
                </ul>
            </div>
        </div>
        <div class="container text-center" style="margin-top: 4rem; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 2rem;">
            <p>&copy; 2026 PHMS_DB Management System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>