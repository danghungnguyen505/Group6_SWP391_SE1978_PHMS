package controller.admin;

import dal.ScheduleVeterianrianDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Schedule;
import model.User;

/**
 * Admin views all doctor schedules with weekly calendar view and filters by date and doctor.
 */
@WebServlet(name = "DoctorScheduleListController", urlPatterns = {"/admin/doctor/schedule/list"})
public class DoctorScheduleListController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get list of veterinarians for filter dropdown
        UserDAO userDAO = new UserDAO();
        List<User> veterinarians = userDAO.getAllVeterinarians();
        request.setAttribute("veterinarians", veterinarians);
        
        // Get filter parameters
        String dateStr = request.getParameter("date");
        String doctorIdStr = request.getParameter("doctorId");
        
        // Determine which week to show
        LocalDate today = LocalDate.now();
        if (dateStr != null && !dateStr.trim().isEmpty()) {
            try {
                today = LocalDate.parse(dateStr);
            } catch (Exception e) {
                // Invalid date, use today
            }
        }
        
        LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate endOfWeek = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
        
        int filterDoctorId = 0;
        if (doctorIdStr != null && !doctorIdStr.trim().isEmpty()) {
            try {
                filterDoctorId = Integer.parseInt(doctorIdStr);
            } catch (NumberFormatException e) {
                // Invalid doctor ID, ignore
            }
        }
        
        // Get schedules for the week with optional doctor filter
        ScheduleVeterianrianDAO scheduleDAO = new ScheduleVeterianrianDAO();
        List<Schedule> allSchedules = scheduleDAO.getSchedulesWithFilters(null, filterDoctorId);
        
        // Filter schedules within the week range
        List<Schedule> weekSchedules = new ArrayList<>();
        for (Schedule s : allSchedules) {
            LocalDate scheduleDate = s.getWorkDate().toLocalDate();
            if (!scheduleDate.isBefore(startOfWeek) && !scheduleDate.isAfter(endOfWeek)) {
                // Attach leave status (if any) so UI can highlight card
                String leaveStatus = scheduleDAO.getLeaveStatusByEmpAndDate(
                        s.getEmpId(),
                        s.getWorkDate()
                );
                s.setLeaveStatus(leaveStatus);
                weekSchedules.add(s);
            }
        }
        
        // Group schedules by date
        Map<String, List<Schedule>> weeklyMap = new LinkedHashMap<>();
        LocalDate current = startOfWeek;
        while (!current.isAfter(endOfWeek)) {
            weeklyMap.put(current.toString(), new ArrayList<>());
            current = current.plusDays(1);
        }
        
        for (Schedule s : weekSchedules) {
            String key = s.getWorkDate().toString();
            if (weeklyMap.containsKey(key)) {
                weeklyMap.get(key).add(s);
            }
        }
        
        // Calculate total shifts
        int totalShifts = weekSchedules.size();
        
        // Get selected doctor name
        String selectedDoctorName = "Tất cả bác sĩ";
        if (filterDoctorId > 0) {
            for (User vet : veterinarians) {
                if (vet.getUserId() == filterDoctorId) {
                    selectedDoctorName = vet.getFullName();
                    break;
                }
            }
        }
        
        // Calculate prev/next week dates for navigation
        LocalDate prevWeek = startOfWeek.minusWeeks(1);
        LocalDate nextWeek = startOfWeek.plusWeeks(1);
        
        request.setAttribute("weeklyMap", weeklyMap);
        request.setAttribute("startOfWeek", startOfWeek.toString());
        request.setAttribute("endOfWeek", endOfWeek.toString());
        request.setAttribute("currentDate", today.toString());
        request.setAttribute("prevWeek", prevWeek.toString());
        request.setAttribute("nextWeek", nextWeek.toString());
        request.setAttribute("selectedDoctorId", doctorIdStr);
        request.setAttribute("selectedDoctorName", selectedDoctorName);
        request.setAttribute("totalShifts", totalShifts);
        
        request.getRequestDispatcher("/views/admin/doctorScheduleList.jsp").forward(request, response);
    }
}
