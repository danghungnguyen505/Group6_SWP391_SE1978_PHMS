/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Service;

/**
 *
 * @author Nguyen Dang Hung
 */
public class ServiceDAO extends DBContext {

    public List<Service> getAllActiveServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, name, base_price, description, is_active FROM ServiceList WHERE is_active = 1 ORDER BY service_id DESC";
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
                if (rs != null) {
                    rs.close();
                }
                if (st != null) {
                    st.close();
                }
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return services;
    }

    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT service_id, name, base_price, description, is_active, managed_by FROM ServiceList ORDER BY service_id DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Service(
                        rs.getInt("service_id"),
                        rs.getString("name"),
                        rs.getDouble("base_price"),
                        rs.getString("description"),
                        rs.getBoolean("is_active"),
                        rs.getInt("managed_by")
                ));
            }
        } catch (Exception e) {
            System.out.println("Error getAllServices: " + e.getMessage());
        }
        return list;
    }

    public void addService(Service s) throws Exception { 
        String sql = "INSERT INTO ServiceList (name, base_price, description, is_active, managed_by) VALUES (?, ?, ?, 1, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setDouble(2, s.getBasePrice());
            ps.setString(3, s.getDescription());
            ps.setInt(4, s.getManageBy());
            ps.executeUpdate();
        } 
    }

    public void updateService(Service s) {
        String sql = "UPDATE ServiceList SET name = ?, base_price = ?, description = ?, managed_by = ? WHERE service_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, s.getName());
            ps.setDouble(2, s.getBasePrice());
            ps.setString(3, s.getDescription());
            ps.setInt(4, s.getManageBy());
            ps.setInt(5, s.getServiceId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void toggleServiceStatus(int id, boolean currentStatus) {
        String sql = "UPDATE ServiceList SET is_active = ? WHERE service_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, !currentStatus);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Service getServiceById(int id) {
        String sql = "SELECT * FROM ServiceList WHERE service_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Service(
                        rs.getInt("service_id"),
                        rs.getString("name"),
                        rs.getDouble("base_price"),
                        rs.getString("description"),
                        rs.getBoolean("is_active"),
                        rs.getInt("managed_by")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get active service by its name (used for invoice preview mapping from
     * Appointment.type).
     */
    public Service getActiveServiceByName(String name) {
        String sql = "SELECT service_id, name, base_price, description, is_active, managed_by "
                + "FROM ServiceList WHERE name = ? AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Service(
                            rs.getInt("service_id"),
                            rs.getString("name"),
                            rs.getDouble("base_price"),
                            rs.getString("description"),
                            rs.getBoolean("is_active"),
                            rs.getInt("managed_by")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getActiveServiceByName: " + e.getMessage());
        }
        return null;
    }

    /**
     * Fallback: lấy 1 dịch vụ active đầu tiên.
     */
    public Service getFirstActiveService() {
        String sql = "SELECT TOP 1 service_id, name, base_price, description, is_active, managed_by "
                + "FROM ServiceList WHERE is_active = 1 ORDER BY service_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new Service(
                        rs.getInt("service_id"),
                        rs.getString("name"),
                        rs.getDouble("base_price"),
                        rs.getString("description"),
                        rs.getBoolean("is_active"),
                        rs.getInt("managed_by")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getFirstActiveService: " + e.getMessage());
        }
        return null;
    }

    /**
     * Check if a service name already exists (case-insensitive).
     */
    public boolean existsByName(String name) {
        String sql = "SELECT service_id FROM ServiceList WHERE LOWER(name) = LOWER(?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.out.println("Error existsByName: " + e.getMessage());
        }
        return false;
    }

    /**
     * Check if a service name already exists for another service (used when editing).
     */
    public boolean existsByNameForOther(int serviceId, String name) {
        String sql = "SELECT service_id FROM ServiceList WHERE LOWER(name) = LOWER(?) AND service_id <> ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.out.println("Error existsByNameForOther: " + e.getMessage());
        }
        return false;
    }
}
