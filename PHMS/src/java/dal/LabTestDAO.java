<<<<<<< Updated upstream
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.LabTest;

/**
 * DAO for LabTest
 */
public class LabTestDAO extends DBContext {

    /**
     * Vet creates lab request for a medical record (must own the appointment for that record).
     */
    public boolean createForVet(int recordId, int vetId, String testType, String requestNotes) {
        String checkSql = "SELECT mr.record_id "
                + "FROM MedicalRecord mr "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "WHERE mr.record_id = ? AND a.vet_id = ?";
        String insertSql = "INSERT INTO LabTest (record_id, nurse_id, test_type, request_notes, result_data, status) "
                + "VALUES (?, NULL, ?, ?, NULL, 'Requested')";
        try {
            try (PreparedStatement chk = connection.prepareStatement(checkSql)) {
                chk.setInt(1, recordId);
                chk.setInt(2, vetId);
                try (ResultSet rs = chk.executeQuery()) {
                    if (!rs.next()) {
                        return false;
                    }
                }
            }
            try (PreparedStatement ins = connection.prepareStatement(insertSql)) {
                ins.setInt(1, recordId);
                ins.setString(2, testType);
                ins.setString(3, requestNotes);
                return ins.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error createForVet: " + e.getMessage());
            return false;
        }
    }

    /**
     * Vet cancels a lab request (must own record and request not Completed).
     */
    public boolean cancelForVet(int testId, int vetId) {
        String sql = "UPDATE lt SET lt.status = 'Cancelled' "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "WHERE lt.test_id = ? AND a.vet_id = ? AND lt.status <> 'Completed'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, testId);
            st.setInt(2, vetId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error cancelForVet: " + e.getMessage());
            return false;
        }
    }

    /**
     * List lab tests requested by this vet (for their records).
     */
    public List<LabTest> listForVet(int vetId) {
        List<LabTest> list = new ArrayList<>();
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE a.vet_id = ? "
                + "ORDER BY lt.test_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, vetId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listForVet: " + e.getMessage());
        }
        return list;
    }

    /**
     * List lab tests visible to owner (based on pet ownership).
     */
    public List<LabTest> listForOwner(int ownerId, Integer petId) {
        List<LabTest> list = new ArrayList<>();
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE p.owner_id = ? "
                + (petId != null ? "AND p.pet_id = ? " : "")
                + "ORDER BY lt.test_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, ownerId);
            if (petId != null) st.setInt(2, petId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listForOwner: " + e.getMessage());
        }
        return list;
    }

    /**
     * Nurse queue: Requested/In Progress lab tests (not cancelled/completed).
     */
    public List<LabTest> listQueueForNurse() {
        List<LabTest> list = new ArrayList<>();
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE lt.status IN ('Requested','In Progress') "
                + "ORDER BY lt.test_id ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listQueueForNurse: " + e.getMessage());
        }
        return list;
    }

    /**
     * Nurse takes/updates test (set nurse_id, status, result_data).
     */
    public boolean updateResultForNurse(int testId, int nurseId, String status, String resultData) {
        String sql = "UPDATE LabTest SET nurse_id = ?, status = ?, result_data = ? WHERE test_id = ? AND status <> 'Cancelled'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, nurseId);
            st.setString(2, status);
            st.setString(3, resultData);
            st.setInt(4, testId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateResultForNurse: " + e.getMessage());
            return false;
        }
    }

    public LabTest getByIdForVet(int testId, int vetId) {
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE lt.test_id = ? AND a.vet_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, testId);
            st.setInt(2, vetId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForVet: " + e.getMessage());
        }
        return null;
    }

    public LabTest getByIdForOwner(int testId, int ownerId) {
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE lt.test_id = ? AND p.owner_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, testId);
            st.setInt(2, ownerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForOwner: " + e.getMessage());
        }
        return null;
    }

    public LabTest getByIdForNurse(int testId) {
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE lt.test_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, testId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForNurse: " + e.getMessage());
        }
        return null;
    }

    private LabTest map(ResultSet rs) throws SQLException {
        LabTest lt = new LabTest();
        lt.setTestId(rs.getInt("test_id"));
        lt.setRecordId(rs.getInt("record_id"));
        int nurse = rs.getInt("nurse_id");
        lt.setNurseId(rs.wasNull() ? null : nurse);
        lt.setTestType(rs.getString("test_type"));
        lt.setRequestNotes(rs.getString("request_notes"));
        lt.setResultData(rs.getString("result_data"));
        lt.setStatus(rs.getString("status"));

        lt.setRecordCreatedAt(rs.getTimestamp("record_created_at"));
        lt.setApptId(rs.getInt("appt_id"));
        lt.setApptStartTime(rs.getTimestamp("appt_start_time"));
        lt.setVetId(rs.getInt("vet_id"));
        lt.setOwnerId(rs.getInt("owner_id"));
        lt.setOwnerName(rs.getString("owner_name"));
        lt.setVetName(rs.getString("vet_name"));
        lt.setPetName(rs.getString("pet_name"));
        return lt;
    }
}

=======
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.LabTest;

/**
 * DAO for LabTest
 */
public class LabTestDAO extends DBContext {

