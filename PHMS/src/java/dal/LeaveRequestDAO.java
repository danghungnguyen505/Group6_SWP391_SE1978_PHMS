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
     * Create a new leave request for a single day. Current DB schema stores
     * only start_date; we treat it as one-day leave.
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
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("emp_id");
            }
        } catch (SQLException e) {
            System.out.println("Error getDefaultManagerId: " + e.getMessage());
        }
        return null;
    }

    //Đăng ký xin nghỉ
// 1. Lấy danh sách đơn nghỉ (có phân trang, search, filter cho SQL Server)
    public List<LeaveRequest> getLeaveRequests(String search, String statusFilter, int offset, int limit) {
        List<LeaveRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT lr.leave_id, lr.emp_id, u.full_name, lr.start_date, lr.reason, lr.status "
            + "FROM LeaveRequest lr "
            + "JOIN Users u ON lr.emp_id = u.user_id "
            + "WHERE 1=1 "
        );

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND u.full_name LIKE ? ");
        }
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
            sql.append("AND lr.status = ? ");
        }

        sql.append("ORDER BY lr.start_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + search.trim() + "%");
            }
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
                st.setString(paramIndex++, statusFilter);
            }
            st.setInt(paramIndex++, offset);
            st.setInt(paramIndex++, limit);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                LeaveRequest lr = new LeaveRequest();
                lr.setLeaveId(rs.getInt("leave_id"));
                lr.setEmpId(rs.getInt("emp_id"));
                lr.setEmpName(rs.getString("full_name"));
                lr.setStartDate(rs.getDate("start_date"));
                lr.setReason(rs.getString("reason"));
                lr.setStatus(rs.getString("status"));
                list.add(lr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Đếm tổng số đơn nghỉ để tính số trang
    public int getTotalLeaveRequests(String search, String statusFilter) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM LeaveRequest lr JOIN Users u ON lr.emp_id = u.user_id WHERE 1=1 "
        );

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND u.full_name LIKE ? ");
        }
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
            sql.append("AND lr.status = ? ");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + search.trim() + "%");
            }
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
                st.setString(paramIndex++, statusFilter);
            }
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Alias for backward compatibility
    public List<LeaveRequest> getPendingLeaveRequests(int offset, int limit) {
        return getLeaveRequests(null, "Pending", offset, limit);
    }

    public int getTotalPendingRequests() {
        return getTotalLeaveRequests(null, "Pending");
    }

    // 3. Cập nhật trạng thái duyệt/từ chối
    public boolean updateLeaveStatus(int leaveId, int managerId, String status) {
        String sql = "UPDATE LeaveRequest SET status = ?, manager_id = ? WHERE leave_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setInt(2, managerId);
            st.setInt(3, leaveId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi Update Status: " + e.getMessage());
            return false;
        }
    }

    // 4. Lấy chi tiết 1 đơn nghỉ để biết ngày và emp_id (phục vụ xóa lịch)
    public LeaveRequest getLeaveRequestById(int leaveId) {
        String sql = "SELECT emp_id, start_date FROM LeaveRequest WHERE leave_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, leaveId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                LeaveRequest lr = new LeaveRequest();
                lr.setEmpId(rs.getInt("emp_id"));
                lr.setStartDate(rs.getDate("start_date"));
                return lr;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
