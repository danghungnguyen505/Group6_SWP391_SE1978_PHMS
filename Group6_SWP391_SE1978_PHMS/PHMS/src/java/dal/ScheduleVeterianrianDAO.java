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
import model.Schedule;
import java.sql.Date;

public class ScheduleVeterianrianDAO extends DBContext {

    public List<Schedule> getAvailableSchedules() {
        List<Schedule> list = new ArrayList<>();
        // Query lấy lịch làm việc trong tương lai và kèm tên bác sĩ
        String sql = "SELECT s.schedule_id, s.emp_id, u.full_name, s.work_date, s.shift_time "
                + "FROM Schedule s "
                + "JOIN Users u ON s.emp_id = u.user_id "
                + "WHERE s.work_date >= CAST(GETDATE() AS DATE)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleId(rs.getInt("schedule_id"));
                s.setEmpId(rs.getInt("emp_id"));
                s.setVetName(rs.getString("full_name"));
                // s.setManagerId(rs.getInt("manager_id")); 
                s.setWorkDate(rs.getDate("work_date"));
                s.setShiftTime(rs.getString("shift_time"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println("Error getAvailableSchedules: " + e);
        }
        return list;
    }

    // Hàm lấy danh sách bác sĩ theo ngày cụ thể
    public List<Schedule> getSchedulesByDate(Date date) {
        List<Schedule> list = new ArrayList<>();
        // Query: Lấy lịch của ngày đó, sắp xếp theo tên bác sĩ và ca làm
        String sql = "SELECT s.schedule_id, s.emp_id, u.full_name, s.work_date, s.shift_time "
                + "FROM Schedule s "
                + "JOIN Users u ON s.emp_id = u.user_id "
                + "WHERE s.work_date = ? "
                + "ORDER BY u.full_name ASC, s.shift_time ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, date);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleId(rs.getInt("schedule_id"));
                s.setEmpId(rs.getInt("emp_id"));
                s.setVetName(rs.getString("full_name"));
                s.setWorkDate(rs.getDate("work_date"));
                s.setShiftTime(rs.getString("shift_time"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println("Error getSchedulesByDate: " + e);
        }
        return list;
    }

    public List<String> getShiftsByVetAndDate(int vetId, Date date) {
        List<String> list = new ArrayList<>();
        // Lấy cột shift_time (ví dụ: "09:00 AM - 11:30 AM")
        String sql = "SELECT shift_time FROM Schedule "
                + "WHERE emp_id = ? AND work_date = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, vetId);
            st.setDate(2, date);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("shift_time"));
            }
        } catch (SQLException e) {
            System.out.println("Error getShiftsByVetAndDate: " + e);
        }
        return list;
    }

    /**
     * Delete schedules for a staff on a specific date (used by leave
     * auto-block).
     */
    public int deleteSchedulesByEmpAndDate(int empId, Date date) {
        String sql = "DELETE FROM Schedule WHERE emp_id = ? AND work_date = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, empId);
            st.setDate(2, date);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleteSchedulesByEmpAndDate: " + e);
            return 0;
        }
    }
    //Ham xin nghi phep
    public boolean insertLeaveRequest(int empId, String startDate, String reason) {
        String sql = "INSERT INTO LeaveRequest (emp_id, manager_id, start_date, reason, status) "
                + "VALUES (?, NULL, ?, ?, 'Pending')";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, empId);
            st.setDate(2, java.sql.Date.valueOf(startDate));
            st.setString(3, reason);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error insertLeaveRequest: " + e.getMessage());
            return false;
        } catch (IllegalArgumentException e) {
            System.out.println("Lỗi định dạng ngày tháng (không phải yyyy-MM-dd): " + e.getMessage());
            return false;
        }
    }
    //Hàm Lấy danh sách trạng thái xin nghỉ phép của một nhân viên
    public java.util.Map<String, String> getLeaveStatusMap(int empId) {
        java.util.Map<String, String> leaveMap = new java.util.HashMap<>();
        // Query lấy ngày và trạng thái của các đơn xin nghỉ
        String sql = "SELECT start_date, status FROM LeaveRequest WHERE emp_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, empId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                // Chuyển java.sql.Date thành chuỗi định dạng yyyy-MM-dd để khớp với JSP
                String dateStr = rs.getDate("start_date").toString();
                String status = rs.getString("status");
                leaveMap.put(dateStr, status);
            }
        } catch (SQLException e) {
            System.out.println("Error getLeaveStatusMap: " + e.getMessage());
        }
        return leaveMap;
    }
}
