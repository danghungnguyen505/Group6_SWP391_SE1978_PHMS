package dal;

import model.Payment;
import java.sql.PreparedStatement;

public class PaymentDAO extends DBContext {

   public void insertPayment(Payment p) {
    String sql = """
        INSERT INTO Payment (invoice_id, trans_code, amount, method, status)
        VALUES (?, ?, ?, ?, ?)
        """;
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, p.getInvoiceId());
        ps.setString(2, p.getTransCode());
        ps.setDouble(3, p.getAmount());
        ps.setString(4, p.getMethod());
        ps.setString(5, p.getStatus());
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

}
