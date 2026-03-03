<<<<<<< Updated upstream
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.appointment;

import dal.AppointmentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import model.User;
import java.sql.Timestamp;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "SaveAppointmentController", urlPatterns = {"/save-appointment"})
public class SaveAppointmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
    }

    //XỬ LÝ LƯU CUỘC HẸN
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 1. Get and sanitize input
            String petIdStr = request.getParameter("petId");
            String serviceType = request.getParameter("serviceType");
            String vetIdStr = request.getParameter("vetId");
            String dateStr = request.getParameter("selectedDate");
            String timeStr = request.getParameter("timeSlot");
            String notes = util.ValidationUtils.sanitize(request.getParameter("notes"));
            String rescheduleIdStr = request.getParameter("rescheduleId");
            
            // 2. Validate required fields
            if (!util.ValidationUtils.isNotEmpty(petIdStr) || !util.ValidationUtils.isNotEmpty(vetIdStr) 
                    || !util.ValidationUtils.isNotEmpty(dateStr) || !util.ValidationUtils.isNotEmpty(timeStr)) {
                request.setAttribute("error", "Vui lòng chọn đầy đủ thông tin!");
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }
            
            // Validate pet belongs to current user
            int petId = Integer.parseInt(petIdStr);
            dal.PetDAO petDAO = new dal.PetDAO();
            model.Pet pet = petDAO.getPetById(petId);
            if (pet == null || pet.getOwnerId() != account.getUserId()) {
                request.setAttribute("error", "Thú cưng không hợp lệ hoặc không thuộc về bạn!");
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }
            
            // Validate service type
            if (!util.ValidationUtils.isNotEmpty(serviceType)) {
                request.setAttribute("error", "Vui lòng chọn loại dịch vụ!");
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }
            
            // Validate date format and future date
//            try {
//                java.sql.Date selectedDate = java.sql.Date.valueOf(dateStr);
//                java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
//                if (selectedDate.before(today)) {
//                    request.setAttribute("error", "Không thể đặt lịch trong quá khứ!");
//                    response.sendRedirect(request.getContextPath() + "/booking");
//                    return;
//                }
//            } catch (IllegalArgumentException e) {
//                request.setAttribute("error", "Ngày không hợp lệ!");
//                response.sendRedirect(request.getContextPath() + "/booking");
//                return;
//            }
            
            // Validate notes length
            if (notes != null && notes.length() > 500) {
                request.setAttribute("error", "Ghi chú không được vượt quá 500 ký tự!");
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }
            // 3. Xử lý lưu // Gộp Ngày + Giờ (dateStr từ input type=date: yyyy-MM-dd; timeStr từ slot: HH:mm)
            String dateTimeString = dateStr + " " + timeStr + ":00";
            Timestamp startTime = Timestamp.valueOf(dateTimeString);
            // Tạo Object
            Appointment appt = new Appointment();
            appt.setPetId(Integer.parseInt(petIdStr));
            appt.setVetId(Integer.parseInt(vetIdStr));
            appt.setStartTime(startTime);
            appt.setType(serviceType);
            appt.setNotes(notes != null ? notes : "");
            // Gọi DAO lưu
            AppointmentDAO dao = new AppointmentDAO();
            boolean isSuccess = false;
            if (rescheduleIdStr != null && !rescheduleIdStr.isEmpty()) {
                // --- TRƯỜNG HỢP 1: ĐỔI LỊCH (UPDATE) ---
                int apptId = Integer.parseInt(rescheduleIdStr);
                appt.setApptId(apptId);
                isSuccess = dao.updateAppointmentFull(appt);
                if (isSuccess) {
                    session.setAttribute("toastMessage", "success|Đổi lịch thành công! Vui lòng chờ duyệt lại.");
                }
            } else {
                // --- TRƯỜNG HỢP 2: ĐẶT MỚI (INSERT) ---
                isSuccess = dao.insertAppointment(appt);
                if (isSuccess) {
                    session.setAttribute("toastMessage", "success|Đặt lịch mới thành công! Vui lòng chờ duyệt.");
                }
            }
            if (isSuccess) {//url
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("error", "Lỗi hệ thống: Không thể lưu cuộc hẹn. Vui lòng thử lại.");
                request.getRequestDispatcher("/booking").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/booking").forward(request, response);
        }
    }
}
=======
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.appointment;

