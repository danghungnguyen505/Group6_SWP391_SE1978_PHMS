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
            
            // Validate input
            if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
                request.setAttribute("error", "Tên thú cưng phải có từ 1 đến 100 ký tự!");
                request.setAttribute("pet", pet);
                request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
                return;
            }
            
            if (!util.ValidationUtils.isNotEmpty(species) || !util.ValidationUtils.isLengthValid(species, 1, 50)) {
                request.setAttribute("error", "Loài thú cưng phải có từ 1 đến 50 ký tự!");
                request.setAttribute("pet", pet);
                request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
                return;
            }
            
            if (history != null && history.length() > 2000) {
                request.setAttribute("error", "Lịch sử bệnh án không được vượt quá 2000 ký tự!");
                request.setAttribute("pet", pet);
                request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
                return;
            }
            
            // Update pet object
            pet.setName(name);
            pet.setSpecies(species);
            pet.setHistorySummary(history != null ? history : "");
            
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
=======
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
            
            // Validate input
            if (!util.ValidationUtils.isNotEmpty(name) || !util.ValidationUtils.isLengthValid(name, 1, 100)) {
                request.setAttribute("error", "Tên thú cưng phải có từ 1 đến 100 ký tự!");
                request.setAttribute("pet", pet);
                request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
                return;
            }
            
            if (!util.ValidationUtils.isNotEmpty(species) || !util.ValidationUtils.isLengthValid(species, 1, 50)) {
                request.setAttribute("error", "Loài thú cưng phải có từ 1 đến 50 ký tự!");
                request.setAttribute("pet", pet);
                request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
                return;
            }
            
            if (history != null && history.length() > 2000) {
                request.setAttribute("error", "Lịch sử bệnh án không được vượt quá 2000 ký tự!");
                request.setAttribute("pet", pet);
                request.getRequestDispatcher("/views/petOwner/updatePet.jsp").forward(request, response);
                return;
            }
            
            // Update pet object
            pet.setName(name);
            pet.setSpecies(species);
            pet.setHistorySummary(history != null ? history : "");
            
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
>>>>>>> Stashed changes
