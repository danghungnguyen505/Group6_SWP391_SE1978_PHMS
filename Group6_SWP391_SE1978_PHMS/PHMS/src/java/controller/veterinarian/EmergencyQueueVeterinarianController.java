package controller.veterinarian;

import dal.AppointmentDAO;
import dal.TriageRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Appointment;
import model.TriageRecord;
import model.User;

/**
 * Veterinarian emergency queue.
 * SRP: Read list of emergency appointments for current vet.
 */
@WebServlet(name = "EmergencyQueueVeterinarianController", urlPatterns = {"/veterinarian/emergency/queue"})
public class EmergencyQueueVeterinarianController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AppointmentDAO apptDAO = new AppointmentDAO();
        List<Appointment> list = apptDAO.getEmergencyAppointmentsForVet(account.getUserId());

        TriageRecordDAO triageDAO = new TriageRecordDAO();
        Map<Integer, TriageRecord> triageMap = new HashMap<>();
        for (Appointment a : list) {
            TriageRecord tr = triageDAO.getByAppointment(a.getApptId());
            if (tr != null) {
                triageMap.put(a.getApptId(), tr);
            }
        }

        request.setAttribute("appointments", list);
        request.setAttribute("triageMap", triageMap);
        request.getRequestDispatcher("/views/veterinarian/emergencyQueue.jsp").forward(request, response);
    }
}

