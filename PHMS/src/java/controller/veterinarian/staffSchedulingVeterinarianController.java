package controller.veterinarian;

import dal.ScheduleVeterianrianDAO;
import dal.StaffScheduleVeterinarianDAO;
import java.io.IOException;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
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

        LocalDate today = LocalDate.now();
        String dateParam = request.getParameter("date");
        if (dateParam != null && !dateParam.isEmpty()) {
            today = LocalDate.parse(dateParam);
        }

        LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate endOfWeek = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));

        StaffScheduleVeterinarianDAO dao = new StaffScheduleVeterinarianDAO();
        ScheduleVeterianrianDAO daoForStatusResgister = new ScheduleVeterianrianDAO();
        List<StaffScheduleVeterinarian> mySchedules = dao.getSchedulesByStaffIdAndDateRange(
                account.getUserId(),
                Date.valueOf(startOfWeek),
                Date.valueOf(endOfWeek)
        );

        Map<String, Map<String, StaffScheduleVeterinarian>> weeklyMap = new LinkedHashMap<>();
        LocalDate current = startOfWeek;
        while (!current.isAfter(endOfWeek)) {
            Map<String, StaffScheduleVeterinarian> shiftMap = new LinkedHashMap<>();
            weeklyMap.put(current.toString(), shiftMap);
            current = current.plusDays(1);
        }

        for (StaffScheduleVeterinarian s : mySchedules) {
            String key = s.getWorkDate().toString();
            if (weeklyMap.containsKey(key)) {
                String shiftType = s.getShiftType() != null ? s.getShiftType() : "morning";
                if (!weeklyMap.get(key).containsKey(shiftType)) {
                    weeklyMap.get(key).put(shiftType, s);
                }
            }
        }

        Map<String, String> leaveMap = daoForStatusResgister.getLeaveStatusMap(account.getUserId());

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
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        session.setAttribute("toastMessage", "info|Add shift is disabled on this page.");
        response.sendRedirect(request.getContextPath() + "/veterinarian/scheduling");
    }
}
