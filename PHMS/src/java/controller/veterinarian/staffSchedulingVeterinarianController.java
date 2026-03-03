/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.veterinarian;

import dal.ScheduleVeterianrianDAO;
import dal.StaffScheduleVeterinarianDAO;
import java.io.IOException;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.StaffScheduleVeterinarian;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "staffSchedulingVeterinarianController", urlPatterns = {"/veterinarian/scheduling"})
public class staffSchedulingVeterinarianController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        // 1. Logic ngày tháng
        LocalDate today = LocalDate.now();
        String dateParam = request.getParameter("date");
        if (dateParam != null && !dateParam.isEmpty()) {
            today = LocalDate.parse(dateParam);
        }
        LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate endOfWeek = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
        // 2. Gọi DAO 
        StaffScheduleVeterinarianDAO dao = new StaffScheduleVeterinarianDAO();
        ScheduleVeterianrianDAO daoForStatusResgister = new ScheduleVeterianrianDAO();
        List<StaffScheduleVeterinarian> mySchedules = dao.getSchedulesByStaffIdAndDateRange(
                account.getUserId(), // ID của bác sĩ đang login
                Date.valueOf(startOfWeek),
                Date.valueOf(endOfWeek)
        );
        // 3. Gom nhóm dữ liệu
        Map<String, List<StaffScheduleVeterinarian>> weeklyMap = new LinkedHashMap<>();
        LocalDate current = startOfWeek;
        while (!current.isAfter(endOfWeek)) {
            weeklyMap.put(current.toString(), new ArrayList<>());
            current = current.plusDays(1);
        }
        for (StaffScheduleVeterinarian s : mySchedules) {
            String key = s.getWorkDate().toString();
            if (weeklyMap.containsKey(key)) {
                weeklyMap.get(key).add(s);
            }
        }
        java.util.Map<String, String> leaveMap = daoForStatusResgister.getLeaveStatusMap(account.getUserId());
        
        request.setAttribute("weeklyMap", weeklyMap);
        request.setAttribute("startOfWeek", startOfWeek);
        request.setAttribute("endOfWeek", endOfWeek);
        request.setAttribute("currentDate", today);
        request.setAttribute("leaveMap", leaveMap);
        request.getRequestDispatcher("/views/veterinarian/staffSchedulingVeterinarian.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        String dateStr = request.getParameter("workDate");
        String shiftType = request.getParameter("shiftType");
        try {
            StaffScheduleVeterinarian s = new StaffScheduleVeterinarian();
            s.setEmpId(account.getUserId()); // Dùng User ID làm Emp ID
            s.setWorkDate(Date.valueOf(dateStr));
            if ("morning".equals(shiftType)) {
                s.setStartTime(java.sql.Time.valueOf("08:00:00"));
                s.setEndTime(java.sql.Time.valueOf("11:00:00"));
            } else if ("afternoon".equals(shiftType)) {
                s.setStartTime(java.sql.Time.valueOf("14:00:00"));
                s.setEndTime(java.sql.Time.valueOf("17:00:00"));
            }
            StaffScheduleVeterinarianDAO dao = new StaffScheduleVeterinarianDAO();
            dao.registerSchedule(s);
            response.sendRedirect(request.getContextPath() + "/veterinarian/scheduling?date=" + dateStr);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/veterinarian/scheduling");
        }
    }
}
