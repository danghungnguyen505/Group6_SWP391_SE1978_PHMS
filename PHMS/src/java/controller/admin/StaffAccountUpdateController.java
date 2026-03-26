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

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            Object userIdAttr = request.getAttribute("userId");
            if (userIdAttr != null) {
                idStr = String.valueOf(userIdAttr);
            }
        }

        if (!util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Staff ID khong hop le.");
            response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            return;
        }

        int id = Integer.parseInt(idStr);
        StaffAccountDAO staffDAO = new StaffAccountDAO();
        User staff = staffDAO.getStaffAccountById(id);

        if (staff == null) {
            session.setAttribute("toastMessage", "error|Khong tim thay tai khoan nhan vien.");
            response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            return;
        }

        if (staff.getAddress() != null && staff.getAddress().contains("|")) {
            String[] parts = staff.getAddress().split("\\|");
            if (parts.length >= 3) {
                request.setAttribute("employeeCode", parts[0]);
                request.setAttribute("department", parts[1]);
                request.setAttribute("salaryBase", parts[2]);
            }
        }

        request.setAttribute("staff", staff);
        request.setAttribute("vetType", staff.getVetType() != null ? staff.getVetType() : "Normal");
        request.setAttribute("specialization", staff.getSpecialization());
        request.setAttribute("licenseNumber", staff.getLicenseNumber());
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
        String vetType = util.ValidationUtils.sanitize(request.getParameter("vetType"));

        if (!util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Staff ID khong hop le.");
            response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            return;
        }

        int userId = Integer.parseInt(idStr);

        if (!util.ValidationUtils.isNotEmpty(fullName) || !util.ValidationUtils.isLengthValid(fullName, 2, 100)) {
            request.setAttribute("error", "Ho ten phai co tu 2 den 100 ky tu!");
            request.setAttribute("userId", idStr);
            doGet(request, response);
            return;
        }

        if (!util.ValidationUtils.isNotEmpty(phone) || !util.ValidationUtils.isValidPhone(phone)) {
            request.setAttribute("error", "So dien thoai khong hop le!");
            request.setAttribute("userId", idStr);
            doGet(request, response);
            return;
        }

        dal.UserDAO userDAO = new dal.UserDAO();
        if (userDAO.checkPhoneExistsForOther(userId, phone)) {
            request.setAttribute("error", "So dien thoai nay da duoc su dung!");
            request.setAttribute("userId", idStr);
            doGet(request, response);
            return;
        }

        if (!isValidStaffRole(role)) {
            request.setAttribute("error", "Vai tro khong hop le!");
            request.setAttribute("userId", idStr);
            doGet(request, response);
            return;
        }

        if ("Veterinarian".equalsIgnoreCase(role)) {
            if (!"Normal".equalsIgnoreCase(vetType) && !"Emergency".equalsIgnoreCase(vetType)) {
                request.setAttribute("error", "Loai bac si khong hop le!");
                request.setAttribute("userId", idStr);
                doGet(request, response);
                return;
            }
        } else {
            vetType = "Normal";
        }

        Double salaryBase = null;
        if (util.ValidationUtils.isNotEmpty(salaryStr)) {
            if (!util.ValidationUtils.isPositiveNumber(salaryStr)) {
                request.setAttribute("error", "Luong co ban phai la so duong!");
                request.setAttribute("userId", idStr);
                doGet(request, response);
                return;
            }
            salaryBase = Double.parseDouble(salaryStr);
        }

        StaffAccountDAO staffDAO = new StaffAccountDAO();

        if (userId == account.getUserId()) {
            User currentStaff = staffDAO.getStaffAccountById(userId);
            if (currentStaff != null && currentStaff.getRole() != null) {
                role = currentStaff.getRole();
            }
        }

        try {
            boolean ok = staffDAO.updateStaffAccount(userId, fullName, phone, role,
                    employeeCode, department, salaryBase, specialization, licenseNumber, vetType);
            if (ok) {
                session.setAttribute("toastMessage", "success|Cap nhat tai khoan nhan vien thanh cong!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            } else {
                request.setAttribute("error", "Khong the cap nhat tai khoan. Vui long thu lai.");
                request.setAttribute("userId", idStr);
                doGet(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Loi he thong: " + e.getMessage());
            request.setAttribute("userId", idStr);
            doGet(request, response);
        }
    }

    private boolean isValidStaffRole(String role) {
        return "Veterinarian".equalsIgnoreCase(role)
                || "Nurse".equalsIgnoreCase(role)
                || "Receptionist".equalsIgnoreCase(role)
                || "ClinicManager".equalsIgnoreCase(role)
                || "Admin".equalsIgnoreCase(role);
    }
}
