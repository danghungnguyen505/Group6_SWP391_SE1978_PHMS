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
                if (shiftTime != null && shiftTime.contains("-")) {
                    String[] parts = shiftTime.split("-");
                    try {
                        String startStr = parts[0].trim().length() == 5 ? parts[0].trim() + ":00" : parts[0].trim();
                        String endStr = parts[1].trim().length() == 5 ? parts[1].trim() + ":00" : parts[1].trim();
                        sv.setStartTime(java.sql.Time.valueOf(startStr));
                        sv.setEndTime(java.sql.Time.valueOf(endStr));
                    } catch (Exception e) {
                        System.out.println("Format shift_time error: " + shiftTime);
                    }
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
                if (shiftTime != null && shiftTime.contains("-")) {
                    String[] parts = shiftTime.split("-");
                    try {
                        // Thêm ":00" để đúng định dạng Time SQL nếu thiếu
                        String startStr = parts[0].trim().length() == 5 ? parts[0].trim() + ":00" : parts[0].trim();
                        String endStr = parts[1].trim().length() == 5 ? parts[1].trim() + ":00" : parts[1].trim();
                        sv.setStartTime(Time.valueOf(startStr));
                        sv.setEndTime(Time.valueOf(endStr));
                    } catch (Exception e) {
                        System.out.println("Format shift_time error: " + shiftTime);
                    }
                }
                sv.setStatus("Active"); // Bảng cũ không có status giả lập status dựa trên dữ liệu có sẵn
                list.add(sv);
            }
        } catch (SQLException e) {
            System.out.println("Error getSchedulesByDateRange: " + e);
        }
        return list;
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
