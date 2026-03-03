/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import dal.LeaveRequestDAO;
import dal.ScheduleVeterianrianDAO;
import model.LeaveRequest;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "UpdateLeaveStatusController", urlPatterns = {"/updateLeaveStatus"})
public class updateLeaveStatusController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int leaveId = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action"); 
        String newStatus = "approve".equals(action) ? "Approved" : "Rejected";
        dal.LeaveRequestDAO leaveDao = new dal.LeaveRequestDAO();
        // Gọi hàm update DAO (chỉ truyền 2 tham số)
        boolean isUpdated = leaveDao.updateLeaveStatus(leaveId, newStatus);
        // TODO: Có thể hiển thị thông báo theo isUpdated nếu cần
        response.sendRedirect(request.getContextPath() + "/leavePending");
    }
}