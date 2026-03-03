<<<<<<< Updated upstream
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
import java.util.List;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name="DashboardReceptionistController", urlPatterns={"/receptionist/dashboard"})
public class DashboardReceptionistController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        AppointmentDAO dao = new AppointmentDAO();
        // 1. Lấy danh sách chờ duyệt (giữ nguyên logic cũ)
        List<model.Appointment> pendingList = dao.getPendingAppointments();
        request.setAttribute("pendingList", pendingList);

        // 2. Lấy danh sách TRONG NGÀY (Logic mới)
        List<model.Appointment> todayList = dao.getTodayAppointments();
        request.setAttribute("todayList", todayList);
        request.getRequestDispatcher("/views/receptionist/dashboardReceptionist.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
    }

}
=======
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
import java.util.List;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name="DashboardReceptionistController", urlPatterns={"/receptionist/dashboard"})
public class DashboardReceptionistController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        AppointmentDAO dao = new AppointmentDAO();
        // 1. Lấy danh sách chờ duyệt (giữ nguyên logic cũ)
        List<model.Appointment> pendingList = dao.getPendingAppointments();
        request.setAttribute("pendingList", pendingList);

        // 2. Lấy danh sách TRONG NGÀY (Logic mới)
        List<model.Appointment> todayList = dao.getTodayAppointments();
        request.setAttribute("todayList", todayList);
        request.getRequestDispatcher("/views/receptionist/dashboardReceptionist.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
    }

}
>>>>>>> Stashed changes
