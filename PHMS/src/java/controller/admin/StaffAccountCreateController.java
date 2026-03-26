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
        String vetType = util.ValidationUtils.sanitize(request.getParameter("vetType"));

        if (!util.ValidationUtils.isNotEmpty(username) || !util.ValidationUtils.isValidUsername(username)) {
            request.setAttribute("error", "Ten dang nhap khong hop le!");
            repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
            doGet(request, response);
            return;
        }

        dal.UserDAO userDAO = new dal.UserDAO();
        if (userDAO.checkUsernameExists(username)) {
            request.setAttribute("error", "Ten dang nhap da ton tai!");
            repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
            doGet(request, response);
            return;
        }

        if (!util.ValidationUtils.isNotEmpty(password) || !util.ValidationUtils.isValidPassword(password)) {
            request.setAttribute("error", "Mat khau phai co it nhat 6 ky tu!");
            repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
            doGet(request, response);
            return;
        }

        if (!util.ValidationUtils.isNotEmpty(fullName) || !util.ValidationUtils.isLengthValid(fullName, 2, 100)) {
            request.setAttribute("error", "Ho ten phai co tu 2 den 100 ky tu!");
            repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
            doGet(request, response);
            return;
        }

        if (!util.ValidationUtils.isNotEmpty(phone) || !util.ValidationUtils.isValidPhone(phone)) {
            request.setAttribute("error", "So dien thoai khong hop le!");
            repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
            doGet(request, response);
            return;
        }

        if (userDAO.checkPhoneExists(phone)) {
            request.setAttribute("error", "So dien thoai nay da duoc su dung!");
            repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
            doGet(request, response);
            return;
        }

        if (!isValidStaffRole(role)) {
            request.setAttribute("error", "Vai tro khong hop le!");
            repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
            doGet(request, response);
            return;
        }

        if (!util.ValidationUtils.isNotEmpty(employeeCode) || !util.ValidationUtils.isLengthValid(employeeCode, 1, 20)) {
            request.setAttribute("error", "Ma nhan vien phai co tu 1 den 20 ky tu!");
            repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
            doGet(request, response);
            return;
        }

        if ("Veterinarian".equalsIgnoreCase(role)) {
            if (!"Normal".equalsIgnoreCase(vetType) && !"Emergency".equalsIgnoreCase(vetType)) {
                request.setAttribute("error", "Loai bac si khong hop le!");
                repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
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
                repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
                doGet(request, response);
                return;
            }
            salaryBase = Double.parseDouble(salaryStr);
        }

        StaffAccountDAO staffDAO = new StaffAccountDAO();
        try {
            boolean ok = staffDAO.createStaffAccount(username, password, fullName, phone, role,
                    employeeCode, department, salaryBase, specialization, licenseNumber, vetType);
            if (ok) {
                session.setAttribute("toastMessage", "success|Tao tai khoan nhan vien thanh cong!");
                response.sendRedirect(request.getContextPath() + "/admin/staff/list");
            } else {
                request.setAttribute("error", "Khong the tao tai khoan. Vui long thu lai.");
                repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
                doGet(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Loi he thong: " + e.getMessage());
            repopulateForm(request, username, fullName, phone, role, employeeCode, department, salaryStr, specialization, licenseNumber, vetType);
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

    private void repopulateForm(HttpServletRequest request, String username,
            String fullName, String phone, String role, String employeeCode,
            String department, String salaryStr, String specialization,
            String licenseNumber, String vetType) {
        request.setAttribute("username", username);
        request.setAttribute("fullName", fullName);
        request.setAttribute("phone", phone);
        request.setAttribute("role", role);
        request.setAttribute("employeeCode", employeeCode);
        request.setAttribute("department", department);
        request.setAttribute("salaryBase", salaryStr);
        request.setAttribute("specialization", specialization);
        request.setAttribute("licenseNumber", licenseNumber);
        request.setAttribute("vetType", vetType);
    }
}
