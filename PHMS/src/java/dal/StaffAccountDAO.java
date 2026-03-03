package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.User;
import util.PasswordUtil;

/**
<<<<<<< Updated upstream
 * DAO for Staff Account Management (Admin only).
 * Handles CRUD for Employee, Veterinarian, Nurse, Receptionist, ClinicManager.
 */
public class StaffAccountDAO extends DBContext {
    
    /**
     * Get all staff accounts (excluding PetOwner) with pagination.
     */
    public List<User> getAllStaffAccounts(int page, int pageSize) {
        List<User> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT u.user_id, u.username, u.full_name, u.role, u.phone, " +
                     "e.employee_code, e.department, e.salary_base " +
                     "FROM Users u " +
                     "LEFT JOIN Employee e ON u.user_id = e.user_id " +
                     "WHERE u.role IN ('Veterinarian', 'Nurse', 'Receptionist', 'ClinicManager', 'Admin') " +
                     "ORDER BY u.user_id DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, offset);
            st.setInt(2, pageSize);
=======
 * DAO for Staff Account Management (Admin only). Handles CRUD for Employee,
 * Veterinarian, Nurse, Receptionist, ClinicManager.
 */
public class StaffAccountDAO extends DBContext {

    /**
     * Get all staff accounts (excluding PetOwner) with pagination.
     * Supports optional filters: keyword (username/full_name/phone/code), role, status.
     *
     * @param page current page (1-based)
     * @param pageSize items per page
     * @param keyword search text (nullable)
     * @param roleFilter specific role or "ALL"/null for any
     * @param statusFilter "active", "inactive" hoặc null/other để không lọc
     */
    public List<User> getAllStaffAccounts(int page, int pageSize, String keyword, String roleFilter, String statusFilter) {
        List<User> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        String like = hasKeyword ? "%" + keyword.trim() + "%" : null;

        boolean hasRole = roleFilter != null && !roleFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleFilter);
        boolean hasStatus = statusFilter != null && !statusFilter.trim().isEmpty();

        String baseSql = "SELECT u.user_id, u.username, u.full_name, u.role, u.phone, u.is_active, "
                + "e.employee_code, e.department, e.salary_base "
                + "FROM Users u "
                + "LEFT JOIN Employee e ON u.user_id = e.user_id "
                + "WHERE u.role IN ('Veterinarian', 'Nurse', 'Receptionist', 'ClinicManager', 'Admin') ";

        StringBuilder filterSql = new StringBuilder();
        if (hasRole) {
            filterSql.append("AND u.role = ? ");
        }
        if (hasStatus) {
            if ("active".equalsIgnoreCase(statusFilter)) {
                filterSql.append("AND u.is_active = 1 ");
            } else if ("inactive".equalsIgnoreCase(statusFilter)) {
                filterSql.append("AND u.is_active = 0 ");
            }
        }
        if (hasKeyword) {
            filterSql.append("AND (u.username LIKE ? OR u.full_name LIKE ? OR u.phone LIKE ? OR e.employee_code LIKE ?) ");
        }

        String pagingSql = "ORDER BY u.user_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        String sql = baseSql + filterSql.toString() + pagingSql;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            int idx = 1;
            if (hasRole) {
                st.setString(idx++, roleFilter);
            }
            if (hasKeyword) {
                st.setString(idx++, like);
                st.setString(idx++, like);
                st.setString(idx++, like);
                st.setString(idx++, like);
            }
            st.setInt(idx++, offset);
            st.setInt(idx, pageSize);

>>>>>>> Stashed changes
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    user.setPhone(rs.getString("phone"));
<<<<<<< Updated upstream
                    // Store employee info in address field temporarily for display
                    user.setAddress(rs.getString("employee_code") + "|" + 
                                   rs.getString("department") + "|" + 
                                   (rs.getDouble("salary_base") != 0 ? String.valueOf(rs.getDouble("salary_base")) : ""));
=======

                    String code = rs.getString("employee_code") != null ? rs.getString("employee_code") : "N/A";
                    String dept = rs.getString("department") != null ? rs.getString("department") : "N/A";
                    double salary = rs.getDouble("salary_base");
                    int active = rs.getInt("is_active");

                    user.setAddress(code + "|" + dept + "|" + salary + "|" + active);

>>>>>>> Stashed changes
                    list.add(user);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getAllStaffAccounts: " + e.getMessage());
        }
        return list;
    }
<<<<<<< Updated upstream
    
