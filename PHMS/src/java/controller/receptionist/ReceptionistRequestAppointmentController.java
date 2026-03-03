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
 * @author zoxy4 (ReceptionistRequestAppointmentController)
 */
@WebServlet(name="ReceptionistDashboardController", urlPatterns={"/receptionist/appointment"})
public class ReceptionistRequestAppointmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        
        // Get filter parameters
        String filterDate = request.getParameter("filterDate");
        String filterStatus = request.getParameter("filterStatus");
        String filterVetIdStr = request.getParameter("filterVetId");
        
        Integer filterVetId = null;
        if (util.ValidationUtils.isNotEmpty(filterVetIdStr) && util.ValidationUtils.isIntegerInRange(filterVetIdStr, 1, Integer.MAX_VALUE)) {
            filterVetId = Integer.parseInt(filterVetIdStr);
        }
        
        dal.AppointmentDAO dao = new dal.AppointmentDAO();
        List<model.Appointment> allAppointments;
        
        // Apply filters if provided
        if (util.ValidationUtils.isNotEmpty(filterDate) || util.ValidationUtils.isNotEmpty(filterStatus) || filterVetId != null) {
            allAppointments = dao.getAppointmentsWithFilters(filterDate, filterDate, filterStatus, filterVetId);
        } else {
            // Default: show pending and confirmed
            allAppointments = dao.getPendingAppointments();
            allAppointments.addAll(dao.getConfirmedAppointments());
        }
        
        // Get all veterinarians for filter dropdown
        dal.UserDAO userDAO = new dal.UserDAO();
        List<User> veterinarians = userDAO.getAllVeterinarians();
        request.setAttribute("veterinarians", veterinarians);
        
        // Pagination
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int totalPages = util.PaginationUtils.getTotalPages(allAppointments, pageSize);
        page = util.PaginationUtils.getValidPage(page, totalPages);
        List<model.Appointment> appointmentList = util.PaginationUtils.getPage(allAppointments, page, pageSize);
        
        // Set attributes
        request.setAttribute("appointments", appointmentList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", allAppointments.size());
        request.setAttribute("filterDate", filterDate);
        request.setAttribute("filterStatus", filterStatus);
        request.setAttribute("filterVetId", filterVetIdStr);
        // Hiển thị thông báo sau Duyệt/Hủy (chỉ 1 lần)
        Object msg = session.getAttribute("actionMessage");
        if (msg != null) {
            request.setAttribute("actionMessage", msg);
            session.removeAttribute("actionMessage");
        }
        request.getRequestDispatcher("/views/receptionist/receptionistRequestAppointment.jsp").forward(request, response);
    } 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

}
