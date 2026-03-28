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
import util.PaginationUtils;

/**
 *
 * @author zoxy4
 */
@WebServlet(name = "leavePendingController", urlPatterns = {"/leavePending"})
public class leavePendingController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int recordsPerPage = PaginationUtils.normalizePageSize(request.getParameter("size"), 10);
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }

        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        if (statusFilter == null) {
            statusFilter = "all";
        }

        int offset = (currentPage - 1) * recordsPerPage;
        LeaveRequestDAO dao = new LeaveRequestDAO();
        List<LeaveRequest> list = dao.getLeaveRequests(search, statusFilter, offset, recordsPerPage);
        int totalRecords = dao.getTotalLeaveRequests(search, statusFilter);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        request.setAttribute("requests", list);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("pageSize", recordsPerPage);
        request.setAttribute("search", search != null ? search : "");
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/views/admin/leavePending.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
    }

}
