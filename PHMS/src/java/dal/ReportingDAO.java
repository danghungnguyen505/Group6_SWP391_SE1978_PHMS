package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for Business Reporting.
 * Provides aggregated data for revenue, appointments, services statistics.
 */
public class ReportingDAO extends DBContext {
    
    /**
     * Get revenue report by date range.
     * Returns total revenue, total invoices, paid invoices count.
     * Calculates revenue from InvoiceDetail (actual service prices) instead of total_amount.
     */
    public Map<String, Object> getRevenueReport(Timestamp startDate, Timestamp endDate) {
        Map<String, Object> report = new HashMap<>();
        // Calculate from InvoiceDetail (service prices in invoice) instead of total_amount
        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM Invoice WHERE CAST(created_at AS DATE) >= CAST(? AS DATE) AND CAST(created_at AS DATE) <= CAST(? AS DATE)) AS total_invoices, " +
                     "COALESCE((SELECT SUM(id.subtotal) FROM InvoiceDetail id INNER JOIN Invoice inv ON id.invoice_id = inv.invoice_id WHERE inv.status = 'Paid' AND CAST(inv.created_at AS DATE) >= CAST(? AS DATE) AND CAST(inv.created_at AS DATE) <= CAST(? AS DATE)), 0) AS total_revenue, " +
                     "(SELECT COUNT(*) FROM Invoice WHERE status = 'Paid' AND CAST(created_at AS DATE) >= CAST(? AS DATE) AND CAST(created_at AS DATE) <= CAST(? AS DATE)) AS paid_invoices, " +
                     "(SELECT COUNT(*) FROM Invoice WHERE status = 'Unpaid' AND CAST(created_at AS DATE) >= CAST(? AS DATE) AND CAST(created_at AS DATE) <= CAST(? AS DATE)) AS unpaid_invoices";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setTimestamp(1, startDate);
            st.setTimestamp(2, endDate);
            st.setTimestamp(3, startDate);
            st.setTimestamp(4, endDate);
            st.setTimestamp(5, startDate);
            st.setTimestamp(6, endDate);
            st.setTimestamp(7, startDate);
            st.setTimestamp(8, endDate);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    report.put("totalInvoices", rs.getInt("total_invoices"));
                    report.put("totalRevenue", rs.getDouble("total_revenue"));
                    report.put("paidInvoices", rs.getInt("paid_invoices"));
                    report.put("unpaidInvoices", rs.getInt("unpaid_invoices"));
                } else {
                    report.put("totalInvoices", 0);
                    report.put("totalRevenue", 0.0);
                    report.put("paidInvoices", 0);
                    report.put("unpaidInvoices", 0);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getRevenueReport: " + e.getMessage());
            report.put("totalInvoices", 0);
            report.put("totalRevenue", 0.0);
            report.put("paidInvoices", 0);
            report.put("unpaidInvoices", 0);
        }
        return report;
    }
    
    /**
     * Get appointment statistics by date range.
     * Returns count by status with proper keys for JSP.
     */
    public Map<String, Integer> getAppointmentStats(Timestamp startDate, Timestamp endDate) {
        Map<String, Integer> stats = new HashMap<>();
        int total = 0, completed = 0, pending = 0, cancelled = 0;
        String sql = "SELECT status, COUNT(*) AS cnt " +
                     "FROM Appointment " +
                     "WHERE CAST(start_time AS DATE) >= CAST(? AS DATE) " +
                     "AND CAST(start_time AS DATE) <= CAST(? AS DATE) " +
                     "GROUP BY status";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setTimestamp(1, startDate);
            st.setTimestamp(2, endDate);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int count = rs.getInt("cnt");
                    total += count;
                    if ("Completed".equalsIgnoreCase(status)) {
                        completed = count;
                    } else if ("Pending".equalsIgnoreCase(status)) {
                        pending = count;
                    } else if ("Cancelled".equalsIgnoreCase(status)) {
                        cancelled = count;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getAppointmentStats: " + e.getMessage());
        }
        stats.put("totalAppointments", total);
        stats.put("completedAppointments", completed);
        stats.put("pendingAppointments", pending);
        stats.put("cancelledAppointments", cancelled);
        return stats;
    }
    
    /**
     * Get top services by revenue (with pagination).
     */
    public List<Map<String, Object>> getTopServicesByRevenue(Timestamp startDate, Timestamp endDate, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) s.name, s.service_id, " +
                     "COUNT(id.detail_id) AS usage_count, " +
                     "SUM(id.subtotal) AS total_revenue " +
                     "FROM ServiceList s " +
                     "LEFT JOIN InvoiceDetail id ON s.service_id = id.service_id AND id.item_type = 'Service' " +
                     "LEFT JOIN Invoice inv ON id.invoice_id = inv.invoice_id " +
                     "WHERE (inv.created_at IS NULL OR (CAST(inv.created_at AS DATE) >= CAST(? AS DATE) " +
                     "AND CAST(inv.created_at AS DATE) <= CAST(? AS DATE))) " +
                     "GROUP BY s.service_id, s.name " +
                     "ORDER BY total_revenue DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            st.setTimestamp(2, startDate);
            st.setTimestamp(3, endDate);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("serviceId", rs.getInt("service_id"));
                    item.put("serviceName", rs.getString("name"));
                    item.put("appointmentCount", rs.getInt("usage_count"));
                    item.put("totalRevenue", rs.getDouble("total_revenue"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getTopServicesByRevenue: " + e.getMessage());
        }
        return list;
    }
    
    /**
     * Get daily appointment count for a date range.
     */
    public List<Map<String, Object>> getDailyAppointmentCount(Timestamp startDate, Timestamp endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT CAST(start_time AS DATE) AS appointment_date, COUNT(*) AS appointment_count " +
                     "FROM Appointment " +
                     "WHERE CAST(start_time AS DATE) >= CAST(? AS DATE) " +
                     "AND CAST(start_time AS DATE) <= CAST(? AS DATE) " +
                     "GROUP BY CAST(start_time AS DATE) " +
                     "ORDER BY appointment_date ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setTimestamp(1, startDate);
            st.setTimestamp(2, endDate);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("date", rs.getDate("appointment_date"));
                    item.put("count", rs.getInt("appointment_count"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getDailyAppointmentCount: " + e.getMessage());
        }
        return list;
    }
    
    /**
     * Get monthly revenue summary.
     * Calculates from InvoiceDetail subtotals instead of total_amount.
     */
    public List<Map<String, Object>> getMonthlyRevenue(Timestamp startDate, Timestamp endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT " +
                     "FORMAT(inv.created_at, 'yyyy-MM') AS month, " +
                     "COALESCE(SUM(CASE WHEN inv.status = 'Paid' THEN id.subtotal ELSE 0 END), 0) AS revenue, " +
                     "COUNT(DISTINCT inv.invoice_id) AS invoice_count " +
                     "FROM Invoice inv " +
                     "LEFT JOIN InvoiceDetail id ON inv.invoice_id = id.invoice_id " +
                     "WHERE CAST(inv.created_at AS DATE) >= CAST(? AS DATE) " +
                     "AND CAST(inv.created_at AS DATE) <= CAST(? AS DATE) " +
                     "GROUP BY FORMAT(inv.created_at, 'yyyy-MM') " +
                     "ORDER BY month ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setTimestamp(1, startDate);
            st.setTimestamp(2, endDate);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("month", rs.getString("month"));
                    item.put("revenue", rs.getDouble("revenue"));
                    item.put("invoiceCount", rs.getInt("invoice_count"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getMonthlyRevenue: " + e.getMessage());
        }
        return list;
    }
}
