package controller;

import dal.PetDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Pet;
import model.User;

@WebServlet(name = "PetController", urlPatterns = {"/my-pets"})
public class PetController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !account.getRole().equalsIgnoreCase("Owner")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PetDAO petDAO = new PetDAO();
        System.out.println("PetController - User ID: " + account.getId() + ", Role: " + account.getRole());
        List<model.Pet> pets = petDAO.getPetsByOwnerId(account.getId());
        System.out.println("PetController - Number of pets retrieved: " + pets.size());
        request.setAttribute("pets", pets);

        request.getRequestDispatcher("/views/myPets.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        if (account == null || !account.getRole().equalsIgnoreCase("Owner")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        PetDAO petDAO = new PetDAO();

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String species = request.getParameter("species");
            String historySummary = request.getParameter("historySummary");

            if (name == null || name.trim().isEmpty() || species == null || species.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin (Tên và Loài là bắt buộc)!");
            } else {
                try {
                    int petId = petDAO.createPet(account.getId(), name.trim(), species.trim(), 
                            historySummary != null ? historySummary.trim() : "");
                    if (petId > 0) {
                        request.setAttribute("success", "Thêm thú cưng thành công! ID: " + petId);
                    } else {
                        request.setAttribute("error", "Thêm thú cưng thất bại! Vui lòng kiểm tra console log để xem chi tiết lỗi.");
                    }
                } catch (Exception e) {
                    System.out.println("Exception in PetController.add: " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                }
            }
        } else if ("update".equals(action)) {
            int petId = Integer.parseInt(request.getParameter("petId"));
            String name = request.getParameter("name");
            String species = request.getParameter("species");
            String historySummary = request.getParameter("historySummary");

            if (name == null || name.trim().isEmpty() || species == null || species.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            } else {
                boolean success = petDAO.updatePet(petId, name.trim(), species.trim(), 
                        historySummary != null ? historySummary.trim() : "");
                if (success) {
                    request.setAttribute("success", "Cập nhật thông tin thú cưng thành công!");
                } else {
                    request.setAttribute("error", "Cập nhật thất bại!");
                }
            }
        } else if ("delete".equals(action)) {
            int petId = Integer.parseInt(request.getParameter("petId"));
            boolean success = petDAO.deletePet(petId, account.getId());
            if (success) {
                request.setAttribute("success", "Xóa thú cưng thành công!");
            } else {
                request.setAttribute("error", "Xóa thất bại!");
            }
        }

        doGet(request, response);
    }
}
