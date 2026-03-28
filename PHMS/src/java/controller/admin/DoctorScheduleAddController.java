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
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.User;

/**
 * Admin adds work schedule for doctors with repeat options (daily, weekly, monthly).
 */
@WebServlet(name = "DoctorScheduleAddController", urlPatterns = {"/admin/doctor/schedule/add"})
public class DoctorScheduleAddController extends HttpServlet {

    // Time slots from 09:00 AM to 05:30 PM
    private static final LocalTime SLOT_START = LocalTime.of(9, 0);
    private static final LocalTime SLOT_END = LocalTime.of(17, 30);
    private static final int SLOT_MINUTES = 30;
    // Display & store time as 12-hour format with AM/PM (e.g. 09:00 AM)
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("hh:mm a");

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

        UserDAO userDAO = new UserDAO();
        List<User> veterinarians = userDAO.getAllVeterinarians();
        request.setAttribute("veterinarians", veterinarians);

        request.setAttribute("timeSlots", buildTimeSlots());

        String prefillDate = request.getParameter("date");
        if (prefillDate != null && !prefillDate.trim().isEmpty()) {
            try {
                LocalDate.parse(prefillDate.trim());
                request.setAttribute("prefillDate", prefillDate.trim());
            } catch (Exception ignore) {
                // ignore invalid date
            }
        }

