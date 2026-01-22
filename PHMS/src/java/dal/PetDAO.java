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
        if (connection == null) {
            System.out.println("Lỗi getPetsByOwnerId: Database connection is null!");
            return pets;
        }
        
        String sql = "SELECT pet_id, owner_id, name, species, history_summary FROM Pet WHERE owner_id = ?";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            System.out.println("getPetsByOwnerId - ownerId: " + ownerId);
            st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            rs = st.executeQuery();
            int count = 0;
            while (rs.next()) {
                Pet pet = new Pet();
                pet.setPetId(rs.getInt("pet_id"));
                pet.setOwnerId(rs.getInt("owner_id"));
                pet.setName(rs.getString("name"));
                pet.setSpecies(rs.getString("species"));
                pet.setHistorySummary(rs.getString("history_summary"));
                pets.add(pet);
                count++;
                System.out.println("Found pet: " + pet.getName() + " (ID: " + pet.getPetId() + ")");
            }
            System.out.println("Total pets found: " + count);
        } catch (SQLException e) {
            System.out.println("Lỗi getPetsByOwnerId: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
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

    public int createPet(int ownerId, String name, String species, String historySummary) {
        if (connection == null) {
            System.out.println("Lỗi createPet: Database connection is null!");
            return -1;
        }
        
        String sql = "INSERT INTO Pet (owner_id, name, species, history_summary) VALUES (?, ?, ?, ?)";
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setInt(1, ownerId);
            st.setString(2, name);
            st.setString(3, species);
            st.setString(4, historySummary != null ? historySummary : "");
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: ownerId=" + ownerId + ", name=" + name + ", species=" + species);
            
            int result = st.executeUpdate();
            System.out.println("Execute update result: " + result);
            
            if (result > 0) {
                rs = st.getGeneratedKeys();
                if (rs != null && rs.next()) {
                    // Try to get by column name first, then by index
                    int petId;
                    try {
                        petId = rs.getInt("pet_id");
                    } catch (SQLException e) {
                        petId = rs.getInt(1);
                    }
                    System.out.println("Created pet with ID: " + petId);
                    return petId;
                } else {
                    System.out.println("Warning: No generated keys returned!");
                }
            } else {
                System.out.println("Warning: No rows affected!");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi createPet: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return -1;
    }

    public boolean updatePet(int petId, String name, String species, String historySummary) {
        String sql = "UPDATE Pet SET name = ?, species = ?, history_summary = ? WHERE pet_id = ?";
        PreparedStatement st = null;
        try {
            st = connection.prepareStatement(sql);
            st.setString(1, name);
            st.setString(2, species);
            st.setString(3, historySummary);
            st.setInt(4, petId);
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi updatePet: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return false;
    }

    public boolean deletePet(int petId, int ownerId) {
        // Only allow owner to delete their own pet
        String sql = "DELETE FROM Pet WHERE pet_id = ? AND owner_id = ?";
        PreparedStatement st = null;
        try {
            st = connection.prepareStatement(sql);
            st.setInt(1, petId);
            st.setInt(2, ownerId);
            int result = st.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi deletePet: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (st != null) st.close();
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng tài nguyên: " + e.getMessage());
            }
        }
        return false;
    }
}
