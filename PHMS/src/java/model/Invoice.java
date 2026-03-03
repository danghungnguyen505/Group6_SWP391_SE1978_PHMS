<<<<<<< Updated upstream
package model;

/**
 * Invoice entity mapped to table Invoice.
 */
public class Invoice {
    private int invoiceId;
    private int apptId;
    private int recepId;
    private double totalAmount;
    private String status; // Unpaid, Paid, Partially Paid

    public Invoice() {
    }

    public Invoice(int invoiceId, int apptId, int recepId, double totalAmount, String status) {
        this.invoiceId = invoiceId;
        this.apptId = apptId;
        this.recepId = recepId;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public int getApptId() {
        return apptId;
    }

    public void setApptId(int apptId) {
        this.apptId = apptId;
    }

    public int getRecepId() {
        return recepId;
    }

    public void setRecepId(int recepId) {
        this.recepId = recepId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

=======
package model;

/**
 * Invoice entity mapped to table Invoice.
 */
public class Invoice {
    private int invoiceId;
    private int apptId;
    private int recepId;
    private double totalAmount;
    private String status; // Unpaid, Paid, Partially Paid

    public Invoice() {
    }

    public Invoice(int invoiceId, int apptId, int recepId, double totalAmount, String status) {
        this.invoiceId = invoiceId;
        this.apptId = apptId;
        this.recepId = recepId;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public int getApptId() {
        return apptId;
    }

    public void setApptId(int apptId) {
        this.apptId = apptId;
    }

    public int getRecepId() {
        return recepId;
    }

    public void setRecepId(int recepId) {
        this.recepId = recepId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

>>>>>>> Stashed changes
