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
     * Create invoice and details for an appointment.
     * All unit prices are loaded from DB (ServiceList / Medicine), not from client.
     */
    public Integer createInvoiceForAppointment(int apptId, int recepId,
                                               List<InvoiceDetail> details) throws SQLException {
        if (details == null || details.isEmpty()) {
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
                    if (qty <= 0) continue;

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
}

