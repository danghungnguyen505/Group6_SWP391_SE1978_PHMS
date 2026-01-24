package controller.petOwner;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dal.PetDAO;
import dal.ServiceDAO;
import dal.UserDAO;

/**
 *
 * @author zoxy4
 */
@WebServlet(name="PetOwnerMenuController", urlPatterns={"/petOwner/menuPetOwner"})
public class PetOwnerMenuController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        // Kiểm tra đăng nhập
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect("../login");
            return;
        }
        try {
            PetDAO petDao = new PetDAO();
            ServiceDAO serviceDao = new ServiceDAO();
            UserDAO userDao = new UserDAO();
            request.setAttribute("pets", petDao.getPetsByOwnerId(account.getUserId())); 
            request.setAttribute("services", serviceDao.getAllServices());
            request.setAttribute("vets", userDao.getAllVeterinarians());
        } catch(Exception e) {
            System.out.println("Chưa kết nối DB hoặc lỗi truy vấn: " + e);
        }
        request.getRequestDispatcher("/views/petOwner/menuPetOwner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
    }

}
