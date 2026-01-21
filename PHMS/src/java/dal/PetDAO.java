package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Pet;

public class PetDAO extends DBContext {

    public List<Pet> getPetsByOwnerId(int ownerId) {
        List<Pet> pets = new ArrayList<>();
        String sql = "SELECT pet_id, owner_id, name, species, history_summary FROM Pet WHERE owner_id = ?";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            rs = st.executeQuery();
            while (rs.next()) {
                Pet pet = new Pet();
                pet.setPetId(rs.getInt("pet_id"));
                pet.setOwnerId(rs.getInt("owner_id"));
                pet.setName(rs.getString("name"));
                pet.setSpecies(rs.getString("species"));
                pet.setHistorySummary(rs.getString("history_summary"));
                pets.add(pet);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getPetsByOwnerId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return pets;
    }

    public Pet getPetById(int petId) {
        String sql = "SELECT pet_id, owner_id, name, species, history_summary FROM Pet WHERE pet_id = ?";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql);
            st.setInt(1, petId);
            rs = st.executeQuery();
            if (rs.next()) {
                Pet pet = new Pet();
                pet.setPetId(rs.getInt("pet_id"));
                pet.setOwnerId(rs.getInt("owner_id"));
                pet.setName(rs.getString("name"));
                pet.setSpecies(rs.getString("species"));
                pet.setHistorySummary(rs.getString("history_summary"));
                return pet;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getPetById: " + e.getMessage());
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
