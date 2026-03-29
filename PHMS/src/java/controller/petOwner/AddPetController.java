package controller.petOwner;

import dal.PetDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import model.User;

@WebServlet(name = "AddPetController", urlPatterns = {"/pet/add"})
public class AddPetController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");

        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String name = request.getParameter("name");
        String species = request.getParameter("species");
        String breed = request.getParameter("breed");
        String gender = request.getParameter("gender");
        String weightStr = request.getParameter("weight");
        String dobStr = request.getParameter("birthDate");
        String history = request.getParameter("history");

        double weight = 0;
        Date birthDate = null;
        String error = "";

        if (name == null || name.trim().isEmpty() || name.length() > 100) {
            error = "Tên thú cưng không hợp lệ (1-100 ký tự)!";
        } else if (species == null || species.trim().isEmpty() || species.length() > 50) {
            error = "Chủng loại không hợp lệ (1-50 ký tự)!";
        } else if (breed == null || breed.trim().isEmpty() || breed.length() > 100) {
            error = "Giống loài không hợp lệ (1-100 ký tự)!";
        } else if (gender == null || gender.trim().isEmpty()) {
            error = "Vui lòng chọn giới tính!";
        } else if (history != null && history.length() > 2000) {
            error = "Tiền sử bệnh quá dài (tối đa 2000 ký tự)!";
        } else {
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

            if (error.isEmpty()) {
                try {
                    if (dobStr == null || dobStr.trim().isEmpty()) {
                        error = "Vui lòng chọn ngày sinh!";
                    } else {
                        birthDate = Date.valueOf(dobStr);
                        if (birthDate.after(new java.util.Date())) {
                            error = "Ngày sinh không được lớn hơn ngày hiện tại!";
                        }
                    }
                } catch (IllegalArgumentException e) {
                    error = "Định dạng ngày sinh không hợp lệ!";
                }
            }
        }

        if (!error.isEmpty()) {
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

        try {
            PetDAO petDAO = new PetDAO();
            boolean success = petDAO.addPet(
                    account.getUserId(),
                    name.trim(),
                    species.trim(),
                    history != null ? history.trim() : "",
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
