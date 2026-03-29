/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.receptionist;

import dal.AppointmentDAO;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import model.Appointment;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name="ReceptionistActionController", urlPatterns={"/receptionist/appointment-action"})
public class ReceptionistActionController extends HttpServlet {
    private boolean isWithinCheckInWindow(Timestamp startTime) {
        if (startTime == null) {
            return false;
        }
        LocalDateTime earliestCheckIn = startTime.toLocalDateTime().minusMinutes(5);
        return !LocalDateTime.now().isBefore(earliestCheckIn);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doPost(request, response);
    } 

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        try {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");
            if (idStr != null && status != null) {
                int apptId = Integer.parseInt(idStr);
                AppointmentDAO dao = new AppointmentDAO();
                boolean isUpdated = false;
                // TRƯỜNG HỢP 1: DUYỆT LỊCH (Pending -> Confirmed/Cancelled)
                if (status.equals("Confirmed") || status.equals("Cancelled")) {
                    isUpdated = dao.updateAppointmentStatusWithReceptionist(apptId, status, account.getUserId());
                    
                    if (isUpdated) {
                        String msg = status.equals("Confirmed") ? "Đã duyệt cuộc hẹn thành công!" : "Đã từ chối cuộc hẹn!";
                        session.setAttribute("actionMessage", msg); 
                    } else {
                        session.setAttribute("actionMessage", "Lỗi: Không thể cập nhật (Có thể cuộc hẹn không còn ở trạng thái Pending).");
                    }
                } 
                // TRƯỜNG HỢP 2: CHECK-IN / NO-SHOW (Confirmed -> Checked-in/No-show)
                else if (status.equals("Checked-in") || status.equals("No-show")) {
                    // TEMP DEMO: bypass check-in time window (kept code in comments)
//                    if ("Checked-in".equals(status)) {
//                        Appointment appt = dao.getAppointmentById(apptId);
//                        if (appt == null) {
//                            session.setAttribute("actionMessage", "Lỗi: Không tìm thấy cuộc hẹn.");
//                            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
//                            return;
//                        }
//                        if (!isWithinCheckInWindow(appt.getStartTime())) {
//                            session.setAttribute("actionMessage", "Chỉ được check-in trong vòng 5 phút trước giờ hẹn.");
//                            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
//                            return;
//                        }
//                    }
                    // TEMP DEMO //
                    
                    isUpdated = dao.changeAppointmentStatusByReceptionist(apptId, status, account.getUserId());
                    
                    if (isUpdated) {
                        String msg = status.equals("Checked-in") ? "Check-in thành công!" : "Đã đánh dấu vắng mặt (No-show).";
                        session.setAttribute("actionMessage", msg);
                    } else {
                        session.setAttribute("actionMessage", "Lỗi: Không thể cập nhật trạng thái.");
                    }
                }
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid ID format: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Redirect back based on action type:
        // - Approve/Reject: back to appointment list page
        // - Check-in/No-show: back to dashboard queue
        String status = request.getParameter("status");
        if ("Confirmed".equals(status) || "Cancelled".equals(status)) {
            response.sendRedirect(request.getContextPath() + "/receptionist/appointment");
        } else {
            response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
        }
    }

}

