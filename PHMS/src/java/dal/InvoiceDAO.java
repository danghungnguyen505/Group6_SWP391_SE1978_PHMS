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
        String sql = "UPDATE Invoice SET status = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
