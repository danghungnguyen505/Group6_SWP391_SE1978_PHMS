/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

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

    public Pet() {
    }

    public Pet(int id, int ownerId, String name, String species, String historySummary) {
        this.id = id;
        this.ownerId = ownerId;
        this.name = name;
        this.species = species;
        this.historySummary = historySummary;
    }

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
    
}
