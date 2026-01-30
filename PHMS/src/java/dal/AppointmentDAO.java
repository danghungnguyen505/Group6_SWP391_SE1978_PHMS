/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Schedule;

/**
 *
 * @author zoxy4
 */
public class AppointmentDAO extends DBContext {

    public List<String> getBookedSlots(int vetId, String date) {
        List<String> list = new ArrayList<>();
        // Lấy giờ (HH:mm) của các cuộc hẹn chưa bị hủy
        String sql = "SELECT FORMAT(start_time, 'HH:mm') as slot "
                + "FROM Appointment "
                + "WHERE vet_id = ? "
                + "AND CAST(start_time AS DATE) = ? "
                + "AND status != 'Cancelled'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, vetId);
            st.setString(2, date); // date dạng 'YYYY-MM-DD'
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("slot")); // Ví dụ add "09:00"
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    //Hàm insert cuoc hen
    public boolean insertAppointment(model.Appointment appt) {
        String sql = "INSERT INTO Appointment (pet_id, vet_id, start_time, status, type, notes) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, appt.getPetId());
            st.setInt(2, appt.getVetId());
            st.setTimestamp(3, appt.getStartTime());
            st.setString(4, "Pending"); // Trạng thái mặc định là Chờ duyệt
            st.setString(5, appt.getType());
            st.setString(6, appt.getNotes());
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("SQL Error at insertAppointment: " + e.getMessage());
            return false;
        }
    }

    public List<model.Appointment> getPendingAppointments() {
        List<model.Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appt_id, a.start_time, a.type, a.notes, "
                + "p.name AS pet_name, "
                + "u_vet.full_name AS vet_name, "
                + "u_owner.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "WHERE a.status = 'Pending' "
                + "ORDER BY a.start_time ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                model.Appointment a = new model.Appointment();
                a.setApptId(rs.getInt("appt_id"));
                a.setStartTime(rs.getTimestamp("start_time"));
                a.setType(rs.getString("type"));
                a.setNotes(rs.getString("notes"));
                a.setPetName(rs.getString("pet_name"));
                a.setVetName(rs.getString("vet_name"));
                a.setOwnerName(rs.getString("owner_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            System.out.println("Error getPendingAppointments: " + e);
        }
        return list;
    }

    /**
     * Cập nhật trạng thái cuộc hẹn (Lễ tân duyệt: Confirmed hoặc từ chối:
     * Cancelled)
     */
    public boolean updateAppointmentStatus(int apptId, String status) {
        String sql = "UPDATE Appointment SET status = ? WHERE appt_id = ? AND status = 'Pending'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, apptId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error updateAppointmentStatus: " + e.getMessage());
            return false;
        }
    }

    //Xác nhận cuộc nhận
    public List<model.Appointment> getConfirmedAppointments() {
        List<model.Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appt_id, a.start_time, a.type, a.notes, "
                + "p.name AS pet_name, "
                + "u_vet.full_name AS vet_name, "
                + "u_owner.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "WHERE a.status = 'Confirmed' "
                + // Chỉ lấy trạng thái Confirmed
                "ORDER BY a.start_time ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                model.Appointment a = new model.Appointment();
                a.setApptId(rs.getInt("appt_id"));
                a.setStartTime(rs.getTimestamp("start_time"));
                a.setType(rs.getString("type"));
                a.setNotes(rs.getString("notes"));
                a.setPetName(rs.getString("pet_name"));
                a.setVetName(rs.getString("vet_name"));
                a.setOwnerName(rs.getString("owner_name"));
                a.setStatus("Confirmed"); // Set cứng trạng thái để hiển thị nếu cần
                list.add(a);
            }
        } catch (SQLException e) {
            System.out.println("Error getConfirmedAppointments: " + e);
        }
        return list;
    }

    //Hàm lấy cuộc hẹn đã từng,sắp tới của petOwner
    public List<model.Appointment> getAppointmentsByOwnerId(int ownerId) {
        List<model.Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appt_id, a.start_time, a.status, a.type, a.notes,a.created_at, "
                + "p.name AS pet_name, "
                + "u.full_name AS vet_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u ON a.vet_id = u.user_id "
                + "WHERE p.owner_id = ? "
                + "ORDER BY a.start_time DESC"; // Mới nhất lên đầu
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                model.Appointment a = new model.Appointment();
                a.setApptId(rs.getInt("appt_id"));
                a.setStartTime(rs.getTimestamp("start_time"));
                a.setStatus(rs.getString("status"));
                a.setType(rs.getString("type"));
                a.setNotes(rs.getString("notes"));
                a.setPetName(rs.getString("pet_name"));
                a.setVetName(rs.getString("vet_name"));
                a.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(a);
            }
        } catch (SQLException e) {
            System.out.println("Error getAppointmentsByOwnerId: " + e);
        }
        return list;
    }

    //Xử lý Hủy trong 5 tiếng/thay đổi cuộc hẹn
    //Lấy thông tin 1 cuộc hẹn
    public model.Appointment getAppointmentById(int apptId) {
        String sql = "SELECT * FROM Appointment WHERE appt_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, apptId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                model.Appointment a = new model.Appointment();
                a.setApptId(rs.getInt("appt_id"));
                a.setStartTime(rs.getTimestamp("start_time"));
                a.setStatus(rs.getString("status"));
                a.setType(rs.getString("type"));
                a.setNotes(rs.getString("notes"));
                a.setCreatedAt(rs.getTimestamp("created_at")); 
                return a;
            }
        } catch (SQLException e) {
            System.out.println("Error getAppointmentById: " + e);
        }
        return null;
    }
    // 2. Đổi lịch (Reschedule) - Đưa trạng thái về Pending để lễ tân duyệt lại
    public boolean rescheduleAppointment(int apptId, java.sql.Timestamp newTime) {
        String sql = "UPDATE Appointment SET start_time = ?, status = 'Pending' WHERE appt_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setTimestamp(1, newTime);
            st.setInt(2, apptId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error reschedule: " + e);
            return false;
        }
    }
}
