package controller;

import dao.PetDAO;
import model.Pet;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class PetListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int currentOwnerId = 1; 
        PetDAO dao = new PetDAO();
        List<Pet> pets;

        String keyword = request.getParameter("search");

        if (keyword != null && !keyword.trim().isEmpty()) {
            pets = dao.searchPets(currentOwnerId, keyword.trim());
        } else {
            pets = dao.getPetsByOwner(currentOwnerId);
        }

        request.setAttribute("petList", pets);
        request.setAttribute("searchKeyword", keyword);
        request.getRequestDispatcher("pet-list.jsp").forward(request, response);
    }
}
