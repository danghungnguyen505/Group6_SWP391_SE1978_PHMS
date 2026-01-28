/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.DoctorDTO;
import model.Service;
import model.TestimonialDTO;

/**
 *
 * @author Nguyen Dang Hung
 */
public class HomeDAO extends DBContext {

    public List<Service> getTopServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT TOP 3 FROM ServiceList WHERE is_active = 1";
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
                    rs.getInt("manage_by")
                ));
            }
        } catch (Exception e) {
        }
        return list;
    }

    public List<DoctorDTO> getTopDoctors() {
        List<DoctorDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 3 u.user_id, u.full_name, v.specialization " +
                     "FROM Users u " +
                     "JOIN Veterinarian v ON u.user_id = v.emp_id " + 
                     "JOIN Employee e ON u.user_id = e.user_id"; 
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new DoctorDTO(
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("specialization")
                ));
            }
        } catch (Exception e) {
            System.out.println("Error getTopDoctors: " + e.getMessage());
        }
        return list;
    }
    
    public List<TestimonialDTO> getTopFeedbacks() {
    List<TestimonialDTO> list = new ArrayList<>();
    String sql = "SELECT TOP 3 u.full_name, f.comment, f.rating " +
                 "FROM Feedback f " +
                 "JOIN Appointment a ON f.appt_id = a.appt_id " +
                 "JOIN Pet p ON a.pet_id = p.pet_id " +
                 "JOIN PetOwner po ON p.owner_id = po.user_id " +
                 "JOIN Users u ON po.user_id = u.user_id " +
                 "ORDER BY f.rating DESC";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new TestimonialDTO(
                rs.getString("full_name"),
                rs.getString("comment"),
                rs.getInt("rating")
            ));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
    }
}