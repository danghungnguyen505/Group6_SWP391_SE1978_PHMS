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
 * Admin updates staff account.
 * SRP: Update staff account only.
 */
@WebServlet(name = "StaffAccountUpdateController", urlPatterns = {"/admin/staff/update"})
public class StaffAccountUpdateController extends HttpServlet {
    
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
<<<<<<< Updated upstream
        
        String idStr = request.getParameter("id");
=======

        // Lấy ID từ query param (truy cập từ danh sách) hoặc từ attribute (trường hợp doPost gọi lại doGet khi có lỗi)
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            Object userIdAttr = request.getAttribute("userId");
            if (userIdAttr != null) {
                idStr = String.valueOf(userIdAttr);
            }
        }

>>>>>>> Stashed changes
        if (!util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Staff ID không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            return;
        }
        
        int id = Integer.parseInt(idStr);
        StaffAccountDAO staffDAO = new StaffAccountDAO();
        User staff = staffDAO.getStaffAccountById(id);
        
        if (staff == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy tài khoản nhân viên.");
            response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            return;
        }
        
        // Parse employee info from address field
        if (staff.getAddress() != null && staff.getAddress().contains("|")) {
            String[] parts = staff.getAddress().split("\\|");
            if (parts.length >= 3) {
                request.setAttribute("employeeCode", parts[0]);
                request.setAttribute("department", parts[1]);
                request.setAttribute("salaryBase", parts[2]);
            }
        }
        
        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/views/admin/staffUpdate.jsp").forward(request, response);
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
        
        String idStr = request.getParameter("userId");
        String fullName = util.ValidationUtils.sanitize(request.getParameter("fullName"));
        String phone = util.ValidationUtils.sanitize(request.getParameter("phone"));
        String role = util.ValidationUtils.sanitize(request.getParameter("role"));
        String employeeCode = util.ValidationUtils.sanitize(request.getParameter("employeeCode"));
        String department = util.ValidationUtils.sanitize(request.getParameter("department"));
        String salaryStr = request.getParameter("salaryBase");
        String specialization = util.ValidationUtils.sanitize(request.getParameter("specialization"));
        String licenseNumber = util.ValidationUtils.sanitize(request.getParameter("licenseNumber"));
        
        if (!util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Staff ID không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            return;
        }
        
        int userId = Integer.parseInt(idStr);
        
        // Validation (similar to create)
        if (!util.ValidationUtils.isNotEmpty(fullName) || !util.ValidationUtils.isLengthValid(fullName, 2, 100)) {
            request.setAttribute("error", "Họ tên phải có từ 2 đến 100 ký tự!");
            request.setAttribute("userId", idStr);
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(phone) || !util.ValidationUtils.isValidPhone(phone)) {
            request.setAttribute("error", "Số điện thoại không hợp lệ!");
            request.setAttribute("userId", idStr);
            doGet(request, response);
            return;
        }
        
<<<<<<< Updated upstream
=======
        // Phone must be unique across users (excluding current staff)
        dal.UserDAO userDAO = new dal.UserDAO();
        if (userDAO.checkPhoneExistsForOther(userId, phone)) {
            request.setAttribute("error", "Số điện thoại này đã được sử dụng!");
            request.setAttribute("userId", idStr);
            doGet(request, response);
            return;
        }
        
>>>>>>> Stashed changes
        if (!isValidStaffRole(role)) {
            request.setAttribute("error", "Vai trò không hợp lệ!");
            request.setAttribute("userId", idStr);
            doGet(request, response);
            return;
        }
        
        Double salaryBase = null;
        if (util.ValidationUtils.isNotEmpty(salaryStr)) {
            if (!util.ValidationUtils.isPositiveNumber(salaryStr)) {
                request.setAttribute("error", "Lương cơ bản phải là số dương!");
                request.setAttribute("userId", idStr);
                doGet(request, response);
                return;
            }
            salaryBase = Double.parseDouble(salaryStr);
        }
        
        StaffAccountDAO staffDAO = new StaffAccountDAO();
<<<<<<< Updated upstream
=======

        // Không cho phép thay đổi role của chính tài khoản đang đăng nhập (dù có chỉnh sửa HTML ở phía client)
        if (userId == account.getUserId()) {
            User currentStaff = staffDAO.getStaffAccountById(userId);
            if (currentStaff != null && currentStaff.getRole() != null) {
                role = currentStaff.getRole();
            }
        }
>>>>>>> Stashed changes
        try {
            boolean ok = staffDAO.updateStaffAccount(userId, fullName, phone, role,
                    employeeCode, department, salaryBase, specialization, licenseNumber);
            if (ok) {
                session.setAttribute("toastMessage", "success|Cập nhật tài khoản nhân viên thành công!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            } else {
                request.setAttribute("error", "Không thể cập nhật tài khoản. Vui lòng thử lại.");
                request.setAttribute("userId", idStr);
                doGet(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("userId", idStr);
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
}
