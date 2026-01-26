/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.receptionist;

import dal.AppointmentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name="AppointmentActionController", urlPatterns={"/receptionist/appointment-action"})
public class AppointmentActionController extends HttpServlet {
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
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        try {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");
            if (idStr != null && status != null) {
                int apptId = Integer.parseInt(idStr);
                if (status.equals("Confirmed") || status.equals("Cancelled")) {
                    AppointmentDAO dao = new AppointmentDAO();
                    boolean isUpdated = dao.updateAppointmentStatus(apptId, status);
                    if (isUpdated) {
                        String msg = status.equals("Confirmed") ? "Đã duyệt cuộc hẹn thành công!" : "Đã từ chối cuộc hẹn!";
                        session.setAttribute("actionMessage", msg); 
                    } else {
                        session.setAttribute("actionMessage", "Lỗi: Không thể cập nhật (Có thể cuộc hẹn không còn ở trạng thái Pending).");
                    }
                }
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid ID format: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/receptionist/dashboard");
    }

}
