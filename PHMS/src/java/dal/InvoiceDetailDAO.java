package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.InvoiceDetail;

public class InvoiceDetailDAO extends DBContext {

    public List<InvoiceDetail> getByInvoiceId(int invoiceId) {
        List<InvoiceDetail> list = new ArrayList<>();

        String sql =
            "SELECT d.*, s.name AS service_name " +
            "FROM InvoiceDetail d " +
            "LEFT JOIN ServiceList s ON d.service_id = s.service_id " +
            "WHERE d.invoice_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();

         while (rs.next()) {
    InvoiceDetail d = new InvoiceDetail();
    d.setDetailId(rs.getInt("detail_id"));
    d.setItemType(rs.getString("item_type"));
    d.setQuantity(rs.getInt("quantity"));
    d.setUnitPrice(rs.getDouble("unit_price"));
    d.setServiceName(rs.getString("service_name"));

    double subtotal = rs.getDouble("unit_price") * rs.getInt("quantity");
    d.setSubtotal(subtotal);

    list.add(d);
}

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
   public double calculateTotalByInvoiceId(int invoiceId) {
    String sql = "SELECT SUM(unit_price * quantity) FROM InvoiceDetail WHERE invoice_id = ?";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, invoiceId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getDouble(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}


}
