package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.TriageRecord;

/**
 * DAO for TriageRecord table.
 */
public class TriageRecordDAO extends DBContext {

    /**
     * Insert or update triage record for a given appointment.
     */
    public boolean upsertForAppointment(int apptId, int recepId, String conditionLevel, String initialSymptoms) {
        TriageRecord existing = getByAppointment(apptId);
        if (existing == null) {
            String sql = "INSERT INTO TriageRecord (appt_id, recep_id, condition_level, initial_symptoms, triage_time) "
                       + "VALUES (?, ?, ?, ?, GETDATE())";
            try (PreparedStatement st = connection.prepareStatement(sql)) {
                st.setInt(1, apptId);
                st.setInt(2, recepId);
                st.setString(3, conditionLevel);
                st.setString(4, initialSymptoms);
                return st.executeUpdate() > 0;
            } catch (SQLException e) {
                System.out.println("Error insert triage: " + e.getMessage());
                return false;
            }
        } else {
            String sql = "UPDATE TriageRecord SET recep_id = ?, condition_level = ?, initial_symptoms = ?, "
                       + "triage_time = GETDATE() WHERE appt_id = ?";
            try (PreparedStatement st = connection.prepareStatement(sql)) {
                st.setInt(1, recepId);
                st.setString(2, conditionLevel);
                st.setString(3, initialSymptoms);
                st.setInt(4, apptId);
                return st.executeUpdate() > 0;
            } catch (SQLException e) {
                System.out.println("Error update triage: " + e.getMessage());
                return false;
            }
        }
    }

    public TriageRecord getByAppointment(int apptId) {
        String sql = "SELECT triage_id, appt_id, recep_id, condition_level, initial_symptoms, triage_time "
                   + "FROM TriageRecord WHERE appt_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, apptId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    TriageRecord tr = new TriageRecord();
                    tr.setTriageId(rs.getInt("triage_id"));
                    tr.setApptId(rs.getInt("appt_id"));
                    tr.setRecepId(rs.getInt("recep_id"));
                    tr.setConditionLevel(rs.getString("condition_level"));
                    tr.setInitialSymptoms(rs.getString("initial_symptoms"));
                    tr.setTriageTime(rs.getTimestamp("triage_time"));
                    return tr;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getByAppointment triage: " + e.getMessage());
        }
        return null;
    }
}

