package controller.admin;

import dal.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Medicine;
import model.User;

/**
 * Admin updates medicine.
 * SRP: Update medicine only.
 */
@WebServlet(name = "MedicineUpdateController", urlPatterns = {"/admin/medicine/update"})
public class MedicineUpdateController extends HttpServlet {
    
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
        if (!util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Medicine ID không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/medicine/list");
            return;
        }
        
        int id = Integer.parseInt(idStr);
        MedicineDAO medicineDAO = new MedicineDAO();
        Medicine medicine = medicineDAO.getById(id);
        
        if (medicine == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy thuốc.");
            response.sendRedirect(request.getContextPath() + "/admin/medicine/list");
            return;
        }
        
        request.setAttribute("medicine", medicine);
        request.getRequestDispatcher("/views/admin/medicineUpdate.jsp").forward(request, response);
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
        
        String idStr = request.getParameter("medicineId");
        String name = util.ValidationUtils.sanitize(request.getParameter("name"));
        String unit = util.ValidationUtils.sanitize(request.getParameter("unit"));
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stockQuantity");
        
        if (!util.ValidationUtils.isIntegerInRange(idStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Medicine ID không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/admin/medicine/list");
            return;
        }
        
        int id = Integer.parseInt(idStr);
        MedicineDAO medicineDAO = new MedicineDAO();
        Medicine medicine = medicineDAO.getById(id);
        
        if (medicine == null) {
            session.setAttribute("toastMessage", "error|Không tìm thấy thuốc.");
            response.sendRedirect(request.getContextPath() + "/admin/medicine/list");
            return;
        }
        
        // Validation (same as add)
        if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
            request.setAttribute("error", "Tên thuốc phải có từ 1 đến 100 ký tự!");
            request.setAttribute("medicine", medicine);
            request.getRequestDispatcher("/views/admin/medicineUpdate.jsp").forward(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(unit) || !util.ValidationUtils.isLengthValid(unit, 1, 20)) {
            request.setAttribute("error", "Đơn vị phải có từ 1 đến 20 ký tự!");
            request.setAttribute("medicine", medicine);
            request.getRequestDispatcher("/views/admin/medicineUpdate.jsp").forward(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isPositiveNumber(priceStr)) {
            request.setAttribute("error", "Giá thuốc phải là số dương!");
            request.setAttribute("medicine", medicine);
            request.getRequestDispatcher("/views/admin/medicineUpdate.jsp").forward(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isIntegerInRange(stockStr, 0, Integer.MAX_VALUE)) {
            request.setAttribute("error", "Số lượng tồn kho không hợp lệ!");
            request.setAttribute("medicine", medicine);
            request.getRequestDispatcher("/views/admin/medicineUpdate.jsp").forward(request, response);
            return;
        }
        
        double price = Double.parseDouble(priceStr);
        int stock = Integer.parseInt(stockStr);
        
        // Business validation: ensure name is unique for other medicines
        if (medicineDAO.existsByNameForOther(id, name)) {
            request.setAttribute("error", "Tên thuốc đã được sử dụng cho thuốc khác!");
            request.setAttribute("medicine", medicine);
            request.getRequestDispatcher("/views/admin/medicineUpdate.jsp").forward(request, response);
            return;
        }
        
        boolean ok = medicineDAO.updateMedicine(new Medicine(id, name, unit, price, stock));
        
        if (ok) {
            session.setAttribute("toastMessage", "success|Cập nhật thuốc thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/medicine/list");
        } else {
            request.setAttribute("error", "Không thể cập nhật thuốc. Vui lòng thử lại.");
            request.setAttribute("medicine", medicine);
            request.getRequestDispatcher("/views/admin/medicineUpdate.jsp").forward(request, response);
        }
    }
}
