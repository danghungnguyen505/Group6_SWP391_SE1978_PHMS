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
import model.Pet;

/**
 *
 * @author zoxy4
 */
public class PetDAO extends DBContext{
    // 1. Lấy danh sách thú cưng của một chủ sở hữu (Dùng cho Booking & Dashboard)
    public List<Pet> getPetsByOwnerId(int ownerId) {
        List<Pet> list = new ArrayList<>();
        String sql = "SELECT * FROM Pet WHERE owner_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Pet p = new Pet(
                    rs.getInt("pet_id"),
                    rs.getInt("owner_id"),
                    rs.getString("name"),
                    rs.getString("species"),
                    rs.getString("history_summary")
                );
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Error getPetsByOwnerId: " + e);
        }
        return list;
    }
    // 2. Lấy thông tin chi tiết 1 thú cưng theo ID (Dùng khi xem chi tiết hoặc sửa)
    public Pet getPetById(int petId) {
        String sql = "SELECT * FROM Pet WHERE pet_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, petId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Pet(
                    rs.getInt("pet_id"),
                    rs.getInt("owner_id"),
                    rs.getString("name"),
                    rs.getString("species"),
                    rs.getString("history_summary")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getPetById: " + e);
        }
        return null;
    }
    // 3. Thêm thú cưng mới (Add New Pet)
    public boolean addPet(int ownerId, String name, String species, String history) {
        String sql = "INSERT INTO Pet (owner_id, name, species, history_summary) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            st.setString(2, name);
            st.setString(3, species);
            st.setString(4, history);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error addPet: " + e);
        }
        return false;
    }
    // 4. Cập nhật thông tin thú cưng (Update Pet Info)
    public boolean updatePet(Pet p) {
        String sql = "UPDATE Pet SET name = ?, species = ?, history_summary = ? WHERE pet_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, p.getName());
            st.setString(2, p.getSpecies());
            st.setString(3, p.getHistorySummary());
            st.setInt(4, p.getId());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("Error updatePet: " + e);
        }
        return false;
    }
    // 5. Xóa thú cưng (Delete Pet)
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
    
    // Hàm main để test thử DAO 
//    public static void main(String[] args) {
//        PetDAO dao = new PetDAO();
//        int ownerIdTest = 5; 
//        System.out.println("Danh sách thú cưng của User ID " + ownerIdTest + ":");
//        List<Pet> list = dao.getPetsByOwnerId(ownerIdTest);
//        
//        for (Pet p : list) {
//            System.out.println("- " + p.getName() + " (" + p.getSpecies() + ")");
//        }
//    }
}
