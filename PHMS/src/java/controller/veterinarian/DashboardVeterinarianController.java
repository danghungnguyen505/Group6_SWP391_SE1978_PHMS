package controller.veterinarian;

import dal.AppointmentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Appointment;
import model.User;

@WebServlet(name = "DashboardVeterinarianController", urlPatterns = {"/veterinarian/dashboard"})
public class DashboardVeterinarianController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();

        // Get today's appointments (checked-in, in-progress)
        List<Appointment> todayQueue = dao.getTodayCheckedInAppointmentsForVet(account.getUserId());

        // Get emergency appointments
        List<Appointment> emergencyQueue = dao.getEmergencyAppointmentsForVet(account.getUserId());

        // Calculate stats
        int totalPatients = todayQueue != null ? todayQueue.size() : 0;
        int completedToday = 0;
        int pendingEMR = 0;
        if (todayQueue != null) {
            for (Appointment a : todayQueue) {
                if ("In-Progress".equalsIgnoreCase(a.getStatus())) {
                    completedToday++;
                } else if ("Checked-in".equalsIgnoreCase(a.getStatus())) {
                    pendingEMR++;
                }
            }
        }

        int emergencyCount = emergencyQueue != null ? emergencyQueue.size() : 0;

        request.setAttribute("todayQueue", todayQueue);
        request.setAttribute("emergencyQueue", emergencyQueue);
        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("completedToday", completedToday);
        request.setAttribute("pendingEMR", pendingEMR);
        request.setAttribute("emergencyCount", emergencyCount);

        request.getRequestDispatcher("/views/veterinarian/dashBoardVeterinarian.jsp").forward(request, response);
    }
}
