package controller.petOwner;

import dal.PetDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "DeletePetController", urlPatterns = {"/pet/delete"})
public class DeletePetController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

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

            model.Pet pet = petDAO.getPetById(petId);
            if (pet == null || pet.getOwnerId() != account.getUserId()) {
                session.setAttribute("toastMessage", "error|Không tìm thấy thú cưng hoặc bạn không có quyền xóa!");
                response.sendRedirect(request.getContextPath() + "/myPetOwner");
                return;
            }

            if (petDAO.hasMedicalRecords(petId)) {
                session.setAttribute("toastMessage", "error|Không thể xoá pet có hồ sơ khám bệnh");
                response.sendRedirect(request.getContextPath() + "/myPetOwner");
                return;
            }

            boolean success = petDAO.deletePet(petId);
            if (success) {
                session.setAttribute("toastMessage", "success|Xóa thú cưng thành công!");
            } else {
                session.setAttribute("toastMessage", "error|Lỗi hệ thống: Không thể xóa thú cưng. Vui lòng thử lại!");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "error|ID thú cưng không hợp lệ!");
        } catch (Exception e) {
            session.setAttribute("toastMessage", "error|Đã xảy ra lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/myPetOwner");
    }
}
