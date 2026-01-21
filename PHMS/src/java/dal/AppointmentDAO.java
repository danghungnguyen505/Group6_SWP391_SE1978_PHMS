package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import model.Appointment;

public class AppointmentDAO extends DBContext {

    public int createAppointment(int petId, int vetId, Timestamp startTime, String type, int serviceId) {
        String sql = "INSERT INTO Appointment (pet_id, vet_id, start_time, status, type, created_at) VALUES (?, ?, ?, 'Pending Payment', ?, GETDATE())";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setInt(1, petId);
            st.setInt(2, vetId);
            st.setTimestamp(3, startTime);
            st.setString(4, type);
            int result = st.executeUpdate();
            if (result > 0) {
                rs = st.getGeneratedKeys();
                if (rs.next()) {
                    int apptId = rs.getInt(1);
                    // Store service_id in a separate table or add to Appointment table
                    // For now, we'll add it to a junction table or extend Appointment
                    return apptId;
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi createAppointment: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return -1;
    }

    public List<Appointment> getAppointmentsByOwnerId(int ownerId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.appt_id, a.pet_id, a.vet_id, a.start_time, a.status, a.type, "
                + "p.name as pet_name, u.full_name as vet_name "
                + "FROM Appointment a "
                + "INNER JOIN Pet p ON a.pet_id = p.pet_id "
                + "INNER JOIN Veterinarian v ON a.vet_id = v.emp_id "
                + "INNER JOIN Employee e ON v.emp_id = e.user_id "
                + "INNER JOIN Users u ON e.user_id = u.user_id "
                + "WHERE p.owner_id = ? "
                + "ORDER BY a.start_time DESC";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            rs = st.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setApptId(rs.getInt("appt_id"));
                appt.setPetId(rs.getInt("pet_id"));
                appt.setVetId(rs.getInt("vet_id"));
                appt.setStartTime(rs.getTimestamp("start_time"));
                appt.setStatus(rs.getString("status"));
                appt.setType(rs.getString("type"));
                appt.setPetName(rs.getString("pet_name"));
                appt.setVetName(rs.getString("vet_name"));
                appointments.add(appt);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAppointmentsByOwnerId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return appointments;
    }

    public boolean updateAppointmentStatus(int apptId, String status) {
        String sql = "UPDATE Appointment SET status = ? WHERE appt_id = ?";
        PreparedStatement st = null;
        try {
            st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, apptId);
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi updateAppointmentStatus: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return false;
    }

    public List<Appointment> getTodayAppointmentsForVet(int vetId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql;
        if (vetId == 0) {
            // Get all appointments for today (for receptionist)
            sql = "SELECT a.appt_id, a.pet_id, a.vet_id, a.start_time, a.status, a.type, "
                    + "p.name as pet_name, u.full_name as vet_name "
                    + "FROM Appointment a "
                    + "INNER JOIN Pet p ON a.pet_id = p.pet_id "
                    + "INNER JOIN Veterinarian v ON a.vet_id = v.emp_id "
                    + "INNER JOIN Employee e ON v.emp_id = e.user_id "
                    + "INNER JOIN Users u ON e.user_id = u.user_id "
                    + "WHERE CAST(a.start_time AS DATE) = CAST(GETDATE() AS DATE) "
                    + "AND a.status IN ('Confirmed', 'Pending Payment') "
                    + "ORDER BY a.start_time ASC";
        } else {
            sql = "SELECT a.appt_id, a.pet_id, a.vet_id, a.start_time, a.status, a.type, "
                    + "p.name as pet_name, u.full_name as vet_name "
                    + "FROM Appointment a "
                    + "INNER JOIN Pet p ON a.pet_id = p.pet_id "
                    + "INNER JOIN Veterinarian v ON a.vet_id = v.emp_id "
                    + "INNER JOIN Employee e ON v.emp_id = e.user_id "
                    + "INNER JOIN Users u ON e.user_id = u.user_id "
                    + "WHERE a.vet_id = ? AND CAST(a.start_time AS DATE) = CAST(GETDATE() AS DATE) "
                    + "AND a.status IN ('Confirmed', 'Checked-in') "
                    + "ORDER BY a.start_time ASC";
        }
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            if (vetId != 0) {
                st.setInt(1, vetId);
            }
            rs = st.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setApptId(rs.getInt("appt_id"));
                appt.setPetId(rs.getInt("pet_id"));
                appt.setVetId(rs.getInt("vet_id"));
                appt.setStartTime(rs.getTimestamp("start_time"));
                appt.setStatus(rs.getString("status"));
                appt.setType(rs.getString("type"));
                appt.setPetName(rs.getString("pet_name"));
                appt.setVetName(rs.getString("vet_name"));
                appointments.add(appt);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getTodayAppointmentsForVet: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return appointments;
    }

    public List<Appointment> getAppointmentsForNotification() {
        List<Appointment> appointments = new ArrayList<>();
        // Get appointments scheduled for tomorrow (any time)
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date tomorrow = cal.getTime();
        java.sql.Date tomorrowDate = new java.sql.Date(tomorrow.getTime());

        String sql = "SELECT a.appt_id, a.pet_id, a.vet_id, a.start_time, a.status, a.type, "
                + "p.name as pet_name, u.full_name as vet_name, po.email "
                + "FROM Appointment a "
                + "INNER JOIN Pet p ON a.pet_id = p.pet_id "
                + "INNER JOIN PetOwner po ON p.owner_id = po.user_id "
                + "INNER JOIN Veterinarian v ON a.vet_id = v.emp_id "
                + "INNER JOIN Employee e ON v.emp_id = e.user_id "
                + "INNER JOIN Users u ON e.user_id = u.user_id "
                + "WHERE CAST(a.start_time AS DATE) = ? "
                + "AND a.status IN ('Confirmed', 'Pending Payment')";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            st.setDate(1, tomorrowDate);
            rs = st.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setApptId(rs.getInt("appt_id"));
                appt.setPetId(rs.getInt("pet_id"));
                appt.setVetId(rs.getInt("vet_id"));
                appt.setStartTime(rs.getTimestamp("start_time"));
                appt.setStatus(rs.getString("status"));
                appt.setType(rs.getString("type"));
                appt.setPetName(rs.getString("pet_name"));
                appt.setVetName(rs.getString("vet_name"));
                appt.setOwnerEmail(rs.getString("email"));
                appointments.add(appt);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAppointmentsForNotification: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return appointments;
    }

    public List<Appointment> getPendingPaymentAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        // Get appointments with status "Pending Payment" that were created more than 15 minutes ago

        String sql = "SELECT appt_id, pet_id, vet_id, start_time, status, type "
                + "FROM Appointment "
                + "WHERE status = 'Pending Payment' "
                + "AND created_at IS NOT NULL "
                + "AND GETDATE() > DATEADD(MINUTE, 15, created_at)";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            rs = st.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setApptId(rs.getInt("appt_id"));
                appt.setPetId(rs.getInt("pet_id"));
                appt.setVetId(rs.getInt("vet_id"));
                appt.setStartTime(rs.getTimestamp("start_time"));
                appt.setStatus(rs.getString("status"));
                appt.setType(rs.getString("type"));
                appointments.add(appt);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getPendingPaymentAppointments: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return appointments;
    }

    public boolean isTimeSlotAvailable(int vetId, Timestamp startTime) {
        String sql = "SELECT COUNT(*) as count FROM Appointment "
                + "WHERE vet_id = ? AND start_time = ? AND status NOT IN ('Cancelled', 'Completed')";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            st.setInt(1, vetId);
            st.setTimestamp(2, startTime);
            rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") == 0;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi isTimeSlotAvailable: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return false;
    }
}
