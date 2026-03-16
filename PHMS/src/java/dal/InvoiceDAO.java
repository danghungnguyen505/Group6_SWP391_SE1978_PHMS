package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Invoice;
import model.InvoiceDetail;
import model.Medicine;
import model.Service;

/**
 * DAO for Invoice and InvoiceDetail.
 */
public class InvoiceDAO extends DBContext {

    /**
     * Create invoice and details for an appointment. All unit prices are loaded
     * from DB (ServiceList / Medicine), not from client.
     */
    public void updateInvoiceStatus(int invoiceId, String status) {
        String sql = "UPDATE Invoice SET status = ? WHERE invoice_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, invoiceId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // Thêm một biến static để lưu lỗi gần nhất
    public static String SQL_ERROR_LOG = "";

    public int createInvoice(int apptId, int recepId, double totalAmount) {
        String sql = "INSERT INTO Invoice (appt_id, recep_id, total_amount, status) VALUES (?, ?, ?, 'Unpaid')";
        try {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, apptId);
            ps.setInt(2, recepId);
            ps.setDouble(3, totalAmount);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            // LƯU LỖI VÀO BIẾN NÀY ĐỂ XEM
            SQL_ERROR_LOG = e.getMessage();
            e.printStackTrace();
        }
        return -1;
    }

    public Integer createInvoiceForAppointment(int apptId, int recepId,
            List<InvoiceDetail> details) throws SQLException {
        if (details == null || details.isEmpty()) {
            return null;
        }

        // Business rule: do not create duplicated invoice for the same appointment
        if (getInvoiceByAppointment(apptId) != null) {
            return null;
        }

        String insertInvoiceSql = "INSERT INTO Invoice (appt_id, recep_id, total_amount, status) "
                + "VALUES (?, ?, 0, 'Unpaid')";
        String insertDetailSql = "INSERT INTO InvoiceDetail "
                + "(invoice_id, medicine_id, service_id, item_type, quantity, unit_price) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        String updateTotalSql = "UPDATE Invoice SET total_amount = ? WHERE invoice_id = ?";

        boolean oldAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);

            // 1. Insert invoice header
            int invoiceId;
            try (PreparedStatement ins = connection.prepareStatement(insertInvoiceSql, Statement.RETURN_GENERATED_KEYS)) {
                ins.setInt(1, apptId);
                ins.setInt(2, recepId);
                if (ins.executeUpdate() <= 0) {
                    connection.rollback();
                    return null;
                }
                try (ResultSet rs = ins.getGeneratedKeys()) {
                    if (!rs.next()) {
                        connection.rollback();
                        return null;
                    }
                    invoiceId = rs.getInt(1);
                }
            }

            // 2. Insert details, computing totalAmount
            double total = 0;
            ServiceDAO serviceDAO = new ServiceDAO();
            MedicineDAO medicineDAO = new MedicineDAO();

            try (PreparedStatement det = connection.prepareStatement(insertDetailSql)) {
                for (InvoiceDetail d : details) {
                    int qty = d.getQuantity();
                    if (qty <= 0) {
                        continue;
                    }

                    double unitPrice;
                    Integer medicineId = null;
                    Integer serviceId = null;
                    String itemType = d.getItemType();

                    if ("Service".equalsIgnoreCase(itemType) && d.getServiceId() != null) {
                        Service s = serviceDAO.getServiceById(d.getServiceId());
                        if (s == null || !s.isIsActive()) {
                            continue;
                        }
                        serviceId = s.getServiceId();
                        unitPrice = s.getBasePrice();
                        itemType = "Service";
                    } else if ("Medicine".equalsIgnoreCase(itemType) && d.getMedicineId() != null) {
                        Medicine m = medicineDAO.getById(d.getMedicineId());
                        if (m == null) {
                            continue;
                        }
                        medicineId = m.getMedicineId();
                        unitPrice = m.getPrice();
                        itemType = "Medicine";
                    } else {
                        continue;
                    }

                    det.setInt(1, invoiceId);
                    if (medicineId != null) {
                        det.setInt(2, medicineId);
                    } else {
                        det.setNull(2, java.sql.Types.INTEGER);
                    }
                    if (serviceId != null) {
                        det.setInt(3, serviceId);
                    } else {
                        det.setNull(3, java.sql.Types.INTEGER);
                    }
                    det.setString(4, itemType);
                    det.setInt(5, qty);
                    det.setDouble(6, unitPrice);
                    det.addBatch();

                    total += qty * unitPrice;
                }

                det.executeBatch();
            }

