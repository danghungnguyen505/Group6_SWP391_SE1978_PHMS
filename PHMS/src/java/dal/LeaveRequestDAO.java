package dal;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.LeaveRequest;

/**
 * DAO for LeaveRequest table.
 */
public class LeaveRequestDAO extends DBContext {

    /**
     * Create a new leave request for a single day.
     * Current DB schema stores only start_date; we treat it as one-day leave.
     */
    public boolean createRequest(int empId, int managerId, Date startDate, String reason) {
        String sql = "INSERT INTO LeaveRequest (emp_id, manager_id, start_date, reason, status) "
                   + "VALUES (?, ?, ?, ?, 'Pending')";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, empId);
            st.setInt(2, managerId);
            st.setDate(3, startDate);
            st.setString(4, reason);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error createRequest: " + e.getMessage());
            return false;
        }
    }

    public List<LeaveRequest> listByEmployee(int empId) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT leave_id, emp_id, manager_id, start_date, start_date AS end_date, reason, status "
                   + "FROM LeaveRequest WHERE emp_id = ? ORDER BY leave_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, empId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listByEmployee: " + e.getMessage());
        }
        return list;
    }

    public List<LeaveRequest> listPendingForManager(int managerId) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT leave_id, emp_id, manager_id, start_date, start_date AS end_date, reason, status "
                   + "FROM LeaveRequest WHERE manager_id = ? AND status = 'Pending' "
                   + "ORDER BY start_date ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, managerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error listPendingForManager: " + e.getMessage());
        }
        return list;
    }

    public LeaveRequest getByIdForManager(int leaveId, int managerId) {
        String sql = "SELECT leave_id, emp_id, manager_id, start_date, start_date AS end_date, reason, status "
                   + "FROM LeaveRequest WHERE leave_id = ? AND manager_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, leaveId);
            st.setInt(2, managerId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getByIdForManager: " + e.getMessage());
        }
        return null;
    }

    public boolean updateStatus(int leaveId, int managerId, String newStatus) {
        String sql = "UPDATE LeaveRequest SET status = ? WHERE leave_id = ? AND manager_id = ? AND status = 'Pending'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, newStatus);
            st.setInt(2, leaveId);
            st.setInt(3, managerId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateStatus: " + e.getMessage());
            return false;
        }
    }

    private LeaveRequest map(ResultSet rs) throws SQLException {
        LeaveRequest lr = new LeaveRequest();
        lr.setLeaveId(rs.getInt("leave_id"));
        lr.setEmpId(rs.getInt("emp_id"));
        lr.setManagerId(rs.getInt("manager_id"));
        lr.setStartDate(rs.getDate("start_date"));
        lr.setEndDate(rs.getDate("end_date"));
        lr.setReason(rs.getString("reason"));
        lr.setStatus(rs.getString("status"));
        return lr;
    }

    /**
     * Get a default manager id (ClinicManager.emp_id) to assign as approver.
     */
    public Integer getDefaultManagerId() {
        String sql = "SELECT TOP 1 emp_id FROM ClinicManager ORDER BY emp_id ASC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("emp_id");
            }
        } catch (SQLException e) {
            System.out.println("Error getDefaultManagerId: " + e.getMessage());
        }
        return null;
    }
}

