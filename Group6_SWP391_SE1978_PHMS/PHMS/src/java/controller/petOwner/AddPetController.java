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
