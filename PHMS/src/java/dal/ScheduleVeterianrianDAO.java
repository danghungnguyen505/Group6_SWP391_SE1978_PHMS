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

    public boolean deleteScheduleById(int scheduleId) {
        String sql = "DELETE FROM Schedule WHERE schedule_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, scheduleId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteScheduleById: " + e.getMessage());
            return false;
        }
    }

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

    /**
     * Get leave request status for a specific employee and date, if any.
     * Returns one of Pending/Approved/Rejected (or other DB value), or null if no leave.
     */
    public String getLeaveStatusByEmpAndDate(int empId, Date workDate) {
        String sql = "SELECT TOP 1 status FROM LeaveRequest WHERE emp_id = ? AND start_date = ? ORDER BY leave_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, empId);
            st.setDate(2, workDate);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getString("status");
            }
        } catch (SQLException e) {
            System.out.println("Error getLeaveStatusByEmpAndDate: " + e.getMessage());
        }
        return null;
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
    
    /**
     * Insert a schedule for a doctor.
     * @param empId Employee ID (doctor ID)
     * @param managerId Manager ID (admin who creates the schedule)
     * @param workDate Work date
     * @param shiftTime Time range in format "HH:mm-HH:mm"
     * @return true if inserted successfully, false otherwise
     */
    public boolean insertSchedule(int empId, int managerId, Date workDate, String shiftTime) {
        // Check if schedule already exists
        String checkSql = "SELECT COUNT(*) FROM Schedule WHERE emp_id = ? AND work_date = ? AND shift_time = ?";
        try (PreparedStatement checkSt = connection.prepareStatement(checkSql)) {
            checkSt.setInt(1, empId);
            checkSt.setDate(2, workDate);
            checkSt.setString(3, shiftTime);
            ResultSet rs = checkSt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // Schedule already exists, skip insertion
                return false;
            }
        } catch (SQLException e) {
            System.out.println("Error checking existing schedule: " + e.getMessage());
            return false;
        }
        
        // Insert new schedule
        String sql = "INSERT INTO Schedule (emp_id, manager_id, work_date, shift_time) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, empId);
            st.setInt(2, managerId);
            st.setDate(3, workDate);
            st.setString(4, shiftTime);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error insertSchedule: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get schedules with optional filters for date and doctor.
     * @param date Optional date filter (null for all dates)
     * @param doctorId Optional doctor ID filter (0 for all doctors)
     * @return List of schedules
     */
    public List<Schedule> getSchedulesWithFilters(Date date, int doctorId) {
        List<Schedule> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.schedule_id, s.emp_id, s.manager_id, s.work_date, s.shift_time, u.full_name "
            + "FROM Schedule s "
            + "JOIN Users u ON s.emp_id = u.user_id "
            + "WHERE 1=1 "
        );
        
        List<Object> params = new ArrayList<>();
        
        if (date != null) {
            sql.append("AND s.work_date = ? ");
            params.add(date);
        }
        
        if (doctorId > 0) {
            sql.append("AND s.emp_id = ? ");
            params.add(doctorId);
        }
        
        sql.append("ORDER BY s.work_date DESC, u.full_name ASC, s.shift_time ASC");
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Date) {
                    st.setDate(i + 1, (Date) param);
                } else if (param instanceof Integer) {
                    st.setInt(i + 1, (Integer) param);
                }
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Schedule s = new Schedule();
                s.setScheduleId(rs.getInt("schedule_id"));
                s.setEmpId(rs.getInt("emp_id"));
                s.setManagerId(rs.getInt("manager_id"));
                s.setWorkDate(rs.getDate("work_date"));
                s.setShiftTime(rs.getString("shift_time"));
                s.setVetName(rs.getString("full_name"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println("Error getSchedulesWithFilters: " + e.getMessage());
        }
        return list;
    }
}
