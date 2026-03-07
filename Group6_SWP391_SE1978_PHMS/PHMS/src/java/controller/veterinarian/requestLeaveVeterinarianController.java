/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.veterinarian;

import dal.ScheduleVeterianrianDAO;
import dal.AppointmentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "requestLeaveVeterinarianController", urlPatterns = {"/requestLeaveVeterinarian"})
public class requestLeaveVeterinarianController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/veterinarian/requestLeaveVeterinarian.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String empIdStr = request.getParameter("empId");
        String startDate = request.getParameter("startDate");
        String reason = request.getParameter("reason");
        String shiftType = request.getParameter("shiftType");
        if (shiftType != null && !shiftType.isEmpty()) {
            String shiftLabel = "custom";
            if ("morning".equalsIgnoreCase(shiftType)) {
                shiftLabel = "Morning";
            } else if ("afternoon".equalsIgnoreCase(shiftType)) {
                shiftLabel = "Afternoon";
            }
            reason = "[" + shiftLabel + "] " + reason;
        }
        try {
            int empId = Integer.parseInt(empIdStr);

            // Business rule: do not allow leave request if vet already has appointments on that date
            AppointmentDAO apptDao = new AppointmentDAO();
            java.sql.Date workDate = java.sql.Date.valueOf(startDate);
            boolean hasAppt = apptDao.hasAppointmentsForVetOnDate(empId, workDate);
            if (hasAppt) {
                request.setAttribute("status", "error");
                request.setAttribute("message", "Không thể xin nghỉ vì bạn đã có cuộc hẹn trong ngày này.");
                request.setAttribute("date", startDate);
                request.getRequestDispatcher("/views/veterinarian/requestLeaveVeterinarian.jsp").forward(request, response);
                return;
            }

            ScheduleVeterianrianDAO dao = new ScheduleVeterianrianDAO();
            boolean isSuccess = dao.insertLeaveRequest(empId, startDate, reason);
            if (isSuccess) {
                request.setAttribute("status", "success");
                request.setAttribute("message", "Your leave request has been submitted successfully!");
                request.setAttribute("message", "Your leave request has been submitted successfully!");
                //response.sendRedirect(request.getContextPath() + "/schedule?msg=success");
            } else {
                request.setAttribute("status", "error");
                request.setAttribute("message", "Failed to submit request. Please try again.");
                //response.sendRedirect(request.getContextPath() + "/schedule?msg=error");
            }
            request.setAttribute("date", startDate);
            request.getRequestDispatcher("/views/veterinarian/requestLeaveVeterinarian.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "error");
            request.setAttribute("message", "System error occurred!");
            request.setAttribute("date", startDate);
            request.getRequestDispatcher("/views/veterinarian/requestLeaveVeterinarian.jsp").forward(request, response);
        }
    }

}
