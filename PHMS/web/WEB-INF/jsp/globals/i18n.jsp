<%-- Global i18n translations - include in any JSP with: <%@ include file="/WEB-INF/jsp/globals/i18n.jsp" %> --%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="L" value="${empty sessionScope.lang ? 'vi' : sessionScope.lang}" />

<%-- Navigation --%>
<c:set var="t_home"     value="${L == 'en' ? 'Home'             : 'Trang chủ'}" />
<c:set var="t_services" value="${L == 'en' ? 'Services'         : 'Dịch vụ'}" />
<c:set var="t_doctors"  value="${L == 'en' ? 'Doctors'          : 'Bác sĩ'}" />
<c:set var="t_about"    value="${L == 'en' ? 'About Us'         : 'Về chúng tôi'}" />
<c:set var="t_booking"  value="${L == 'en' ? 'Book Appointment' : 'Đặt lịch'}" />
<c:set var="t_schedule" value="${L == 'en' ? 'My Schedule'      : 'Lịch làm việc'}" />
<c:set var="t_admin"    value="${L == 'en' ? 'Administration'   : 'Quản trị'}" />
<c:set var="t_login"    value="${L == 'en' ? 'Login'            : 'Đăng nhập'}" />
<c:set var="t_register" value="${L == 'en' ? 'Register'         : 'Đăng ký'}" />
<c:set var="t_logout"   value="${L == 'en' ? 'Logout'           : 'Đăng xuất'}" />

<%-- Hero Section --%>
<c:set var="t_hero_badge"     value="${L == 'en' ? 'PHMS - PET HEALTH MANAGEMENT SYSTEM' : 'PHMS - HỆ THỐNG QUẢN LÝ Y TẾ'}" />
<c:set var="t_hero_title"     value="${L == 'en' ? 'Comprehensive Care'  : 'Chăm sóc Toàn diện'}" />
<c:set var="t_hero_highlight" value="${L == 'en' ? 'For Your Pets.'      : 'Cho Thú cưng.'}" />
<c:set var="t_hero_subtitle"  value="${L == 'en' ? 'Using modern technology and dedication to protect the health of your little companions.' : 'Sử dụng công nghệ hiện đại và lòng tận tâm để bảo vệ sức khỏe cho người bạn nhỏ của bạn.'}" />
<c:set var="t_book_now"       value="${L == 'en' ? 'Book Now'   : 'Đặt lịch ngay'}" />
<c:set var="t_learn_more"     value="${L == 'en' ? 'Learn More' : 'Tìm hiểu thêm'}" />

<%-- Sections --%>
<c:set var="t_services_title"        value="${L == 'en' ? 'Professional Services'                    : 'Dịch vụ Chuyên môn'}" />
<c:set var="t_doctors_title"         value="${L == 'en' ? 'Our Expert Team'                          : 'Đội ngũ Chuyên gia'}" />
<c:set var="t_doctors_subtitle"      value="${L == 'en' ? 'Experienced doctors dedicated to all kinds of pets.' : 'Các bác sĩ giàu kinh nghiệm, tận tâm với mọi loài vật nuôi.'}" />
<c:set var="t_testimonials_title"    value="${L == 'en' ? 'Customer Reviews'                         : 'Ý kiến Khách hàng'}" />
<c:set var="t_testimonials_subtitle" value="${L == 'en' ? 'Real stories from our pet-loving community.' : 'Những câu chuyện thật từ cộng đồng yêu thú cưng của chúng tôi.'}" />

<%-- Common actions --%>
<c:set var="t_from"         value="${L == 'en' ? 'From'         : 'Từ'}" />
<c:set var="t_view_profile" value="${L == 'en' ? 'View Profile' : 'Xem hồ sơ'}" />
<c:set var="t_view_details" value="${L == 'en' ? 'View Details' : 'Xem chi tiết'}" />
<c:set var="t_submit"       value="${L == 'en' ? 'Submit'       : 'Gửi'}" />
<c:set var="t_cancel"       value="${L == 'en' ? 'Cancel'       : 'Hủy'}" />
<c:set var="t_save"         value="${L == 'en' ? 'Save'         : 'Lưu'}" />
<c:set var="t_edit"         value="${L == 'en' ? 'Edit'         : 'Sửa'}" />
<c:set var="t_delete"       value="${L == 'en' ? 'Delete'       : 'Xóa'}" />
<c:set var="t_add"          value="${L == 'en' ? 'Add'          : 'Thêm'}" />
<c:set var="t_search"       value="${L == 'en' ? 'Search'       : 'Tìm kiếm'}" />
<c:set var="t_back"         value="${L == 'en' ? 'Back'         : 'Quay lại'}" />
<c:set var="t_next"         value="${L == 'en' ? 'Next'         : 'Tiếp'}" />
<c:set var="t_previous"     value="${L == 'en' ? 'Previous'     : 'Trước'}" />