    /**
     * Get total count of staff accounts.
     */
    public int getTotalStaffAccounts() {
        String sql = "SELECT COUNT(*) AS total FROM Users " +
                     "WHERE role IN ('Veterinarian', 'Nurse', 'Receptionist', 'ClinicManager', 'Admin')";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
=======

    /**
     * Get total count of staff accounts, with optional keyword/role/status filters.
     */
    public int getTotalStaffAccounts(String keyword, String roleFilter, String statusFilter) {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        String like = hasKeyword ? "%" + keyword.trim() + "%" : null;

        boolean hasRole = roleFilter != null && !roleFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleFilter);
        boolean hasStatus = statusFilter != null && !statusFilter.trim().isEmpty();

        String baseSql = "SELECT COUNT(*) AS total FROM Users u "
                + "LEFT JOIN Employee e ON u.user_id = e.user_id "
                + "WHERE u.role IN ('Veterinarian', 'Nurse', 'Receptionist', 'ClinicManager', 'Admin') ";

        StringBuilder filterSql = new StringBuilder();
        if (hasRole) {
            filterSql.append("AND u.role = ? ");
        }
        if (hasStatus) {
            if ("active".equalsIgnoreCase(statusFilter)) {
                filterSql.append("AND u.is_active = 1 ");
            } else if ("inactive".equalsIgnoreCase(statusFilter)) {
                filterSql.append("AND u.is_active = 0 ");
            }
        }
        if (hasKeyword) {
            filterSql.append("AND (u.username LIKE ? OR u.full_name LIKE ? OR u.phone LIKE ? OR e.employee_code LIKE ?)");
        }

        String sql = baseSql + filterSql.toString();

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            int idx = 1;
            if (hasRole) {
                st.setString(idx++, roleFilter);
            }
            if (hasKeyword) {
                st.setString(idx++, like);
                st.setString(idx++, like);
                st.setString(idx++, like);
                st.setString(idx++, like);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
>>>>>>> Stashed changes
            }
        } catch (SQLException e) {
            System.out.println("Error getTotalStaffAccounts: " + e.getMessage());
        }
        return 0;
    }
<<<<<<< Updated upstream
    
=======

>>>>>>> Stashed changes
    /**
     * Get staff account detail by ID.
     */
    public User getStaffAccountById(int userId) {
<<<<<<< Updated upstream
        String sql = "SELECT u.*, e.employee_code, e.department, e.salary_base " +
                     "FROM Users u " +
                     "LEFT JOIN Employee e ON u.user_id = e.user_id " +
                     "WHERE u.user_id = ? AND u.role IN ('Veterinarian', 'Nurse', 'Receptionist', 'ClinicManager', 'Admin')";
=======
        String sql = "SELECT u.*, e.employee_code, e.department, e.salary_base "
                + "FROM Users u "
                + "LEFT JOIN Employee e ON u.user_id = e.user_id "
                + "WHERE u.user_id = ? AND u.role IN ('Veterinarian', 'Nurse', 'Receptionist', 'ClinicManager', 'Admin')";
>>>>>>> Stashed changes
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    user.setPhone(rs.getString("phone"));
                    // Store employee info
<<<<<<< Updated upstream
                    user.setAddress(rs.getString("employee_code") + "|" + 
                                   rs.getString("department") + "|" + 
                                   (rs.getDouble("salary_base") != 0 ? String.valueOf(rs.getDouble("salary_base")) : ""));
=======
                    user.setAddress(rs.getString("employee_code") + "|"
                            + rs.getString("department") + "|"
                            + (rs.getDouble("salary_base") != 0 ? String.valueOf(rs.getDouble("salary_base")) : ""));
>>>>>>> Stashed changes
                    return user;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getStaffAccountById: " + e.getMessage());
        }
        return null;
    }
