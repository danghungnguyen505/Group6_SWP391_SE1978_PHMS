package model;

import java.sql.Timestamp;

/**
 * Prescription entity mapped to table Prescription.
 */
public class Prescription {
    private int presId;
    private int recordId;
    private int medicineId;
    private int quantity;
    private String dosage;
    
    // Additional fields for display (from JOIN)
    private String medicineName;
    private String medicineUnit;
    private double medicinePrice;
    private String petName;
    private String ownerName;
    private Timestamp recordCreatedAt;
    private String vetName;
    
    public Prescription() {
    }
    
    public Prescription(int presId, int recordId, int medicineId, int quantity, String dosage) {
        this.presId = presId;
        this.recordId = recordId;
        this.medicineId = medicineId;
        this.quantity = quantity;
        this.dosage = dosage;
    }
    
    public int getPresId() {
        return presId;
    }
    
    public void setPresId(int presId) {
        this.presId = presId;
    }
    
    public int getRecordId() {
        return recordId;
    }
    
    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }
    
    public int getMedicineId() {
        return medicineId;
    }
    
    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public String getDosage() {
        return dosage;
    }
    
    public void setDosage(String dosage) {
        this.dosage = dosage;
    }
    
    public String getMedicineName() {
        return medicineName;
    }
    
    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }
    
    public String getMedicineUnit() {
        return medicineUnit;
    }
    
    public void setMedicineUnit(String medicineUnit) {
        this.medicineUnit = medicineUnit;
    }
    
    public double getMedicinePrice() {
        return medicinePrice;
    }
    
    public void setMedicinePrice(double medicinePrice) {
        this.medicinePrice = medicinePrice;
    }
    
    public String getPetName() {
        return petName;
    }
    
    public void setPetName(String petName) {
        this.petName = petName;
    }
    
    public String getOwnerName() {
        return ownerName;
    }
    
    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public Timestamp getRecordCreatedAt() {
        return recordCreatedAt;
    }

    public void setRecordCreatedAt(Timestamp recordCreatedAt) {
        this.recordCreatedAt = recordCreatedAt;
    }

    public String getVetName() {
        return vetName;
    }

    public void setVetName(String vetName) {
        this.vetName = vetName;
    }
}
