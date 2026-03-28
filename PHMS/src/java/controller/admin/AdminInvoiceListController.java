package controller.admin;

import dal.ReportingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import model.User;

@WebServlet(name = "AdminInvoiceListController", urlPatterns = {"/admin/invoice/list"})
public class AdminInvoiceListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User account = session == null ? null : (User) session.getAttribute("account");
        if (account == null || (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = util.ValidationUtils.sanitize(request.getParameter("q"));
        String status = util.ValidationUtils.sanitize(request.getParameter("status"));
        String startDate = util.ValidationUtils.sanitize(request.getParameter("startDate"));
        String endDate = util.ValidationUtils.sanitize(request.getParameter("endDate"));

        if ("all".equalsIgnoreCase(status)) {
            status = "";
        }
        if (!"Paid".equalsIgnoreCase(status) && !"Unpaid".equalsIgnoreCase(status)) {
            status = "";
        }
        if (!isValidDate(startDate)) {
            startDate = "";
        }
        if (!isValidDate(endDate)) {
            endDate = "";
        }
        if (util.ValidationUtils.isNotEmpty(startDate) && util.ValidationUtils.isNotEmpty(endDate)
                && startDate.compareTo(endDate) > 0) {
            String tmp = startDate;
            startDate = endDate;
            endDate = tmp;
        }

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        String sizeStr = request.getParameter("size");
        if (util.ValidationUtils.isIntegerInRange(pageStr, 1, Integer.MAX_VALUE)) {
            page = Integer.parseInt(pageStr);
        }
        if (util.ValidationUtils.isIntegerInRange(sizeStr, 5, 100)) {
            int requestedSize = Integer.parseInt(sizeStr);
            if (requestedSize == 5 || requestedSize == 10 || requestedSize == 20
                    || requestedSize == 50 || requestedSize == 100) {
                pageSize = requestedSize;
            }
        }

        ReportingDAO reportingDAO = new ReportingDAO();
        int totalItems = reportingDAO.countInvoicesForAdmin(search, status, startDate, endDate);
        int totalPages = totalItems == 0 ? 1 : (int) Math.ceil((double) totalItems / pageSize);
        if (page > totalPages) {
            page = totalPages;
        }
        int offset = (page - 1) * pageSize;

        List<Map<String, Object>> invoices = reportingDAO.getInvoicesForAdmin(
                search, status, startDate, endDate, offset, pageSize);
        request.setAttribute("invoices", invoices);
        request.setAttribute("q", search);
        request.setAttribute("status", util.ValidationUtils.isNotEmpty(status) ? status : "all");
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("page", page);
        request.setAttribute("size", pageSize);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/views/admin/invoiceList.jsp").forward(request, response);
    }

    private boolean isValidDate(String value) {
        if (!util.ValidationUtils.isNotEmpty(value)) {
            return false;
        }
        try {
            LocalDate.parse(value);
            return true;
        } catch (DateTimeParseException ex) {
            return false;
        }
    }
}
