/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author zoxy4
 */
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Locale;
import model.StaffScheduleVeterinarian;
//chỉ đọc dữ liệu của lịch trình,đăng ký lịch ở ScheduleVeterianrianDAO
public class StaffScheduleVeterinarianDAO extends DBContext{
    
    // Hàm lấy lịch theo StaffID và khoảng thời gian
    public List<StaffScheduleVeterinarian> getSchedulesByStaffIdAndDateRange(int staffId, Date startDate, Date endDate) {
        List<StaffScheduleVeterinarian> list = new ArrayList<>();
        String sql = "SELECT s.schedule_id, s.work_date, s.shift_time, "
                   + "e.user_id AS emp_id, u.full_name, u.role "
                   + "FROM Schedule s "
                   + "JOIN Employee e ON s.emp_id = e.user_id "
                   + "JOIN Users u ON e.user_id = u.user_id "
                   + "WHERE s.emp_id = ? " // <--- Chỉ lấy được lịch của bản thân
                   + "AND s.work_date BETWEEN ? AND ? "
                   + "ORDER BY s.work_date";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, staffId);
            st.setDate(2, startDate);
            st.setDate(3, endDate);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                StaffScheduleVeterinarian sv = new StaffScheduleVeterinarian();
                sv.setScheduleId(rs.getInt("schedule_id"));
                sv.setWorkDate(rs.getDate("work_date"));
                sv.setEmpId(rs.getInt("emp_id"));
                sv.setStaffName(rs.getString("full_name"));
                sv.setRole(rs.getString("role"));
                String shiftTime = rs.getString("shift_time");
                sv.setShiftTime(shiftTime);
                Time[] parsed = parseShiftTimeToSqlTimes(shiftTime);
                if (parsed != null) {
                    sv.setStartTime(parsed[0]);
                    sv.setEndTime(parsed[1]);
                }
                sv.setStatus("Active");
                list.add(sv);
            }
        } catch (SQLException e) {
            System.out.println("Error getSchedulesByStaffIdAndDateRange: " + e);
        }
        return list;
    }
    
    
    // Lấy lịch làm việc từ bảng Schedule cũ(Hàm này lấy đc lịch của all doctor) (Có thể dùng hoặc không)
    public List<StaffScheduleVeterinarian> getSchedulesByDateRange(Date startDate, Date endDate) {
        List<StaffScheduleVeterinarian> list = new ArrayList<>();
        // JOIN với bảng Employee và Users để lấy tên và role
        String sql = "SELECT s.schedule_id, s.work_date, s.shift_time, "
                   + "e.user_id AS emp_id, u.full_name, u.role "
                   + "FROM Schedule s "
                   + "JOIN Employee e ON s.emp_id = e.user_id "
                   + "JOIN Users u ON e.user_id = u.user_id "
                   + "WHERE s.work_date BETWEEN ? AND ? "
                   + "ORDER BY s.work_date";
                   
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, startDate);
            st.setDate(2, endDate);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                StaffScheduleVeterinarian sv = new StaffScheduleVeterinarian();
                sv.setScheduleId(rs.getInt("schedule_id"));
                sv.setWorkDate(rs.getDate("work_date"));
                sv.setEmpId(rs.getInt("emp_id"));
                sv.setStaffName(rs.getString("full_name"));
                sv.setRole(rs.getString("role"));
                String shiftTime = rs.getString("shift_time");// Xử lý tách chuỗi shift_time ("08:00-16:00") thành Time object
                sv.setShiftTime(shiftTime);
                Time[] parsed = parseShiftTimeToSqlTimes(shiftTime);
                if (parsed != null) {
                    sv.setStartTime(parsed[0]);
                    sv.setEndTime(parsed[1]);
                }
                sv.setStatus("Active"); // Bảng cũ không có status giả lập status dựa trên dữ liệu có sẵn
                list.add(sv);
            }
        } catch (SQLException e) {
            System.out.println("Error getSchedulesByDateRange: " + e);
        }
        return list;
    }

    /**
     * Supports both formats:
     * - "HH:mm-HH:mm" or "HH:mm:SS-HH:mm:SS"
     * - "hh:mm AM-hh:mm PM" (with or without spaces around '-')
     */
    private Time[] parseShiftTimeToSqlTimes(String shiftTime) {
        if (shiftTime == null) {
            return null;
        }
        String s = shiftTime.trim();
        if (s.isEmpty() || !s.contains("-")) {
            return null;
        }

        String[] parts = s.split("\\s*-\\s*");
        if (parts.length != 2) {
            return null;
        }

        LocalTime start = parseToLocalTime(parts[0].trim());
        LocalTime end = parseToLocalTime(parts[1].trim());
        if (start == null || end == null) {
            return null;
        }
        return new Time[]{Time.valueOf(start), Time.valueOf(end)};
    }

    private LocalTime parseToLocalTime(String raw) {
        if (raw == null) {
            return null;
        }
        String t = raw.trim().toUpperCase(Locale.ENGLISH);
        if (t.isEmpty()) {
            return null;
        }

        // Try 24h formats first
        try {
            if (t.length() == 5) { // HH:mm
                return LocalTime.parse(t, DateTimeFormatter.ofPattern("HH:mm"));
            }
            if (t.length() == 8) { // HH:mm:ss
                return LocalTime.parse(t, DateTimeFormatter.ofPattern("HH:mm:ss"));
            }
        } catch (DateTimeParseException ignore) {
        }

        // Try 12h with AM/PM (e.g. 09:00 AM)
        try {
            return LocalTime.parse(t, DateTimeFormatter.ofPattern("hh:mm a", Locale.ENGLISH));
        } catch (DateTimeParseException ignore) {
        }
        try {
            return LocalTime.parse(t, DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH));
        } catch (DateTimeParseException ignore) {
        }

        return null;
    }

    // Đăng ký lịch (Gộp giờ thành chuỗi để lưu vào bảng cũ)
    public boolean registerSchedule(StaffScheduleVeterinarian s) {
        // shift_time sẽ lưu dạng "08:00-16:00"
        String sql = "INSERT INTO Schedule (emp_id, work_date, shift_time, manager_id) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, s.getEmpId());
            st.setDate(2, s.getWorkDate());
            // Format Time thành String HH:mm
            String timeRange = s.getStartTime().toString().substring(0, 5) + "-" + s.getEndTime().toString().substring(0, 5);
            st.setString(3, timeRange);
            st.setObject(4, null); // Manager ID để null hoặc set cứng
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error registerSchedule: " + e);
            return false;
        }
    }
}