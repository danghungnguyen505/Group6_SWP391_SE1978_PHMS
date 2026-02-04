package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Feedback;

/**
 * DAO for Feedback table.
 */
public class FeedbackDAO extends DBContext {
    
    /**
     * Create feedback for an appointment (PetOwner only).
     * Business rule: appointment must belong to owner and be Completed.
     */
    public boolean createFeedback(int apptId, int ownerId, int rating, String comment) {
        // Verify appointment belongs to owner and is Completed
        String checkSql = "SELECT a.appt_id FROM Appointment a " +
                         "JOIN Pet p ON a.pet_id = p.pet_id " +
                         "WHERE a.appt_id = ? AND p.owner_id = ? AND a.status = 'Completed'";
        String insertSql = "INSERT INTO Feedback (appt_id, rating, comment) VALUES (?, ?, ?)";
        
        try {
            // Check authorization and status
            try (PreparedStatement chk = connection.prepareStatement(checkSql)) {
                chk.setInt(1, apptId);
                chk.setInt(2, ownerId);
                try (ResultSet rs = chk.executeQuery()) {
                    if (!rs.next()) {
                        return false;
                    }
                }
            }
            
            // Check if feedback already exists
            String existsSql = "SELECT feedback_id FROM Feedback WHERE appt_id = ?";
            try (PreparedStatement exists = connection.prepareStatement(existsSql)) {
                exists.setInt(1, apptId);
                try (ResultSet rs = exists.executeQuery()) {
                    if (rs.next()) {
                        return false; // Already exists
                    }
                }
            }
            
            // Insert feedback
            try (PreparedStatement ins = connection.prepareStatement(insertSql)) {
                ins.setInt(1, apptId);
                ins.setInt(2, rating);
                ins.setString(3, comment);
                return ins.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error createFeedback: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get feedback list for admin/manager (all feedbacks with pagination).
     */
    public List<Feedback> getAllFeedbacks(int page, int pageSize) {
        List<Feedback> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT f.feedback_id, f.appt_id, f.rating, f.comment, " +
                     "u.full_name AS customer_name, p.name AS pet_name, " +
                     "FORMAT(a.start_time, 'dd/MM/yyyy HH:mm') AS appt_date " +
                     "FROM Feedback f " +
                     "JOIN Appointment a ON f.appt_id = a.appt_id " +
                     "JOIN Pet p ON a.pet_id = p.pet_id " +
                     "JOIN PetOwner po ON p.owner_id = po.user_id " +
                     "JOIN Users u ON po.user_id = u.user_id " +
                     "ORDER BY f.feedback_id DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, offset);
            st.setInt(2, pageSize);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Feedback f = mapFeedback(rs);
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getAllFeedbacks: " + e.getMessage());
        }
        return list;
    }
    
    /**
     * Get total count of feedbacks.
     */
    public int getTotalFeedbacks() {
        String sql = "SELECT COUNT(*) AS total FROM Feedback";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("Error getTotalFeedbacks: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Get feedbacks for a specific owner.
     */
    public List<Feedback> getFeedbacksByOwner(int ownerId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.feedback_id, f.appt_id, f.rating, f.comment, " +
                     "u.full_name AS customer_name, p.name AS pet_name, " +
                     "FORMAT(a.start_time, 'dd/MM/yyyy HH:mm') AS appt_date " +
                     "FROM Feedback f " +
                     "JOIN Appointment a ON f.appt_id = a.appt_id " +
                     "JOIN Pet p ON a.pet_id = p.pet_id " +
                     "JOIN PetOwner po ON p.owner_id = po.user_id " +
                     "JOIN Users u ON po.user_id = u.user_id " +
                     "WHERE p.owner_id = ? " +
                     "ORDER BY f.feedback_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, ownerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Feedback f = mapFeedback(rs);
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getFeedbacksByOwner: " + e.getMessage());
        }
        return list;
    }
    
    /**
     * Get appointments available for feedback (Completed, not yet feedbacked) for owner.
     */
    public List<model.Appointment> getAppointmentsForFeedback(int ownerId) {
        List<model.Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appt_id, a.start_time, a.type, " +
                     "p.name AS pet_name, u.full_name AS vet_name " +
                     "FROM Appointment a " +
                     "JOIN Pet p ON a.pet_id = p.pet_id " +
                     "JOIN Users u ON a.vet_id = u.user_id " +
                     "WHERE p.owner_id = ? AND a.status = 'Completed' " +
                     "AND NOT EXISTS (SELECT 1 FROM Feedback f WHERE f.appt_id = a.appt_id) " +
                     "ORDER BY a.start_time DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, ownerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    model.Appointment a = new model.Appointment();
                    a.setApptId(rs.getInt("appt_id"));
                    a.setStartTime(rs.getTimestamp("start_time"));
                    a.setType(rs.getString("type"));
                    a.setPetName(rs.getString("pet_name"));
                    a.setVetName(rs.getString("vet_name"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getAppointmentsForFeedback: " + e.getMessage());
        }
        return list;
    }
    
    private Feedback mapFeedback(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setApptId(rs.getInt("appt_id"));
        f.setRating(rs.getInt("rating"));
        f.setComment(rs.getString("comment"));
        f.setCustomerName(rs.getString("customer_name"));
        f.setPetName(rs.getString("pet_name"));
        f.setApptDate(rs.getString("appt_date"));
        return f;
    }
}
