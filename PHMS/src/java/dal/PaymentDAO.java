package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Payment;

/**
 * DAO for Payment table.
 */
public class PaymentDAO extends DBContext {

    public boolean createPayment(int invoiceId, double amount, String method, String status, String transCode) {
        String sql = "INSERT INTO Payment (invoice_id, trans_code, amount, method, status) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, invoiceId);
            st.setString(2, transCode);
            st.setDouble(3, amount);
            st.setString(4, method);
            st.setString(5, status);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error createPayment: " + e.getMessage());
            return false;
        }
    }

    public List<Payment> getPaymentsByInvoice(int invoiceId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT payment_id, invoice_id, trans_code, amount, method, status "
                   + "FROM Payment WHERE invoice_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, invoiceId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setInvoiceId(rs.getInt("invoice_id"));
                    p.setTransCode(rs.getString("trans_code"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setMethod(rs.getString("method"));
                    p.setStatus(rs.getString("status"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getPaymentsByInvoice: " + e.getMessage());
        }
        return list;
    }
}

