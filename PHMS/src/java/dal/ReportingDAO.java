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
     * Revenue = SUM(total_amount) from Invoice where status = 'Paid'.
     * Date filter uses Appointment.start_time.
     */
    public Map<String, Object> getRevenueReport(Timestamp startDate, Timestamp endDate) {
        Map<String, Object> report = new HashMap<>();
        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM Invoice inv INNER JOIN Appointment a ON inv.appt_id = a.appt_id WHERE CAST(a.start_time AS DATE) >= CAST(? AS DATE) AND CAST(a.start_time AS DATE) <= CAST(? AS DATE)) AS total_invoices, " +
                     "COALESCE((SELECT SUM(inv.total_amount) FROM Invoice inv INNER JOIN Appointment a ON inv.appt_id = a.appt_id WHERE inv.status = 'Paid' AND CAST(a.start_time AS DATE) >= CAST(? AS DATE) AND CAST(a.start_time AS DATE) <= CAST(? AS DATE)), 0) AS total_revenue, " +
                     "(SELECT COUNT(*) FROM Invoice inv INNER JOIN Appointment a ON inv.appt_id = a.appt_id WHERE inv.status = 'Paid' AND CAST(a.start_time AS DATE) >= CAST(? AS DATE) AND CAST(a.start_time AS DATE) <= CAST(? AS DATE)) AS paid_invoices, " +
                     "(SELECT COUNT(*) FROM Invoice inv INNER JOIN Appointment a ON inv.appt_id = a.appt_id WHERE inv.status = 'Unpaid' AND CAST(a.start_time AS DATE) >= CAST(? AS DATE) AND CAST(a.start_time AS DATE) <= CAST(? AS DATE)) AS unpaid_invoices";
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
        String sql = "SELECT TOP (?) s.name, s.service_id, s.base_price, " +
                     "COUNT(appt.appt_id) AS appointment_count, " +
                     "COALESCE(SUM(inv.total_amount), 0) AS total_revenue " +
                     "FROM ServiceList s " +
                     "LEFT JOIN Appointment appt ON appt.type = s.name " +
                     "AND CAST(appt.start_time AS DATE) >= CAST(? AS DATE) " +
                     "AND CAST(appt.start_time AS DATE) <= CAST(? AS DATE) " +
                     "LEFT JOIN Invoice inv ON inv.appt_id = appt.appt_id AND inv.status = 'Paid' " +
                     "GROUP BY s.service_id, s.name, s.base_price " +
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
                    item.put("price", rs.getDouble("base_price"));
                    item.put("appointmentCount", rs.getInt("appointment_count"));
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
     * Revenue = SUM(total_amount) from Invoice where status = 'Paid'.
     * Date filter uses Appointment.start_time.
     * Always returns all months in range, filling 0 for months without data.
     */
    public List<Map<String, Object>> getMonthlyRevenue(Timestamp startDate, Timestamp endDate) {
        // 1. Query months that have data
        Map<String, Map<String, Object>> dataMap = new java.util.LinkedHashMap<>();
        String sql = "SELECT " +
                     "FORMAT(a.start_time, 'yyyy-MM') AS month, " +
                     "COALESCE(SUM(CASE WHEN inv.status = 'Paid' THEN inv.total_amount ELSE 0 END), 0) AS revenue, " +
                     "COUNT(DISTINCT inv.invoice_id) AS invoice_count " +
                     "FROM Invoice inv " +
                     "INNER JOIN Appointment a ON inv.appt_id = a.appt_id " +
                     "WHERE CAST(a.start_time AS DATE) >= CAST(? AS DATE) " +
                     "AND CAST(a.start_time AS DATE) <= CAST(? AS DATE) " +
                     "GROUP BY FORMAT(a.start_time, 'yyyy-MM') " +
                     "ORDER BY month ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setTimestamp(1, startDate);
            st.setTimestamp(2, endDate);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    String month = rs.getString("month");
                    item.put("month", month);
                    item.put("revenue", rs.getDouble("revenue"));
                    item.put("invoiceCount", rs.getInt("invoice_count"));
                    dataMap.put(month, item);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getMonthlyRevenue: " + e.getMessage());
        }

        // 2. Generate all months in range and fill missing with 0
        List<Map<String, Object>> list = new ArrayList<>();
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTimeInMillis(startDate.getTime());
        cal.set(java.util.Calendar.DAY_OF_MONTH, 1);

        java.util.Calendar endCal = java.util.Calendar.getInstance();
        endCal.setTimeInMillis(endDate.getTime());

        while (!cal.after(endCal)) {
            String monthKey = sdf.format(cal.getTime());
            if (dataMap.containsKey(monthKey)) {
                list.add(dataMap.get(monthKey));
            } else {
                Map<String, Object> empty = new HashMap<>();
                empty.put("month", monthKey);
                empty.put("revenue", 0.0);
                empty.put("invoiceCount", 0);
                list.add(empty);
            }
            cal.add(java.util.Calendar.MONTH, 1);
        }
        return list;
    }

    /**
     * Calculate revenue growth percentage compared to previous period.
     * Returns map with currentRevenue, previousRevenue, and growthPercentage.
     */
    public Map<String, Object> getRevenueGrowth(Timestamp currentStart, Timestamp currentEnd) {
        Map<String, Object> result = new HashMap<>();

        // Get current period revenue
        double currentRevenue = 0;
        String currentSql = "SELECT COALESCE(SUM(total_amount), 0) AS rev FROM Invoice " +
                          "WHERE status = 'Paid' AND appt_id IN " +
                          "(SELECT appt_id FROM Appointment WHERE start_time >= ? AND start_time <= ?)";
        try (PreparedStatement st = connection.prepareStatement(currentSql)) {
            st.setTimestamp(1, currentStart);
            st.setTimestamp(2, currentEnd);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    currentRevenue = rs.getDouble("rev");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getRevenueGrowth current: " + e.getMessage());
        }

        // Calculate previous period (same duration before current start)
        long duration = currentEnd.getTime() - currentStart.getTime();
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTimeInMillis(currentStart.getTime());
        cal.add(java.util.Calendar.MILLISECOND, -(int) duration);
        Timestamp previousEnd = new Timestamp(currentStart.getTime() - 1);
        Timestamp previousStart = new Timestamp(cal.getTimeInMillis());

        // Get previous period revenue
        double previousRevenue = 0;
        try (PreparedStatement st = connection.prepareStatement(currentSql)) {
            st.setTimestamp(1, previousStart);
            st.setTimestamp(2, previousEnd);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    previousRevenue = rs.getDouble("rev");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getRevenueGrowth previous: " + e.getMessage());
        }

        result.put("currentRevenue", currentRevenue);
        result.put("previousRevenue", previousRevenue);

        // Calculate growth percentage
        double growth = 0;
        if (previousRevenue > 0) {
            growth = ((currentRevenue - previousRevenue) / previousRevenue) * 100;
        } else if (currentRevenue > 0) {
            growth = 100; // New revenue from zero
        }
        result.put("growthPercentage", growth);

        return result;
    }

    /**
     * Get recent invoices for transaction history panel in admin report.
     */
    public List<Map<String, Object>> getRecentInvoices(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) "
                + "inv.invoice_id, inv.appt_id, inv.total_amount, inv.status, inv.created_at, "
                + "p.name AS pet_name, u_owner.full_name AS owner_name "
                + "FROM Invoice inv "
                + "INNER JOIN Appointment a ON inv.appt_id = a.appt_id "
                + "INNER JOIN Pet p ON a.pet_id = p.pet_id "
                + "INNER JOIN Users u_owner ON p.owner_id = u_owner.user_id "
                + "WHERE inv.status = 'Paid' "
                + "ORDER BY inv.created_at DESC, inv.invoice_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("invoiceId", rs.getInt("invoice_id"));
                    item.put("appointmentId", rs.getInt("appt_id"));
                    item.put("totalAmount", rs.getDouble("total_amount"));
                    item.put("status", rs.getString("status"));
                    item.put("createdAt", rs.getTimestamp("created_at"));
                    item.put("petName", rs.getString("pet_name"));
                    item.put("ownerName", rs.getString("owner_name"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getRecentInvoices: " + e.getMessage());
        }
        return list;
    }
}
