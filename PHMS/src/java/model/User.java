package model;

public class User {
    // 1. Khai báo các thuộc tính giống hệt các cột trong bảng Users
    private int id;             // user_id
    private String username;    // username
    private String password;    // password
    private String fullName;    // full_name
    private String phone;       // phone
    private String role;        // role

    // 2. Constructor
    public User() {
    }

    // 3. Constructor đầy đủ tham số (Dùng khi lấy dữ liệu từ DB lên)
    public User(int id, String username, String password, String fullName, String phone, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.role = role;
    }
    
    // 4. Constructor thiếu ID (Dùng khi tạo User mới để Insert vào DB - vì ID tự tăng)
    public User(String username, String password, String fullName, String phone, String role) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.role = role;
    }

    // 5. Getters và Setters để JSP và Servlet truy xuất dữ liệu
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // 6. Hàm toString() Giúp in thông tin đối tượng ra console
    @Override
    public String toString() {
        return "User{" + "id=" + id + ", username=" + username + ", role=" + role + '}';
    }
}