<%-- Footer --%>
<c:set var="t_links"     value="${L == 'en' ? 'Links'               : 'Liên kết'}" />
<c:set var="t_contact"   value="${L == 'en' ? 'Contact'             : 'Liên hệ'}" />
<c:set var="t_emergency" value="${L == 'en' ? 'Emergency Services'  : 'Dịch vụ cấp cứu'}" />
<c:set var="t_pharmacy"  value="${L == 'en' ? 'Veterinary Pharmacy' : 'Nhà thuốc thú y'}" />
<c:set var="t_spa"       value="${L == 'en' ? 'Spa Care'            : 'Chăm sóc Spa'}" />

<%-- Booking page --%>
<c:set var="t_book_appt"         value="${L == 'en' ? 'Book Appointment'                    : 'Đặt lịch hẹn'}" />
<c:set var="t_book_subtitle"     value="${L == 'en' ? 'Schedule a visit for your beloved pet in just a few clicks.' : 'Đặt lịch khám cho thú cưng của bạn chỉ trong vài bước.'}" />
<c:set var="t_back_home"         value="${L == 'en' ? 'Back to Home'                        : 'Về trang chủ'}" />
<c:set var="t_visit_details"     value="${L == 'en' ? 'Visit Details'                       : 'Thông tin khám'}" />
<c:set var="t_select_pet"        value="${L == 'en' ? 'Select Pet'                          : 'Chọn thú cưng'}" />
<c:set var="t_no_pets"           value="${L == 'en' ? 'No pets added yet.'                  : 'Bạn chưa có thú cưng nào.'}" />
<c:set var="t_service_type"      value="${L == 'en' ? 'Service Type'                        : 'Loại dịch vụ'}" />
<c:set var="t_no_service"        value="${L == 'en' ? 'No service available.'               : 'Hiện chưa có dịch vụ.'}" />
<c:set var="t_select_date"       value="${L == 'en' ? 'Select Date'                         : 'Chọn ngày'}" />
<c:set var="t_pref_vet"          value="${L == 'en' ? 'Preferred Veterinarian'              : 'Chọn bác sĩ'}" />
<c:set var="t_choose_vet"        value="${L == 'en' ? '-- Choose a Veterinarian --'         : '-- Chọn bác sĩ --'}" />
<c:set var="t_no_vet_day"        value="${L == 'en' ? 'No veterinarian scheduled this day.' : 'Không có bác sĩ trong ngày này.'}" />
<c:set var="t_select_date_first" value="${L == 'en' ? 'Please select a date first.'         : 'Vui lòng chọn ngày trước.'}" />
<c:set var="t_notes"             value="${L == 'en' ? 'Notes &amp; Symptoms'                : 'Ghi chú &amp; Triệu chứng'}" />
<c:set var="t_notes_placeholder" value="${L == 'en' ? 'Tell us about your pet symptoms or any specific concerns...' : 'Mô tả triệu chứng hoặc vấn đề của thú cưng...'}" />
<c:set var="t_schedule_title"    value="${L == 'en' ? 'Schedule'                            : 'Chọn giờ'}" />
<c:set var="t_time_slots"        value="${L == 'en' ? 'Available Time Slots'                : 'Khung giờ trống'}" />
<c:set var="t_no_slots"          value="${L == 'en' ? 'Please select a Date and Doctor to see available slots.' : 'Vui lòng chọn ngày và bác sĩ để xem khung giờ.'}" />
<c:set var="t_confirm_booking"   value="${L == 'en' ? 'Confirm Booking'                     : 'Xác nhận đặt lịch'}" />
<c:set var="t_cancel_policy"     value="${L == 'en' ? 'By confirming, you agree to our 24-hour cancellation policy.' : 'Khi xác nhận, bạn đồng ý với chính sách hủy lịch trước 24 giờ.'}" />

