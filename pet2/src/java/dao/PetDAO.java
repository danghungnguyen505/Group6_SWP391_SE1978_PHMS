/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author quag
 */
import model.MedicalRecord;
import model.Pet;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PetDAO extends DBContext {

    public List<Pet> getPetsByOwner(int ownerId) {
        List<Pet> list = new ArrayList<>();
        String sql = "SELECT pet_id, name, species, history_summary FROM Pet WHERE owner_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Pet(
                        rs.getInt("pet_id"),
                        rs.getString("name"),
                        rs.getString("species"),
                        rs.getString("history_summary")
                ));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public Pet getPetById(int id) {
        String sql = "SELECT pet_id, name, species, history_summary FROM Pet WHERE pet_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Pet(
                        rs.getInt("pet_id"),
                        rs.getString("name"),
                        rs.getString("species"),
                        rs.getString("history_summary")
                );
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public List<MedicalRecord> getEMRByPetId(int petId) {
        List<MedicalRecord> list = new ArrayList<>();
        // Query này join MedicalRecord -> Appointment -> Veterinarian -> Employee -> User để lấy tên bác sĩ
        String sql = "SELECT m.record_id, a.start_time, m.diagnosis, m.treatment_plan, u.full_name as vet_name "
                + "FROM MedicalRecord m "
                + "JOIN Appointment a ON m.appt_id = a.appt_id "
                + "LEFT JOIN Veterinarian v ON a.vet_id = v.emp_id "
                + "LEFT JOIN Employee e ON v.emp_id = e.user_id "
                + "LEFT JOIN Users u ON e.user_id = u.user_id "
                + "WHERE a.pet_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, petId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new MedicalRecord(
                        rs.getInt("record_id"),
                        rs.getTimestamp("start_time"), // Lấy từ SQL
                        rs.getString("diagnosis"),
                        rs.getString("treatment_plan"), // Lấy từ SQL
                        rs.getString("full_name")
                ));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public void addPet(Pet p, int ownerId) {
        String sql = "INSERT INTO Pet (owner_id, name, species, history_summary) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            st.setString(2, p.getName());
            st.setString(3, p.getSpecies());
            st.setString(4, p.getHistorySummary());
            // Lưu ý: Mình tạm bỏ qua Weight/DOB/Gender để code đơn giản, bạn có thể tự thêm nếu muốn
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void updatePet(Pet p) {
        String sql = "UPDATE Pet SET name=?, species=?, history_summary=? WHERE pet_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, p.getName());
            st.setString(2, p.getSpecies());
            st.setString(3, p.getHistorySummary());
            st.setInt(4, p.getPetId());
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void deletePet(int id) {
        String sql = "DELETE FROM Pet WHERE pet_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Lỗi xóa: Có thể do dính khóa ngoại với bảng khác. " + e);
        }
    }
    
    public List<Pet> searchPets(int ownerId, String keyword) {
        List<Pet> list = new ArrayList<>();
        String sql = "SELECT pet_id, name, species, history_summary FROM Pet WHERE owner_id = ? AND name LIKE ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            st.setString(2, "%" + keyword + "%"); // Thêm dấu % để tìm kiếm chứa chuỗi
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Pet(
                    rs.getInt("pet_id"),
                    rs.getString("name"),
                    rs.getString("species"),
                    rs.getString("history_summary")
                ));
            }
        } catch (Exception e) {
            System.out.println("Error search: " + e);
        }
        return list;
    }
}