import dal.AppointmentDAO;
import dal.ScheduleVeterianrianDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import model.User;
import java.sql.Timestamp;
import java.time.LocalDate;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "SaveAppointmentController", urlPatterns = {"/save-appointment"})
public class SaveAppointmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
    }

    //XỬ LÝ LƯU CUỘC HẸN
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 1. Get and sanitize input
            String petIdStr = request.getParameter("petId");
            String serviceType = request.getParameter("serviceType");
            String vetIdStr = request.getParameter("vetId");
            String dateStr = request.getParameter("selectedDate");
            String timeStr = request.getParameter("timeSlot");
            String notes = util.ValidationUtils.sanitize(request.getParameter("notes"));
            String rescheduleIdStr = request.getParameter("rescheduleId");
            
            // 2. Validate required fields
            if (!util.ValidationUtils.isNotEmpty(petIdStr) || !util.ValidationUtils.isNotEmpty(vetIdStr) 
                    || !util.ValidationUtils.isNotEmpty(dateStr) || !util.ValidationUtils.isNotEmpty(timeStr)) {
                request.setAttribute("error", "Vui lòng chọn đầy đủ thông tin!");
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }
            
            // Validate pet belongs to current user
            int petId = Integer.parseInt(petIdStr);
            dal.PetDAO petDAO = new dal.PetDAO();
            model.Pet pet = petDAO.getPetById(petId);
            if (pet == null || pet.getOwnerId() != account.getUserId()) {
                request.setAttribute("error", "Thú cưng không hợp lệ hoặc không thuộc về bạn!");
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }
            
            // Validate service type
            if (!util.ValidationUtils.isNotEmpty(serviceType)) {
                request.setAttribute("error", "Vui lòng chọn loại dịch vụ!");
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }
            
            // Validate date format and future date
            try {
                LocalDate selectedDate = LocalDate.parse(dateStr);
                LocalDate today = LocalDate.now();
                if (selectedDate.isBefore(today)) {
                    request.setAttribute("error", "Không thể đặt lịch trong quá khứ!");
                    response.sendRedirect(request.getContextPath() + "/booking");
                    return;
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Ngày không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }
            
            // Business rule: do not allow booking if vet has leave request on that date
            int vetId = Integer.parseInt(vetIdStr);
            java.sql.Date sqlDate = java.sql.Date.valueOf(dateStr);
            ScheduleVeterianrianDAO scheduleDao = new ScheduleVeterianrianDAO();
            String leaveStatus = scheduleDao.getLeaveStatusByEmpAndDate(vetId, sqlDate);
            if (leaveStatus != null) {
                session.setAttribute("toastMessage", "error|Bác sĩ đã đăng ký nghỉ trong ngày này, vui lòng chọn ngày hoặc bác sĩ khác.");
                response.sendRedirect(request.getContextPath() + "/booking?selectedDate=" + dateStr + "&vetId=" + vetIdStr);
                return;
            }

            // Validate notes length
            if (notes != null && notes.length() > 500) {
                request.setAttribute("error", "Ghi chú không được vượt quá 500 ký tự!");
                response.sendRedirect(request.getContextPath() + "/booking");
                return;
            }
            // 3. Xử lý lưu // Gộp Ngày + Giờ (dateStr từ input type=date: yyyy-MM-dd; timeStr từ slot: HH:mm)
            String dateTimeString = dateStr + " " + timeStr + ":00";
            Timestamp startTime = Timestamp.valueOf(dateTimeString);
            // Tạo Object
            Appointment appt = new Appointment();
            appt.setPetId(Integer.parseInt(petIdStr));
            appt.setVetId(Integer.parseInt(vetIdStr));
            appt.setStartTime(startTime);
            appt.setType(serviceType);
            appt.setNotes(notes != null ? notes : "");
            // Gọi DAO lưu
            AppointmentDAO dao = new AppointmentDAO();
            boolean isSuccess = false;
            if (rescheduleIdStr != null && !rescheduleIdStr.isEmpty()) {
                // --- TRƯỜNG HỢP 1: ĐỔI LỊCH (UPDATE) ---
                int apptId = Integer.parseInt(rescheduleIdStr);
                appt.setApptId(apptId);
                isSuccess = dao.updateAppointmentFull(appt);
                if (isSuccess) {
                    session.setAttribute("toastMessage", "success|Đổi lịch thành công! Vui lòng chờ duyệt lại.");
                }
            } else {
                // --- TRƯỜNG HỢP 2: ĐẶT MỚI (INSERT) ---
                isSuccess = dao.insertAppointment(appt);
                if (isSuccess) {
                    session.setAttribute("toastMessage", "success|Đặt lịch mới thành công! Vui lòng chờ duyệt.");
                }
            }
            if (isSuccess) {//url
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("error", "Lỗi hệ thống: Không thể lưu cuộc hẹn. Vui lòng thử lại.");
                request.getRequestDispatcher("/booking").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/booking").forward(request, response);
        }
    }
}
>>>>>>> Stashed changes
