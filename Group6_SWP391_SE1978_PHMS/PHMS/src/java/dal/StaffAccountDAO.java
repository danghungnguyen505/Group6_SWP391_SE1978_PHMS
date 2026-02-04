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
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    user.setPhone(rs.getString("phone"));
                    // Store employee info in address field temporarily for display
                    user.setAddress(rs.getString("employee_code") + "|" + 
                                   rs.getString("department") + "|" + 
                                   (rs.getDouble("salary_base") != 0 ? String.valueOf(rs.getDouble("salary_base")) : ""));
                    list.add(user);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getAllStaffAccounts: " + e.getMessage());
        }
        return list;
    }
    
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
            }
        } catch (SQLException e) {
            System.out.println("Error getTotalStaffAccounts: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Get staff account detail by ID.
     */
    public User getStaffAccountById(int userId) {
        String sql = "SELECT u.*, e.employee_code, e.department, e.salary_base " +
                     "FROM Users u " +
                     "LEFT JOIN Employee e ON u.user_id = e.user_id " +
                     "WHERE u.user_id = ? AND u.role IN ('Veterinarian', 'Nurse', 'Receptionist', 'ClinicManager', 'Admin')";
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
                    user.setAddress(rs.getString("employee_code") + "|" + 
                                   rs.getString("department") + "|" + 
                                   (rs.getDouble("salary_base") != 0 ? String.valueOf(rs.getDouble("salary_base")) : ""));
                    return user;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getStaffAccountById: " + e.getMessage());
        }
        return null;
    }
    
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
     * Update staff account.
     */
    public boolean updateStaffAccount(int userId, String fullName, String phone, String role,
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
            
            // 2. Update Employee
            try (PreparedStatement ps = connection.prepareStatement(sqlEmployee)) {
                ps.setString(1, employeeCode);
                ps.setString(2, department);
                ps.setDouble(3, salaryBase != null ? salaryBase : 0.0);
                ps.setInt(4, userId);
                ps.executeUpdate(); // May not exist, use executeUpdate
            }
            
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
     * Delete staff account (soft delete by setting role to inactive or hard delete).
     * For safety, we'll just mark as inactive or prevent deletion if has appointments.
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
        
        // Delete role-specific record first
        String deleteVet = "DELETE FROM Veterinarian WHERE emp_id = ?";
        String deleteNurse = "DELETE FROM Nurse WHERE emp_id = ?";
        String deleteRecep = "DELETE FROM Receptionist WHERE emp_id = ?";
        String deleteManager = "DELETE FROM ClinicManager WHERE emp_id = ?";
        String deleteEmployee = "DELETE FROM Employee WHERE user_id = ?";
        String deleteUser = "DELETE FROM Users WHERE user_id = ?";
        
        try {
            connection.setAutoCommit(false);
            
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
    
    private boolean isValidStaffRole(String role) {
        return "Veterinarian".equalsIgnoreCase(role) ||
               "Nurse".equalsIgnoreCase(role) ||
               "Receptionist".equalsIgnoreCase(role) ||
               "ClinicManager".equalsIgnoreCase(role) ||
               "Admin".equalsIgnoreCase(role);
    }
    
    private String getRoleSpecificInsertSQL(String role) {
        if ("Veterinarian".equalsIgnoreCase(role)) {
            return "INSERT INTO Veterinarian (emp_id, license_number, specialization) VALUES (?, ?, ?)";
        }
        // Other roles don't need additional inserts based on schema
        return null;
    }
    
    private String getRoleSpecificUpdateSQL(String role) {
        if ("Veterinarian".equalsIgnoreCase(role)) {
            return "UPDATE Veterinarian SET license_number = ?, specialization = ? WHERE emp_id = ?";
        }
        return null;
    }
}
