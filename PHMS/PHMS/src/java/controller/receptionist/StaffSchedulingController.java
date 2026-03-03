package controller.receptionist;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name="StaffSchedulingController", urlPatterns={"/receptionist/scheduling"})
public class StaffSchedulingController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Currently this page is a static scheduling UI (no DB operations).
        // Any future scheduling logic should go into dedicated servlets/DAOs.
        request.getRequestDispatcher("/views/receptionist/staffScheduling.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // No POST actions defined yet for receptionist scheduling.
        doGet(request, response);
    }
}
