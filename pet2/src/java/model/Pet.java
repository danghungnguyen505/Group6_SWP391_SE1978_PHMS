/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author quag
 */

public class Pet {
    private int petId;
    private String name;
    private String species;
    private String historySummary;
    // Các trường này trong DB của bạn chưa có, mình giả lập để lên giao diện đẹp
    // Bạn có thể ALTER TABLE thêm vào sau.
    private String gender = "Male"; 
    private double weight = 5.0; 
    private String dob = "2023-01-01"; 

    public Pet() {}

    public Pet(int petId, String name, String species, String historySummary) {
        this.petId = petId;
        this.name = name;
        this.species = species;
        this.historySummary = historySummary;
    }

    public int getPetId() {
        return petId;
    }

    public void setPetId(int petId) {
        this.petId = petId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecies() {
        return species;
    }

    public void setSpecies(String species) {
        this.species = species;
    }

    public String getHistorySummary() {
        return historySummary;
    }

    public void setHistorySummary(String historySummary) {
        this.historySummary = historySummary;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }


}
