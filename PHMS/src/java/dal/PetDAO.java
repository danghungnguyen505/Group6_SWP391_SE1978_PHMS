/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Pet;

/**
 *
 * @author zoxy4
 */
public class PetDAO extends DBContext {

    // 1. Lấy danh sách thú cưng của một chủ sở hữu
    public List<Pet> getPetsByOwnerId(int ownerId) {
        List<Pet> list = new ArrayList<>();
        String sql = "SELECT * FROM Pet WHERE owner_id = ? ORDER BY pet_id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Pet p = new Pet();
                // Map dữ liệu từ DB (tên cột SQL) vào Object (tên thuộc tính Java)
                p.setId(rs.getInt("pet_id"));
                p.setOwnerId(rs.getInt("owner_id"));
                p.setName(rs.getString("name"));
                p.setSpecies(rs.getString("species"));
                p.setHistorySummary(rs.getString("history_summary"));

                // Các trường mới theo ALTER TABLE
                p.setBreed(rs.getString("breed"));
                p.setWeight(rs.getDouble("weight"));
                p.setBirthDate(rs.getDate("dob")); // LƯU Ý: Trong SQL cột là 'dob'
                p.setGender(rs.getString("gender"));

                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Error getPetsByOwnerId: " + e);
        }
        return list;
    }

    // 2. Lấy thông tin chi tiết 1 thú cưng theo ID
    public Pet getPetById(int petId) {
        String sql = "SELECT * FROM Pet WHERE pet_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, petId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Pet p = new Pet();
                p.setId(rs.getInt("pet_id"));
                p.setOwnerId(rs.getInt("owner_id"));
                p.setName(rs.getString("name"));
                p.setSpecies(rs.getString("species"));
                p.setHistorySummary(rs.getString("history_summary"));

                p.setBreed(rs.getString("breed"));
                p.setWeight(rs.getDouble("weight"));
                p.setBirthDate(rs.getDate("dob")); // Map 'dob' sang birthDate
                p.setGender(rs.getString("gender"));

                return p;
            }
        } catch (SQLException e) {
            System.out.println("Error getPetById: " + e);
        }
        return null;
    }

    // 3. Thêm thú cưng mới 
    public boolean addPet(int ownerId, String name, String species, String history,
            String breed, double weight, Date birthDate, String gender) {

        // Cập nhật câu lệnh SQL khớp với tên cột trong DB
        String sql = "INSERT INTO Pet (owner_id, name, species, history_summary, breed, weight, dob, gender) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            st.setString(2, name);
            st.setString(3, species);
            st.setString(4, history); // Map vào history_summary

            // Set các tham số mới
            st.setString(5, breed);
            st.setDouble(6, weight);
            st.setDate(7, birthDate); // Map vào cột dob
            st.setString(8, gender);

            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error addPet: " + e);
        }
        return false;
    }

    // 4. Cập nhật thông tin thú cưng
    public boolean updatePet(Pet p) {
        String sql = "UPDATE Pet SET name = ?, species = ?, history_summary = ?, "
                + "breed = ?, weight = ?, dob = ?, gender = ? "
                + "WHERE pet_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, p.getName());
            st.setString(2, p.getSpecies());
            st.setString(3, p.getHistorySummary());

            st.setString(4, p.getBreed());
            st.setDouble(5, p.getWeight());
            st.setDate(6, p.getBirthDate()); // Map vào cột dob
            st.setString(7, p.getGender());

            st.setInt(8, p.getId());

            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error updatePet: " + e);
        }
        return false;
    }

    // 5. Xóa thú cưng
    public boolean deletePet(int petId) {
        String sql = "DELETE FROM Pet WHERE pet_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, petId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error deletePet: " + e);
        }
        return false;
    }

    // 6. Tìm kiếm thú cưng (Tìm theo Tên, Loài hoặc Giống)
    public List<Pet> searchPets(int ownerId, String keyword) {
        List<Pet> list = new ArrayList<>();
        String sql = "SELECT * FROM Pet WHERE owner_id = ? AND (name LIKE ? OR species LIKE ? OR breed LIKE ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            String pattern = "%" + keyword + "%";
            st.setString(2, pattern);
            st.setString(3, pattern);
            st.setString(4, pattern);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Pet p = new Pet();
                p.setId(rs.getInt("pet_id"));
                p.setOwnerId(rs.getInt("owner_id"));
                p.setName(rs.getString("name"));
                p.setSpecies(rs.getString("species"));
                p.setHistorySummary(rs.getString("history_summary"));

                p.setBreed(rs.getString("breed"));
                p.setWeight(rs.getDouble("weight"));
                p.setBirthDate(rs.getDate("dob")); // Map 'dob'
                p.setGender(rs.getString("gender"));

                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Error searchPets: " + e);
        }
        return list;
    }
}
