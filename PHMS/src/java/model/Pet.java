package model;

public class Pet {
    private int petId;
    private int ownerId;
    private String name;
    private String species;
    private String historySummary;

    public Pet() {
    }

    public Pet(int petId, int ownerId, String name, String species, String historySummary) {
        this.petId = petId;
        this.ownerId = ownerId;
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
