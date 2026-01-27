/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.receptionist;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name="ReceptionistDashboardController", urlPatterns={"/receptionist/dashboard"})
public class ReceptionistDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        // Lấy danh sách chờ duyệt từ DAO
        dal.AppointmentDAO dao = new dal.AppointmentDAO();
        List<model.Appointment> pendingList = dao.getPendingAppointments();
        //Danh sách đã duyệt
        List<model.Appointment> confirmedList = dao.getConfirmedAppointments();
        request.setAttribute("confirmedList", confirmedList);
        
        request.setAttribute("pendingList", pendingList);
        // Hiển thị thông báo sau Duyệt/Hủy (chỉ 1 lần)
        Object msg = session.getAttribute("actionMessage");
        if (msg != null) {
            request.setAttribute("actionMessage", msg);
            session.removeAttribute("actionMessage");
        }
        request.getRequestDispatcher("/views/receptionist/receptionistDashboard.jsp").forward(request, response);
    } 
//
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

}
