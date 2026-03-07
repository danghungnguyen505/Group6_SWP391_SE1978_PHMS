/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.veterinarian;

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
@WebServlet(name="DashboardVeterinarianController", urlPatterns={"/veterinarian/dashboard"})
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

        int vetId = account.getUserId();
        AppointmentDAO apptDAO = new AppointmentDAO();
        dal.LabTestDAO labDAO = new dal.LabTestDAO();

        // Fetch dashboard data
        List<model.Appointment> todaySchedule = apptDAO.getTodayAppointmentsForVet(vetId);
        int patientsToday = todaySchedule.size();
        
        int emrUpdatesReq = 0;
        for (model.Appointment a : todaySchedule) {
            if ("In-Progress".equals(a.getStatus())) {
                emrUpdatesReq++;
            }
        }

        int pendingLabResults = labDAO.getPendingLabResultsCountForVet(vetId);

        // Pass data to JSP
        request.setAttribute("todaySchedule", todaySchedule);
        request.setAttribute("patientsToday", patientsToday);
        request.setAttribute("emrUpdatesReq", emrUpdatesReq);
        request.setAttribute("pendingLabResults", pendingLabResults);

        request.getRequestDispatcher("/views/veterinarian/dashBoardVeterinarian.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
    }

}
