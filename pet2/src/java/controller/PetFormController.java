package controller;

import dao.PetDAO;
import model.Pet;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class PetFormController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.isEmpty()) {
            PetDAO dao = new PetDAO();
            Pet p = dao.getPetById(Integer.parseInt(idStr));
            request.setAttribute("pet", p);
        }
        request.getRequestDispatcher("pet-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        
        String idStr = request.getParameter("id"); // ID ẩn trong form
        String name = request.getParameter("name");
        String species = request.getParameter("species");
        String summary = request.getParameter("summary");
        
        PetDAO dao = new PetDAO();
        Pet p = new Pet();
        p.setName(name);
        p.setSpecies(species);
        p.setHistorySummary(summary);
        
        if (idStr == null || idStr.isEmpty()) {
            dao.addPet(p, 1);
        } else {
            p.setPetId(Integer.parseInt(idStr));
            dao.updatePet(p);
        }
        
        response.sendRedirect("pets");
    }
}