<%-- My Appointments page --%>
<c:set var="t_my_appts"          value="${L == 'en' ? 'My Appointments'                          : 'Lịch hẹn của tôi'}" />
<c:set var="t_my_appts_sub"      value="${L == 'en' ? 'Track your upcoming visits and view past history.' : 'Theo dõi lịch hẹn sắp tới và xem lịch sử.'}" />
<c:set var="t_upcoming"          value="${L == 'en' ? 'Upcoming Appointments'                    : 'Lịch hẹn sắp tới'}" />
<c:set var="t_history"           value="${L == 'en' ? 'History'                                  : 'Lịch sử'}" />
<c:set var="t_no_upcoming"       value="${L == 'en' ? 'No upcoming appointments.'                : 'Không có lịch hẹn sắp tới.'}" />
<c:set var="t_no_history"        value="${L == 'en' ? 'No past appointment history found.'       : 'Chưa có lịch sử cuộc hẹn.'}" />
<c:set var="t_date_time"         value="${L == 'en' ? 'Date &amp; Time'                          : 'Ngày &amp; Giờ'}" />
<c:set var="t_pet"               value="${L == 'en' ? 'Pet'                                      : 'Thú cưng'}" />
<c:set var="t_service"           value="${L == 'en' ? 'Service'                                  : 'Dịch vụ'}" />
<c:set var="t_doctor"            value="${L == 'en' ? 'Doctor'                                   : 'Bác sĩ'}" />
<c:set var="t_status"            value="${L == 'en' ? 'Status'                                   : 'Trạng thái'}" />
<c:set var="t_notes_col"         value="${L == 'en' ? 'Notes'                                    : 'Ghi chú'}" />
<c:set var="t_actions"           value="${L == 'en' ? 'Actions'                                  : 'Thao tác'}" />
<c:set var="t_no_notes"          value="${L == 'en' ? 'No notes'                                 : 'Không có ghi chú'}" />
<c:set var="t_locked"            value="${L == 'en' ? 'Locked'                                   : 'Đã khóa'}" />
<c:set var="t_reviewed"          value="${L == 'en' ? 'Reviewed'                                 : 'Đã đánh giá'}" />
<c:set var="t_feedback"          value="${L == 'en' ? 'Feedback'                                 : 'Đánh giá'}" />
<c:set var="t_appt_notes_title"  value="${L == 'en' ? 'Appointment Notes'                        : 'Ghi chú cuộc hẹn'}" />

<%-- My Pets page --%>
<c:set var="t_my_pets"           value="${L == 'en' ? 'My Pets'                                  : 'Thú cưng của tôi'}" />
<c:set var="t_pet_profile"       value="${L == 'en' ? 'Pet Profile &amp; History'                : 'Hồ sơ &amp; Lịch sử thú cưng'}" />
<c:set var="t_pet_profile_sub"   value="${L == 'en' ? 'Comprehensive overview of your pet health records.' : 'Tổng quan hồ sơ sức khỏe thú cưng của bạn.'}" />
<c:set var="t_add_pet"           value="${L == 'en' ? 'Add New Pet'                              : 'Thêm thú cưng'}" />
<c:set var="t_no_pets_found"     value="${L == 'en' ? 'No pets found.'                           : 'Không tìm thấy thú cưng.'}" />
<c:set var="t_breed"             value="${L == 'en' ? 'Breed'                                    : 'Giống'}" />
<c:set var="t_gender"            value="${L == 'en' ? 'Gender'                                   : 'Giới tính'}" />
<c:set var="t_weight"            value="${L == 'en' ? 'Weight'                                   : 'Cân nặng'}" />
<c:set var="t_birth_date"        value="${L == 'en' ? 'Birth Date'                               : 'Ngày sinh'}" />
<c:set var="t_history_summary"   value="${L == 'en' ? 'History Summary'                          : 'Tóm tắt bệnh sử'}" />
<c:set var="t_no_history_sum"    value="${L == 'en' ? 'No history summary available.'            : 'Chưa có tóm tắt bệnh sử.'}" />
<c:set var="t_delete_profile"    value="${L == 'en' ? 'Delete Profile'                           : 'Xóa hồ sơ'}" />
<c:set var="t_pets_list"         value="${L == 'en' ? 'My Pets List'                             : 'Danh sách thú cưng'}" />
<c:set var="t_species"           value="${L == 'en' ? 'Species'                                  : 'Loài'}" />
<c:set var="t_medical_visits"    value="${L == 'en' ? 'Medical Visits'                           : 'Lịch sử khám'}" />
<c:set var="t_vaccinations"      value="${L == 'en' ? 'Vaccinations'                             : 'Tiêm phòng'}" />

<%-- Medical Records page --%>
<c:set var="t_medical_records"   value="${L == 'en' ? 'Medical Records'                          : 'Hồ sơ bệnh án'}" />
<c:set var="t_medical_rec_sub"   value="${L == 'en' ? 'View examination results for your pets.'  : 'Xem kết quả khám bệnh của thú cưng.'}" />
<c:set var="t_filter_pet"        value="${L == 'en' ? 'Filter by Pet:'                           : 'Lọc theo thú cưng:'}" />
<c:set var="t_all"               value="${L == 'en' ? 'All'                                      : 'Tất cả'}" />
<c:set var="t_no_records"        value="${L == 'en' ? 'No medical records found.'                : 'Chưa có hồ sơ bệnh án.'}" />
<c:set var="t_date"              value="${L == 'en' ? 'Date'                                     : 'Ngày'}" />

