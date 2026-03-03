/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.petOwner;

import dal.AppointmentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Appointment;
import model.User;
import util.PaginationUtils;
import java.util.Date;
/**
 *
 * @author zoxy4
 */
@WebServlet(name = "MyAppointmentController", urlPatterns = {"/myAppointment"})
public class MyAppointmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        // 1. Check login
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // 2. Lấy dữ liệu từ DAO
        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> allList = dao.getAppointmentsByOwnerId(account.getUserId());
        // 3. Phân loại danh sách
        List<Appointment> upcomingList = new ArrayList<>(); // Sắp tới
        List<Appointment> historyList = new ArrayList<>();  // Đã xong/Hủy
        //Login theo Lịch hẹn tương lai
        Date now = new Date();
        for (Appointment a : allList) {
            String status = a.getStatus();
            Date startTime = a.getStartTime();//Lấy thời gian bắt đầu của cuộc hẹn
            boolean isActiveStatus = "Pending".equalsIgnoreCase(status)
                    || "Confirmed".equalsIgnoreCase(status);
            boolean isFuture = startTime.after(now);
            if (isActiveStatus && isFuture) {
                upcomingList.add(a);
            } else {
                //(Completed, Cancelled, hoặc Pending/Confirmed nhưng đã qua ngày)
                // đều cho vào lịch sử
                historyList.add(a);
            }
        }
        //Login theo trạng thái
//        for (Appointment a : allList) {
//            String status = a.getStatus();
//            // Logic: Pending hoặc Confirmed là "Sắp tới"
//            if ("Pending".equalsIgnoreCase(status) || "Confirmed".equalsIgnoreCase(status)) {
//                upcomingList.add(a);
//            } else {
//                // Completed, Cancelled là "Lịch sử"
//                historyList.add(a);
//            }
//        }
        // Phân trang
        int page = 1;
        int pageSize = 5;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int totalPages = PaginationUtils.getTotalPages(historyList, pageSize);
        page = PaginationUtils.getValidPage(page, totalPages);
        List<Appointment> paginatedHistory = PaginationUtils.getPage(historyList, page, pageSize);
        // 4. Đẩy ra JSP
        request.setAttribute("upcomingList", upcomingList);
        request.setAttribute("historyList", paginatedHistory); // List đã cắt
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("/views/petOwner/myAppointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
