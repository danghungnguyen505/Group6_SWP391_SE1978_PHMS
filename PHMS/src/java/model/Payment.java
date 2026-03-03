<<<<<<< Updated upstream
package model;

/**
 * Payment entity mapped to table Payment.
 */
public class Payment {
    private int paymentId;
    private int invoiceId;
    private String transCode;
    private double amount;
    private String method; // Cash, VNPay, Transfer...
    private String status;

    public Payment() {
    }

    public Payment(int paymentId, int invoiceId, String transCode, double amount, String method, String status) {
        this.paymentId = paymentId;
        this.invoiceId = invoiceId;
        this.transCode = transCode;
        this.amount = amount;
        this.method = method;
        this.status = status;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public String getTransCode() {
        return transCode;
    }

    public void setTransCode(String transCode) {
        this.transCode = transCode;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
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
 * Payment entity mapped to table Payment.
 */
public class Payment {
    private int paymentId;
    private int invoiceId;
    private String transCode;
    private double amount;
    private String method; // Cash, VNPay, Transfer...
    private String status;

    public Payment() {
    }

    public Payment(int paymentId, int invoiceId, String transCode, double amount, String method, String status) {
        this.paymentId = paymentId;
        this.invoiceId = invoiceId;
        this.transCode = transCode;
        this.amount = amount;
        this.method = method;
        this.status = status;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public String getTransCode() {
        return transCode;
    }

    public void setTransCode(String transCode) {
        this.transCode = transCode;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

>>>>>>> Stashed changes
