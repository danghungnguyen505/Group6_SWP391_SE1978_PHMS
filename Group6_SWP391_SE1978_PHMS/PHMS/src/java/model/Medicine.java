package model;

/**
 * Medicine entity mapped to table Medicine.
 */
public class Medicine {
    private int medicineId;
    private String name;
    private String unit;
    private double price;
    private int stockQuantity;

    public Medicine() {
    }

    public Medicine(int medicineId, String name, String unit, double price, int stockQuantity) {
        this.medicineId = medicineId;
        this.name = name;
        this.unit = unit;
        this.price = price;
        this.stockQuantity = stockQuantity;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
}

