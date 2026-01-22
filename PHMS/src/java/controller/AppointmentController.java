package controller;

import dal.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "AppointmentController", urlPatterns = {"/appointments"})
public class AppointmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !account.getRole().equalsIgnoreCase("Owner")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        request.setAttribute("appointments", appointmentDAO.getAppointmentsByOwnerId(account.getUserId()));
        
        String success = request.getParameter("success");
        if (success != null) {
            request.setAttribute("success", success);
        }

        request.getRequestDispatcher("/views/myAppointments.jsp").forward(request, response);
    }
}
