<<<<<<< Updated upstream
package controller.petOwner;

import dal.PetDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Controller for adding a new pet
 * Single Responsibility: Handle pet creation only
 */
@WebServlet(name = "AddPetController", urlPatterns = {"/pet/add"})
public class AddPetController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get and sanitize input
        String name = util.ValidationUtils.sanitize(request.getParameter("name"));
        String species = util.ValidationUtils.sanitize(request.getParameter("species"));
        String history = util.ValidationUtils.sanitize(request.getParameter("history"));
        
        // Validate input
        if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
            request.setAttribute("error", "Tên thú cưng phải có từ 1 đến 100 ký tự!");
            request.setAttribute("name", name);
            request.setAttribute("species", species);
            request.setAttribute("history", history);
            request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(species) || !util.ValidationUtils.isLengthValid(species, 1, 50)) {
            request.setAttribute("error", "Loài thú cưng phải có từ 1 đến 50 ký tự!");
            request.setAttribute("name", name);
            request.setAttribute("species", species);
            request.setAttribute("history", history);
            request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
            return;
        }
        
        if (history != null && history.length() > 2000) {
            request.setAttribute("error", "Lịch sử bệnh án không được vượt quá 2000 ký tự!");
            request.setAttribute("name", name);
            request.setAttribute("species", species);
            request.setAttribute("history", history);
            request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
            return;
        }
        
        try {
            PetDAO petDAO = new PetDAO();
            boolean success = petDAO.addPet(account.getUserId(), name, species, history != null ? history : "");
            
            if (success) {
                session.setAttribute("toastMessage", "success|Thêm thú cưng thành công!");
                response.sendRedirect(request.getContextPath() + "/myPetOwner");
            } else {
                request.setAttribute("error", "Lỗi hệ thống: Không thể thêm thú cưng. Vui lòng thử lại!");
                request.setAttribute("name", name);
                request.setAttribute("species", species);
                request.setAttribute("history", history);
                request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.setAttribute("name", name);
            request.setAttribute("species", species);
            request.setAttribute("history", history);
            request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
        }
    }
}
=======
package controller.petOwner;

import dal.PetDAO;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "AddPetController", urlPatterns = {"/pet/add"})
public class AddPetController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        // Kiểm tra quyền PetOwner
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        // Check Auth
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // 1. Lấy dữ liệu từ form
        // Các tên tham số này PHẢI khớp với name="" bên JSP
        String name = request.getParameter("name");
        String species = request.getParameter("species");
        String breed = request.getParameter("breed");  
        String gender = request.getParameter("gender");  
        String weightStr = request.getParameter("weight");  
        String dobStr = request.getParameter("birthDate"); 
        String history = request.getParameter("history");

        // Biến lưu giá trị sau khi parse
        double weight = 0;
        Date birthDate = null;
        String error = "";

        // 2. Validate dữ liệu
        if (name == null || name.trim().isEmpty() || name.length() > 100) {
            error = "Tên thú cưng không hợp lệ (1-100 ký tự)!";
        } else if (species == null || species.trim().isEmpty() || species.length() > 50) {
            error = "Chủng loại không hợp lệ (1-50 ký tự)!";
        } else if (breed == null || breed.trim().isEmpty() || breed.length() > 100) {
            error = "Giống loài không hợp lệ (1-100 ký tự)!";
        } else if (gender == null || gender.trim().isEmpty()) {
            error = "Vui lòng chọn giới tính!";
        } else if (history != null && history.length() > 2000) {
            error = "Lịch sử bệnh án quá dài (tối đa 2000 ký tự)!";
        } else {
            // Validate số (Weight)
            try {
                if (weightStr == null || weightStr.isEmpty()) {
                    error = "Vui lòng nhập cân nặng!";
                } else {
                    weight = Double.parseDouble(weightStr);
                    if (weight <= 0) {
                        error = "Cân nặng phải lớn hơn 0!";
                    }
                }
            } catch (NumberFormatException e) {
                error = "Cân nặng phải là số hợp lệ!";
            }

            // Validate ngày (Date)
            if (error.isEmpty()) { // Chỉ check tiếp nếu chưa có lỗi
                try {
                    if (dobStr == null || dobStr.trim().isEmpty()) {
                        error = "Vui lòng chọn ngày sinh!";
                    } else {
                        birthDate = Date.valueOf(dobStr); // Format yyyy-MM-dd
                        if (birthDate.after(new java.util.Date())) {
                            error = "Ngày sinh không được lớn hơn ngày hiện tại!";
                        }
                    }
                } catch (IllegalArgumentException e) {
                    error = "Định dạng ngày sinh không hợp lệ!";
                }
            }
        }

        // 3. Xử lý Lỗi hoặc Thành công
        if (!error.isEmpty()) {
            // Có lỗi -> Set lại attribute để hiện lại form
            request.setAttribute("error", error);
            request.setAttribute("name", name);
            request.setAttribute("species", species);
            request.setAttribute("breed", breed);
            request.setAttribute("gender", gender);
            request.setAttribute("weight", weightStr);
            request.setAttribute("birthDate", dobStr);
            request.setAttribute("history", history);
            request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
            return;
        }

        // 4. Gọi DAO để lưu
        try {
            PetDAO petDAO = new PetDAO();
            // Thứ tự tham số phải khớp với hàm addPet trong DAO bạn gửi:
            // (ownerId, name, species, history, breed, weight, birthDate, gender)
            boolean success = petDAO.addPet(
                account.getUserId(), 
                name.trim(), 
                species.trim(), 
                (history != null ? history.trim() : ""), // History ở vị trí thứ 4
                breed.trim(), 
                weight, 
                birthDate, 
                gender
            );
            
            if (success) {
                session.setAttribute("toastMessage", "success|Thêm thú cưng thành công!");
                response.sendRedirect(request.getContextPath() + "/myPetOwner");
            } else {
                request.setAttribute("error", "Lỗi hệ thống: Không thể thêm thú cưng. Vui lòng thử lại!");
                // Set lại attribute để giữ form
                request.setAttribute("name", name);
                request.setAttribute("species", species);
                request.setAttribute("breed", breed);
                request.setAttribute("gender", gender);
                request.setAttribute("weight", weightStr);
                request.setAttribute("birthDate", dobStr);
                request.setAttribute("history", history);
                request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/petOwner/addPet.jsp").forward(request, response);
        }
    }
}
>>>>>>> Stashed changes
