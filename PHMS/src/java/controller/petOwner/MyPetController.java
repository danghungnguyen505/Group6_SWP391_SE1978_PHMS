/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.petOwner;

import dal.PetDAO; 
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.User;
// import model.Pet;
/**
 *
 * @author zoxy4
 */
@WebServlet(name="MyPetController", urlPatterns={"/myPetOwner"})
public class MyPetController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");

        // 1. Check Login
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        // 2. Lấy dữ liệu thú cưng của User này (để hiển thị lên dropdown hoặc card)
        // PetDAO petDao = new PetDAO();
        // List<Pet> pets = petDao.getPetsByOwnerId(account.getUserId());
        // request.setAttribute("pets", pets);

        // 3. Lấy dữ liệu lịch sử khám (giống như trong ảnh mẫu)
        // ... Logic lấy Medical History ...

        // 4. Forward sang trang JSP
        request.getRequestDispatcher("/views/petOwner/myPetOwner.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
    }

}
