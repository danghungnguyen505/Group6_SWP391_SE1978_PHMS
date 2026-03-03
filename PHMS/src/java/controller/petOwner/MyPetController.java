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
import model.Pet;
import util.PaginationUtils;

/**
 * Controller for displaying pet list with pagination
 * Single Responsibility: Handle pet list display only
 */
@WebServlet(name="MyPetController", urlPatterns={"/myPetOwner"})
public class MyPetController extends HttpServlet {
    
    private static final int PAGE_SIZE = 10; // Number of pets per page
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");

        // Check Login and Authorization
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get pagination parameters
            String pageStr = request.getParameter("page");
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Get all pets for this owner
            PetDAO petDAO = new PetDAO();
            List<Pet> allPets = petDAO.getPetsByOwnerId(account.getUserId());

            // Determine selected pet (for left panel display)
            Pet selectedPet = null;
            String selectedPetIdStr = request.getParameter("selectedPetId");
            if (selectedPetIdStr != null && !selectedPetIdStr.trim().isEmpty()) {
                try {
                    int selectedPetId = Integer.parseInt(selectedPetIdStr);
                    for (Pet p : allPets) {
                        if (p.getId() == selectedPetId) {
                            selectedPet = p;
                            break;
                        }
                    }
                } catch (NumberFormatException ignored) {
                    // ignore invalid id
                }
            }
            if (selectedPet == null && allPets != null && !allPets.isEmpty()) {
                selectedPet = allPets.get(0);
            }
            
            // Calculate pagination
            int totalPages = PaginationUtils.getTotalPages(allPets, PAGE_SIZE);
            currentPage = PaginationUtils.getValidPage(currentPage, totalPages);
            
            // Get page of pets
            List<Pet> pets = PaginationUtils.getPage(allPets, currentPage, PAGE_SIZE);
            
            // Set attributes for JSP
            request.setAttribute("pets", pets);
            request.setAttribute("allPets", allPets); // for dropdown
            request.setAttribute("selectedPet", selectedPet);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalPets", allPets.size());
            request.setAttribute("pageSize", PAGE_SIZE);
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tải danh sách thú cưng: " + e.getMessage());
            e.printStackTrace();
        }

        // Forward to JSP
        request.getRequestDispatcher("/views/petOwner/myPetOwner.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST not used for this controller
        doGet(request, response);
    }
}
