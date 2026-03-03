/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

/**
 *
 * @author zoxy4
 */
public class Pet {

    private int id;
    private int ownerId;
    private String name;
    private String species;
    private String historySummary;

    // Các trường mới thêm
    private String breed;
    private double weight;
    private Date birthDate;
    private String gender;

    // 1. Constructor rỗng (Bắt buộc phải có để tạo đối tượng rồi set sau)
    public Pet() {
    }

    public Pet(int id, int ownerId, String name, String species, String historySummary,
            String breed, double weight, Date birthDate, String gender) {
        this.id = id;
        this.ownerId = ownerId;
        this.name = name;
        this.species = species;
        this.historySummary = historySummary;
        this.breed = breed;
        this.weight = weight;
        this.birthDate = birthDate;
        this.gender = gender;
    }

    // Getters và Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
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

    public String getBreed() {
        return breed;
    }

    public void setBreed(String breed) {
        this.breed = breed;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    @Override
    public String toString() {
        return "Pet{" + "id=" + id + ", name=" + name + ", species=" + species + ", breed=" + breed + '}';
    }
}
