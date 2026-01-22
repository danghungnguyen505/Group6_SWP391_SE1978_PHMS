/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
public class UserDAO extends DBContext{
    // Chức năng 1: Kiểm tra đăng nhập
    public User checkLogin(String username, String password) {
        // Câu lệnh SQL lấy thông tin user dựa vào username và password
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            // Gán giá trị cho dấu hỏi chấm (?)
            st.setString(1, username);
            st.setString(2, password);
            
            rs = st.executeQuery();
            
            // Nếu tìm thấy kết quả
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setFullName(rs.getString("full_name"));
                u.setRole(rs.getString("role"));
                // Các trường khác nếu cần (email, phone...)
                return u;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi checkLogin: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Đóng tài nguyên
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return null; // Trả về null nếu sai tk hoặc mk
    }
    //Check tài khoản
    public boolean checkUserExist(String username) {
        String sql = "SELECT * FROM Users WHERE username = ?";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            st.setString(1, username);
            rs = st.executeQuery();
            if (rs.next()) {
                return true; // Đã tồn tại
            }
        } catch (SQLException e) {
            System.out.println("Lỗi checkUserExist: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Đóng tài nguyên
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return false;
    }
    //Hàm Test Database
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        User u = dao.checkLogin("admin", "123");
        if (u != null) {
            System.out.println("Login thành công! Xin chào: " + u.getFullName());
            System.out.println("Role: " + u.getRole());
        } else {
            System.out.println("Login thất bại!");
        }
import model.User;

/**
 *
 * @author Nguyen Dang Hung
 */
public class UserDAO extends DBContext {

    public User checkLogin(String username, String password) {
    String sql = "SELECT u.*, p.address, p.email FROM Users u " +
                 "LEFT JOIN PetOwner p ON u.user_id = p.user_id " +
                 "WHERE u.username = ? AND u.password = ?";
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
}
