package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Medicine;

/**
 * DAO for Medicine master data.
 */
public class MedicineDAO extends DBContext {

    public List<Medicine> getAllMedicines() {
        List<Medicine> list = new ArrayList<>();
<<<<<<< Updated upstream
        String sql = "SELECT medicine_id, name, unit, price, stock_quantity FROM Medicine";
=======
        String sql = "SELECT medicine_id, name, unit, price, stock_quantity FROM Medicine ORDER BY medicine_id";
>>>>>>> Stashed changes
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Medicine m = new Medicine(
                        rs.getInt("medicine_id"),
                        rs.getString("name"),
                        rs.getString("unit"),
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity")
                );
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println("Error getAllMedicines: " + e.getMessage());
        }
        return list;
    }

    public Medicine getById(int id) {
        String sql = "SELECT medicine_id, name, unit, price, stock_quantity FROM Medicine WHERE medicine_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Medicine(
                            rs.getInt("medicine_id"),
                            rs.getString("name"),
                            rs.getString("unit"),
                            rs.getDouble("price"),
                            rs.getInt("stock_quantity")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getById Medicine: " + e.getMessage());
        }
        return null;
    }
    
    public boolean addMedicine(Medicine m) {
        String sql = "INSERT INTO Medicine (name, unit, price, stock_quantity) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, m.getName());
            st.setString(2, m.getUnit());
            st.setDouble(3, m.getPrice());
            st.setInt(4, m.getStockQuantity());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error addMedicine: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateMedicine(Medicine m) {
        String sql = "UPDATE Medicine SET name = ?, unit = ?, price = ?, stock_quantity = ? WHERE medicine_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, m.getName());
            st.setString(2, m.getUnit());
            st.setDouble(3, m.getPrice());
            st.setInt(4, m.getStockQuantity());
            st.setInt(5, m.getMedicineId());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updateMedicine: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteMedicine(int medicineId) {
        // Check if medicine is used in prescriptions or invoices
        String checkSql = "SELECT COUNT(*) AS cnt FROM Prescription WHERE medicine_id = ? " +
                         "UNION ALL " +
                         "SELECT COUNT(*) FROM InvoiceDetail WHERE medicine_id = ?";
        String deleteSql = "DELETE FROM Medicine WHERE medicine_id = ?";
        
        try {
            // Check usage
            try (PreparedStatement chk = connection.prepareStatement(checkSql)) {
                chk.setInt(1, medicineId);
                chk.setInt(2, medicineId);
                try (ResultSet rs = chk.executeQuery()) {
                    int totalUsage = 0;
                    while (rs.next()) {
                        totalUsage += rs.getInt("cnt");
                    }
                    if (totalUsage > 0) {
                        System.out.println("Cannot delete medicine: still in use");
                        return false;
                    }
                }
            }
            
            // Delete
            try (PreparedStatement del = connection.prepareStatement(deleteSql)) {
                del.setInt(1, medicineId);
                return del.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error deleteMedicine: " + e.getMessage());
            return false;
        }
    }
<<<<<<< Updated upstream
=======

    /**
     * Check if a medicine name already exists (case-insensitive).
     */
    public boolean existsByName(String name) {
        String sql = "SELECT medicine_id FROM Medicine WHERE LOWER(name) = LOWER(?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, name);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.out.println("Error existsByName (Medicine): " + e.getMessage());
        }
        return false;
    }

    /**
     * Check if a medicine name already exists for another medicine (used when editing).
     */
    public boolean existsByNameForOther(int medicineId, String name) {
        String sql = "SELECT medicine_id FROM Medicine WHERE LOWER(name) = LOWER(?) AND medicine_id <> ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, name);
            st.setInt(2, medicineId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.out.println("Error existsByNameForOther (Medicine): " + e.getMessage());
        }
        return false;
    }
>>>>>>> Stashed changes
}

