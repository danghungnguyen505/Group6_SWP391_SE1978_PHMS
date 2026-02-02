package dal;

import model.Invoice;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class InvoiceDAO extends DBContext {

   public Invoice getInvoiceById(int id) {
    String sql = "SELECT * FROM Invoice WHERE invoice_id = ?";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Invoice i = new Invoice();
            i.setInvoiceId(rs.getInt("invoice_id"));
            i.setApptId(rs.getInt("appt_id"));
            i.setRecepId(rs.getInt("recep_id"));
            i.setTotalAmount(rs.getDouble("total_amount"));
            i.setStatus(rs.getString("status"));
            return i;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}


    public void updateInvoiceStatus(int id, String status) {
       String sql = "UPDATE Invoice SET status = ? WHERE invoice_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public Invoice getInvoiceFull(int invoiceId) {
    String sql = """
        SELECT i.*, 
               u.full_name AS owner_name,
               p.name AS pet_name
        FROM Invoice i
        JOIN Appointment a ON i.appt_id = a.appt_id
        JOIN Pet p ON a.pet_id = p.pet_id
        JOIN PetOwner po ON p.owner_id = po.user_id
        JOIN Users u ON po.user_id = u.user_id
        WHERE i.invoice_id = ?
    """;

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, invoiceId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Invoice i = new Invoice();
            i.setInvoiceId(rs.getInt("invoice_id"));
            i.setTotalAmount(rs.getDouble("total_amount"));
            i.setStatus(rs.getString("status"));
            i.setOwnerName(rs.getString("owner_name"));
            i.setPetName(rs.getString("pet_name"));
            return i;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
    public Integer getLatestInvoiceIdByOwner(int ownerId) {
    String sql = """
        SELECT TOP 1 i.invoice_id
        FROM Invoice i
        JOIN Appointment a ON i.appt_id = a.appt_id
        JOIN Pet p ON a.pet_id = p.pet_id
        WHERE p.owner_id = ?
        ORDER BY i.invoice_id DESC
    """;

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, ownerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt("invoice_id");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
public void updateTotalAmount(int invoiceId, double total) {
    String sql = "UPDATE Invoice SET total_amount = ? WHERE invoice_id = ?";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setDouble(1, total);
        ps.setInt(2, invoiceId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

}
