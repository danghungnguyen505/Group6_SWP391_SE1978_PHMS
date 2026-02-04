/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Nguyen Dang Hung
 */
public class DoctorDTO {
    private int id;
    private String fullName;
    private String specialization;
    private String image; //img random

    public DoctorDTO() {
    }

    public DoctorDTO(int id, String fullName, String specialization) {
        this.id = id;
        this.fullName = fullName;
        this.specialization = specialization;
        this.image = "https://ui-avatars.com/api/?background=random&name=" + fullName.replace(" ", "+");
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
    
}