<%-- AI Health Guide page --%>
<c:set var="t_ai_title"          value="${L == 'en' ? 'AI Pet Health Assistant'                  : 'Trợ lý sức khỏe thú cưng AI'}" />
<c:set var="t_ai_subtitle"       value="${L == 'en' ? 'Instant advice for your pets, powered by advanced AI.' : 'Tư vấn tức thì cho thú cưng, được hỗ trợ bởi AI tiên tiến.'}" />
<c:set var="t_ai_online"         value="${L == 'en' ? 'Gemini AI is Online'                      : 'Gemini AI đang hoạt động'}" />
<c:set var="t_ai_offline"        value="${L == 'en' ? 'AI Offline (Config Error)'                : 'AI ngoại tuyến (Lỗi cấu hình)'}" />
<c:set var="t_ai_greeting"       value="${L == 'en' ? 'Hello! I am VetCare AI assistant. How can I help your pet today?' : 'Xin chào! Tôi là trợ lý AI VetCare. Tôi có thể giúp gì cho sức khỏe thú cưng của bạn hôm nay?'}" />
<c:set var="t_ai_loading"        value="${L == 'en' ? 'AI is composing a response...'            : 'AI đang soạn câu trả lời...'}" />
<c:set var="t_ai_placeholder"    value="${L == 'en' ? 'Ask about symptoms, diet...'              : 'Hỏi về triệu chứng, chế độ ăn uống...'}" />
<c:set var="t_ai_disclaimer"     value="${L == 'en' ? 'ALWAYS CONSULT A VET IN EMERGENCIES'      : 'LUÔN HỎI BÁC SĨ THÚ Y TRONG TRƯỜNG HỢP KHẨN CẤP'}" />

<%-- Admin Dashboard --%>
<c:set var="t_admin_dashboard"    value="${L == 'en' ? 'Admin Control Center'                    : 'Trung tâm điều khiển Admin'}" />
<c:set var="t_admin_dash_sub"     value="${L == 'en' ? 'Monitor hospital operations and system health.' : 'Giám sát hoạt động bệnh viện và sức khỏe hệ thống.'}" />
<c:set var="t_total_revenue"      value="${L == 'en' ? 'Total Revenue'                           : 'Tổng doanh thu'}" />
<c:set var="t_total_appointments" value="${L == 'en' ? 'Total Appointments'                       : 'Tổng cuộc hẹn'}" />
<c:set var="t_completed"          value="${L == 'en' ? 'Completed'                               : 'Hoàn thành'}" />
<c:set var="t_pending_appt"       value="${L == 'en' ? 'Pending'                                 : 'Đang chờ'}" />
<c:set var="t_monthly_revenue"    value="${L == 'en' ? 'Monthly Revenue'                          : 'Doanh thu tháng'}" />
<c:set var="t_total_staff"        value="${L == 'en' ? 'Total Staff'                              : 'Tổng nhân sự'}" />
<c:set var="t_new_feedback"       value="${L == 'en' ? 'New Feedback'                             : 'Phản hồi mới'}" />
<c:set var="t_leave_requests"     value="${L == 'en' ? 'Leave Requests'                           : 'Yêu cầu nghỉ'}" />
<c:set var="t_active"             value="${L == 'en' ? 'ACTIVE'                                   : 'HOẠT ĐỘNG'}" />
<c:set var="t_unread"             value="${L == 'en' ? 'UNREAD'                                   : 'CHƯA ĐỌC'}" />
<c:set var="t_pending"            value="${L == 'en' ? 'PENDING'                                  : 'ĐANG CHỜ'}" />
<c:set var="t_leave_pending"      value="${L == 'en' ? 'Pending Leave Requests'                   : 'Yêu cầu nghỉ phép chờ duyệt'}" />
<c:set var="t_view_all"           value="${L == 'en' ? 'VIEW ALL'                                 : 'XEM TẤT CẢ'}" />
<c:set var="t_no_pending_leave"   value="${L == 'en' ? 'No pending leave requests.'               : 'Không có đơn nào đang chờ duyệt.'}" />
<c:set var="t_quick_actions"      value="${L == 'en' ? 'Quick Actions'                            : 'Thao tác nhanh'}" />
<c:set var="t_services_mgmt"      value="${L == 'en' ? 'Services'                                 : 'Dịch vụ'}" />
<c:set var="t_services_mgmt_sub"  value="${L == 'en' ? 'Pricing &amp; Catalog'                    : 'Bảng giá &amp; Danh mục'}" />
<c:set var="t_pharmacy_mgmt"      value="${L == 'en' ? 'Pharmacy'                                 : 'Kho thuốc'}" />
<c:set var="t_pharmacy_mgmt_sub"  value="${L == 'en' ? 'Medicines &amp; Pricing'                  : 'Dược phẩm &amp; Giá bán'}" />
<c:set var="t_schedule_mgmt"      value="${L == 'en' ? 'Work Schedule'                            : 'Lịch làm việc'}" />
<c:set var="t_schedule_mgmt_sub"  value="${L == 'en' ? 'Staff shift management'                   : 'Phân ca trực nhân viên'}" />
<c:set var="t_feedback_mgmt"      value="${L == 'en' ? 'Feedback'                                 : 'Phản hồi'}" />
<c:set var="t_feedback_mgmt_sub"  value="${L == 'en' ? 'Customer reviews'                         : 'Đánh giá khách hàng'}" />
<c:set var="t_filter_by"          value="${L == 'en' ? 'Filter by'                               : 'Lọc theo'}" />
<c:set var="t_today"              value="${L == 'en' ? 'Today'                                   : 'Hôm nay'}" />
<c:set var="t_this_week"          value="${L == 'en' ? 'This Week'                               : 'Tuần này'}" />
<c:set var="t_this_month"         value="${L == 'en' ? 'This Month'                              : 'Tháng này'}" />
<c:set var="t_this_quarter"       value="${L == 'en' ? 'This Quarter'                            : 'Quý này'}" />
<c:set var="t_this_year"          value="${L == 'en' ? 'This Year'                               : 'Năm nay'}" />
<c:set var="t_custom_range"       value="${L == 'en' ? 'Custom Range'                            : 'Tùy chọn'}" />
<c:set var="t_to"                value="${L == 'en' ? 'To'                                      : 'Đến'}" />
<c:set var="t_apply"              value="${L == 'en' ? 'Apply'                                   : 'Áp dụng'}" />
<c:set var="t_top_services"       value="${L == 'en' ? 'Top Services'                            : 'Dịch vụ hàng đầu'}" />
<c:set var="t_revenue_trend"      value="${L == 'en' ? 'Revenue Trend'                           : 'Xu hướng doanh thu'}" />
<c:set var="t_no_data"            value="${L == 'en' ? 'No data available'                        : 'Chưa có dữ liệu'}" />
<c:set var="t_appointments"       value="${L == 'en' ? 'Appointments'                            : 'Cuộc hẹn'}" />

