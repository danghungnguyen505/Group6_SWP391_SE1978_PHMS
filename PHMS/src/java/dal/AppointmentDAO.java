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
import model.Schedule; 
/**
 *
 * @author zoxy4
 */
public class AppointmentDAO extends DBContext{
    public List<String> getBookedSlots(int vetId, String date) {
        List<String> list = new ArrayList<>();
        // Lấy giờ (HH:mm) của các cuộc hẹn chưa bị hủy
        String sql = "SELECT FORMAT(start_time, 'HH:mm') as slot " +
                     "FROM Appointment " +
                     "WHERE vet_id = ? " +
                     "AND CAST(start_time AS DATE) = ? " +
                     "AND status != 'Cancelled'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, vetId);
            st.setString(2, date); // date dạng 'YYYY-MM-DD'
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("slot")); // Ví dụ add "09:00"
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
}
