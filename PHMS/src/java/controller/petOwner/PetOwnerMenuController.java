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
import dal.ScheduleVeterianrianDAO;
import dal.ServiceDAO;
import dal.UserDAO;
import java.util.List;
import model.Schedule;

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
            // 1. Lấy danh sách thú cưng của User
            PetDAO petDao = new PetDAO();
            request.setAttribute("pets", petDao.getPetsByOwnerId(account.getUserId())); 
            // 2. Lấy danh sách Dịch vụ
            ServiceDAO serviceDao = new ServiceDAO();
            request.setAttribute("services", serviceDao.getAllServices());
            // 3. Lấy danh sách Lịch làm việc của Bác sĩ 
            ScheduleVeterianrianDAO scheduleDao = new ScheduleVeterianrianDAO();
            List<Schedule> schedules = scheduleDao.getAvailableSchedules();
            request.setAttribute("schedules", schedules);

        } catch(Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/views/petOwner/menuPetOwner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
    }

}