<<<<<<< Updated upstream
    
    /**
     * Create staff account with Employee record and role-specific table.
     * Business rule: role must be Veterinarian, Nurse, Receptionist, ClinicManager, or Admin.
     */
    public boolean createStaffAccount(String username, String password, String fullName, String phone,
                                     String role, String employeeCode, String department, Double salaryBase,
                                     String specialization, String licenseNumber) throws SQLException {
        if (!isValidStaffRole(role)) {
            return false;
        }
        
        String sqlUser = "INSERT INTO Users (username, password, full_name, phone, role) VALUES (?, ?, ?, ?, ?)";
        String sqlEmployee = "INSERT INTO Employee (user_id, employee_code, department, salary_base) VALUES (?, ?, ?, ?)";
        String sqlRoleSpecific = getRoleSpecificInsertSQL(role);
        
        boolean oldAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);
            
=======

    /**
     * Create staff account with Employee record and role-specific table.
     * Business rule: role must be Veterinarian, Nurse, Receptionist,
     * ClinicManager, or Admin.
     */
    public boolean createStaffAccount(String username, String password, String fullName, String phone,
            String role, String employeeCode, String department, Double salaryBase,
            String specialization, String licenseNumber) throws SQLException {
        if (!isValidStaffRole(role)) {
            return false;
        }

        String sqlUser = "INSERT INTO Users (username, password, full_name, phone, role) VALUES (?, ?, ?, ?, ?)";
        String sqlEmployee = "INSERT INTO Employee (user_id, employee_code, department, salary_base) VALUES (?, ?, ?, ?)";
        String sqlRoleSpecific = getRoleSpecificInsertSQL(role);

        boolean oldAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);

>>>>>>> Stashed changes
            // 1. Insert Users
            int userId;
            String hashedPassword = PasswordUtil.hashPassword(password);
            try (PreparedStatement ps = connection.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, username);
                ps.setString(2, hashedPassword);
                ps.setString(3, fullName);
                ps.setString(4, phone);
                ps.setString(5, role);
                if (ps.executeUpdate() <= 0) {
                    connection.rollback();
                    return false;
                }
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }
                    userId = rs.getInt(1);
                }
            }
<<<<<<< Updated upstream
            
=======

>>>>>>> Stashed changes
            // 2. Insert Employee
            try (PreparedStatement ps = connection.prepareStatement(sqlEmployee)) {
                ps.setInt(1, userId);
                ps.setString(2, employeeCode);
                ps.setString(3, department);
                ps.setDouble(4, salaryBase != null ? salaryBase : 0.0);
                if (ps.executeUpdate() <= 0) {
                    connection.rollback();
                    return false;
                }
            }
<<<<<<< Updated upstream
            
=======

>>>>>>> Stashed changes
            // 3. Insert role-specific record
            if (sqlRoleSpecific != null) {
                try (PreparedStatement ps = connection.prepareStatement(sqlRoleSpecific)) {
                    ps.setInt(1, userId);
                    if ("Veterinarian".equalsIgnoreCase(role)) {
                        ps.setString(2, licenseNumber != null ? licenseNumber : "");
                        ps.setString(3, specialization != null ? specialization : "");
                    }
                    if (ps.executeUpdate() <= 0) {
                        connection.rollback();
                        return false;
                    }
                }
            }
<<<<<<< Updated upstream
            
=======

>>>>>>> Stashed changes
            connection.commit();
            return true;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }
<<<<<<< Updated upstream
    
=======

>>>>>>> Stashed changes
    /**
     * Update staff account.
     */
    public boolean updateStaffAccount(int userId, String fullName, String phone, String role,
<<<<<<< Updated upstream
                                     String employeeCode, String department, Double salaryBase,
                                     String specialization, String licenseNumber) throws SQLException {
        if (!isValidStaffRole(role)) {
            return false;
        }
        
        String sqlUser = "UPDATE Users SET full_name = ?, phone = ?, role = ? WHERE user_id = ?";
        String sqlEmployee = "UPDATE Employee SET employee_code = ?, department = ?, salary_base = ? WHERE user_id = ?";
        String sqlRoleSpecific = getRoleSpecificUpdateSQL(role);
        
        boolean oldAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);
            
