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
 * Controller for deleting a pet
 * Single Responsibility: Handle pet deletion only
 */
@WebServlet(name = "DeletePetController", urlPatterns = {"/pet/delete"})
public class DeletePetController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String petIdStr = request.getParameter("id");
        if (petIdStr == null || petIdStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "error|ID thú cưng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/myPetOwner");
            return;
        }
        
        try {
            int petId = Integer.parseInt(petIdStr);
            PetDAO petDAO = new PetDAO();
            
            // Verify pet belongs to current user
            model.Pet pet = petDAO.getPetById(petId);
            if (pet == null || pet.getOwnerId() != account.getUserId()) {
                session.setAttribute("toastMessage", "error|Không tìm thấy thú cưng hoặc bạn không có quyền xóa!");
                response.sendRedirect(request.getContextPath() + "/myPetOwner");
                return;
            }
            
            // Check if pet has appointments (optional business rule)
            // You might want to prevent deletion if pet has active appointments
            
            boolean success = petDAO.deletePet(petId);
            
            if (success) {
                session.setAttribute("toastMessage", "success|Xóa thú cưng thành công!");
            } else {
                session.setAttribute("toastMessage", "error|Lỗi hệ thống: Không thể xóa thú cưng. Vui lòng thử lại!");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "error|ID thú cưng không hợp lệ!");
        } catch (Exception e) {
            session.setAttribute("toastMessage", "error|Lỗi: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/myPetOwner");
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
import model.User;

/**
 * Controller for deleting a pet
 * Single Responsibility: Handle pet deletion only
 */
@WebServlet(name = "DeletePetController", urlPatterns = {"/pet/delete"})
public class DeletePetController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String petIdStr = request.getParameter("id");
        if (petIdStr == null || petIdStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "error|ID thú cưng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/myPetOwner");
            return;
        }
        
        try {
            int petId = Integer.parseInt(petIdStr);
            PetDAO petDAO = new PetDAO();
            
            // Verify pet belongs to current user
            model.Pet pet = petDAO.getPetById(petId);
            if (pet == null || pet.getOwnerId() != account.getUserId()) {
                session.setAttribute("toastMessage", "error|Không tìm thấy thú cưng hoặc bạn không có quyền xóa!");
                response.sendRedirect(request.getContextPath() + "/myPetOwner");
                return;
            }
            
            // Check if pet has appointments (optional business rule)
            // You might want to prevent deletion if pet has active appointments
            
            boolean success = petDAO.deletePet(petId);
            
            if (success) {
                session.setAttribute("toastMessage", "success|Xóa thú cưng thành công!");
            } else {
                session.setAttribute("toastMessage", "error|Lỗi hệ thống: Không thể xóa thú cưng. Vui lòng thử lại!");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "error|ID thú cưng không hợp lệ!");
        } catch (Exception e) {
            session.setAttribute("toastMessage", "error|Lỗi: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/myPetOwner");
    }
}
>>>>>>> Stashed changes
