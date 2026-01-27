/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package model;

public class MedicalRecord {
    private int apptId;
    private String diagnosis;
    private String treatmentPlan;

    public MedicalRecord(int apptId, String diagnosis, String treatmentPlan) {
        this.apptId = apptId;
        this.diagnosis = diagnosis;
        this.treatmentPlan = treatmentPlan;
    }

    public int getApptId() {
        return apptId;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public String getTreatmentPlan() {
        return treatmentPlan;
    }
}

