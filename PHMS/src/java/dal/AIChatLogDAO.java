package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.AIChatLog;

/**
 * DAO for AIChatLog table.
 */
public class AIChatLogDAO extends DBContext {

    public boolean insertLog(int userId, String question, String response) {
        String sql = "INSERT INTO AIChatLog (user_id, question_raw, ai_response) VALUES (?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setString(2, question);
            st.setString(3, response);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error insertLog AIChat: " + e.getMessage());
            return false;
        }
    }

    public List<AIChatLog> listByUser(int userId, int limit) {
        List<AIChatLog> list = new ArrayList<>();
        String sql = "SELECT * FROM (" +
                 "    SELECT TOP (?) log_id, user_id, question_raw, ai_response, created_at " +
                 "    FROM AIChatLog " +
                 "    WHERE user_id = ? " +
                 "    ORDER BY created_at DESC" +
                 ") AS SubQuery " +
                 "ORDER BY created_at ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            st.setInt(2, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    AIChatLog log = new AIChatLog();
                    log.setLogId(rs.getInt("log_id"));
                    log.setUserId(rs.getInt("user_id"));
                    log.setQuestionRaw(rs.getString("question_raw"));
                    log.setAiResponse(rs.getString("ai_response"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listByUser AIChat: " + e.getMessage());
        }
        return list;
    }
}

