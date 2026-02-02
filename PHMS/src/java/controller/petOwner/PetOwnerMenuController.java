package controller.petOwner;

import dal.InvoiceDAO;
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

    if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
        response.sendRedirect("../login");
        return;
    }

    try {
        PetDAO petDao = new PetDAO();
        request.setAttribute("pets", petDao.getPetsByOwnerId(account.getUserId())); 

        ServiceDAO serviceDao = new ServiceDAO();
        request.setAttribute("services", serviceDao.getAllServices());

        ScheduleVeterianrianDAO scheduleDao = new ScheduleVeterianrianDAO();
        List<Schedule> schedules = scheduleDao.getAvailableSchedules();
        request.setAttribute("schedules", schedules);

        // 
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Integer latestInvoiceId = invoiceDAO.getLatestInvoiceIdByOwner(account.getUserId());
        request.setAttribute("latestInvoiceId", latestInvoiceId);

    } catch(Exception e) {
        e.printStackTrace();
    }

    request.setAttribute("contentPage", "/views/petOwner/menuPetOwner.jsp");
request.getRequestDispatcher("/views/petOwner/layoutPetOwner.jsp").forward(request, response);

}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
    }

}
