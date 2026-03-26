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

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        Date endDate = cal.getTime();
        Date startDate;

        String filter = request.getParameter("filter");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

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
                    cal.add(Calendar.DAY_OF_MONTH, -30);
                    startDate = cal.getTime();
            }
        } else if (util.ValidationUtils.isNotEmpty(startDateStr) || util.ValidationUtils.isNotEmpty(endDateStr)) {
            cal.add(Calendar.DAY_OF_MONTH, -30);
            startDate = cal.getTime();
            cal = Calendar.getInstance();
            endDate = cal.getTime();
            if (util.ValidationUtils.isNotEmpty(startDateStr)) {
                try { startDate = sdf.parse(startDateStr); } catch (ParseException e) { /* use default */ }
            }
            if (util.ValidationUtils.isNotEmpty(endDateStr)) {
                try { endDate = sdf.parse(endDateStr); } catch (ParseException e) { /* use default */ }
            }
        } else {
            // Default: this month
            cal.set(Calendar.DAY_OF_MONTH, 1);
            startDate = cal.getTime();
            cal = Calendar.getInstance();
            endDate = cal.getTime();
        }

        Timestamp startTimestamp = new Timestamp(startDate.getTime());
        Timestamp endTimestamp = new Timestamp(endDate.getTime());

        ReportingDAO reportingDAO = new ReportingDAO();
        Map<String, Object> revenueReport = reportingDAO.getRevenueReport(startTimestamp, endTimestamp);
        Map<String, Integer> appointmentStats = reportingDAO.getAppointmentStats(startTimestamp, endTimestamp);
        List<Map<String, Object>> topServices = reportingDAO.getTopServicesByRevenue(startTimestamp, endTimestamp, 5);
        List<Map<String, Object>> dailyAppointments = reportingDAO.getDailyAppointmentCount(startTimestamp, endTimestamp);

        // Always get last 6 months for chart
        Calendar cal6 = Calendar.getInstance();
        cal6.add(Calendar.MONTH, -5);
        cal6.set(Calendar.DAY_OF_MONTH, 1);
        cal6.set(Calendar.HOUR_OF_DAY, 0);
        cal6.set(Calendar.MINUTE, 0);
        cal6.set(Calendar.SECOND, 0);
        cal6.set(Calendar.MILLISECOND, 0);
        Timestamp chartStart = new Timestamp(cal6.getTime().getTime());
        Timestamp chartEnd = new Timestamp(System.currentTimeMillis());
        List<Map<String, Object>> monthlyRevenue = reportingDAO.getMonthlyRevenue(chartStart, chartEnd);

        // Growth percentage
        Map<String, Object> revenueGrowth = reportingDAO.getRevenueGrowth(startTimestamp, endTimestamp);
        List<Map<String, Object>> recentInvoices = reportingDAO.getRecentInvoices(6);

        request.setAttribute("startDate", sdf.format(startDate));
        request.setAttribute("endDate", sdf.format(endDate));
        request.setAttribute("revenueReport", revenueReport);
        request.setAttribute("appointmentStats", appointmentStats);
        request.setAttribute("topServices", topServices);
        request.setAttribute("dailyAppointments", dailyAppointments);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("recentInvoices", recentInvoices);
        request.setAttribute("revenueGrowth", revenueGrowth);

        request.getRequestDispatcher("/views/admin/businessReport.jsp").forward(request, response);
    }
}
