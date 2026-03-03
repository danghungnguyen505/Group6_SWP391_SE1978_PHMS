<<<<<<< Updated upstream
package model;

import java.sql.Timestamp;

/**
 * Feedback entity mapped to table Feedback.
 */
public class Feedback {
    private int feedbackId;
    private int apptId;
    private int rating;
    private String comment;
    
    // Additional fields from JOIN
    private String customerName;
    private String petName;
    private Timestamp createdAt;
    private String apptDate;
    
    public Feedback() {
    }
    
    public Feedback(int feedbackId, int apptId, int rating, String comment) {
        this.feedbackId = feedbackId;
        this.apptId = apptId;
        this.rating = rating;
        this.comment = comment;
    }
    
    public int getFeedbackId() {
        return feedbackId;
    }
    
    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }
    
    public int getApptId() {
        return apptId;
    }
    
    public void setApptId(int apptId) {
        this.apptId = apptId;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getPetName() {
        return petName;
    }
    
    public void setPetName(String petName) {
        this.petName = petName;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getApptDate() {
        return apptDate;
    }
    
    public void setApptDate(String apptDate) {
        this.apptDate = apptDate;
    }
}
=======
package model;

import java.sql.Timestamp;

/**
 * Feedback entity mapped to table Feedback.
 */
public class Feedback {
    private int feedbackId;
    private int apptId;
    private int rating;
    private String comment;
    
    // Additional fields from JOIN
    private String customerName;
    private String petName;
    private Timestamp createdAt;
    private String apptDate;
    
    public Feedback() {
    }
    
    public Feedback(int feedbackId, int apptId, int rating, String comment) {
        this.feedbackId = feedbackId;
        this.apptId = apptId;
        this.rating = rating;
        this.comment = comment;
    }
    
    public int getFeedbackId() {
        return feedbackId;
    }
    
    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }
    
    public int getApptId() {
        return apptId;
    }
    
    public void setApptId(int apptId) {
        this.apptId = apptId;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getComment() {
        return comment;
    }
    
    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getPetName() {
        return petName;
    }
    
    public void setPetName(String petName) {
        this.petName = petName;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getApptDate() {
        return apptDate;
    }
    
    public void setApptDate(String apptDate) {
        this.apptDate = apptDate;
    }
}
>>>>>>> Stashed changes