<%-- Login page --%>
<c:set var="t_login_title"    value="${L == 'en' ? 'Login to System'                            : 'Đăng nhập Hệ thống'}" />
<c:set var="t_login_subtitle" value="${L == 'en' ? 'Comprehensive Pet Health Management System' : 'Hệ thống quản lý y tế thú cưng toàn diện'}" />
<c:set var="t_username"       value="${L == 'en' ? 'Username'                                   : 'Tên đăng nhập'}" />
<c:set var="t_password"       value="${L == 'en' ? 'Password'                                   : 'Mật khẩu'}" />
<c:set var="t_forgot_pass"    value="${L == 'en' ? 'Forgot Password?'                           : 'Quên mật khẩu?'}" />
<c:set var="t_login_btn"      value="${L == 'en' ? 'Login Now'                                  : 'Đăng nhập ngay'}" />
<c:set var="t_no_account"     value="${L == 'en' ? 'Do not have an account?'                    : 'Bạn chưa có tài khoản?'}" />
<c:set var="t_register_now"   value="${L == 'en' ? 'Register Now'                               : 'Đăng ký ngay'}" />
<c:set var="t_enter_username" value="${L == 'en' ? 'Enter your username'                        : 'Nhập tên đăng nhập của bạn'}" />

<%-- Auto-added dictionary entries from inline page labels --%>
<c:set var="t_action" value="${L == 'en' ? 'Action' : 'Thao tác'}" />
<c:set var="t_action_2" value="${L == 'en' ? 'Action' : 'Hành động'}" />
<c:set var="t_add_a_pet_or_clear_search" value="${L == 'en' ? 'Add a pet or clear search' : 'Thêm thú cưng hoặc xóa tìm kiếm'}" />
<c:set var="t_address" value="${L == 'en' ? 'Address' : 'Địa chỉ'}" />
<c:set var="t_admin_menu" value="${L == 'en' ? 'Admin Menu' : 'Menu Quản trị'}" />
<c:set var="t_ai_health_guide" value="${L == 'en' ? 'AI Health Guide' : 'Hướng dẫn sức khỏe AI'}" />
<c:set var="t_all_levels" value="${L == 'en' ? 'All Levels' : 'Tất cả mức độ'}" />
<c:set var="t_all_status" value="${L == 'en' ? 'All Status' : 'Tất cả trạng thái'}" />
<c:set var="t_already_have_an_account" value="${L == 'en' ? 'Already have an account?' : 'Đã có tài khoản?'}" />
<c:set var="t_amount" value="${L == 'en' ? 'Amount' : 'Số tiền'}" />
<c:set var="t_appointment_id" value="${L == 'en' ? 'Appointment ID' : 'Mã lịch hẹn'}" />
<c:set var="t_appointment_information" value="${L == 'en' ? 'Appointment Information' : 'Thông tin lịch hẹn'}" />
<c:set var="t_appointment_time" value="${L == 'en' ? 'Appointment Time' : 'Thời gian khám'}" />
<c:set var="t_appointments_2" value="${L == 'en' ? 'Appointments' : 'Đặt lịch'}" />
<c:set var="t_appointments_3" value="${L == 'en' ? 'Appointments' : 'Cuộc hẹn'}" />
<c:set var="t_are_you_sure_you_want_to_delete" value="${L == 'en' ? 'Are you sure you want to delete' : 'Bạn chắc chắn muốn xóa hồ sơ thú cưng'}" />
<c:set var="t_back_to_appointments" value="${L == 'en' ? 'Back to Appointments' : 'Quay lại lịch hẹn'}" />
<c:set var="t_back_to_medical_records" value="${L == 'en' ? 'Back to Medical Records' : 'Quay lại hồ sơ bệnh án'}" />
<c:set var="t_billing" value="${L == 'en' ? 'Billing' : 'Thanh toán'}" />
<c:set var="t_billing_2" value="${L == 'en' ? 'Billing' : 'Thanh toán'}" />
<c:set var="t_briefly_describe_the_pet_symptoms" value="${L == 'en' ? 'Briefly describe the pet symptoms...' : 'Ghi nhận ngắn gọn các triệu chứng của thú cưng...'}" />
<c:set var="t_cancelled" value="${L == 'en' ? 'Cancelled' : 'Đã hủy'}" />
<c:set var="t_comment" value="${L == 'en' ? 'Comment' : 'Nhận xét'}" />
<c:set var="t_confirm_password" value="${L == 'en' ? 'Confirm Password' : 'Nhập lại mật khẩu'}" />
<c:set var="t_contact_support" value="${L == 'en' ? 'Contact Support' : 'Liên hệ hỗ trợ'}" />
<c:set var="t_contact_support_2" value="${L == 'en' ? 'Contact Support' : 'Liên hệ hỗ trợ'}" />
<c:set var="t_create_account" value="${L == 'en' ? 'Create Account' : 'Đăng ký Tài khoản'}" />
<c:set var="t_create_emergency" value="${L == 'en' ? 'Create Emergency' : 'Tạo cấp cứu'}" />
<c:set var="t_create_invoice" value="${L == 'en' ? 'Create Invoice' : 'Tạo hóa đơn'}" />
<c:set var="t_create_new_account" value="${L == 'en' ? 'Create New Account' : 'Tạo tài khoản mới'}" />
<c:set var="t_critical_critical_condition" value="${L == 'en' ? 'Critical - Critical condition' : 'Critical - Nguy kịch'}" />
<c:set var="t_dashboard" value="${L == 'en' ? 'Dashboard' : 'Bảng điều khiển'}" />
<c:set var="t_dashboard_2" value="${L == 'en' ? 'Dashboard' : 'Bảng điều khiển'}" />
<c:set var="t_date_time_2" value="${L == 'en' ? 'Date & Time' : 'Ngày giờ'}" />
<c:set var="t_diagnosis" value="${L == 'en' ? 'Diagnosis' : 'Chẩn đoán'}" />
<c:set var="t_elevating_pet_healthcare_standards_with_technology_and_dedication" value="${L == 'en' ? 'Elevating pet healthcare standards with technology and dedication.' : 'Nâng tầm tiêu chuẩn chăm sóc sức khỏe thú cưng tại Việt Nam bằng công nghệ và sự tận tâm.'}" />
<c:set var="t_emergency_queue" value="${L == 'en' ? 'Emergency Queue' : 'Hàng đợi cấp cứu'}" />
<c:set var="t_emergency_queue_2" value="${L == 'en' ? 'Emergency Queue' : 'Khẩn cấp'}" />
<c:set var="t_emergency_triage" value="${L == 'en' ? 'Emergency Triage' : 'Cấp cứu'}" />
<c:set var="t_emergency_triage_2" value="${L == 'en' ? 'Emergency Triage' : 'Cấp cứu'}" />
<c:set var="t_emr_queue" value="${L == 'en' ? 'EMR Queue' : 'Hàng đợi EMR'}" />
<c:set var="t_female" value="${L == 'en' ? 'Female' : 'Cái'}" />
<c:set var="t_full_name" value="${L == 'en' ? 'Full Name' : 'Họ và tên'}" />
<c:set var="t_high_urgent" value="${L == 'en' ? 'High - Urgent' : 'High - Khẩn'}" />
<c:set var="t_house_number_street_district" value="${L == 'en' ? 'House number, Street, District...' : 'Số nhà, Đường, Quận/Huyện...'}" />
<c:set var="t_in_progress" value="${L == 'en' ? 'In Progress' : 'Đang xử lý'}" />
<c:set var="t_initial_symptoms" value="${L == 'en' ? 'Initial Symptoms' : 'Triệu chứng ban đầu'}" />
<c:set var="t_invoice" value="${L == 'en' ? 'INVOICE' : 'HÓA ĐƠN'}" />
<c:set var="t_invoice_detail" value="${L == 'en' ? 'Invoice Detail' : 'Chi tiết hóa đơn'}" />
<c:set var="t_invoice_id" value="${L == 'en' ? 'Invoice ID' : 'Mã hóa đơn'}" />
<c:set var="t_invoice_items" value="${L == 'en' ? 'Invoice Items' : 'Chi tiết hạng mục'}" />
<c:set var="t_invoice_not_available_yet" value="${L == 'en' ? 'Invoice not available yet' : 'Chưa có hóa đơn'}" />
<c:set var="t_item" value="${L == 'en' ? 'Item' : 'Hạng mục'}" />
<c:set var="t_join_the_vetcare_pro_pet_care_community" value="${L == 'en' ? 'Join the VetCare Pro pet care community' : 'Tham gia cộng đồng chăm sóc thú cưng VetCare Pro'}" />
<c:set var="t_lab_requests" value="${L == 'en' ? 'Lab Requests' : 'Xét nghiệm'}" />
<c:set var="t_leave_requests_2" value="${L == 'en' ? 'Leave Requests' : 'Xin nghỉ'}" />
<c:set var="t_level" value="${L == 'en' ? 'Level' : 'Mức độ'}" />
<c:set var="t_list_of_emergency_cases_awaiting_examination" value="${L == 'en' ? 'List of emergency cases awaiting examination.' : 'Danh sách các ca cấp cứu đang chờ khám.'}" />
<c:set var="t_low_stable" value="${L == 'en' ? 'Low - Stable' : 'Low - ổn định'}" />
<c:set var="t_main_menu" value="${L == 'en' ? 'MAIN MENU' : 'MENU CHÍNH'}" />
<c:set var="t_male" value="${L == 'en' ? 'Male' : 'Đực'}" />
<c:set var="t_medium_moderate" value="${L == 'en' ? 'Medium - Moderate' : 'Medium - Trung bình'}" />
<c:set var="t_method" value="${L == 'en' ? 'Method' : 'Phương thức'}" />
<c:set var="t_minimum_5_characters_maximum_1000_characters" value="${L == 'en' ? 'Minimum 5 characters, maximum 1000 characters.' : 'Tối thiểu 5 ký tự, tối đa 1000 ký tự.'}" />
<c:set var="t_name" value="${L == 'en' ? 'Name' : 'Tên'}" />
<c:set var="t_need_help" value="${L == 'en' ? 'Need help?' : 'Cần hỗ trợ?'}" />
<c:set var="t_need_help_2" value="${L == 'en' ? 'Need help?' : 'Cần hỗ trợ?'}" />
<c:set var="t_no" value="${L == 'en' ? 'No.' : 'STT'}" />
<c:set var="t_no_completed_appointments_available_for_feedback" value="${L == 'en' ? 'No completed appointments available for feedback.' : 'Hiện chưa có lịch hẹn hoàn thành để gửi phản hồi.'}" />
<c:set var="t_no_invoice_available_for_this_visit_yet" value="${L == 'en' ? 'No invoice available for this visit yet.' : 'Lần khám này chưa có hóa đơn.'}" />
<c:set var="t_no_invoice_items_found" value="${L == 'en' ? 'No invoice items found.' : 'Không có chi tiết hóa đơn.'}" />
<c:set var="t_no_medical_records_found" value="${L == 'en' ? 'No medical records found.' : 'Chưa có lịch sử khám nào.'}" />
<c:set var="t_not_triaged" value="${L == 'en' ? 'Not triaged' : 'Chưa phân loại'}" />
<c:set var="t_overview" value="${L == 'en' ? 'Overview' : 'Tổng quan'}" />
<c:set var="t_pay_invoice" value="${L == 'en' ? 'Pay Invoice' : 'Thanh toán'}" />
<c:set var="t_payment_history" value="${L == 'en' ? 'Payment History' : 'Lịch sử thanh toán'}" />
<c:set var="t_pet_owner" value="${L == 'en' ? 'Pet Owner' : 'Chủ thú cưng'}" />
<c:set var="t_pet_street_hanoi" value="${L == 'en' ? 'Pet Street, Hanoi' : 'Đường Thú Cưng, TP. Hà Nội'}" />
<c:set var="t_pets" value="${L == 'en' ? 'Pets' : 'Thú cưng'}" />
<c:set var="t_pharmacy_2" value="${L == 'en' ? 'Pharmacy' : 'Nhà thuốc'}" />
<c:set var="t_phone_number" value="${L == 'en' ? 'Phone Number' : 'Số điện thoại'}" />
<c:set var="t_please_share_your_experience" value="${L == 'en' ? 'Please share your experience...' : 'Hãy chia sẻ trải nghiệm của bạn...'}" />
<c:set var="t_prescription" value="${L == 'en' ? 'Prescription' : 'Đơn thuốc'}" />
<c:set var="t_prescriptions" value="${L == 'en' ? 'Prescriptions' : 'Đơn thuốc'}" />
<c:set var="t_priority_level" value="${L == 'en' ? 'Priority Level' : 'Mức độ ưu tiên'}" />
<c:set var="t_professional_pet_care" value="${L == 'en' ? 'Professional Pet Care' : 'Chăm sóc Thú cưng Chuyên nghiệp'}" />
<c:set var="t_qty" value="${L == 'en' ? 'Qty' : 'SL'}" />
<c:set var="t_rating" value="${L == 'en' ? 'Rating' : 'Số sao'}" />
<c:set var="t_receptionist" value="${L == 'en' ? 'Receptionist' : 'Lễ tân'}" />
<c:set var="t_reset" value="${L == 'en' ? 'Reset' : 'Đặt lại'}" />
<c:set var="t_result_s" value="${L == 'en' ? 'result(s)' : 'kết quả'}" />
<c:set var="t_revenue" value="${L == 'en' ? 'Revenue' : 'Doanh thu'}" />
<c:set var="t_review" value="${L == 'en' ? 'Review' : 'Đánh giá'}" />
<c:set var="t_review_charges_for_this_medical_record_visit" value="${L == 'en' ? 'Review charges for this medical record visit.' : 'Xem chi phí tương ứng với lần khám trong hồ sơ bệnh án.'}" />
<c:set var="t_scheduling" value="${L == 'en' ? 'Scheduling' : 'Lịch làm việc'}" />
<c:set var="t_search_by_pet_name_owner" value="${L == 'en' ? 'Search by pet name, owner...' : 'Tìm theo tên pet, chủ...'}" />
<c:set var="t_select_a_completed_appointment_to_review" value="${L == 'en' ? 'Select a completed appointment to review.' : 'Chọn lịch hẹn đã hoàn thành để gửi đánh giá.'}" />
<c:set var="t_select_level" value="${L == 'en' ? '-- Select level --' : '-- Chọn mức độ --'}" />
<c:set var="t_share_your_experience_after_this_appointment" value="${L == 'en' ? 'Share your experience after this appointment.' : 'Chia sẻ trải nghiệm của bạn sau lịch hẹn này.'}" />
<c:set var="t_showing" value="${L == 'en' ? 'Showing' : 'Hiển thị'}" />
<c:set var="t_sign_out" value="${L == 'en' ? 'Sign Out' : 'Đăng xuất'}" />
<c:set var="t_staff" value="${L == 'en' ? 'Staff' : 'Nhân viên'}" />
<c:set var="t_staff_management" value="${L == 'en' ? 'Staff Management' : 'Quản lý nhân viên'}" />
<c:set var="t_staff_scheduling" value="${L == 'en' ? 'Staff Scheduling' : 'Lịch làm việc'}" />
<c:set var="t_submit_feedback" value="${L == 'en' ? 'Submit Feedback' : 'Gửi phản hồi'}" />
<c:set var="t_subtotal" value="${L == 'en' ? 'Subtotal' : 'Thành tiền'}" />
<c:set var="t_there_are_currently_no_emergency_cases" value="${L == 'en' ? 'There are currently no emergency cases.' : 'Hiện không có ca cấp cứu nào.'}" />
<c:set var="t_time" value="${L == 'en' ? 'Time' : 'Thời gian'}" />
<c:set var="t_time_2" value="${L == 'en' ? 'Time' : 'Giờ'}" />
<c:set var="t_total_amount" value="${L == 'en' ? 'Total Amount' : 'Tổng tiền'}" />
<c:set var="t_treatment_plan" value="${L == 'en' ? 'Treatment Plan' : 'Hướng điều trị'}" />
<c:set var="t_unit_price" value="${L == 'en' ? 'Unit Price' : 'Đơn giá'}" />
<c:set var="t_veterinarian" value="${L == 'en' ? 'Veterinarian' : 'Bác sĩ'}" />
<c:set var="t_view" value="${L == 'en' ? 'View' : 'Xem'}" />
<c:set var="t_view_details_prescription" value="${L == 'en' ? 'View Details & Prescription' : 'Xem chi tiết / Đơn thuốc'}" />
<c:set var="t_view_invoice" value="${L == 'en' ? 'View invoice' : 'Xem hóa đơn'}" />
<c:set var="t_view_medical_record" value="${L == 'en' ? 'View medical record' : 'Xem hồ sơ bệnh án'}" />
<c:set var="t_you_can_cancel_reschedule_at_least_5_hours_before_remaining" value="${L == 'en' ? 'You can cancel/reschedule at least 5 hours before. Remaining:' : 'Bạn có thể hủy/đổi lịch trước giờ hẹn ít nhất 5 tiếng. Còn khoảng:'}" />
<c:set var="t_you_do_not_have_permission_to_view_this_invoice" value="${L == 'en' ? 'You do not have permission to view this invoice.' : 'Bạn không có quyền xem hóa đơn này.'}" />
<c:set var="t_your_review" value="${L == 'en' ? 'Your Review' : 'Đánh giá của bạn'}" />