            // 3. Update invoice total
            try (PreparedStatement up = connection.prepareStatement(updateTotalSql)) {
                up.setDouble(1, total);
                up.setInt(2, invoiceId);
                up.executeUpdate();
            }

            connection.commit();
            return invoiceId;
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(oldAutoCommit);
        }
    }

    /**
     * Tự động tạo hóa đơn cho một cuộc hẹn dựa trên: - Dịch vụ chính từ
     * Appointment.type -> ServiceList.name - Thuốc từ các Prescription thuộc
     * các MedicalRecord của cuộc hẹn đó Lễ tân không cần chọn tay từng dịch
     * vụ/thuốc.
     */
    public Integer autoCreateInvoiceForAppointment(int apptId, int recepId) throws SQLException {
        // Không tạo trùng hóa đơn cho cùng 1 cuộc hẹn
        if (getInvoiceByAppointment(apptId) != null) {
            return null;
        }

        List<InvoiceDetail> autoDetails = new ArrayList<>();

        // 1. Lấy thông tin loại dịch vụ từ Appointment
        String apptSql = "SELECT type FROM Appointment WHERE appt_id = ?";
        String apptType = null;
        try (PreparedStatement st = connection.prepareStatement(apptSql)) {
            st.setInt(1, apptId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    apptType = rs.getString("type");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error autoCreateInvoiceForAppointment - load appointment: " + e.getMessage());
        }

        boolean hasMainService = false;

        // 2. Map Appointment.type -> ServiceList (dịch vụ chính) nếu có
        if (apptType != null && !apptType.trim().isEmpty()) {
            String serviceSql = "SELECT service_id FROM ServiceList WHERE name = ? AND is_active = 1";
            try (PreparedStatement st = connection.prepareStatement(serviceSql)) {
                st.setString(1, apptType);
                try (ResultSet rs = st.executeQuery()) {
                    if (rs.next()) {
                        InvoiceDetail serviceDetail = new InvoiceDetail();
                        serviceDetail.setServiceId(rs.getInt("service_id"));
                        serviceDetail.setItemType("Service");
                        serviceDetail.setQuantity(1); // 1 lần dịch vụ chính cho cuộc hẹn
                        autoDetails.add(serviceDetail);
                        hasMainService = true;
                    }
                }
            } catch (SQLException e) {
                System.out.println("Error autoCreateInvoiceForAppointment - load main service: " + e.getMessage());
            }
        }

        // 2b. Nếu không map được theo type, fallback: lấy dịch vụ active đầu tiên làm dịch vụ chính
        if (!hasMainService) {
            String fallbackSql = "SELECT TOP 1 service_id FROM ServiceList WHERE is_active = 1 ORDER BY service_id ASC";
            try (PreparedStatement st = connection.prepareStatement(fallbackSql); ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    InvoiceDetail serviceDetail = new InvoiceDetail();
                    serviceDetail.setServiceId(rs.getInt("service_id"));
                    serviceDetail.setItemType("Service");
                    serviceDetail.setQuantity(1);
                    autoDetails.add(serviceDetail);
                    hasMainService = true;
                }
            } catch (SQLException e) {
                System.out.println("Error autoCreateInvoiceForAppointment - fallback main service: " + e.getMessage());
            }
        }

        // 3. Thêm thuốc từ Prescription của cuộc hẹn (tính tiền thuốc)
        String medSql = "SELECT p.medicine_id, SUM(p.quantity) AS total_qty "
                + "FROM Prescription p "
                + "JOIN MedicalRecord mr ON p.record_id = mr.record_id "
                + "WHERE mr.appt_id = ? "
                + "GROUP BY p.medicine_id";
        try (PreparedStatement st = connection.prepareStatement(medSql)) {
            st.setInt(1, apptId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    int medicineId = rs.getInt("medicine_id");
                    int qty = rs.getInt("total_qty");
                    if (qty <= 0) {
                        continue;
                    }
                    InvoiceDetail medDetail = new InvoiceDetail();
                    medDetail.setMedicineId(medicineId);
                    medDetail.setItemType("Medicine");
                    medDetail.setQuantity(qty);
                    autoDetails.add(medDetail);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error autoCreateInvoiceForAppointment - load medicines: " + e.getMessage());
        }

        // Nếu không có bất kỳ dịch vụ nào thì không tạo hóa đơn
        if (autoDetails.isEmpty()) {
            return null;
        }

        // Tái sử dụng logic transaction đã có
        return createInvoiceForAppointment(apptId, recepId, autoDetails);
    }

    public Invoice getInvoiceByAppointment(int apptId) {
        String sql = "SELECT invoice_id, appt_id, recep_id, total_amount, status "
                + "FROM Invoice WHERE appt_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, apptId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapInvoice(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getInvoiceByAppointment: " + e.getMessage());
        }
        return null;
    }

    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT invoice_id, appt_id, recep_id, total_amount, status "
                + "FROM Invoice WHERE invoice_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, invoiceId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapInvoice(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getInvoiceById: " + e.getMessage());
        }
        return null;
    }

    public List<InvoiceDetail> getDetailsByInvoice(int invoiceId) {
        List<InvoiceDetail> list = new ArrayList<>();
        String sql = "SELECT detail_id, invoice_id, medicine_id, service_id, item_type, quantity, unit_price "
                + "FROM InvoiceDetail WHERE invoice_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, invoiceId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    InvoiceDetail d = new InvoiceDetail();
                    d.setDetailId(rs.getInt("detail_id"));
                    d.setInvoiceId(rs.getInt("invoice_id"));
                    int med = rs.getInt("medicine_id");
                    d.setMedicineId(rs.wasNull() ? null : med);
                    int svc = rs.getInt("service_id");
                    d.setServiceId(rs.wasNull() ? null : svc);
                    d.setItemType(rs.getString("item_type"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setUnitPrice(rs.getDouble("unit_price"));
                    list.add(d);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getDetailsByInvoice: " + e.getMessage());
        }
        return list;
    }

    public boolean updateStatus(int invoiceId, String status) {
        String sql = "UPDATE Invoice SET status = ? WHERE invoice_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setInt(2, invoiceId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateStatus Invoice: " + e.getMessage());
            return false;
        }
    }

    private Invoice mapInvoice(ResultSet rs) throws SQLException {
        Invoice inv = new Invoice();
        inv.setInvoiceId(rs.getInt("invoice_id"));
        inv.setApptId(rs.getInt("appt_id"));
        inv.setRecepId(rs.getInt("recep_id"));
        inv.setTotalAmount(rs.getDouble("total_amount"));
        inv.setStatus(rs.getString("status"));
        return inv;
    }

public List<Invoice> getInvoicesByOwnerId(int ownerId) {
    List<Invoice> list = new ArrayList<>();

    String sql = """
        SELECT i.invoice_id, i.appt_id, i.recep_id,
               i.total_amount, i.status
        FROM Invoice i
        JOIN Appointment a ON i.appt_id = a.appt_id
        JOIN Pet p ON a.pet_id = p.pet_id
        WHERE p.owner_id = ?
        ORDER BY i.invoice_id DESC
    """;

    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, ownerId);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapInvoice(rs));
            }
        }
    } catch (SQLException e) {
        System.out.println("Error getInvoicesByOwnerId: " + e.getMessage());
    }

    return list;
}
}