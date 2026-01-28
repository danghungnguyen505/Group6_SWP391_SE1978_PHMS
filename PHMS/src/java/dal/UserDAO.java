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

/**
 *
 * @author Nguyen Dang Hung
 */
public class UserDAO extends DBContext {

    public User checkLogin(String username, String password) {
        String sql = "SELECT u.*, p.address, p.email FROM Users u "
                + "LEFT JOIN PetOwner p ON u.user_id = p.user_id "
                + "WHERE u.username = ? AND u.password = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
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

    public void registerOwner(String username, String password, String fullName, String email, String phone, String address) {
        String sqlUser = "INSERT INTO Users (username, password, full_name, phone, role) VALUES (?, ?, ?, ?, 'PetOwner')";
        String sqlOwner = "INSERT INTO PetOwner (user_id, address, email) VALUES (?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sqlUser, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, username);
            ps.setString(2, password); // chưa mã hoá BCrypt
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

    public void changePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

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

    //List Veterinarians để hiện danh sách làm việc
    public List<User> getAllVeterinarians() {
        List<User> list = new ArrayList<>();
        // Join bảng Users và Veterinarian để chỉ lấy những ai là Bác sĩ
        String sql = "SELECT u.user_id, u.full_name FROM Users u "
                + "JOIN Veterinarian v ON u.user_id = v.emp_id";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public void createStaffAccount(String username, String password, String fullName, String phone, String role, String empCode) {
        String sqlUser = "INSERT INTO Users (username, password, full_name, phone, role) VALUES (?, ?, ?, ?, ?)";
        String sqlEmp = "INSERT INTO Employee (user_id, employee_code, department, salary_base) VALUES (?, ?, ?, 0)";

        String sqlRoleSpecific = "";
        if (role.equals("Veterinarian")) {
            sqlRoleSpecific = "INSERT INTO Veterinarian (emp_id, license_number, specialization) VALUES (?, 'N/A', 'General')";
        } else if (role.equals("Nurse")) {
            sqlRoleSpecific = "INSERT INTO Nurse (emp_id, skill_level) VALUES (?, 'Junior')";
        } else if (role.equals("Receptionist")) {
            sqlRoleSpecific = "INSERT INTO Receptionist (emp_id, desk_number) VALUES (?, 'Desk 1')";
        }

        try {
            connection.setAutoCommit(false);

            PreparedStatement psUser = connection.prepareStatement(sqlUser, PreparedStatement.RETURN_GENERATED_KEYS);
            psUser.setString(1, username);
            psUser.setString(2, password); // chưa mã hóa BCrypt
            psUser.setString(3, fullName);
            psUser.setString(4, phone);
            psUser.setString(5, role);
            
            psUser.executeUpdate();

            ResultSet rs = psUser.getGeneratedKeys();
            if (rs.next()) {
                int userId = rs.getInt(1);
                // 2. Insert Employee
                PreparedStatement psEmp = connection.prepareStatement(sqlEmp);
                psEmp.setInt(1, userId);
                psEmp.setString(2, empCode);
                psEmp.setString(3, "General");
                psEmp.executeUpdate();
                // 3. Insert Specific Role Table
                if (!sqlRoleSpecific.isEmpty()) {
                    PreparedStatement psSpecific = connection.prepareStatement(sqlRoleSpecific);
                    psSpecific.setInt(1, userId);
                    psSpecific.executeUpdate();
                }
            }

            connection.commit();
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
            }
        }
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.user_id, u.username, u.full_name, u.phone, u.role, u.is_active, p.email "
                + "FROM Users u LEFT JOIN PetOwner p ON u.user_id = p.user_id";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setEmail(rs.getString("email"));
                u.setIsActive(rs.getBoolean("is_active"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateUser(User user) {
        String sql = "UPDATE Users SET full_name = ?, phone = ?, role = ? WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getRole());
            ps.setInt(4, user.getUserId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void toggleUserStatus(int userId, boolean isActive) {
        String sql = "UPDATE Users SET is_active = ? WHERE user_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
