<<<<<<< Updated upstream
package controller.petOwner;

import dal.AppointmentDAO;
import dal.PetDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.Appointment;
import model.Pet;
import model.User;

/**
 * PetOwner SOS emergency booking.
 * DISABLED: Emergency appointments are now created by Receptionist when pet owner brings pet to clinic.
 * SRP: Create emergency appointment only.
 */
@WebServlet(name = "EmergencySOSController", urlPatterns = {"/sos"})
public class EmergencySOSController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to home - PetOwner should bring pet to clinic for emergency
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", "info|Vui lòng mang thú cưng đến phòng khám để được lễ tân tạo cuộc hẹn cấp cứu.");
        response.sendRedirect(request.getContextPath() + "/home");
        return;
        
        /* DISABLED - Old code
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PetDAO petDAO = new PetDAO();
        List<Pet> pets = petDAO.getPetsByOwnerId(account.getUserId());
        request.setAttribute("pets", pets);
        request.getRequestDispatcher("/views/petOwner/sos.jsp").forward(request, response);
        */
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to home - PetOwner should bring pet to clinic for emergency
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", "info|Vui lòng mang thú cưng đến phòng khám để được lễ tân tạo cuộc hẹn cấp cứu.");
        response.sendRedirect(request.getContextPath() + "/home");
        return;
        
        /* DISABLED - Old code
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // ... old logic removed ...
        */
    }
}

=======
package controller.petOwner;

import dal.AppointmentDAO;
import dal.PetDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.Appointment;
import model.Pet;
import model.User;

/**
 * PetOwner SOS emergency booking.
 * DISABLED: Emergency appointments are now created by Receptionist when pet owner brings pet to clinic.
 * SRP: Create emergency appointment only.
 */
@WebServlet(name = "EmergencySOSController", urlPatterns = {"/sos"})
public class EmergencySOSController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to home - PetOwner should bring pet to clinic for emergency
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", "info|Vui lòng mang thú cưng đến phòng khám để được lễ tân tạo cuộc hẹn cấp cứu.");
        response.sendRedirect(request.getContextPath() + "/home");
        return;
        
        /* DISABLED - Old code
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        PetDAO petDAO = new PetDAO();
        List<Pet> pets = petDAO.getPetsByOwnerId(account.getUserId());
        request.setAttribute("pets", pets);
        request.getRequestDispatcher("/views/petOwner/sos.jsp").forward(request, response);
        */
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to home - PetOwner should bring pet to clinic for emergency
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", "info|Vui lòng mang thú cưng đến phòng khám để được lễ tân tạo cuộc hẹn cấp cứu.");
        response.sendRedirect(request.getContextPath() + "/home");
        return;
        
        /* DISABLED - Old code
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // ... old logic removed ...
        */
    }
}

>>>>>>> Stashed changes
