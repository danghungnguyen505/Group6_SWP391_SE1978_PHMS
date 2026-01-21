package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Service;

public class ServiceDAO extends DBContext {

    public List<Service> getAllActiveServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, name, base_price, description, is_active FROM ServiceList WHERE is_active = 1";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            rs = st.executeQuery();
            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setName(rs.getString("name"));
                service.setBasePrice(rs.getDouble("base_price"));
                service.setDescription(rs.getString("description"));
                service.setActive(rs.getBoolean("is_active"));
                services.add(service);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAllActiveServices: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return services;
    }

    public Service getServiceById(int serviceId) {
        String sql = "SELECT service_id, name, base_price, description, is_active FROM ServiceList WHERE service_id = ?";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            st.setInt(1, serviceId);
            rs = st.executeQuery();
            if (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setName(rs.getString("name"));
                service.setBasePrice(rs.getDouble("base_price"));
                service.setDescription(rs.getString("description"));
                service.setActive(rs.getBoolean("is_active"));
                return service;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getServiceById: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return null;
    }
}
