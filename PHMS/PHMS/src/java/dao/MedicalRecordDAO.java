/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import model.MedicalRecord;
import util.DBUtil;

public class MedicalRecordDAO {

    public void insert(MedicalRecord record) {
        String sql = """
            INSERT INTO medical_record (appt_id, diagnosis, treatment_plan)
            VALUES (?, ?, ?)
        """;

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, record.getApptId());
            ps.setString(2, record.getDiagnosis());
            ps.setString(3, record.getTreatmentPlan());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
   
