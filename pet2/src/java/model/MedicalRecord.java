package model;

import java.sql.Timestamp;

public class MedicalRecord {
    private int recordId;
    private Timestamp visitDate; 
    private String diagnosis;
    private String treatment;    
    private String vetName;

    public MedicalRecord() {
    }

    public MedicalRecord(int recordId, Timestamp visitDate, String diagnosis, String treatment, String vetName) {
        this.recordId = recordId;
        this.visitDate = visitDate;
        this.diagnosis = diagnosis;
        this.treatment = treatment;
        this.vetName = vetName;
    }

    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public Timestamp getVisitDate() {
        return visitDate;
    }

    public void setVisitDate(Timestamp visitDate) {
        this.visitDate = visitDate;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getTreatment() {
        return treatment;
    }

    public void setTreatment(String treatment) {
        this.treatment = treatment;
    }

    public String getVetName() {
        return vetName;
    }

    public void setVetName(String vetName) {
        this.vetName = vetName;
    }

}