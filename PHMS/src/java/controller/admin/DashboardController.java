/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin;

import dal.FeedbackDAO;
import dal.ReportingDAO;
import dal.ServiceDAO;
import dal.StaffAccountDAO;
import dal.LeaveRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import model.User;
import model.Service;
import model.LeaveRequest;

/**
 *
 * @author Nguyen Dang Hung
 */
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");

        if (account == null) {
            response.sendRedirect("../login");
            return;
        }

        // --- Filter logic (like Shopee) ---
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        Date endDate = cal.getTime();
        Date startDate;

        String filter = request.getParameter("filter");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        if (filter == null && startDateStr == null) {
            filter = "month"; // default: this month
        }

        if (filter != null) {
            cal = Calendar.getInstance();
            switch (filter) {
                case "today":
                    startDate = cal.getTime();
                    endDate = cal.getTime();
                    break;
                case "week":
                    cal.set(Calendar.DAY_OF_WEEK, cal.getFirstDayOfWeek());
                    startDate = cal.getTime();
                    cal = Calendar.getInstance();
                    endDate = cal.getTime();
                    break;
                case "month":
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    startDate = cal.getTime();
                    cal = Calendar.getInstance();
                    endDate = cal.getTime();
                    break;
                case "quarter":
                    int month = cal.get(Calendar.MONTH);
                    int quarterStart = (month / 3) * 3;
                    cal.set(Calendar.MONTH, quarterStart);
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    startDate = cal.getTime();
                    cal = Calendar.getInstance();
                    endDate = cal.getTime();
                    break;
                case "year":
                    cal.set(Calendar.DAY_OF_YEAR, 1);
                    startDate = cal.getTime();
                    cal = Calendar.getInstance();
                    endDate = cal.getTime();
                    break;
                default:
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    startDate = cal.getTime();
                    cal = Calendar.getInstance();
                    endDate = cal.getTime();
            }
        } else {
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = cal.getTime();
            cal = Calendar.getInstance();
            endDate = cal.getTime();
            if (util.ValidationUtils.isNotEmpty(startDateStr)) {
                try { startDate = sdf.parse(startDateStr); } catch (ParseException e) { /* default */ }
            }
            if (util.ValidationUtils.isNotEmpty(endDateStr)) {
                try { endDate = sdf.parse(endDateStr); } catch (ParseException e) { /* default */ }
            }
        }

        Timestamp startTimestamp = new Timestamp(startDate.getTime());
        Timestamp endTimestamp = new Timestamp(endDate.getTime());

        // --- Fetch all data ---
        ReportingDAO reportingDAO = new ReportingDAO();
        Map<String, Object> revenueReport = reportingDAO.getRevenueReport(startTimestamp, endTimestamp);
        Map<String, Integer> appointmentStats = reportingDAO.getAppointmentStats(startTimestamp, endTimestamp);
        List<Map<String, Object>> topServices = reportingDAO.getTopServicesByRevenue(startTimestamp, endTimestamp, 5);

        // Always get 12 months for chart display
        Calendar cal12 = Calendar.getInstance();
        cal12.add(Calendar.MONTH, -11);
        cal12.set(Calendar.DAY_OF_MONTH, 1);
        cal12.set(Calendar.HOUR_OF_DAY, 0);
        cal12.set(Calendar.MINUTE, 0);
        cal12.set(Calendar.SECOND, 0);
        cal12.set(Calendar.MILLISECOND, 0);
        Timestamp chartStart = new Timestamp(cal12.getTime().getTime());
        Timestamp chartEnd = new Timestamp(System.currentTimeMillis());
        List<Map<String, Object>> monthlyRevenue = reportingDAO.getMonthlyRevenue(chartStart, chartEnd);

        StaffAccountDAO staffDAO = new StaffAccountDAO();
        List<User> staffAccounts = staffDAO.getAllStaffAccounts(1, 1000, "", "", "");

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<model.Feedback> feedbacks = feedbackDAO.getAllFeedbacks(1, 10);

        LeaveRequestDAO leaveDAO = new LeaveRequestDAO();
        List<LeaveRequest> requests = leaveDAO.getPendingLeaveRequests(0, 10);

        // --- Set attributes ---
        request.setAttribute("filter", filter);
        request.setAttribute("startDate", sdf.format(startDate));
        request.setAttribute("endDate", sdf.format(endDate));
        request.setAttribute("revenueReport", revenueReport);
        request.setAttribute("appointmentStats", appointmentStats);
        request.setAttribute("topServices", topServices);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("staffAccounts", staffAccounts);
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("requests", requests);

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null) {
            response.sendRedirect("../login");
            return;
        }

        int currentAdminId = account.getUserId(); 
        String action = request.getParameter("action");
        ServiceDAO dao = new ServiceDAO();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                String desc = request.getParameter("description");

                dao.addService(new Service(0, name, price, desc, true, currentAdminId));

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("serviceId"));
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                String desc = request.getParameter("description");

                dao.updateService(new Service(id, name, price, desc, true, currentAdminId));

            } else if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean status = Boolean.parseBoolean(request.getParameter("status"));
                dao.toggleServiceStatus(id, status);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("dashboard");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
