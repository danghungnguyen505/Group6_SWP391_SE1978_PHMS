<<<<<<< Updated upstream
package controller.admin;

import dal.ReportingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import model.User;

/**
 * Admin views business reports.
 * SRP: Read reports only.
 */
@WebServlet(name = "BusinessReportController", urlPatterns = {"/admin/reports"})
public class BusinessReportController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get date range parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        // Default to last 30 days if not provided
        Calendar cal = Calendar.getInstance();
        Date endDate = cal.getTime();
        cal.add(Calendar.DAY_OF_MONTH, -30);
        Date startDate = cal.getTime();
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        if (util.ValidationUtils.isNotEmpty(startDateStr)) {
            try {
                startDate = sdf.parse(startDateStr);
            } catch (ParseException e) {
                // Use default
            }
        }
        
        if (util.ValidationUtils.isNotEmpty(endDateStr)) {
            try {
                endDate = sdf.parse(endDateStr);
            } catch (ParseException e) {
                // Use default
            }
        }
        
        Timestamp startTimestamp = new Timestamp(startDate.getTime());
        Timestamp endTimestamp = new Timestamp(endDate.getTime());
        
        ReportingDAO reportingDAO = new ReportingDAO();
        
        // Get revenue report
        Map<String, Object> revenueReport = reportingDAO.getRevenueReport(startTimestamp, endTimestamp);
        
        // Get appointment statistics
        Map<String, Integer> appointmentStats = reportingDAO.getAppointmentStats(startTimestamp, endTimestamp);
        
        // Get top services
        List<Map<String, Object>> topServices = reportingDAO.getTopServicesByRevenue(startTimestamp, endTimestamp, 10);
        
        // Get daily appointment count
        List<Map<String, Object>> dailyAppointments = reportingDAO.getDailyAppointmentCount(startTimestamp, endTimestamp);
        
        // Get monthly revenue
        List<Map<String, Object>> monthlyRevenue = reportingDAO.getMonthlyRevenue(startTimestamp, endTimestamp);
        
        request.setAttribute("startDate", sdf.format(startDate));
        request.setAttribute("endDate", sdf.format(endDate));
        request.setAttribute("revenueReport", revenueReport);
        request.setAttribute("appointmentStats", appointmentStats);
        request.setAttribute("topServices", topServices);
        request.setAttribute("dailyAppointments", dailyAppointments);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        
        request.getRequestDispatcher("/views/admin/businessReport.jsp").forward(request, response);
    }
}
=======
package controller.admin;

import dal.ReportingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import model.User;

/**
 * Admin views business reports.
 * SRP: Read reports only.
 */
@WebServlet(name = "BusinessReportController", urlPatterns = {"/admin/reports"})
public class BusinessReportController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get date range parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        // Default to last 30 days if not provided
        Calendar cal = Calendar.getInstance();
        Date endDate = cal.getTime();
        cal.add(Calendar.DAY_OF_MONTH, -30);
        Date startDate = cal.getTime();
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        if (util.ValidationUtils.isNotEmpty(startDateStr)) {
            try {
                startDate = sdf.parse(startDateStr);
            } catch (ParseException e) {
                // Use default
            }
        }
        
        if (util.ValidationUtils.isNotEmpty(endDateStr)) {
            try {
                endDate = sdf.parse(endDateStr);
            } catch (ParseException e) {
                // Use default
            }
        }
        
        Timestamp startTimestamp = new Timestamp(startDate.getTime());
        Timestamp endTimestamp = new Timestamp(endDate.getTime());
        
        ReportingDAO reportingDAO = new ReportingDAO();
        
        // Get revenue report
        Map<String, Object> revenueReport = reportingDAO.getRevenueReport(startTimestamp, endTimestamp);
        
        // Get appointment statistics
        Map<String, Integer> appointmentStats = reportingDAO.getAppointmentStats(startTimestamp, endTimestamp);
        
        // Get top services
        List<Map<String, Object>> topServices = reportingDAO.getTopServicesByRevenue(startTimestamp, endTimestamp, 10);
        
        // Get daily appointment count
        List<Map<String, Object>> dailyAppointments = reportingDAO.getDailyAppointmentCount(startTimestamp, endTimestamp);
        
        // Get monthly revenue
        List<Map<String, Object>> monthlyRevenue = reportingDAO.getMonthlyRevenue(startTimestamp, endTimestamp);
        
        request.setAttribute("startDate", sdf.format(startDate));
        request.setAttribute("endDate", sdf.format(endDate));
        request.setAttribute("revenueReport", revenueReport);
        request.setAttribute("appointmentStats", appointmentStats);
        request.setAttribute("topServices", topServices);
        request.setAttribute("dailyAppointments", dailyAppointments);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        
        request.getRequestDispatcher("/views/admin/businessReport.jsp").forward(request, response);
    }
}
>>>>>>> Stashed changes
