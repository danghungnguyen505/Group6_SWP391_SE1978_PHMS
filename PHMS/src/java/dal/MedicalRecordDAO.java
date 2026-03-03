package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.MedicalRecord;

/**
 * DAO for MedicalRecord
 */
public class MedicalRecordDAO extends DBContext {

    /**
     * Create medical record for an appointment (Vet flow).
     * Business rules:
     * - appointment must belong to vetId
     * - appointment status must be 'Checked-in'
     * - after creating record, appointment status becomes 'Completed'
     */
    public boolean createForVet(int apptId, int vetId, String diagnosis, String treatmentPlan) throws SQLException {
        String checkSql = "SELECT appt_id FROM Appointment WHERE appt_id = ? AND vet_id = ? AND status = 'Checked-in'";
        String insertSql = "INSERT INTO MedicalRecord (appt_id, diagnosis, treatment_plan) VALUES (?, ?, ?)";
<<<<<<< Updated upstream
        String updateApptSql = "UPDATE Appointment SET status = 'Completed' WHERE appt_id = ? AND vet_id = ? AND status = 'Checked-in'";
=======
        String updateApptSql = "UPDATE Appointment SET status = 'In-Progress' WHERE appt_id = ? AND vet_id = ? AND status = 'Checked-in'";
>>>>>>> Stashed changes

        boolean oldAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement chk = connection.prepareStatement(checkSql)) {
                chk.setInt(1, apptId);
                chk.setInt(2, vetId);
                try (ResultSet rs = chk.executeQuery()) {
                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement ins = connection.prepareStatement(insertSql)) {
                ins.setInt(1, apptId);
                ins.setString(2, diagnosis);
                ins.setString(3, treatmentPlan);
                if (ins.executeUpdate() <= 0) {
                    connection.rollback();
                    return false;
                }
            }

            try (PreparedStatement up = connection.prepareStatement(updateApptSql)) {
                up.setInt(1, apptId);
                up.setInt(2, vetId);
                if (up.executeUpdate() <= 0) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }

    /**
     * Get medical record detail for vet (must own appointment).
     */
    public MedicalRecord getByIdForVet(int recordId, int vetId) {
        String sql = "SELECT mr.record_id, mr.appt_id, mr.diagnosis, mr.treatment_plan, mr.created_at, "
<<<<<<< Updated upstream
                + "a.start_time AS appt_start_time, a.vet_id, "
=======
                + "a.start_time AS appt_start_time, a.vet_id, a.status AS appt_status, "
>>>>>>> Stashed changes
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM MedicalRecord mr "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE mr.record_id = ? AND a.vet_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, recordId);
            st.setInt(2, vetId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRecord(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForVet: " + e.getMessage());
        }
        return null;
    }

    /**
     * Get medical record detail for owner (must own pet).
     */
    public MedicalRecord getByIdForOwner(int recordId, int ownerId) {
        String sql = "SELECT mr.record_id, mr.appt_id, mr.diagnosis, mr.treatment_plan, mr.created_at, "
<<<<<<< Updated upstream
                + "a.start_time AS appt_start_time, a.vet_id, "
=======
                + "a.start_time AS appt_start_time, a.vet_id, a.status AS appt_status, "
>>>>>>> Stashed changes
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM MedicalRecord mr "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE mr.record_id = ? AND p.owner_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, recordId);
            st.setInt(2, ownerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRecord(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForOwner: " + e.getMessage());
        }
        return null;
    }

    /**
     * List medical records for vet with pagination in memory (controller will paginate).
     */
    public List<MedicalRecord> listForVet(int vetId) {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = "SELECT mr.record_id, mr.appt_id, mr.diagnosis, mr.treatment_plan, mr.created_at, "
<<<<<<< Updated upstream
                + "a.start_time AS appt_start_time, a.vet_id, "
=======
                + "a.start_time AS appt_start_time, a.vet_id, a.status AS appt_status, "
>>>>>>> Stashed changes
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM MedicalRecord mr "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE a.vet_id = ? "
                + "ORDER BY mr.created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, vetId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRecord(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listForVet: " + e.getMessage());
        }
        return list;
    }

    /**
     * List medical records for owner, optionally filter by petId.
     */
    public List<MedicalRecord> listForOwner(int ownerId, Integer petId) {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = "SELECT mr.record_id, mr.appt_id, mr.diagnosis, mr.treatment_plan, mr.created_at, "
<<<<<<< Updated upstream
                + "a.start_time AS appt_start_time, a.vet_id, "
=======
                + "a.start_time AS appt_start_time, a.vet_id, a.status AS appt_status, "
>>>>>>> Stashed changes
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM MedicalRecord mr "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE p.owner_id = ? "
                + (petId != null ? "AND p.pet_id = ? " : "")
                + "ORDER BY mr.created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, ownerId);
            if (petId != null) {
                st.setInt(2, petId);
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRecord(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listForOwner: " + e.getMessage());
        }
        return list;
    }

    /**
     * Update medical record for vet (must own appointment).
<<<<<<< Updated upstream
=======
     * Business rule:
     * - Do NOT allow update when related appointment is not In-Progress.  
>>>>>>> Stashed changes
     */
    public boolean updateForVet(int recordId, int vetId, String diagnosis, String treatmentPlan) {
        String sql = "UPDATE mr SET mr.diagnosis = ?, mr.treatment_plan = ? "
                + "FROM MedicalRecord mr "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
<<<<<<< Updated upstream
                + "WHERE mr.record_id = ? AND a.vet_id = ?";
=======
                + "WHERE mr.record_id = ? AND a.vet_id = ? AND a.status = 'In-Progress'";
>>>>>>> Stashed changes
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, diagnosis);
            st.setString(2, treatmentPlan);
            st.setInt(3, recordId);
            st.setInt(4, vetId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateForVet: " + e.getMessage());
            return false;
        }
    }

    /**
     * Delete medical record for vet (must own appointment).
     * Note: does not change appointment status (schema has no link for rollback logic).
     */
    public boolean deleteForVet(int recordId, int vetId) {
        String sql = "DELETE mr "
                + "FROM MedicalRecord mr "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
<<<<<<< Updated upstream
                + "WHERE mr.record_id = ? AND a.vet_id = ?";
=======
                + "WHERE mr.record_id = ? AND a.vet_id = ? AND a.status = 'In-Progress'";
>>>>>>> Stashed changes
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, recordId);
            st.setInt(2, vetId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleteForVet: " + e.getMessage());
            return false;
        }
    }

    private MedicalRecord mapRecord(ResultSet rs) throws SQLException {
        MedicalRecord mr = new MedicalRecord();
        mr.setRecordId(rs.getInt("record_id"));
        mr.setApptId(rs.getInt("appt_id"));
        mr.setDiagnosis(rs.getString("diagnosis"));
        mr.setTreatmentPlan(rs.getString("treatment_plan"));
        mr.setCreatedAt(rs.getTimestamp("created_at"));
        mr.setApptStartTime(rs.getTimestamp("appt_start_time"));
        mr.setPetName(rs.getString("pet_name"));
        mr.setOwnerName(rs.getString("owner_name"));
        mr.setVetName(rs.getString("vet_name"));
        mr.setVetId(rs.getInt("vet_id"));
        mr.setOwnerId(rs.getInt("owner_id"));
<<<<<<< Updated upstream
=======
        mr.setApptStatus(rs.getString("appt_status"));
>>>>>>> Stashed changes
        return mr;
    }
}

