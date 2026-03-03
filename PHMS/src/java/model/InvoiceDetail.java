<<<<<<< Updated upstream
package model;

/**
 * Invoice detail row mapped to table InvoiceDetail.
 */
public class InvoiceDetail {
    private int detailId;
    private int invoiceId;
    private Integer medicineId; // nullable
    private Integer serviceId;  // nullable
    private String itemType;    // Medicine or Service
    private int quantity;
    private double unitPrice;

    public InvoiceDetail() {
    }

    public InvoiceDetail(int detailId, int invoiceId, Integer medicineId, Integer serviceId,
                         String itemType, int quantity, double unitPrice) {
        this.detailId = detailId;
        this.invoiceId = invoiceId;
        this.medicineId = medicineId;
        this.serviceId = serviceId;
        this.itemType = itemType;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public Integer getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(Integer medicineId) {
        this.medicineId = medicineId;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }
}

=======
package model;

/**
 * Invoice detail row mapped to table InvoiceDetail.
 */
public class InvoiceDetail {
    private int detailId;
    private int invoiceId;
    private Integer medicineId; // nullable
    private Integer serviceId;  // nullable
    private String itemType;    // Medicine or Service
    private int quantity;
    private double unitPrice;

    public InvoiceDetail() {
    }

    public InvoiceDetail(int detailId, int invoiceId, Integer medicineId, Integer serviceId,
                         String itemType, int quantity, double unitPrice) {
        this.detailId = detailId;
        this.invoiceId = invoiceId;
        this.medicineId = medicineId;
        this.serviceId = serviceId;
        this.itemType = itemType;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public Integer getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(Integer medicineId) {
        this.medicineId = medicineId;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }
}

>>>>>>> Stashed changes
