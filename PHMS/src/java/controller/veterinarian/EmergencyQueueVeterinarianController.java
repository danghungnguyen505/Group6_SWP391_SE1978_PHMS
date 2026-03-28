package controller.veterinarian;

import dal.AppointmentDAO;
import dal.MedicalRecordDAO;
import dal.TriageRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Appointment;
import model.TriageRecord;
import model.User;
import util.PaginationUtils;

/**
 * Veterinarian emergency queue.
 * SRP: Read list of emergency appointments for current vet.
 */
@WebServlet(name = "EmergencyQueueVeterinarianController", urlPatterns = {"/veterinarian/emergency/queue"})
public class EmergencyQueueVeterinarianController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

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

        String filter = request.getParameter("filter");
        if (filter == null) filter = "all";

        String level = request.getParameter("level");
        if (level == null || level.trim().isEmpty()) {
            level = "all";
        } else {
            String lv = level.trim();
            if ("Critical".equalsIgnoreCase(lv)) {
                level = "Critical";
            } else if ("High".equalsIgnoreCase(lv)) {
                level = "High";
            } else if ("Medium".equalsIgnoreCase(lv)) {
                level = "Medium";
            } else if ("Low".equalsIgnoreCase(lv)) {
                level = "Low";
            } else {
                level = "all";
            }
        }

        String search = request.getParameter("search");
        if (search != null && search.trim().isEmpty()) {
            search = null;
        }

        List<Appointment> all;
        if (search != null && !search.trim().isEmpty()) {
            all = apptDAO.searchEmergencyAppointmentsForVet(account.getUserId(), search.trim(), filter.equals("all") ? null : filter);
        } else if ("all".equals(filter)) {
            all = apptDAO.getEmergencyAppointmentsForVet(account.getUserId());
        } else {
            all = apptDAO.filterEmergencyAppointmentsByStatusForVet(account.getUserId(), filter);
        }

        TriageRecordDAO triageDAO = new TriageRecordDAO();
        MedicalRecordDAO mrDAO = new MedicalRecordDAO();
        Map<Integer, TriageRecord> triageMap = new HashMap<>();
        Map<Integer, Integer> recordIdMap = new HashMap<>();
        for (Appointment a : all) {
            TriageRecord tr = triageDAO.getByAppointment(a.getApptId());
            if (tr != null) {
                triageMap.put(a.getApptId(), tr);
            }
            Integer recordId = mrDAO.getRecordIdByApptForVet(a.getApptId(), account.getUserId());
            if (recordId != null) {
                recordIdMap.put(a.getApptId(), recordId);
            }
        }

        if (!"all".equalsIgnoreCase(level)) {
            List<Appointment> filteredByLevel = new ArrayList<>();
            for (Appointment a : all) {
                TriageRecord tr = triageMap.get(a.getApptId());
                if (tr != null && level.equalsIgnoreCase(tr.getConditionLevel())) {
                    filteredByLevel.add(a);
                }
            }
            all = filteredByLevel;
        }

        all.sort(Comparator
                .comparing(Appointment::getStartTime, Comparator.nullsLast(Comparator.naturalOrder()))
                .thenComparing(Appointment::getApptId, Comparator.nullsLast(Comparator.naturalOrder()))
                .reversed());

        int page = 1;
        int pageSize = PaginationUtils.normalizePageSize(request.getParameter("size"), PAGE_SIZE);
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int totalPages = PaginationUtils.getTotalPages(all, pageSize);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<Appointment> list = PaginationUtils.getPage(all, page, pageSize);

        request.setAttribute("appointments", list);
        request.setAttribute("triageMap", triageMap);
        request.setAttribute("recordIdMap", recordIdMap);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("filter", filter);
        request.setAttribute("level", level);
        request.setAttribute("search", search != null ? search : "");
        request.getRequestDispatcher("/views/veterinarian/emergencyQueue.jsp").forward(request, response);
    }
}

