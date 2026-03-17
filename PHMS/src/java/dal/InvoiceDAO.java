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
import model.TriageRecord;

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
        // First try to auto-create invoice with details (same logic as autoCreateInvoiceForAppointment)
        // This ensures InvoiceDetail records are created
        try {
            Integer invoiceId = autoCreateInvoiceForAppointment(apptId, recepId);
            if (invoiceId != null && invoiceId > 0) {
                return invoiceId;
            }
        } catch (SQLException e) {
            System.out.println("Error autoCreateInvoiceForAppointment in createInvoice: " + e.getMessage());
            // Fallback to simple invoice creation if auto-create fails
        }

        // Fallback: simple invoice creation without details (legacy behavior)
        String sql = "INSERT INTO Invoice (appt_id, recep_id, total_amount, status, created_at) VALUES (?, ?, ?, 'Unpaid', GETDATE())";
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

        String insertInvoiceSql = "INSERT INTO Invoice (appt_id, recep_id, total_amount, status, created_at) "
                + "VALUES (?, ?, 0, 'Unpaid', GETDATE())";
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
        ServiceDAO serviceDAO = new ServiceDAO();

        // 2. For emergency (Urgent) appointments, use triage level to find the correct service
        if ("Urgent".equalsIgnoreCase(apptType)) {
            TriageRecordDAO triageDAO = new TriageRecordDAO();
            TriageRecord triage = triageDAO.getByAppointment(apptId);
            if (triage != null && triage.getConditionLevel() != null) {
                Service triageService = serviceDAO.getServiceByTriageLevel(triage.getConditionLevel());
                if (triageService != null) {
                    InvoiceDetail serviceDetail = new InvoiceDetail();
                    serviceDetail.setServiceId(triageService.getServiceId());
                    serviceDetail.setItemType("Service");
                    serviceDetail.setQuantity(1);
                    autoDetails.add(serviceDetail);
                    hasMainService = true;
                }
            }
        }

        // 2b. For non-emergency or if triage lookup failed, try matching by appointment type name
        if (!hasMainService && apptType != null && !apptType.trim().isEmpty()) {
            Service svc = serviceDAO.getActiveServiceByName(apptType);
            if (svc == null) {
                svc = serviceDAO.getActiveServiceByNameLike(apptType);
            }
            if (svc != null) {
                InvoiceDetail serviceDetail = new InvoiceDetail();
                serviceDetail.setServiceId(svc.getServiceId());
                serviceDetail.setItemType("Service");
                serviceDetail.setQuantity(1);
                autoDetails.add(serviceDetail);
                hasMainService = true;
            }
        }

        // 2c. Final fallback: first active service
        if (!hasMainService) {
            Service fallback = serviceDAO.getFirstActiveService();
            if (fallback != null) {
                InvoiceDetail serviceDetail = new InvoiceDetail();
                serviceDetail.setServiceId(fallback.getServiceId());
                serviceDetail.setItemType("Service");
                serviceDetail.setQuantity(1);
                autoDetails.add(serviceDetail);
                hasMainService = true;
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
        // JOIN with ServiceList and Medicine to get names
        String sql = "SELECT d.detail_id, d.invoice_id, d.medicine_id, d.service_id, d.item_type, d.quantity, d.unit_price, "
                + "       s.name AS service_name, m.name AS medicine_name "
                + "FROM InvoiceDetail d "
                + "LEFT JOIN ServiceList s ON d.service_id = s.service_id "
                + "LEFT JOIN Medicine m ON d.medicine_id = m.medicine_id "
                + "WHERE d.invoice_id = ?";
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
                    // Set display names
                    d.setServiceName(rs.getString("service_name"));
                    d.setMedicineName(rs.getString("medicine_name"));
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

    /**
     * Tái tạo InvoiceDetail cho hóa đơn cũ (dùng khi hóa đơn không có chi tiết)
     */
    public boolean regenerateInvoiceDetails(int invoiceId) {
        // Lấy apptId từ invoice
        Invoice inv = getInvoiceById(invoiceId);
        if (inv == null) {
            return false;
        }
        int apptId = inv.getApptId();

        // Lấy appointment type
        String apptType = null;
        String apptSql = "SELECT type FROM Appointment WHERE appt_id = ?";
        try (PreparedStatement st = connection.prepareStatement(apptSql)) {
            st.setInt(1, apptId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    apptType = rs.getString("type");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error regenerateInvoiceDetails - load appointment: " + e.getMessage());
            return false;
        }

        if (apptType == null) {
            return false;
        }

        ServiceDAO serviceDAO = new ServiceDAO();
        Service mainService = null;

        // Tìm service theo triage (cho cấp cứu) hoặc type name
        if ("Urgent".equalsIgnoreCase(apptType)) {
            TriageRecordDAO triageDAO = new TriageRecordDAO();
            TriageRecord triage = triageDAO.getByAppointment(apptId);
            if (triage != null && triage.getConditionLevel() != null) {
                mainService = serviceDAO.getServiceByTriageLevel(triage.getConditionLevel());
            }
        }
        if (mainService == null) {
            mainService = serviceDAO.getActiveServiceByName(apptType);
            if (mainService == null) {
                mainService = serviceDAO.getActiveServiceByNameLike(apptType);
            }
        }
        if (mainService == null) {
            mainService = serviceDAO.getFirstActiveService();
        }

        // Xóa details cũ và thêm mới
        String deleteSql = "DELETE FROM InvoiceDetail WHERE invoice_id = ?";
        String insertSql = "INSERT INTO InvoiceDetail (invoice_id, medicine_id, service_id, item_type, quantity, unit_price) VALUES (?, NULL, ?, 'Service', 1, ?)";

        try {
            // Xóa details cũ
            try (PreparedStatement st = connection.prepareStatement(deleteSql)) {
                st.setInt(1, invoiceId);
                st.executeUpdate();
            }

            // Thêm service mới
            if (mainService != null) {
                try (PreparedStatement st = connection.prepareStatement(insertSql)) {
                    st.setInt(1, invoiceId);
                    st.setInt(2, mainService.getServiceId());
                    st.setDouble(3, mainService.getBasePrice());
                    st.executeUpdate();
                }
            }

            // Cập nhật total amount
            double total = mainService != null ? mainService.getBasePrice() : 0;
            String updateTotal = "UPDATE Invoice SET total_amount = ? WHERE invoice_id = ?";
            try (PreparedStatement st = connection.prepareStatement(updateTotal)) {
                st.setDouble(1, total);
                st.setInt(2, invoiceId);
                st.executeUpdate();
            }

            return true;
        } catch (SQLException e) {
            System.out.println("Error regenerateInvoiceDetails: " + e.getMessage());
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
}
