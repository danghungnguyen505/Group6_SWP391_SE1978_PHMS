package dal;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Schedule;
import model.TimeSlot;

public class ScheduleDAO extends DBContext {

    public List<Schedule> getSchedulesByVetId(int vetId) {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.schedule_id, s.emp_id, s.manager_id, s.work_date, s.shift_time, "
                + "u.full_name as vet_name "
                + "FROM Schedule s "
                + "INNER JOIN Employee e ON s.emp_id = e.user_id "
                + "INNER JOIN Users u ON e.user_id = u.user_id "
                + "WHERE s.emp_id = ? AND s.work_date >= CAST(GETDATE() AS DATE) "
                + "ORDER BY s.work_date ASC, s.shift_time ASC";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            st.setInt(1, vetId);
            rs = st.executeQuery();
            while (rs.next()) {
                Schedule schedule = new Schedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setEmpId(rs.getInt("emp_id"));
                schedule.setManagerId(rs.getInt("manager_id"));
                schedule.setWorkDate(rs.getDate("work_date"));
                schedule.setShiftTime(rs.getString("shift_time"));
                schedule.setVetName(rs.getString("vet_name"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getSchedulesByVetId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return schedules;
    }

    public List<Schedule> getAllVetSchedules() {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.schedule_id, s.emp_id, s.manager_id, s.work_date, s.shift_time, "
                + "u.full_name as vet_name "
                + "FROM Schedule s "
                + "INNER JOIN Employee e ON s.emp_id = e.user_id "
                + "INNER JOIN Users u ON e.user_id = u.user_id "
                + "INNER JOIN Veterinarian v ON e.user_id = v.emp_id "
                + "WHERE s.work_date >= CAST(GETDATE() AS DATE) "
                + "ORDER BY s.work_date ASC, s.shift_time ASC";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            rs = st.executeQuery();
            while (rs.next()) {
                Schedule schedule = new Schedule();
                schedule.setScheduleId(rs.getInt("schedule_id"));
                schedule.setEmpId(rs.getInt("emp_id"));
                schedule.setManagerId(rs.getInt("manager_id"));
                schedule.setWorkDate(rs.getDate("work_date"));
                schedule.setShiftTime(rs.getString("shift_time"));
                schedule.setVetName(rs.getString("vet_name"));
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAllVetSchedules: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return schedules;
    }

    public List<TimeSlot> getAvailableTimeSlots(Date workDate) {
        List<TimeSlot> timeSlots = new ArrayList<>();
        
        // Get all schedules for the date
        String scheduleSql = "SELECT s.emp_id, s.work_date, s.shift_time, u.full_name as vet_name "
                + "FROM Schedule s "
                + "INNER JOIN Employee e ON s.emp_id = e.user_id "
                + "INNER JOIN Users u ON e.user_id = u.user_id "
                + "INNER JOIN Veterinarian v ON e.user_id = v.emp_id "
                + "WHERE s.work_date = ?";
        
        // Get all appointments for the date
        String appointmentSql = "SELECT vet_id, start_time "
                + "FROM Appointment "
                + "WHERE CAST(start_time AS DATE) = ? "
                + "AND status NOT IN ('Cancelled', 'Completed')";
        
        Map<String, Boolean> bookedSlots = new HashMap<>();
        
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            // Get appointments
            st = connection.prepareStatement(appointmentSql);
            st.setDate(1, workDate);
            rs = st.executeQuery();
            while (rs.next()) {
                int vetId = rs.getInt("vet_id");
                Timestamp startTime = rs.getTimestamp("start_time");
                Calendar cal = Calendar.getInstance();
                cal.setTime(startTime);
                int hour = cal.get(Calendar.HOUR_OF_DAY);
                String key = vetId + "_" + hour;
                bookedSlots.put(key, true);
            }
            rs.close();
            st.close();
            
            // Get schedules and create time slots
            st = connection.prepareStatement(scheduleSql);
            st.setDate(1, workDate);
            rs = st.executeQuery();
            
            while (rs.next()) {
                int vetId = rs.getInt("emp_id");
                String vetName = rs.getString("vet_name");
                String shiftTime = rs.getString("shift_time");
                
                // Parse shift time (e.g., "08:00 - 17:00" or "08:00 - 12:00")
                String[] parts = shiftTime.split(" - ");
                if (parts.length == 2) {
                    int startHour = Integer.parseInt(parts[0].trim().substring(0, 2));
                    int endHour = Integer.parseInt(parts[1].trim().substring(0, 2));
                    
                    // Create time slots for each hour
                    for (int hour = startHour; hour < endHour; hour++) {
                        String key = vetId + "_" + hour;
                        boolean available = !bookedSlots.containsKey(key);
                        
                        TimeSlot slot = new TimeSlot(vetId, vetName, workDate, hour, available);
                        slot.setHasSchedule(true);
                        timeSlots.add(slot);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAvailableTimeSlots: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        
        return timeSlots;
    }

    public List<TimeSlot> getAvailableTimeSlotsByVet(int vetId, Date workDate) {
        List<TimeSlot> timeSlots = new ArrayList<>();
        
        // Get schedule for the vet and date
        String scheduleSql = "SELECT s.emp_id, s.work_date, s.shift_time, u.full_name as vet_name "
                + "FROM Schedule s "
                + "INNER JOIN Employee e ON s.emp_id = e.user_id "
                + "INNER JOIN Users u ON e.user_id = u.user_id "
                + "WHERE s.emp_id = ? AND s.work_date = ?";
        
        // Get appointments for the vet and date
        String appointmentSql = "SELECT start_time "
                + "FROM Appointment "
                + "WHERE vet_id = ? AND CAST(start_time AS DATE) = ? "
                + "AND status NOT IN ('Cancelled', 'Completed')";
        
        List<Integer> bookedHours = new ArrayList<>();
        
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            // Get booked hours
            st = connection.prepareStatement(appointmentSql);
            st.setInt(1, vetId);
            st.setDate(2, workDate);
            rs = st.executeQuery();
            while (rs.next()) {
                Timestamp startTime = rs.getTimestamp("start_time");
                Calendar cal = Calendar.getInstance();
                cal.setTime(startTime);
                bookedHours.add(cal.get(Calendar.HOUR_OF_DAY));
            }
            rs.close();
            st.close();
            
            // Get schedule
            st = connection.prepareStatement(scheduleSql);
            st.setInt(1, vetId);
            st.setDate(2, workDate);
            rs = st.executeQuery();
            
            if (rs.next()) {
                String vetName = rs.getString("vet_name");
                String shiftTime = rs.getString("shift_time");
                
                // Parse shift time
                String[] parts = shiftTime.split(" - ");
                if (parts.length == 2) {
                    int startHour = Integer.parseInt(parts[0].trim().substring(0, 2));
                    int endHour = Integer.parseInt(parts[1].trim().substring(0, 2));
                    
                    // Create time slots for each hour
                    for (int hour = startHour; hour < endHour; hour++) {
                        boolean available = !bookedHours.contains(hour);
                        
                        TimeSlot slot = new TimeSlot(vetId, vetName, workDate, hour, available);
                        slot.setHasSchedule(true);
                        timeSlots.add(slot);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAvailableTimeSlotsByVet: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        
        return timeSlots;
    }
}
