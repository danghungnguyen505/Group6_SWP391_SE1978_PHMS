package controller.petOwner;

import dal.PetDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Pet;
import model.User;

/**
 * Controller for updating pet information
 * Single Responsibility: Handle pet update only
 */
@WebServlet(name = "UpdatePetController", urlPatterns = {"/pet/update"})
public class UpdatePetController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String petIdStr = request.getParameter("id");
        if (petIdStr == null || petIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/myPetOwner");
            return;
        }
        
        try {
            int petId = Integer.parseInt(petIdStr);
            PetDAO petDAO = new PetDAO();
            Pet pet = petDAO.getPetById(petId);
            
            if (pet == null || pet.getOwnerId() != account.getUserId()) {
                session.setAttribute("toastMessage", "error|Không tìm thấy thú cưng hoặc bạn không có quyền chỉnh sửa!");
                response.sendRedirect(request.getContextPath() + "/myPetOwner");
                return;
            }
            
            request.setAttribute("pet", pet);
            request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "error|ID thú cưng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/myPetOwner");
        }
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
        
        String petIdStr = request.getParameter("petId");
        if (petIdStr == null || petIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/myPetOwner");
            return;
        }
        
        try {
            int petId = Integer.parseInt(petIdStr);
            PetDAO petDAO = new PetDAO();
            Pet pet = petDAO.getPetById(petId);
            
            if (pet == null || pet.getOwnerId() != account.getUserId()) {
                session.setAttribute("toastMessage", "error|Không tìm thấy thú cưng hoặc bạn không có quyền chỉnh sửa!");
                response.sendRedirect(request.getContextPath() + "/myPetOwner");
                return;
            }
            
            // Get and sanitize input
            String name = util.ValidationUtils.sanitize(request.getParameter("name"));
            String species = util.ValidationUtils.sanitize(request.getParameter("species"));
            String history = util.ValidationUtils.sanitize(request.getParameter("history"));
            String breed = util.ValidationUtils.sanitize(request.getParameter("breed"));
            String gender = util.ValidationUtils.sanitize(request.getParameter("gender"));
            String weightStr = request.getParameter("weight");
            String dobStr = request.getParameter("birthDate");
            
            double weight = 0;
            java.sql.Date birthDate = null;
            String error = "";
            
            // Validate input
            if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
                error = "Tên thú cưng phải có từ 1 đến 100 ký tự!";
            } else if (!util.ValidationUtils.isNotEmpty(species) || !util.ValidationUtils.isLengthValid(species, 1, 50)) {
                error = "Loài thú cưng phải có từ 1 đến 50 ký tự!";
            } else if (!util.ValidationUtils.isNotEmpty(breed) || !util.ValidationUtils.isLengthValid(breed, 1, 100)) {
                error = "Giống loài phải có từ 1 đến 100 ký tự!";
            } else if (!util.ValidationUtils.isNotEmpty(gender)) {
                error = "Vui lòng chọn giới tính!";
            } else if (history != null && history.length() > 2000) {
                error = "Lịch sử bệnh án không được vượt quá 2000 ký tự!";
            } else {
                try {
                    if (!util.ValidationUtils.isNotEmpty(weightStr)) {
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
                        if (!util.ValidationUtils.isNotEmpty(dobStr)) {
                            error = "Vui lòng chọn ngày sinh!";
                        } else {
                            birthDate = java.sql.Date.valueOf(dobStr);
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
                request.setAttribute("rawWeight", weightStr);
                request.setAttribute("rawDob", dobStr);
                pet.setName(name);
                pet.setSpecies(species);
                pet.setBreed(breed);
                pet.setGender(gender);
                pet.setHistorySummary(history);
                request.setAttribute("pet", pet);
                request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
                return;
            }
            
            // Update pet object
            pet.setName(name);
            pet.setSpecies(species);
            pet.setHistorySummary(history != null ? history : "");
            pet.setBreed(breed);
            pet.setGender(gender);
            pet.setWeight(weight);
            pet.setBirthDate(birthDate);
            
            boolean success = petDAO.updatePet(pet);
            
            if (success) {
                session.setAttribute("toastMessage", "success|Cập nhật thông tin thú cưng thành công!");
                response.sendRedirect(request.getContextPath() + "/myPetOwner");
            } else {
                request.setAttribute("error", "Lỗi hệ thống: Không thể cập nhật thông tin. Vui lòng thử lại!");
                request.setAttribute("pet", pet);
                request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "error|ID thú cưng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/myPetOwner");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
        }
    }
}
