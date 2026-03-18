package controller.petOwner;

import dal.PetDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.User;
import model.Pet;
import util.PaginationUtils;

/**
 * Controller for displaying pet list and details
 */
@WebServlet(name = "MyPetController", urlPatterns = {"/myPetOwner"})
public class MyPetController extends HttpServlet {

    private static final int PAGE_SIZE = 5; // Số lượng thú cưng mỗi trang (để 5 cho dễ nhìn)

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");

        // 1. Check Login & Role
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PetDAO petDAO = new PetDAO();
        String error = null;

        try {
            // 2. Lấy tham số từ URL
            String pageStr = request.getParameter("page");
            String search = request.getParameter("search");
            String selectedPetIdStr = request.getParameter("selectedPetId");

            // 3. Xử lý Search & List (Lấy danh sách tổng)
            List<Pet> allPets;
            if (search != null && !search.trim().isEmpty()) {
                // Nếu có từ khóa tìm kiếm -> Gọi hàm searchPets
                allPets = petDAO.searchPets(account.getUserId(), search.trim());
            } else {
                // Nếu không -> Lấy toàn bộ
                allPets = petDAO.getPetsByOwnerId(account.getUserId());
            }

            if (allPets == null) {
                allPets = new ArrayList<>();
            }

            // 4. Xử lý Phân trang (Pagination)
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int totalPages = PaginationUtils.getTotalPages(allPets, PAGE_SIZE);
            currentPage = PaginationUtils.getValidPage(currentPage, totalPages);
            List<Pet> petsOnPage = PaginationUtils.getPage(allPets, currentPage, PAGE_SIZE);

            // 5. Xử lý Selected Pet (Để hiển thị chi tiết cho chức năng VIEW/EDIT)
            Pet selectedPet = null;

            if (selectedPetIdStr != null && !selectedPetIdStr.trim().isEmpty()) {
                try {
                    int selectedId = Integer.parseInt(selectedPetIdStr);

                    // Cách 1: Tìm trong list hiện có (nhanh, đỡ query lại DB)
                    for (Pet p : allPets) {
                        if (p.getId() == selectedId) {
                            selectedPet = p;
                            break;
                        }
                    }

                    // Cách 2: Nếu không tìm thấy trong list (VD: list đang filter), 
                    // Query trực tiếp DB để đảm bảo hiển thị đúng
                    if (selectedPet == null) {
                        Pet dbPet = petDAO.getPetById(selectedId);
                        // QUAN TRỌNG: Check xem pet này có đúng là của user đang login không?
                        if (dbPet != null && dbPet.getOwnerId() == account.getUserId()) {
                            selectedPet = dbPet;
                        }
                    }
                } catch (NumberFormatException e) {
                    // ID lỗi, bỏ qua
                }
            }

            // Fallback: Nếu chưa chọn con nào, mặc định lấy con đầu tiên trong danh sách (nếu có)
            if (selectedPet == null && !allPets.isEmpty()) {
                selectedPet = allPets.get(0);
            }

            // Fetch Medical Records for selectedPet
            if (selectedPet != null) {
                dal.MedicalRecordDAO mrDAO = new dal.MedicalRecordDAO();
                dal.PrescriptionDAO presDAO = new dal.PrescriptionDAO();
                java.util.List<model.MedicalRecord> medicalRecords = mrDAO.listForOwner(account.getUserId(), selectedPet.getId());
                
                java.util.Map<Integer, java.util.List<model.Prescription>> recordPrescriptions = new java.util.HashMap<>();
                for (model.MedicalRecord mr : medicalRecords) {
                    java.util.List<model.Prescription> pres = presDAO.getByRecordIdForOwner(mr.getRecordId(), account.getUserId());
                    recordPrescriptions.put(mr.getRecordId(), pres);
                }
                
                request.setAttribute("medicalRecords", medicalRecords);
                request.setAttribute("recordPrescriptions", recordPrescriptions);
            }

            // 6. Set attributes để JSP dùng
            request.setAttribute("pets", petsOnPage);       // List hiển thị bên trái (theo trang)
            request.setAttribute("selectedPet", selectedPet); // Object hiển thị chi tiết bên phải (View/Edit)
            request.setAttribute("allPets", petDAO.getPetsByOwnerId(account.getUserId())); // List đầy đủ cho dropdown chuyển đổi thú cưng

            request.setAttribute("search", search);         // Giữ lại từ khóa search trong ô input
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalPets", allPets.size());

            // Dùng Toast message nếu có (từ AddPetController chuyển sang)
            String toastMessage = (String) session.getAttribute("toastMessage");
            if (toastMessage != null) {
                request.setAttribute("toastMessage", toastMessage);
                session.removeAttribute("toastMessage");
            }

        } catch (Exception e) {
            error = "Lỗi hệ thống: " + e.getMessage();
            e.printStackTrace();
        }

        if (error != null) {
            request.setAttribute("error", error);
        }

        request.getRequestDispatcher("/views/petOwner/myPetOwner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
