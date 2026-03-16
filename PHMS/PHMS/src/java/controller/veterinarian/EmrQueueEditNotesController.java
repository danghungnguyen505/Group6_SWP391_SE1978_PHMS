package controller.veterinarian;

import dal.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 * Trang edit cuộc hẹn trong EMR Queue (hiện thông tin + sửa notes).
 */
@WebServlet(name = "EmrQueueEditNotesController", urlPatterns = {"/veterinarian/emr/queue/edit"})
public class EmrQueueEditNotesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdRaw = request.getParameter("apptId");
        int apptId;
        try {
            apptId = Integer.parseInt(apptIdRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        model.Appointment appt = dao.getAppointmentById(apptId);
        if (appt == null || appt.getVetId() != account.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        request.setAttribute("appt", appt);
        request.getRequestDispatcher("/views/veterinarian/emrQueueEdit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String apptIdRaw = request.getParameter("apptId");
        String notes = request.getParameter("notes");

        int apptId;
        try {
            apptId = Integer.parseInt(apptIdRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();
        dao.updateAppointmentNotes(apptId, notes != null ? notes.trim() : null);

        response.sendRedirect(request.getContextPath() + "/veterinarian/emr/queue");
    }
}

