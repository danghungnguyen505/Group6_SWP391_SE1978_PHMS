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
        String insertSql = "INSERT INTO Feedback (appt_id, rating, comment, status) VALUES (?, ?, ?, 'New')";
        
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
     * Get feedback list for admin/manager with optional rating and status filters.
     */
    public List<Feedback> getAllFeedbacks(int page, int pageSize, String ratingFilter, String statusFilter) {
        List<Feedback> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String baseSql = "SELECT f.feedback_id, f.appt_id, f.rating, f.comment, f.status, " +
                     "u.full_name AS customer_name, p.name AS pet_name, " +
                     "FORMAT(a.start_time, 'dd/MM/yyyy HH:mm') AS appt_date " +
                     "FROM Feedback f " +
                     "JOIN Appointment a ON f.appt_id = a.appt_id " +
                     "JOIN Pet p ON a.pet_id = p.pet_id " +
                     "JOIN PetOwner po ON p.owner_id = po.user_id " +
                     "JOIN Users u ON po.user_id = u.user_id ";

        String where = buildWhereClause(ratingFilter, statusFilter);
        String sql = baseSql + where + " ORDER BY f.feedback_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            int idx = 1;
            if (ratingFilter != null && !"all".equals(ratingFilter) && !ratingFilter.isEmpty()) {
                st.setInt(idx++, getRatingValue(ratingFilter));
            }
            if (statusFilter != null && !"all".equals(statusFilter) && !statusFilter.isEmpty()) {
                st.setString(idx++, statusFilter);
            }
            st.setInt(idx++, offset);
            st.setInt(idx++, pageSize);
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

    public List<Feedback> getAllFeedbacks(int page, int pageSize, String ratingFilter) {
        return getAllFeedbacks(page, pageSize, ratingFilter, null);
    }

    public List<Feedback> getAllFeedbacks(int page, int pageSize) {
        return getAllFeedbacks(page, pageSize, null, null);
    }

    /**
     * Get total count of feedbacks with optional filters.
     */
    public int getTotalFeedbacks(String ratingFilter, String statusFilter) {
        String sql = "SELECT COUNT(*) AS total FROM Feedback f " + buildWhereClause(ratingFilter, statusFilter);
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            int idx = 1;
            if (ratingFilter != null && !"all".equals(ratingFilter) && !ratingFilter.isEmpty()) {
                st.setInt(idx++, getRatingValue(ratingFilter));
            }
            if (statusFilter != null && !"all".equals(statusFilter) && !statusFilter.isEmpty()) {
                st.setString(idx++, statusFilter);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getTotalFeedbacks: " + e.getMessage());
        }
        return 0;
    }

    public int getTotalFeedbacks(String ratingFilter) {
        return getTotalFeedbacks(ratingFilter, null);
    }

    public int getTotalFeedbacks() {
        return getTotalFeedbacks(null, null);
    }

    private String buildWhereClause(String ratingFilter, String statusFilter) {
        StringBuilder sb = new StringBuilder();
        boolean hasRating = ratingFilter != null && !"all".equals(ratingFilter) && !ratingFilter.isEmpty();
        boolean hasStatus = statusFilter != null && !"all".equals(statusFilter) && !statusFilter.isEmpty();

        if (hasRating || hasStatus) {
            sb.append("WHERE ");
            if (hasRating) {
                if ("below3".equals(ratingFilter)) {
                    sb.append("f.rating <= 3");
                } else {
                    sb.append("f.rating = ?");
                }
            }
            if (hasRating && hasStatus) {
                sb.append(" AND ");
            }
            if (hasStatus) {
                sb.append("f.status = ?");
            }
            sb.append(" ");
        }
        return sb.toString();
    }

    private int getRatingValue(String ratingFilter) {
        switch (ratingFilter) {
            case "5": return 5;
            case "4": return 4;
            default: return 0;
        }
    }

    /**
     * Update feedback status.
     */
    public boolean updateFeedbackStatus(int feedbackId, String newStatus) {
        String sql = "UPDATE Feedback SET status = ? WHERE feedback_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, newStatus);
            st.setInt(2, feedbackId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateFeedbackStatus: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get feedbacks for a specific owner.
     */
    public List<Feedback> getFeedbacksByOwner(int ownerId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.feedback_id, f.appt_id, f.rating, f.comment, f.status, " +
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
                     "AND (NOT EXISTS (SELECT 1 FROM Feedback f WHERE f.appt_id = a.appt_id) " +
                     "OR EXISTS (SELECT 1 FROM Feedback f WHERE f.appt_id = a.appt_id AND f.status = 'New')) " +
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

    /**
     * Get existing feedback for a specific appointment of an owner.
     */
    public Feedback getFeedbackByAppointmentAndOwner(int apptId, int ownerId) {
        String sql = "SELECT TOP 1 f.feedback_id, f.appt_id, f.rating, f.comment, f.status, " +
                     "u.full_name AS customer_name, p.name AS pet_name, " +
                     "FORMAT(a.start_time, 'dd/MM/yyyy HH:mm') AS appt_date " +
                     "FROM Feedback f " +
                     "JOIN Appointment a ON f.appt_id = a.appt_id " +
                     "JOIN Pet p ON a.pet_id = p.pet_id " +
                     "JOIN PetOwner po ON p.owner_id = po.user_id " +
                     "JOIN Users u ON po.user_id = u.user_id " +
                     "WHERE f.appt_id = ? AND p.owner_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, apptId);
            st.setInt(2, ownerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapFeedback(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getFeedbackByAppointmentAndOwner: " + e.getMessage());
        }
        return null;
    }

    /**
     * Allow owner to overwrite feedback only when current status is New.
     */
    public boolean updateFeedbackIfNew(int apptId, int ownerId, int rating, String comment) {
        String sql = "UPDATE f " +
                     "SET f.rating = ?, f.comment = ? " +
                     "FROM Feedback f " +
                     "JOIN Appointment a ON f.appt_id = a.appt_id " +
                     "JOIN Pet p ON a.pet_id = p.pet_id " +
                     "WHERE f.appt_id = ? AND p.owner_id = ? AND f.status = 'New'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, rating);
            st.setString(2, comment);
            st.setInt(3, apptId);
            st.setInt(4, ownerId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateFeedbackIfNew: " + e.getMessage());
            return false;
        }
    }
    
    private Feedback mapFeedback(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setApptId(rs.getInt("appt_id"));
        f.setRating(rs.getInt("rating"));
        f.setComment(rs.getString("comment"));
        f.setStatus(rs.getString("status"));
        f.setCustomerName(rs.getString("customer_name"));
        f.setPetName(rs.getString("pet_name"));
        f.setApptDate(rs.getString("appt_date"));
        return f;
    }

    /**
     * Check if an appointment already has feedback.
     */
    public boolean hasFeedback(int apptId) {
        String sql = "SELECT COUNT(*) FROM Feedback WHERE appt_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, apptId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error hasFeedback: " + e.getMessage());
        }
        return false;
    }
}
