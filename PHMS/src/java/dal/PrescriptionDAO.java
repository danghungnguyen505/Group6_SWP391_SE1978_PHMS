package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Prescription;

/**
 * DAO for Prescription table.
 */
public class PrescriptionDAO extends DBContext {
    
    /**
     * Create prescription items for a medical record.
     * Business rule: record must belong to vet's appointment.
     */
    public boolean createPrescriptions(int recordId, int vetId, List<Prescription> prescriptions) throws SQLException {
        if (prescriptions == null || prescriptions.isEmpty()) {
            return false;
        }
        
        // Verify record belongs to vet
        String checkSql = "SELECT mr.record_id FROM MedicalRecord mr " +
                         "JOIN Appointment a ON mr.appt_id = a.appt_id " +
                         "WHERE mr.record_id = ? AND a.vet_id = ?";
        String insertSql = "INSERT INTO Prescription (record_id, medicine_id, quantity, dosage) VALUES (?, ?, ?, ?)";
        
        boolean oldAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);
            
            // Check authorization
            try (PreparedStatement chk = connection.prepareStatement(checkSql)) {
                chk.setInt(1, recordId);
                chk.setInt(2, vetId);
                try (ResultSet rs = chk.executeQuery()) {
                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }
                }
            }
            
            // Insert prescriptions
            try (PreparedStatement ins = connection.prepareStatement(insertSql)) {
                for (Prescription p : prescriptions) {
                    ins.setInt(1, recordId);
                    ins.setInt(2, p.getMedicineId());
                    ins.setInt(3, p.getQuantity());
                    ins.setString(4, p.getDosage());
                    ins.addBatch();
                }
                ins.executeBatch();
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
     * Get all prescriptions for a medical record (for vet).
     */
    public List<Prescription> getByRecordIdForVet(int recordId, int vetId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT p.pres_id, p.record_id, p.medicine_id, p.quantity, p.dosage, " +
                     "m.name AS medicine_name, m.unit AS medicine_unit, m.price AS medicine_price " +
                     "FROM Prescription p " +
                     "JOIN Medicine m ON p.medicine_id = m.medicine_id " +
                     "JOIN MedicalRecord mr ON p.record_id = mr.record_id " +
                     "JOIN Appointment a ON mr.appt_id = a.appt_id " +
                     "WHERE p.record_id = ? AND a.vet_id = ? " +
                     "ORDER BY p.pres_id";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, recordId);
            st.setInt(2, vetId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Prescription p = new Prescription();
                    p.setPresId(rs.getInt("pres_id"));
                    p.setRecordId(rs.getInt("record_id"));
                    p.setMedicineId(rs.getInt("medicine_id"));
                    p.setQuantity(rs.getInt("quantity"));
                    p.setDosage(rs.getString("dosage"));
                    p.setMedicineName(rs.getString("medicine_name"));
                    p.setMedicineUnit(rs.getString("medicine_unit"));
                    p.setMedicinePrice(rs.getDouble("medicine_price"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getByRecordIdForVet: " + e.getMessage());
        }
        return list;
    }
    
    /**
     * Get all prescriptions for a medical record (for owner).
     */
    public List<Prescription> getByRecordIdForOwner(int recordId, int ownerId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT p.pres_id, p.record_id, p.medicine_id, p.quantity, p.dosage, " +
                     "m.name AS medicine_name, m.unit AS medicine_unit, m.price AS medicine_price " +
                     "FROM Prescription p " +
                     "JOIN Medicine m ON p.medicine_id = m.medicine_id " +
                     "JOIN MedicalRecord mr ON p.record_id = mr.record_id " +
                     "JOIN Appointment a ON mr.appt_id = a.appt_id " +
                     "JOIN Pet pet ON a.pet_id = pet.pet_id " +
                     "WHERE p.record_id = ? AND pet.owner_id = ? " +
                     "ORDER BY p.pres_id";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, recordId);
            st.setInt(2, ownerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Prescription p = new Prescription();
                    p.setPresId(rs.getInt("pres_id"));
                    p.setRecordId(rs.getInt("record_id"));
                    p.setMedicineId(rs.getInt("medicine_id"));
                    p.setQuantity(rs.getInt("quantity"));
                    p.setDosage(rs.getString("dosage"));
                    p.setMedicineName(rs.getString("medicine_name"));
                    p.setMedicineUnit(rs.getString("medicine_unit"));
                    p.setMedicinePrice(rs.getDouble("medicine_price"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getByRecordIdForOwner: " + e.getMessage());
        }
        return list;
    }
    
    /**
     * Delete a prescription (for vet only).
     */
    public boolean deletePrescription(int presId, int vetId) {
        String sql = "DELETE p FROM Prescription p " +
                     "JOIN MedicalRecord mr ON p.record_id = mr.record_id " +
                     "JOIN Appointment a ON mr.appt_id = a.appt_id " +
                     "WHERE p.pres_id = ? AND a.vet_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, presId);
            st.setInt(2, vetId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deletePrescription: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Update a prescription (for vet only).
     */
    public boolean updatePrescription(int presId, int vetId, int quantity, String dosage) {
        String sql = "UPDATE p SET p.quantity = ?, p.dosage = ? " +
                     "FROM Prescription p " +
                     "JOIN MedicalRecord mr ON p.record_id = mr.record_id " +
                     "JOIN Appointment a ON mr.appt_id = a.appt_id " +
                     "WHERE p.pres_id = ? AND a.vet_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quantity);
            st.setString(2, dosage);
            st.setInt(3, presId);
            st.setInt(4, vetId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updatePrescription: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get prescription by ID for vet.
     */
    public Prescription getByIdForVet(int presId, int vetId) {
        String sql = "SELECT p.pres_id, p.record_id, p.medicine_id, p.quantity, p.dosage, " +
                     "m.name AS medicine_name, m.unit AS medicine_unit, m.price AS medicine_price " +
                     "FROM Prescription p " +
                     "JOIN Medicine m ON p.medicine_id = m.medicine_id " +
                     "JOIN MedicalRecord mr ON p.record_id = mr.record_id " +
                     "JOIN Appointment a ON mr.appt_id = a.appt_id " +
                     "WHERE p.pres_id = ? AND a.vet_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, presId);
            st.setInt(2, vetId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Prescription p = new Prescription();
                    p.setPresId(rs.getInt("pres_id"));
                    p.setRecordId(rs.getInt("record_id"));
                    p.setMedicineId(rs.getInt("medicine_id"));
                    p.setQuantity(rs.getInt("quantity"));
                    p.setDosage(rs.getString("dosage"));
                    p.setMedicineName(rs.getString("medicine_name"));
                    p.setMedicineUnit(rs.getString("medicine_unit"));
                    p.setMedicinePrice(rs.getDouble("medicine_price"));
                    return p;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForVet: " + e.getMessage());
        }
        return null;
    }
}
