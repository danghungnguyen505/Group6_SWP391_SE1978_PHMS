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
 * Admin adds new medicine.
 * SRP: Create medicine only.
 */
@WebServlet(name = "MedicineAddController", urlPatterns = {"/admin/medicine/add"})
public class MedicineAddController extends HttpServlet {
    
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
        
        request.getRequestDispatcher("/views/admin/medicineAdd.jsp").forward(request, response);
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
        
        String name = util.ValidationUtils.sanitize(request.getParameter("name"));
        String unit = util.ValidationUtils.sanitize(request.getParameter("unit"));
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stockQuantity");
        
        // Validation
        if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
            request.setAttribute("error", "Tên thuốc phải có từ 1 đến 100 ký tự!");
            request.setAttribute("name", name);
            request.setAttribute("unit", unit);
            request.setAttribute("price", priceStr);
            request.setAttribute("stockQuantity", stockStr);
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(unit) || !util.ValidationUtils.isLengthValid(unit, 1, 20)) {
            request.setAttribute("error", "Đơn vị phải có từ 1 đến 20 ký tự!");
            request.setAttribute("name", name);
            request.setAttribute("unit", unit);
            request.setAttribute("price", priceStr);
            request.setAttribute("stockQuantity", stockStr);
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isPositiveNumber(priceStr)) {
            request.setAttribute("error", "Giá thuốc phải là số dương!");
            request.setAttribute("name", name);
            request.setAttribute("unit", unit);
            request.setAttribute("price", priceStr);
            request.setAttribute("stockQuantity", stockStr);
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isIntegerInRange(stockStr, 0, Integer.MAX_VALUE)) {
            request.setAttribute("error", "Số lượng tồn kho không hợp lệ!");
            request.setAttribute("name", name);
            request.setAttribute("unit", unit);
            request.setAttribute("price", priceStr);
            request.setAttribute("stockQuantity", stockStr);
            doGet(request, response);
            return;
        }
        
        double price = Double.parseDouble(priceStr);
        int stock = Integer.parseInt(stockStr);
        
        MedicineDAO medicineDAO = new MedicineDAO();
        // Business validation: medicine name must be unique
        if (medicineDAO.existsByName(name)) {
            request.setAttribute("error", "Tên thuốc đã tồn tại trong kho! Vui lòng chọn tên khác.");
            request.setAttribute("name", name);
            request.setAttribute("unit", unit);
            request.setAttribute("price", priceStr);
            request.setAttribute("stockQuantity", stockStr);
            doGet(request, response);
            return;
        }
        
        boolean ok = medicineDAO.addMedicine(new Medicine(0, name, unit, price, stock));
        
        if (ok) {
            session.setAttribute("toastMessage", "success|Thêm thuốc thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/medicine/list");
        } else {
            request.setAttribute("error", "Không thể thêm thuốc. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
