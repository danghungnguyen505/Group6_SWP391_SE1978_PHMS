package model;

public class Service {
    private int serviceId;
    private String name;
    private double basePrice;
    private String description;
    private boolean isActive;

    public Service() {
    }

    public Service(int serviceId, String name, double basePrice, String description, boolean isActive) {
        this.serviceId = serviceId;
        this.name = name;
        this.basePrice = basePrice;
        this.description = description;
        this.isActive = isActive;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}
