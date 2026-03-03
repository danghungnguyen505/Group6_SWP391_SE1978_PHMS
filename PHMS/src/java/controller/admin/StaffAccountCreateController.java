package controller.admin;

import dal.StaffAccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import model.User;

/**
 * Admin creates new staff account.
 * SRP: Create staff account only.
 */
@WebServlet(name = "StaffAccountCreateController", urlPatterns = {"/admin/staff/create"})
public class StaffAccountCreateController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.getRequestDispatcher("/views/admin/staffCreate.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String username = util.ValidationUtils.sanitize(request.getParameter("username"));
        String password = request.getParameter("password");
        String fullName = util.ValidationUtils.sanitize(request.getParameter("fullName"));
        String phone = util.ValidationUtils.sanitize(request.getParameter("phone"));
        String role = util.ValidationUtils.sanitize(request.getParameter("role"));
        String employeeCode = util.ValidationUtils.sanitize(request.getParameter("employeeCode"));
        String department = util.ValidationUtils.sanitize(request.getParameter("department"));
        String salaryStr = request.getParameter("salaryBase");
        String specialization = util.ValidationUtils.sanitize(request.getParameter("specialization"));
        String licenseNumber = util.ValidationUtils.sanitize(request.getParameter("licenseNumber"));
        
        // Validation
        if (!util.ValidationUtils.isNotEmpty(username) || !util.ValidationUtils.isValidUsername(username)) {
            request.setAttribute("error", "Tên đăng nhập không hợp lệ!");
            repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
            doGet(request, response);
            return;
        }
        
        dal.UserDAO userDAO = new dal.UserDAO();
        if (userDAO.checkUsernameExists(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(password) || !util.ValidationUtils.isValidPassword(password)) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
            repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(fullName) || !util.ValidationUtils.isLengthValid(fullName, 2, 100)) {
            request.setAttribute("error", "Họ tên phải có từ 2 đến 100 ký tự!");
            repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(phone) || !util.ValidationUtils.isValidPhone(phone)) {
            request.setAttribute("error", "Số điện thoại không hợp lệ!");
            repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
            doGet(request, response);
            return;
        }
        
<<<<<<< Updated upstream
=======
        // Phone must be unique across all users
        if (userDAO.checkPhoneExists(phone)) {
            request.setAttribute("error", "Số điện thoại này đã được sử dụng!");
            repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
            doGet(request, response);
            return;
        }
        
>>>>>>> Stashed changes
        if (!isValidStaffRole(role)) {
            request.setAttribute("error", "Vai trò không hợp lệ!");
            repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(employeeCode) || !util.ValidationUtils.isLengthValid(employeeCode, 1, 20)) {
            request.setAttribute("error", "Mã nhân viên phải có từ 1 đến 20 ký tự!");
            repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
            doGet(request, response);
            return;
        }
        
        Double salaryBase = null;
        if (util.ValidationUtils.isNotEmpty(salaryStr)) {
            if (!util.ValidationUtils.isPositiveNumber(salaryStr)) {
                request.setAttribute("error", "Lương cơ bản phải là số dương!");
                repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
                doGet(request, response);
                return;
            }
            salaryBase = Double.parseDouble(salaryStr);
        }
        
        StaffAccountDAO staffDAO = new StaffAccountDAO();
        try {
            boolean ok = staffDAO.createStaffAccount(username, password, fullName, phone, role,
                    employeeCode, department, salaryBase, specialization, licenseNumber);
            if (ok) {
                session.setAttribute("toastMessage", "success|Tạo tài khoản nhân viên thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            } else {
                request.setAttribute("error", "Không thể tạo tài khoản. Vui lòng thử lại.");
                repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
                doGet(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            repopulateForm(request, username, password, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber);
            doGet(request, response);
        }
    }
    
    private boolean isValidStaffRole(String role) {
        return "Veterinarian".equalsIgnoreCase(role) ||
               "Nurse".equalsIgnoreCase(role) ||
               "Receptionist".equalsIgnoreCase(role) ||
               "ClinicManager".equalsIgnoreCase(role) ||
               "Admin".equalsIgnoreCase(role);
    }
    
    private void repopulateForm(HttpServletRequest request, String username, String password,
                               String fullName, String phone, String role, String employeeCode,
                               String department, String salaryStr, String specialization, String licenseNumber) {
        request.setAttribute("username", username);
        request.setAttribute("fullName", fullName);
        request.setAttribute("phone", phone);
        request.setAttribute("role", role);
        request.setAttribute("employeeCode", employeeCode);
        request.setAttribute("department", department);
        request.setAttribute("salaryBase", salaryStr);
        request.setAttribute("specialization", specialization);
        request.setAttribute("licenseNumber", licenseNumber);
    }
}