    /**
     * Vet creates lab request for a medical record (must own the appointment for that record).
     */
    public boolean createForVet(int recordId, int vetId, String testType, String requestNotes) {
        String checkSql = "SELECT mr.record_id "
                + "FROM MedicalRecord mr "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "WHERE mr.record_id = ? AND a.vet_id = ? AND a.status = 'In-Progress'";
        String insertSql = "INSERT INTO LabTest (record_id, nurse_id, test_type, request_notes, result_data, status) "
                + "VALUES (?, NULL, ?, ?, NULL, 'Requested')";
        try {
            try (PreparedStatement chk = connection.prepareStatement(checkSql)) {
                chk.setInt(1, recordId);
                chk.setInt(2, vetId);
                try (ResultSet rs = chk.executeQuery()) {
                    if (!rs.next()) {
                        return false;
                    }
                }
            }
            try (PreparedStatement ins = connection.prepareStatement(insertSql)) {
                ins.setInt(1, recordId);
                ins.setString(2, testType);
                ins.setString(3, requestNotes);
                return ins.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error createForVet: " + e.getMessage());
            return false;
        }
    }

    /**
     * Vet cancels a lab request (must own record and request not Completed).
     */
    public boolean cancelForVet(int testId, int vetId) {
        String sql = "UPDATE lt SET lt.status = 'Cancelled' "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "WHERE lt.test_id = ? AND a.vet_id = ? AND a.status = 'In-Progress' AND lt.status <> 'Completed'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, testId);
            st.setInt(2, vetId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error cancelForVet: " + e.getMessage());
            return false;
        }
    }

    /**
     * List lab tests requested by this vet (for their records).
     */
    public List<LabTest> listForVet(int vetId) {
        List<LabTest> list = new ArrayList<>();
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE a.vet_id = ? "
                + "ORDER BY lt.test_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, vetId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listForVet: " + e.getMessage());
        }
        return list;
    }

    /**
     * List lab tests visible to owner (based on pet ownership).
     */
    public List<LabTest> listForOwner(int ownerId, Integer petId) {
        List<LabTest> list = new ArrayList<>();
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE p.owner_id = ? "
                + (petId != null ? "AND p.pet_id = ? " : "")
                + "ORDER BY lt.test_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, ownerId);
            if (petId != null) st.setInt(2, petId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listForOwner: " + e.getMessage());
        }
        return list;
    }

    /**
     * Nurse queue: Requested/In Progress lab tests (not cancelled/completed).
     */
    public List<LabTest> listQueueForNurse() {
        List<LabTest> list = new ArrayList<>();
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE lt.status IN ('Requested','In Progress') "
                + "ORDER BY lt.test_id ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listQueueForNurse: " + e.getMessage());
        }
        return list;
    }

    /**
     * Nurse takes/updates test (set nurse_id, status, result_data).
     */
    public boolean updateResultForNurse(int testId, int nurseId, String status, String resultData) {
        String sql = "UPDATE LabTest SET nurse_id = ?, status = ?, result_data = ? WHERE test_id = ? AND status <> 'Cancelled'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, nurseId);
            st.setString(2, status);
            st.setString(3, resultData);
            st.setInt(4, testId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateResultForNurse: " + e.getMessage());
            return false;
        }
    }

    public LabTest getByIdForVet(int testId, int vetId) {
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE lt.test_id = ? AND a.vet_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, testId);
            st.setInt(2, vetId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForVet: " + e.getMessage());
        }
        return null;
    }

    public LabTest getByIdForOwner(int testId, int ownerId) {
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE lt.test_id = ? AND p.owner_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, testId);
            st.setInt(2, ownerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForOwner: " + e.getMessage());
        }
        return null;
    }

    public LabTest getByIdForNurse(int testId) {
        String sql = "SELECT lt.test_id, lt.record_id, lt.nurse_id, lt.test_type, lt.request_notes, lt.result_data, lt.status, "
                + "mr.created_at AS record_created_at, mr.appt_id, "
                + "a.start_time AS appt_start_time, a.vet_id, "
                + "p.owner_id, p.name AS pet_name, "
                + "u_owner.full_name AS owner_name, "
                + "u_vet.full_name AS vet_name "
                + "FROM LabTest lt "
                + "JOIN MedicalRecord mr ON lt.record_id = mr.record_id "
                + "JOIN Appointment a ON mr.appt_id = a.appt_id "
                + "JOIN Pet p ON a.pet_id = p.pet_id "
                + "JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "JOIN Users u_vet ON a.vet_id = u_vet.user_id "
                + "WHERE lt.test_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, testId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForNurse: " + e.getMessage());
        }
        return null;
    }

    private LabTest map(ResultSet rs) throws SQLException {
        LabTest lt = new LabTest();
        lt.setTestId(rs.getInt("test_id"));
        lt.setRecordId(rs.getInt("record_id"));
        int nurse = rs.getInt("nurse_id");
        lt.setNurseId(rs.wasNull() ? null : nurse);
        lt.setTestType(rs.getString("test_type"));
        lt.setRequestNotes(rs.getString("request_notes"));
        lt.setResultData(rs.getString("result_data"));
        lt.setStatus(rs.getString("status"));

        lt.setRecordCreatedAt(rs.getTimestamp("record_created_at"));
        lt.setApptId(rs.getInt("appt_id"));
        lt.setApptStartTime(rs.getTimestamp("appt_start_time"));
        lt.setVetId(rs.getInt("vet_id"));
        lt.setOwnerId(rs.getInt("owner_id"));
        lt.setOwnerName(rs.getString("owner_name"));
        lt.setVetName(rs.getString("vet_name"));
        lt.setPetName(rs.getString("pet_name"));
        return lt;
    }
}

>>>>>>> Stashed changes