        request.getRequestDispatcher("/views/admin/doctorScheduleAdd.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String doctorIdStr = request.getParameter("doctorId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String[] selectedSlots = request.getParameterValues("slots");
        String repeatType = request.getParameter("repeatType");
        String repeatEndDateStr = request.getParameter("repeatEndDate");

        if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Vui long chon bac si!");
            doGet(request, response);
            return;
        }

        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            request.setAttribute("error", "Vui long chon ngay bat dau!");
            doGet(request, response);
            return;
        }

        if (selectedSlots == null || selectedSlots.length == 0) {
            request.setAttribute("error", "Vui long chon it nhat 1 slot lam viec (09:00 - 17:30, moi 30 phut)!");
            doGet(request, response);
            return;
        }

        try {
            int doctorId = Integer.parseInt(doctorIdStr);
            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate today = LocalDate.now();

            if (startDate.isBefore(today)) {
                request.setAttribute("error", "Khong the them lich lam viec trong qua khu!");
                doGet(request, response);
                return;
            }

            Set<String> allowedSlots = new HashSet<>(buildTimeSlots());
            List<String> validSlots = new ArrayList<>();
            for (String slot : selectedSlots) {
                if (slot != null) {
                    String trimmed = slot.trim();
                    if (allowedSlots.contains(trimmed)) {
                        validSlots.add(trimmed);
                    }
                }
            }
            if (validSlots.isEmpty()) {
                request.setAttribute("error", "Slot khong hop le. Vui long chon lai!");
                doGet(request, response);
                return;
            }

            ScheduleVeterianrianDAO scheduleDAO = new ScheduleVeterianrianDAO();
            int managerId = account.getUserId();
            int successCount = 0;
            boolean skippedPastTimeSlots = false;

            if (repeatType == null || repeatType.isEmpty() || "none".equals(repeatType)) {
                if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                    LocalDate endDate = LocalDate.parse(endDateStr);
                    if (endDate.isBefore(startDate)) {
                        request.setAttribute("error", "Ngay ket thuc phai sau ngay bat dau!");
                        doGet(request, response);
                        return;
                    }
                    if (endDate.isBefore(today)) {
                        request.setAttribute("error", "Khong the them lich lam viec trong qua khu!");
                        doGet(request, response);
                        return;
                    }

                    LocalDate currentDate = startDate;
                    while (!currentDate.isAfter(endDate)) {
                        for (String slot : validSlots) {
                            if (isSlotInPastForDate(currentDate, slot)) {
                                skippedPastTimeSlots = true;
                                continue;
                            }
                            if (scheduleDAO.insertSchedule(doctorId, managerId, Date.valueOf(currentDate), slot)) {
                                successCount++;
                            }
                        }
                        currentDate = currentDate.plusDays(1);
                    }
                } else {
                    for (String slot : validSlots) {
                        if (isSlotInPastForDate(startDate, slot)) {
                            skippedPastTimeSlots = true;
                            continue;
                        }
                        if (scheduleDAO.insertSchedule(doctorId, managerId, Date.valueOf(startDate), slot)) {
                            successCount++;
                        }
                    }
                }
            } else {
                LocalDate repeatEndDate;
                if (repeatEndDateStr != null && !repeatEndDateStr.trim().isEmpty()) {
                    repeatEndDate = LocalDate.parse(repeatEndDateStr);
                } else {
                    repeatEndDate = startDate.plusMonths(3);
                }

                if (repeatEndDate.isBefore(startDate)) {
                    request.setAttribute("error", "Ngay ket thuc lap lai phai sau ngay bat dau!");
                    doGet(request, response);
                    return;
                }
                if (repeatEndDate.isBefore(today)) {
                    request.setAttribute("error", "Khong the them lich lam viec trong qua khu!");
                    doGet(request, response);
                    return;
                }

                LocalDate currentDate = startDate;
                while (!currentDate.isAfter(repeatEndDate)) {
                    for (String slot : validSlots) {
                        if (isSlotInPastForDate(currentDate, slot)) {
                            skippedPastTimeSlots = true;
                            continue;
                        }
                        if (scheduleDAO.insertSchedule(doctorId, managerId, Date.valueOf(currentDate), slot)) {
                            successCount++;
                        }
                    }

                    switch (repeatType) {
                        case "daily":
                            currentDate = currentDate.plusDays(1);
                            break;
                        case "weekly":
                            currentDate = currentDate.plusWeeks(1);
                            break;
                        case "monthly":
                            currentDate = currentDate.plusMonths(1);
                            break;
                        default:
                            currentDate = repeatEndDate.plusDays(1);
                            break;
                    }
                }
            }

            if (successCount > 0) {
                String msg = skippedPastTimeSlots
                        ? "Da them " + successCount + " lich. Mot so slot hom nay da qua gio nen bi bo qua."
                        : "Da them " + successCount + " lich lam viec thanh cong!";
                session.setAttribute("toastMessage", "success|" + msg);
                response.sendRedirect(request.getContextPath() + "/admin/doctor/schedule/add");
            } else {
                if (skippedPastTimeSlots) {
                    request.setAttribute("error", "Không thể thêm slot đã qua giờ ở ngày hôm nay!");
                } else {
                    request.setAttribute("error", "Khong the them lich lam viec. Co the lich da ton tai!");
                }
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Du lieu khong hop le!");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Loi he thong: " + e.getMessage());
            doGet(request, response);
        }
    }

    private boolean isSlotInPastForDate(LocalDate workDate, String slot) {
        if (workDate == null || slot == null) {
            return false;
        }
        if (!workDate.equals(LocalDate.now())) {
            return false;
        }
        try {
            String[] parts = slot.split("-");
            if (parts.length == 0) {
                return false;
            }
            LocalTime slotStart = LocalTime.parse(parts[0].trim(), TIME_FMT);
            return !slotStart.isAfter(LocalTime.now());
        } catch (Exception e) {
            return false;
        }
    }

    private static List<String> buildTimeSlots() {
        List<String> slots = new ArrayList<>();
        LocalTime t = SLOT_START;
        while (!t.plusMinutes(SLOT_MINUTES).isAfter(SLOT_END)) {
            LocalTime t2 = t.plusMinutes(SLOT_MINUTES);
            slots.add(TIME_FMT.format(t) + "-" + TIME_FMT.format(t2));
            t = t2;
        }
        return slots;
    }
}