=======
            String employeeCode, String department, Double salaryBase,
            String specialization, String licenseNumber) throws SQLException {
        if (!isValidStaffRole(role)) {
            return false;
        }

        String sqlUser = "UPDATE Users SET full_name = ?, phone = ?, role = ? WHERE user_id = ?";
        String sqlEmployee = "UPDATE Employee SET employee_code = ?, department = ?, salary_base = ? WHERE user_id = ?";
        String sqlRoleSpecific = getRoleSpecificUpdateSQL(role);

        boolean oldAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);

>>>>>>> Stashed changes
            // 1. Update Users
            try (PreparedStatement ps = connection.prepareStatement(sqlUser)) {
                ps.setString(1, fullName);
                ps.setString(2, phone);
                ps.setString(3, role);
                ps.setInt(4, userId);
                if (ps.executeUpdate() <= 0) {
                    connection.rollback();
                    return false;
                }
            }
<<<<<<< Updated upstream
            
=======

>>>>>>> Stashed changes
            // 2. Update Employee
            try (PreparedStatement ps = connection.prepareStatement(sqlEmployee)) {
                ps.setString(1, employeeCode);
                ps.setString(2, department);
                ps.setDouble(3, salaryBase != null ? salaryBase : 0.0);
                ps.setInt(4, userId);
                ps.executeUpdate(); // May not exist, use executeUpdate
            }
<<<<<<< Updated upstream
            
=======

>>>>>>> Stashed changes
            // 3. Update role-specific (delete old, insert new if role changed)
            // For simplicity, we'll update if exists
            if (sqlRoleSpecific != null && "Veterinarian".equalsIgnoreCase(role)) {
                String checkSql = "SELECT emp_id FROM Veterinarian WHERE emp_id = ?";
                boolean exists = false;
                try (PreparedStatement chk = connection.prepareStatement(checkSql)) {
                    chk.setInt(1, userId);
                    try (ResultSet rs = chk.executeQuery()) {
                        exists = rs.next();
                    }
                }
<<<<<<< Updated upstream
                
=======

>>>>>>> Stashed changes
                if (exists) {
                    try (PreparedStatement ps = connection.prepareStatement(sqlRoleSpecific)) {
                        ps.setString(1, licenseNumber != null ? licenseNumber : "");
                        ps.setString(2, specialization != null ? specialization : "");
                        ps.setInt(3, userId);
                        ps.executeUpdate();
                    }
                } else {
                    String insertSql = "INSERT INTO Veterinarian (emp_id, license_number, specialization) VALUES (?, ?, ?)";
                    try (PreparedStatement ps = connection.prepareStatement(insertSql)) {
                        ps.setInt(1, userId);
                        ps.setString(2, licenseNumber != null ? licenseNumber : "");
                        ps.setString(3, specialization != null ? specialization : "");
                        ps.executeUpdate();
                    }
                }
            }
<<<<<<< Updated upstream
            
=======

>>>>>>> Stashed changes
            connection.commit();
            return true;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }
