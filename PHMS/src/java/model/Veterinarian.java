package model;

public class Veterinarian {
    private int empId;
    private String fullName;
    private String licenseNumber;
    private String specialization;

    public Veterinarian() {
    }

    public Veterinarian(int empId, String fullName, String licenseNumber, String specialization) {
        this.empId = empId;
        this.fullName = fullName;
        this.licenseNumber = licenseNumber;
        this.specialization = specialization;
    }

    public int getEmpId() {
        return empId;
    }

    public void setEmpId(int empId) {
        this.empId = empId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
}
