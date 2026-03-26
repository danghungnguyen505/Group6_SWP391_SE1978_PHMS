package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Service;

/**
 * Service DAO.
 */
public class ServiceDAO extends DBContext {

    private boolean hasTypeColumn() {
        String sql = "SELECT COL_LENGTH('ServiceList', 'type') AS col_len";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getObject("col_len") != null;
            }
        } catch (SQLException e) {
            System.out.println("Error hasTypeColumn: " + e.getMessage());
        }
        return false;
    }

    public List<Service> getAllActiveServices() {
        List<Service> services = new ArrayList<>();
        boolean withType = hasTypeColumn();
        String sql = withType
                ? "SELECT service_id, name, [type], base_price, description, is_active FROM ServiceList WHERE is_active = 1 ORDER BY service_id DESC"
                : "SELECT service_id, name, base_price, description, is_active FROM ServiceList WHERE is_active = 1 ORDER BY service_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setName(rs.getString("name"));
                service.setType(withType ? rs.getString("type") : "Basic");
                service.setBasePrice(rs.getDouble("base_price"));
                service.setDescription(rs.getString("description"));
                service.setActive(rs.getBoolean("is_active"));
                services.add(service);
            }
        } catch (SQLException e) {
            System.out.println("Error getAllActiveServices: " + e.getMessage());
        }
        return services;
    }

    public List<Service> getAllActiveServicesByType(String type) {
        List<Service> services = new ArrayList<>();
        if (type == null || type.trim().isEmpty()) {
            return services;
        }

        boolean withType = hasTypeColumn();
        if (!withType) {
            if ("basic".equalsIgnoreCase(type.trim())) {
                return getAllActiveServices();
            }
            return services;
        }

        String sql = "SELECT service_id, name, [type], base_price, description, is_active "
                + "FROM ServiceList "
                + "WHERE is_active = 1 "
                + "  AND UPPER(LTRIM(RTRIM(COALESCE([type], '')))) = UPPER(?) "
                + "ORDER BY service_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, type.trim());
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Service service = new Service();
                    service.setServiceId(rs.getInt("service_id"));
                    service.setName(rs.getString("name"));
                    service.setType(rs.getString("type"));
                    service.setBasePrice(rs.getDouble("base_price"));
                    service.setDescription(rs.getString("description"));
                    service.setActive(rs.getBoolean("is_active"));
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getAllActiveServicesByType: " + e.getMessage());
        }
        return services;
    }

    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        boolean withType = hasTypeColumn();
        String sql = withType
                ? "SELECT service_id, name, [type], base_price, description, is_active, managed_by FROM ServiceList ORDER BY service_id DESC"
                : "SELECT service_id, name, base_price, description, is_active, managed_by FROM ServiceList ORDER BY service_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Service(
                        rs.getInt("service_id"),
                        rs.getString("name"),
                        withType ? rs.getString("type") : "Basic",
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
        boolean withType = hasTypeColumn();
        String sql = withType
                ? "INSERT INTO ServiceList (name, [type], base_price, description, is_active, managed_by) VALUES (?, ?, ?, ?, 1, ?)"
                : "INSERT INTO ServiceList (name, base_price, description, is_active, managed_by) VALUES (?, ?, ?, 1, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            if (withType) {
                ps.setString(2, s.getType() != null ? s.getType() : "Basic");
                ps.setDouble(3, s.getBasePrice());
                ps.setString(4, s.getDescription());
                ps.setInt(5, s.getManageBy());
            } else {
                ps.setDouble(2, s.getBasePrice());
                ps.setString(3, s.getDescription());
                ps.setInt(4, s.getManageBy());
            }
            ps.executeUpdate();
        }
    }

    public void updateService(Service s) {
        boolean withType = hasTypeColumn();
        String sql = withType
                ? "UPDATE ServiceList SET name = ?, [type] = ?, base_price = ?, description = ?, managed_by = ? WHERE service_id = ?"
                : "UPDATE ServiceList SET name = ?, base_price = ?, description = ?, managed_by = ? WHERE service_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            if (withType) {
                ps.setString(2, s.getType() != null ? s.getType() : "Basic");
                ps.setDouble(3, s.getBasePrice());
                ps.setString(4, s.getDescription());
                ps.setInt(5, s.getManageBy());
                ps.setInt(6, s.getServiceId());
            } else {
                ps.setDouble(2, s.getBasePrice());
                ps.setString(3, s.getDescription());
                ps.setInt(4, s.getManageBy());
                ps.setInt(5, s.getServiceId());
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void toggleServiceStatus(int id, boolean currentStatus) {
        String sql = "UPDATE ServiceList SET is_active = ? WHERE service_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, !currentStatus);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Service getServiceById(int id) {
        boolean withType = hasTypeColumn();
        String sql = withType
                ? "SELECT service_id, name, [type], base_price, description, is_active, managed_by FROM ServiceList WHERE service_id = ?"
                : "SELECT service_id, name, base_price, description, is_active, managed_by FROM ServiceList WHERE service_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Service(
                            rs.getInt("service_id"),
                            rs.getString("name"),
                            withType ? rs.getString("type") : "Basic",
                            rs.getDouble("base_price"),
                            rs.getString("description"),
                            rs.getBoolean("is_active"),
                            rs.getInt("managed_by")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Service getActiveServiceByName(String name) {
        boolean withType = hasTypeColumn();
        String sql = withType
                ? "SELECT service_id, name, [type], base_price, description, is_active, managed_by FROM ServiceList WHERE name = ? AND is_active = 1"
                : "SELECT service_id, name, base_price, description, is_active, managed_by FROM ServiceList WHERE name = ? AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Service(
                            rs.getInt("service_id"),
                            rs.getString("name"),
                            withType ? rs.getString("type") : "Basic",
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

    public Service getActiveServiceByNameAndType(String name, String type) {
        if (name == null || name.trim().isEmpty() || type == null || type.trim().isEmpty()) {
            return null;
        }
        boolean withType = hasTypeColumn();
        String sql = withType
                ? "SELECT service_id, name, [type], base_price, description, is_active, managed_by "
                + "FROM ServiceList "
                + "WHERE name = ? AND is_active = 1 "
                + "  AND UPPER(LTRIM(RTRIM(COALESCE([type], '')))) = UPPER(?)"
                : "SELECT service_id, name, base_price, description, is_active, managed_by "
                + "FROM ServiceList WHERE name = ? AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            if (withType) {
                ps.setString(2, type.trim());
            } else if (!"basic".equalsIgnoreCase(type.trim())) {
                return null;
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Service(
                            rs.getInt("service_id"),
                            rs.getString("name"),
                            withType ? rs.getString("type") : "Basic",
                            rs.getDouble("base_price"),
                            rs.getString("description"),
                            rs.getBoolean("is_active"),
                            rs.getInt("managed_by")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getActiveServiceByNameAndType: " + e.getMessage());
        }
        return null;
    }

    public Service getActiveServiceByNameLike(String name) {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }
        boolean withType = hasTypeColumn();
        String sql = withType
                ? "SELECT TOP 1 service_id, name, [type], base_price, description, is_active, managed_by FROM ServiceList WHERE is_active = 1 AND name LIKE ? ORDER BY base_price DESC"
                : "SELECT TOP 1 service_id, name, base_price, description, is_active, managed_by FROM ServiceList WHERE is_active = 1 AND name LIKE ? ORDER BY base_price DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Service(
                            rs.getInt("service_id"),
                            rs.getString("name"),
                            withType ? rs.getString("type") : "Basic",
                            rs.getDouble("base_price"),
                            rs.getString("description"),
                            rs.getBoolean("is_active"),
                            rs.getInt("managed_by")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getActiveServiceByNameLike: " + e.getMessage());
        }
        return null;
    }

    public Service getFirstActiveService() {
        boolean withType = hasTypeColumn();
        String sql = withType
                ? "SELECT TOP 1 service_id, name, [type], base_price, description, is_active, managed_by FROM ServiceList WHERE is_active = 1 ORDER BY service_id ASC"
                : "SELECT TOP 1 service_id, name, base_price, description, is_active, managed_by FROM ServiceList WHERE is_active = 1 ORDER BY service_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new Service(
                        rs.getInt("service_id"),
                        rs.getString("name"),
                        withType ? rs.getString("type") : "Basic",
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

    public Service getFirstActiveServiceByType(String type) {
        if (type == null || type.trim().isEmpty() || !hasTypeColumn()) {
            return null;
        }
        String sql = "SELECT TOP 1 service_id, name, [type], base_price, description, is_active, managed_by "
                + "FROM ServiceList "
                + "WHERE is_active = 1 AND UPPER(LTRIM(RTRIM(COALESCE([type], '')))) = UPPER(?) "
                + "ORDER BY service_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Service(
                            rs.getInt("service_id"),
                            rs.getString("name"),
                            rs.getString("type"),
                            rs.getDouble("base_price"),
                            rs.getString("description"),
                            rs.getBoolean("is_active"),
                            rs.getInt("managed_by")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getFirstActiveServiceByType: " + e.getMessage());
        }
        return null;
    }

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

    public Service getServiceByTriageLevel(String conditionLevel) {
        if (conditionLevel == null || conditionLevel.trim().isEmpty()) {
            return null;
        }
        String level = conditionLevel.trim();

        String[] keywords;
        switch (level) {
            case "Critical":
                keywords = new String[]{"Critical", "Emergency", "Urgent"};
                break;
            case "High":
                keywords = new String[]{"Urgent", "Emergency", "Critical"};
                break;
            case "Medium":
                keywords = new String[]{"Emergency", "Urgent"};
                break;
            case "Low":
                keywords = new String[]{"Emergency", "Urgent"};
                break;
            default:
                keywords = new String[]{"Emergency", "Urgent"};
        }

        boolean withType = hasTypeColumn();
        for (String keyword : keywords) {
            String sql = withType
                    ? "SELECT TOP 1 service_id, name, [type], base_price, description, is_active, managed_by "
                    + "FROM ServiceList "
                    + "WHERE is_active = 1 "
                    + "  AND UPPER(LTRIM(RTRIM(COALESCE([type], '')))) = 'EMERGENCY' "
                    + "  AND name LIKE ? "
                    + "ORDER BY service_id ASC"
                    : "SELECT TOP 1 service_id, name, base_price, description, is_active, managed_by FROM ServiceList WHERE is_active = 1 AND name LIKE ? ORDER BY service_id ASC";
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, "%" + keyword + "%");
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return new Service(
                                rs.getInt("service_id"),
                                rs.getString("name"),
                                withType ? rs.getString("type") : "Basic",
                                rs.getDouble("base_price"),
                                rs.getString("description"),
                                rs.getBoolean("is_active"),
                                rs.getInt("managed_by")
                        );
                    }
                }
            } catch (SQLException e) {
                System.out.println("Error getServiceByTriageLevel: " + e.getMessage());
            }
        }

        if (withType) {
            Service emergencyFallback = getFirstActiveServiceByType("Emergency");
            if (emergencyFallback != null) {
                return emergencyFallback;
            }
        }
        return null;
    }
}