<<<<<<< Updated upstream
    
    /**
     * Delete staff account (soft delete by setting role to inactive or hard delete).
     * For safety, we'll just mark as inactive or prevent deletion if has appointments.
=======

    public boolean toggleStaffStatus(int userId) {
        // 1. Lấy trạng thái hiện tại để biết là đang muốn KHÓA hay MỞ KHÓA
        String statusSql = "SELECT is_active FROM Users WHERE user_id = ?";
        int currentStatus = -1;

        try (PreparedStatement ps = connection.prepareStatement(statusSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    currentStatus = rs.getInt("is_active");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // 2. Nếu đang hoạt động (1) và muốn KHÓA (về 0), kiểm tra lịch hẹn chưa xong
        if (currentStatus == 1) {
            String checkSql = "SELECT COUNT(*) AS cnt FROM Appointment WHERE vet_id = ? AND status = 'Pending'";
            try (PreparedStatement chk = connection.prepareStatement(checkSql)) {
                chk.setInt(1, userId);
                try (ResultSet rs = chk.executeQuery()) {
                    if (rs.next() && rs.getInt("cnt") > 0) {
                        return false; // Có lịch hẹn chưa xong -> ko cho khóa
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }

        // 3. Thực hiện đảo ngược trạng thái: 1 -> 0, 0 -> 1
        String updateSql = "UPDATE Users SET is_active = 1 - is_active WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete staff account (soft delete by setting role to inactive or hard
     * delete). For safety, we'll just mark as inactive or prevent deletion if
     * has appointments.
>>>>>>> Stashed changes
     */
    public boolean deleteStaffAccount(int userId) {
        // Check if staff has appointments
        String checkSql = "SELECT COUNT(*) AS cnt FROM Appointment WHERE vet_id = ?";
        try (PreparedStatement chk = connection.prepareStatement(checkSql)) {
            chk.setInt(1, userId);
            try (ResultSet rs = chk.executeQuery()) {
                if (rs.next() && rs.getInt("cnt") > 0) {
                    return false; // Cannot delete if has appointments
                }
            }
        } catch (SQLException e) {
            System.out.println("Error checking appointments: " + e.getMessage());
            return false;
        }
<<<<<<< Updated upstream
        
=======

>>>>>>> Stashed changes
        // Delete role-specific record first
        String deleteVet = "DELETE FROM Veterinarian WHERE emp_id = ?";
        String deleteNurse = "DELETE FROM Nurse WHERE emp_id = ?";
        String deleteRecep = "DELETE FROM Receptionist WHERE emp_id = ?";
        String deleteManager = "DELETE FROM ClinicManager WHERE emp_id = ?";
        String deleteEmployee = "DELETE FROM Employee WHERE user_id = ?";
        String deleteUser = "DELETE FROM Users WHERE user_id = ?";
<<<<<<< Updated upstream
        
        try {
            connection.setAutoCommit(false);
            
=======

        try {
            connection.setAutoCommit(false);

>>>>>>> Stashed changes
            try (PreparedStatement ps = connection.prepareStatement(deleteVet)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(deleteNurse)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(deleteRecep)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(deleteManager)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(deleteEmployee)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(deleteUser)) {
                ps.setInt(1, userId);
                if (ps.executeUpdate() <= 0) {
                    connection.rollback();
                    return false;
                }
            }
<<<<<<< Updated upstream
            
=======

>>>>>>> Stashed changes
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.out.println("Error rollback: " + ex.getMessage());
            }
            System.out.println("Error deleteStaffAccount: " + e.getMessage());
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                System.out.println("Error reset autocommit: " + e.getMessage());
            }
        }
    }
<<<<<<< Updated upstream
    
    private boolean isValidStaffRole(String role) {
        return "Veterinarian".equalsIgnoreCase(role) ||
               "Nurse".equalsIgnoreCase(role) ||
               "Receptionist".equalsIgnoreCase(role) ||
               "ClinicManager".equalsIgnoreCase(role) ||
               "Admin".equalsIgnoreCase(role);
    }
    
=======

    private boolean isValidStaffRole(String role) {
        return "Veterinarian".equalsIgnoreCase(role)
                || "Nurse".equalsIgnoreCase(role)
                || "Receptionist".equalsIgnoreCase(role)
                || "ClinicManager".equalsIgnoreCase(role)
                || "Admin".equalsIgnoreCase(role);
    }

>>>>>>> Stashed changes
    private String getRoleSpecificInsertSQL(String role) {
        if ("Veterinarian".equalsIgnoreCase(role)) {
            return "INSERT INTO Veterinarian (emp_id, license_number, specialization) VALUES (?, ?, ?)";
        }
        // Other roles don't need additional inserts based on schema
        return null;
    }
<<<<<<< Updated upstream
    
=======

>>>>>>> Stashed changes
    private String getRoleSpecificUpdateSQL(String role) {
        if ("Veterinarian".equalsIgnoreCase(role)) {
            return "UPDATE Veterinarian SET license_number = ?, specialization = ? WHERE emp_id = ?";
        }
        return null;
    }
}
