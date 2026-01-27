/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.appointment;

import dal.AppointmentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Appointment;
import java.sql.Timestamp;
/**
 *
 * @author zoxy4
 */
@WebServlet(name="SaveAppointmentController", urlPatterns={"/save-appointment"})
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
        try {
            // 1. // Lấy dữ liệu từ form
            String petIdStr = request.getParameter("petId");
            String serviceType = request.getParameter("serviceType");
            String vetIdStr = request.getParameter("vetId");
            String dateStr = request.getParameter("selectedDate");
            String timeStr = request.getParameter("timeSlot");
            String notes = request.getParameter("notes");
            // 2. Validate (Nếu thiếu dữ liệu thì đẩy về trang đặt lịch kèm thông báo lỗi)
            if (petIdStr == null || vetIdStr == null || dateStr == null || timeStr == null || 
                petIdStr.isEmpty() || vetIdStr.isEmpty() || dateStr.isEmpty() || timeStr.isEmpty()) {
                
                request.setAttribute("error", "Vui lòng chọn đầy đủ thông tin!");
                // Forward ngược lại BookingController để hiện lại form
                request.getRequestDispatcher("/booking").forward(request, response);
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
            boolean isSaved = dao.insertAppointment(appt);

            if (isSaved) {
                // 4. THÀNH CÔNG: Dùng Session để lưu thông báo & Redirect về Home
                HttpSession session = request.getSession();
                session.setAttribute("toastMessage", "success|Đặt lịch thành công! Vui lòng chờ duyệt.");
                
                //Dùng sendRedirect để tránh lỗi lặp lại khi F5
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("error", "Lỗi hệ thống: Không thể lưu cuộc hẹn.");
                request.getRequestDispatcher("/booking").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/booking").forward(request, response);
        }
    }
}
