package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Veterinarian;

public class VeterinarianDAO extends DBContext {

    public List<Veterinarian> getAllVeterinarians() {
        List<Veterinarian> vets = new ArrayList<>();
        String sql = "SELECT v.emp_id, u.full_name, v.license_number, v.specialization "
                + "FROM Veterinarian v "
                + "INNER JOIN Employee e ON v.emp_id = e.user_id "
                + "INNER JOIN Users u ON e.user_id = u.user_id";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            rs = st.executeQuery();
            while (rs.next()) {
                Veterinarian vet = new Veterinarian();
                vet.setEmpId(rs.getInt("emp_id"));
                vet.setFullName(rs.getString("full_name"));
                vet.setLicenseNumber(rs.getString("license_number"));
                vet.setSpecialization(rs.getString("specialization"));
                vets.add(vet);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAllVeterinarians: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return vets;
    }

    public Veterinarian getVeterinarianById(int vetId) {
        String sql = "SELECT v.emp_id, u.full_name, v.license_number, v.specialization "
                + "FROM Veterinarian v "
                + "INNER JOIN Employee e ON v.emp_id = e.user_id "
                + "INNER JOIN Users u ON e.user_id = u.user_id "
                + "WHERE v.emp_id = ?";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            st.setInt(1, vetId);
            rs = st.executeQuery();
            if (rs.next()) {
                Veterinarian vet = new Veterinarian();
                vet.setEmpId(rs.getInt("emp_id"));
                vet.setFullName(rs.getString("full_name"));
                vet.setLicenseNumber(rs.getString("license_number"));
                vet.setSpecialization(rs.getString("specialization"));
                return vet;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getVeterinarianById: " + e.getMessage());
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
