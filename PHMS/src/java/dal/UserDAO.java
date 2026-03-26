/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.User;
import util.PasswordUtil;

/**
 *
 * @author Nguyen Dang Hung
 */
public class UserDAO extends DBContext {

    private boolean hasVeterinarianTypeColumn() {
        String sql = "SELECT COL_LENGTH('Veterinarian', 'type') AS col_len";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getObject("col_len") != null;
            }
        } catch (SQLException e) {
            System.out.println("Error hasVeterinarianTypeColumn: " + e.getMessage());
        }
        return false;
    }

    /**
     * Check login credentials with BCrypt password verification
     * Supports both BCrypt hashed passwords and plain text (for backward compatibility)
     */
    public User checkLogin(String username, String password) {
        String sql = "SELECT u.*, p.address, p.email FROM Users u " +
                     "LEFT JOIN PetOwner p ON u.user_id = p.user_id " +
                     "WHERE u.username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                
                // Verify password: check if it's BCrypt hash or plain text (for backward compatibility)
                boolean passwordMatches = false;
                if (PasswordUtil.isValidHash(storedPassword)) {
                    // BCrypt hash - verify using BCrypt
                    passwordMatches = PasswordUtil.verifyPassword(password, storedPassword);
                } else {
                    // Plain text (legacy) - direct comparison
                    passwordMatches = password.equals(storedPassword);
                }
                
                if (passwordMatches) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    user.setPhone(rs.getString("phone"));
                    user.setEmail(rs.getString("email"));
                    user.setAddress(rs.getString("address"));
                    // Don't store password in User object for security
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkUsernameExists(String username) {
        String sql = "SELECT user_id FROM Users WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            if (ps.executeQuery().next()) {
                return true;
            }
        } catch (Exception e) {
        }
        return false;
    }

    /**
     * Check if an email is already used by any PetOwner.
     */
    public boolean checkEmailExists(String email) {
        String sql = "SELECT p.user_id FROM PetOwner p WHERE p.email = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            if (ps.executeQuery().next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error checkEmailExists: " + e.getMessage());
        }
        return false;
    }

    /**
     * Check if a phone number is already used by any user.
     */
    public boolean checkPhoneExists(String phone) {
        String sql = "SELECT user_id FROM Users WHERE phone = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, phone);
            if (ps.executeQuery().next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error checkPhoneExists: " + e.getMessage());
        }
        return false;
    }

    /**
     * Check if a phone number is already used by another user (exclude current user).
     */
    public boolean checkPhoneExistsForOther(int userId, String phone) {
        String sql = "SELECT user_id FROM Users WHERE phone = ? AND user_id <> ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, phone);
            ps.setInt(2, userId);
            if (ps.executeQuery().next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error checkPhoneExistsForOther: " + e.getMessage());
        }
        return false;
    }

    /**
     * Get PetOwner account by phone number.
     */
    public User getPetOwnerByPhone(String phone) {
        String sql = "SELECT u.*, po.address, po.email "
                + "FROM Users u "
                + "JOIN PetOwner po ON u.user_id = po.user_id "
                + "WHERE u.phone = ? AND u.role = 'PetOwner'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error getPetOwnerByPhone: " + e.getMessage());
        }
        return null;
    }

    /**
     * Get PetOwner account by email.
     */
    public User getPetOwnerByEmail(String email) {
        String sql = "SELECT u.*, po.address, po.email "
                + "FROM Users u "
                + "JOIN PetOwner po ON u.user_id = po.user_id "
                + "WHERE po.email = ? AND u.role = 'PetOwner'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error getPetOwnerByEmail: " + e.getMessage());
        }
        return null;
    }

    /**
     * Create a PetOwner account and return new user_id.
     * Password will be BCrypt-hashed before storing.
     */
    public int insertPetOwnerReturnId(String username, String password, String fullName, String email, String phone, String address) {
        String sqlUser = "INSERT INTO Users (username, password, full_name, phone, role) VALUES (?, ?, ?, ?, 'PetOwner')";
        String sqlOwner = "INSERT INTO PetOwner (user_id, address, email) VALUES (?, ?, ?)";

        try {
            String hashedPassword = PasswordUtil.hashPassword(password);

            PreparedStatement ps = connection.prepareStatement(sqlUser, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, fullName);
            ps.setString(4, phone);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int userId = rs.getInt(1);

                PreparedStatement psOwner = connection.prepareStatement(sqlOwner);
                psOwner.setInt(1, userId);
                psOwner.setString(2, address);
                psOwner.setString(3, email);
                psOwner.executeUpdate();
                return userId;
            }
        } catch (Exception e) {
            System.out.println("Error insertPetOwnerReturnId: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Register a new pet owner with BCrypt password hashing
     */
    public void registerOwner(String username, String password, String fullName, String email, String phone, String address) {
        String sqlUser = "INSERT INTO Users (username, password, full_name, phone, role) VALUES (?, ?, ?, ?, 'PetOwner')";
        String sqlOwner = "INSERT INTO PetOwner (user_id, address, email) VALUES (?, ?, ?)";

        try {
            // Hash password using BCrypt
            String hashedPassword = PasswordUtil.hashPassword(password);
            
            PreparedStatement ps = connection.prepareStatement(sqlUser, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, fullName);
            ps.setString(4, phone);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int userId = rs.getInt(1);

                PreparedStatement psOwner = connection.prepareStatement(sqlOwner);
                psOwner.setInt(1, userId);
                psOwner.setString(2, address);
                psOwner.setString(3, email);
                psOwner.executeUpdate();
            }
        } catch (Exception e) {
            System.out.println("Register Error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateProfile(User user, String address) {
        String sqlUser = "UPDATE Users SET full_name = ?, phone = ? WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sqlUser);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone()); 
            ps.setInt(3, user.getUserId());
            ps.executeUpdate();

            if ("PetOwner".equalsIgnoreCase(user.getRole())) {
                String sqlOwner = "UPDATE PetOwner SET address = ? WHERE user_id = ?";
                PreparedStatement psOwner = connection.prepareStatement(sqlOwner);
                psOwner.setString(1, address);
                psOwner.setInt(2, user.getUserId());
                psOwner.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Change user password with BCrypt hashing
     */
    public void changePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        try {
            // Hash password using BCrypt
            String hashedPassword = PasswordUtil.hashPassword(newPassword);
            
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Get user by ID (for password verification in change password)
     */
    public User getUserById(int userId) {
        String sql = "SELECT u.*, p.address, p.email FROM Users u " +
                     "LEFT JOIN PetOwner p ON u.user_id = p.user_id " +
                     "WHERE u.user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password")); // Include password for verification
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    // (deprecated) Use checkEmailExists for uniqueness check instead.
    public User checkEmailExist(String email) {
        String sql = "SELECT u.*, p.address, p.email FROM Users u JOIN PetOwner p ON u.user_id = p.user_id WHERE p.email = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("role"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("email")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    //List Veterinarians Ä‘á»ƒ hiá»‡n danh sÃ¡ch lÃ m viá»‡c
    public List<User> getAllVeterinarians() {
        List<User> list = new ArrayList<>();
        boolean withType = hasVeterinarianTypeColumn();
        String sql = withType
                ? "SELECT u.user_id, u.full_name, v.[type] AS vet_type FROM Users u "
                + "JOIN Veterinarian v ON u.user_id = v.emp_id"
                : "SELECT u.user_id, u.full_name FROM Users u "
                + "JOIN Veterinarian v ON u.user_id = v.emp_id";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setVetType(withType ? rs.getString("vet_type") : "Normal");
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public boolean isBookableVeterinarianForOwner(int vetId) {
        boolean withType = hasVeterinarianTypeColumn();
        String sql = withType
                ? "SELECT TOP 1 1 FROM Users u "
                + "JOIN Veterinarian v ON u.user_id = v.emp_id "
                + "WHERE u.user_id = ? AND u.role = 'Veterinarian' "
                + "AND ISNULL(u.is_active, 1) = 1 "
                + "AND UPPER(ISNULL(v.[type], 'Normal')) = 'NORMAL'"
                : "SELECT TOP 1 1 FROM Users u "
                + "JOIN Veterinarian v ON u.user_id = v.emp_id "
                + "WHERE u.user_id = ? AND u.role = 'Veterinarian' "
                + "AND ISNULL(u.is_active, 1) = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, vetId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.out.println("Error isBookableVeterinarianForOwner: " + e.getMessage());
            return false;
        }
    }

    public List<User> getEmergencyVeterinarians() {
        List<User> list = new ArrayList<>();
        boolean withType = hasVeterinarianTypeColumn();
        String sql = withType
                ? "SELECT u.user_id, u.full_name, v.[type] AS vet_type "
                + "FROM Users u "
                + "JOIN Veterinarian v ON u.user_id = v.emp_id "
                + "WHERE UPPER(ISNULL(v.[type], 'Normal')) = 'EMERGENCY'"
                : "SELECT u.user_id, u.full_name FROM Users u "
                + "JOIN Veterinarian v ON u.user_id = v.emp_id";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setVetType(withType ? rs.getString("vet_type") : "Emergency");
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println("Error getEmergencyVeterinarians: " + e.getMessage());
        }
        return list;
    }

    /**
     * Get owner (PetOwner) by pet ID.
     */
    public User getOwnerByPetId(int petId) {
        String sql = "SELECT u.*, p.address, p.email FROM Users u " +
                     "JOIN PetOwner po ON u.user_id = po.user_id " +
                     "JOIN Pet p ON po.user_id = p.owner_id " +
                     "WHERE p.pet_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, petId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error getOwnerByPetId: " + e.getMessage());
        }
        return null;
    }
}

