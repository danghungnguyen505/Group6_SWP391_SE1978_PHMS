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
    }
}
