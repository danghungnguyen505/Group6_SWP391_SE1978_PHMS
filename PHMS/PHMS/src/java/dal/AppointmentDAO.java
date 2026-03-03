/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author zoxy4
 */
public class AppointmentDAO extends DBContext {

    /**
     * Check if a vet has any non-cancelled appointments on a specific date.
     */
    public boolean hasAppointmentsForVetOnDate(int vetId, Date workDate) {
        String sql = "SELECT COUNT(*) AS cnt FROM Appointment "
                + "WHERE vet_id = ? "
                + "AND CAST(start_time AS DATE) = ? "
                + "AND status <> 'Cancelled'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, vetId);
            st.setDate(2, workDate);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cnt") > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error hasAppointmentsForVetOnDate: " + e.getMessage());
        }
        return false;
    }

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
            st.setString(4, appt.getStatus() != null ? appt.getStatus() : "Pending"); // Use provided status or default to Pending
            st.setString(5, appt.getType());
            st.setString(6, appt.getNotes());
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("SQL Error at insertAppointment: " + e.getMessage());
            return false;
        }
    }

    /**
     * Insert appointment and return the generated ID. Used for emergency
     * appointments where we need the ID immediately for triage.
     */
    public int insertAppointmentReturnId(model.Appointment appt) {
        String sql = "INSERT INTO Appointment (pet_id, vet_id, start_time, status, type, notes) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setInt(1, appt.getPetId());
            st.setInt(2, appt.getVetId());
            st.setTimestamp(3, appt.getStartTime());
            st.setString(4, appt.getStatus() != null ? appt.getStatus() : "Pending");
            st.setString(5, appt.getType());
            st.setString(6, appt.getNotes());
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            return -1;
        } catch (SQLException e) {
            System.out.println("SQL Error at insertAppointmentReturnId: " + e.getMessage());
            return -1;
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
        String sql = "SELECT a.appt_id, a.start_time, a.status, a.type, a.notes, "
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
                list.add(a);
            }
        } catch (SQLException e) {
            System.out.println("Error getAppointmentsByOwnerId: " + e);
        }
        return list;
    }

    //Xử lý Hủy trong 5 tiếng/thay đổi cuộc hẹn
    // Lấy thông tin 1 cuộc hẹn (Updated to fetch Names via JOIN)
    public model.Appointment getAppointmentById(int apptId) {
        // SQL query with JOINs to fetch pet_name and vet_name (and service if needed)
        String sql
                = "SELECT a.*, "
                + "       p.name AS pet_name, "
                + "       u.full_name AS vet_name, "
                + "       o.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u ON a.vet_id = u.user_id "
                + "JOIN Users o ON p.owner_id = o.user_id "
                + "WHERE a.appt_id = ?";
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

                // Set the fetched names
                a.setPetName(rs.getString("pet_name"));
                a.setVetName(rs.getString("vet_name"));
                a.setOwnerName(rs.getString("owner_name"));
                // IDs (if needed)
                a.setPetId(rs.getInt("pet_id"));
                a.setVetId(rs.getInt("vet_id"));
                return a;
            }
        } catch (SQLException e) {
            System.out.println("Error getAppointmentById: " + e);
        }
        return null;
    }

    /**
     * Lấy thông tin cuộc hẹn theo apptId và ownerId (đảm bảo quyền sở hữu).
     */
    public model.Appointment getAppointmentByIdForOwner(int apptId, int ownerId) {
        String sql = "SELECT a.*, "
                + "p.owner_id, p.name AS pet_name, "
                + "u.full_name AS vet_name "
                + "u_owner.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u ON a.vet_id = u.user_id "
                + "WHERE a.appt_id = ? AND p.owner_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, apptId);
            st.setInt(2, ownerId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                model.Appointment a = new model.Appointment();
                a.setApptId(rs.getInt("appt_id"));
                a.setStartTime(rs.getTimestamp("start_time"));
                a.setStatus(rs.getString("status"));
                a.setType(rs.getString("type"));
                a.setNotes(rs.getString("notes"));
                a.setPetName(rs.getString("pet_name"));
                a.setVetName(rs.getString("vet_name"));
                a.setOwnerName(rs.getString("owner_name"));
                a.setPetId(rs.getInt("pet_id"));
                a.setVetId(rs.getInt("vet_id"));
                return a;
            }
        } catch (SQLException e) {
            System.out.println("Error getAppointmentByIdForOwner: " + e.getMessage());
        }
        return null;
    }

    /**
     * PetOwner hủy lịch: chỉ cho phép hủy khi lịch thuộc ownerId và đang ở
     * Pending/Confirmed.
     */
    public boolean cancelAppointmentByOwner(int apptId, int ownerId) {
        String sql = "UPDATE a SET a.status = 'Cancelled' "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "WHERE a.appt_id = ? AND p.owner_id = ? AND a.status IN ('Pending','Confirmed')";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, apptId);
            st.setInt(2, ownerId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error cancelAppointmentByOwner: " + e.getMessage());
            return false;
        }
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

    //Update cuộc hẹn
    public boolean updateAppointmentFull(model.Appointment appt) {
        String sql = "UPDATE Appointment SET pet_id = ?, vet_id = ?, start_time = ?, type = ?, notes = ?, status = 'Pending' "
                + "WHERE appt_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, appt.getPetId());
            st.setInt(2, appt.getVetId());
            st.setTimestamp(3, appt.getStartTime());
            st.setString(4, appt.getType());
            st.setString(5, appt.getNotes());
            st.setInt(6, appt.getApptId()); // ID của cuộc hẹn cần sửa

            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateAppointmentFull: " + e);
            return false;
        }
    }

    //Checkin 1. Hàm lấy danh sách cuộc hẹn TRONG NGÀY HÔM NAY cho lễ tân
    // Bao gồm: Confirmed, Checked-in, No-show, Completed
    public List<model.Appointment> getTodayAppointments() {
        List<model.Appointment> list = new ArrayList<>();
        // SQL: Lấy cuộc hẹn có ngày bắt đầu = ngày hiện tại
        String sql = "SELECT a.*, p.name AS pet_name, u.full_name AS vet_name, u_owner.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u ON a.vet_id = u.user_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "WHERE CAST(a.start_time AS DATE) = CAST(GETDATE() AS DATE) " // Dùng GETDATE() cho SQL Server, hoặc CURDATE() cho MySQL
                + "AND a.status IN ('Confirmed', 'Checked-in', 'In-Progress', 'No-show', 'Completed') "
                + "ORDER BY a.start_time ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                model.Appointment a = new model.Appointment();
                a.setApptId(rs.getInt("appt_id"));
                a.setStartTime(rs.getTimestamp("start_time"));
                a.setStatus(rs.getString("status")); // Quan trọng để check trạng thái
                a.setType(rs.getString("type"));
                a.setNotes(rs.getString("notes"));
                a.setPetName(rs.getString("pet_name"));
                a.setVetName(rs.getString("vet_name"));
                a.setOwnerName(rs.getString("owner_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            System.out.println("Error getTodayAppointments: " + e);
        }
        return list;
    }

    /**
     * Veterinarian queue: appointments for TODAY assigned to this vet that are
     * Checked-in.
     */
    public List<model.Appointment> getTodayCheckedInAppointmentsForVet(int vetId) {
        List<model.Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.name AS pet_name, u_owner.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "WHERE CAST(a.start_time AS DATE) = CAST(GETDATE() AS DATE) "
                + "AND a.vet_id = ? "
                + "AND a.status = 'Checked-in' "
                + "ORDER BY a.start_time ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, vetId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    model.Appointment a = new model.Appointment();
                    a.setApptId(rs.getInt("appt_id"));
                    a.setStartTime(rs.getTimestamp("start_time"));
                    a.setStatus(rs.getString("status"));
                    a.setType(rs.getString("type"));
                    a.setNotes(rs.getString("notes"));
                    a.setPetId(rs.getInt("pet_id"));
                    a.setVetId(rs.getInt("vet_id"));
                    a.setPetName(rs.getString("pet_name"));
                    a.setOwnerName(rs.getString("owner_name"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getTodayCheckedInAppointmentsForVet: " + e.getMessage());
        }
        return list;
    }

    //Checkin 2. Hàm update trạng thái chung (dùng cho cả Check-in và No-show)
    public boolean changeAppointmentStatus(int apptId, String newStatus) {
        String sql = "UPDATE Appointment SET status = ? WHERE appt_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newStatus);
            st.setInt(2, apptId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error changeAppointmentStatus: " + e);
            return false;
        }
    }

    /**
     * Mark appointment as Completed if it is not already Cancelled. Used after
     * successful invoice payment.
     */
    public boolean completeIfNotCancelled(int apptId) {
        String sql = "UPDATE Appointment SET status = 'Completed' WHERE appt_id = ? AND status <> 'Cancelled'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, apptId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error completeIfNotCancelled: " + e.getMessage());
            return false;
        }
    }

    /**
     * Auto-cancel appointments for a staff (vet) on a specific date when a
     * leave request is approved.
     */
    public int cancelAppointmentsForEmpOnDate(int empId, java.sql.Date date) {
        String sql = "UPDATE Appointment SET status = 'Cancelled' "
                + "WHERE vet_id = ? "
                + "AND CAST(start_time AS DATE) = ? "
                + "AND status IN ('Pending','Confirmed')";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, empId);
            st.setDate(2, date);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error cancelAppointmentsForEmpOnDate: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Auto-cancel appointments that are still in 'Pending Payment' and whose
     * start_time is at least 'minutes' minutes in the past. This approximates
     * the 15-minute pending payment window using start_time.
     */
    public int autoCancelPendingPaymentAppointments(int minutes) {
        String sql = "UPDATE Appointment SET status = 'Cancelled' "
                + "WHERE status = 'Pending Payment' "
                + "AND DATEDIFF(MINUTE, start_time, GETDATE()) >= ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, minutes);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error autoCancelPendingPaymentAppointments: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Get appointments by date range and status (for notification job).
     */
    public List<model.Appointment> getAppointmentsByDateRange(java.sql.Timestamp startDate,
            java.sql.Timestamp endDate,
            String status) {
        List<model.Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.name AS pet_name, u.full_name AS vet_name, u_owner.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u ON a.vet_id = u.user_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "WHERE CAST(a.start_time AS DATE) >= CAST(? AS DATE) "
                + "AND CAST(a.start_time AS DATE) <= CAST(? AS DATE) "
                + "AND a.status = ? "
                + "ORDER BY a.start_time ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setTimestamp(1, startDate);
            st.setTimestamp(2, endDate);
            st.setString(3, status);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    model.Appointment a = new model.Appointment();
                    a.setApptId(rs.getInt("appt_id"));
                    a.setStartTime(rs.getTimestamp("start_time"));
                    a.setStatus(rs.getString("status"));
                    a.setType(rs.getString("type"));
                    a.setNotes(rs.getString("notes"));
                    a.setPetName(rs.getString("pet_name"));
                    a.setVetName(rs.getString("vet_name"));
                    a.setOwnerName(rs.getString("owner_name"));
                    a.setPetId(rs.getInt("pet_id"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getAppointmentsByDateRange: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get appointments with filters (date, status, vet) for receptionist/admin.
     */
    public List<model.Appointment> getAppointmentsWithFilters(String startDateStr, String endDateStr,
            String status, Integer vetId) {
        List<model.Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.*, p.name AS pet_name, u.full_name AS vet_name, u_owner.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u ON a.vet_id = u.user_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (util.ValidationUtils.isNotEmpty(startDateStr)) {
            sql.append("AND CAST(a.start_time AS DATE) >= ? ");
            params.add(startDateStr);
        }

        if (util.ValidationUtils.isNotEmpty(endDateStr)) {
            sql.append("AND CAST(a.start_time AS DATE) <= ? ");
            params.add(endDateStr);
        }

        if (util.ValidationUtils.isNotEmpty(status) && !"All".equalsIgnoreCase(status)) {
            sql.append("AND a.status = ? ");
            params.add(status);
        }

        if (vetId != null && vetId > 0) {
            sql.append("AND a.vet_id = ? ");
            params.add(vetId);
        }

        sql.append("ORDER BY a.start_time DESC");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Integer) {
                    st.setInt(i + 1, (Integer) param);
                } else {
                    st.setString(i + 1, param.toString());
                }
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    model.Appointment a = new model.Appointment();
                    a.setApptId(rs.getInt("appt_id"));
                    a.setStartTime(rs.getTimestamp("start_time"));
                    a.setStatus(rs.getString("status"));
                    a.setType(rs.getString("type"));
                    a.setNotes(rs.getString("notes"));
                    a.setPetName(rs.getString("pet_name"));
                    a.setVetName(rs.getString("vet_name"));
                    a.setOwnerName(rs.getString("owner_name"));
                    a.setPetId(rs.getInt("pet_id"));
                    a.setVetId(rs.getInt("vet_id"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getAppointmentsWithFilters: " + e.getMessage());
        }
        return list;
    }

    /**
     * Emergency appointments for receptionist (all vets).
     */
    public List<model.Appointment> getEmergencyAppointmentsForReceptionist() {
        List<model.Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appt_id, a.start_time, a.status, a.type, a.notes, "
                + "p.name AS pet_name, u_vet.full_name AS vet_name, u_owner.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "WHERE a.type = 'Urgent' "
                + "AND a.status IN ('Pending','Confirmed','Checked-in') "
                + "ORDER BY a.start_time ASC";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                model.Appointment a = new model.Appointment();
                a.setApptId(rs.getInt("appt_id"));
                a.setStartTime(rs.getTimestamp("start_time"));
                a.setStatus(rs.getString("status"));
                a.setType(rs.getString("type"));
                a.setNotes(rs.getString("notes"));
                a.setPetName(rs.getString("pet_name"));
                a.setVetName(rs.getString("vet_name"));
                a.setOwnerName(rs.getString("owner_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            System.out.println("Error getEmergencyAppointmentsForReceptionist: " + e.getMessage());
        }
        return list;
    }

    /**
     * Emergency appointments assigned to a specific vet.
     */
    public List<model.Appointment> getEmergencyAppointmentsForVet(int vetId) {
        List<model.Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appt_id, a.start_time, a.status, a.type, a.notes, "
                + "p.name AS pet_name, u_owner.full_name AS owner_name "
                + "FROM Appointment a "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "WHERE a.type = 'Urgent' "
                + "AND a.vet_id = ? "
                + "AND a.status IN ('Confirmed','Checked-in') "
                + "ORDER BY a.start_time ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, vetId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    model.Appointment a = new model.Appointment();
                    a.setApptId(rs.getInt("appt_id"));
                    a.setStartTime(rs.getTimestamp("start_time"));
                    a.setStatus(rs.getString("status"));
                    a.setType(rs.getString("type"));
                    a.setNotes(rs.getString("notes"));
                    a.setPetName(rs.getString("pet_name"));
                    a.setOwnerName(rs.getString("owner_name"));
                    a.setVetId(vetId);
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getEmergencyAppointmentsForVet: " + e.getMessage());
        }
        return list;
    }

    //Mark appointment as Completed for the assigned vet only when In-Progress.
    //Danh dau cuoc hen da Completed
    public boolean completeForVet(int apptId, int vetId) {
        String sql = "UPDATE Appointment SET status = 'Completed' "
                + "WHERE appt_id = ? AND vet_id = ? AND status = 'In-Progress'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, apptId);
            st.setInt(2, vetId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error completeForVet: " + e.getMessage());
            return false;
        }
    }
}
