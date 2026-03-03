/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.LeaveRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.LeaveRequest;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "leavePendingController", urlPatterns = {"/leavePending"})
public class leavePendingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập số lượng bản ghi trên 1 trang
        int recordsPerPage = 5;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }
        int offset = (currentPage - 1) * recordsPerPage;
        LeaveRequestDAO dao = new LeaveRequestDAO();
        List<LeaveRequest> list = dao.getPendingLeaveRequests(offset, recordsPerPage);
        int totalRecords = dao.getTotalPendingRequests();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        request.setAttribute("requests", list);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.getRequestDispatcher("/views/admin/leavePending.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
    }

}
