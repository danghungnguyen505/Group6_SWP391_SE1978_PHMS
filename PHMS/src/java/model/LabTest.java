<<<<<<< Updated upstream
package model;

import java.sql.Timestamp;

/**
 * LabTest entity (LabTest table)
 */
public class LabTest {
    private int testId;
    private int recordId;
    private Integer nurseId; // can be null
    private String testType;
    private String requestNotes;
    private String resultData; // can store text or file path
    private String status; // Requested / In Progress / Completed / Cancelled

    // Display fields (JOIN)
    private Timestamp recordCreatedAt;
    private int apptId;
    private Timestamp apptStartTime;
    private int vetId;
    private String vetName;
    private int ownerId;
    private String ownerName;
    private String petName;

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public Integer getNurseId() {
        return nurseId;
    }

    public void setNurseId(Integer nurseId) {
        this.nurseId = nurseId;
    }

    public String getTestType() {
        return testType;
    }

    public void setTestType(String testType) {
        this.testType = testType;
    }

    public String getRequestNotes() {
        return requestNotes;
    }

    public void setRequestNotes(String requestNotes) {
        this.requestNotes = requestNotes;
    }

    public String getResultData() {
        return resultData;
    }

    public void setResultData(String resultData) {
        this.resultData = resultData;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getRecordCreatedAt() {
        return recordCreatedAt;
    }

    public void setRecordCreatedAt(Timestamp recordCreatedAt) {
        this.recordCreatedAt = recordCreatedAt;
    }

    public int getApptId() {
        return apptId;
    }

    public void setApptId(int apptId) {
        this.apptId = apptId;
    }

    public Timestamp getApptStartTime() {
        return apptStartTime;
    }

    public void setApptStartTime(Timestamp apptStartTime) {
        this.apptStartTime = apptStartTime;
    }

    public int getVetId() {
        return vetId;
    }

    public void setVetId(int vetId) {
        this.vetId = vetId;
    }

    public String getVetName() {
        return vetName;
    }

    public void setVetName(String vetName) {
        this.vetName = vetName;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getPetName() {
        return petName;
    }

    public void setPetName(String petName) {
        this.petName = petName;
    }
}

=======
package model;

import java.sql.Timestamp;

/**
 * LabTest entity (LabTest table)
 */
public class LabTest {
    private int testId;
    private int recordId;
    private Integer nurseId; // can be null
    private String testType;
    private String requestNotes;
    private String resultData; // can store text or file path
    private String status; // Requested / In Progress / Completed / Cancelled

    // Display fields (JOIN)
    private Timestamp recordCreatedAt;
    private int apptId;
    private Timestamp apptStartTime;
    private int vetId;
    private String vetName;
    private int ownerId;
    private String ownerName;
    private String petName;

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public int getRecordId() {
        return recordId;
    }

    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }

    public Integer getNurseId() {
        return nurseId;
    }

    public void setNurseId(Integer nurseId) {
        this.nurseId = nurseId;
    }

    public String getTestType() {
        return testType;
    }

    public void setTestType(String testType) {
        this.testType = testType;
    }

    public String getRequestNotes() {
        return requestNotes;
    }

    public void setRequestNotes(String requestNotes) {
        this.requestNotes = requestNotes;
    }

    public String getResultData() {
        return resultData;
    }

    public void setResultData(String resultData) {
        this.resultData = resultData;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getRecordCreatedAt() {
        return recordCreatedAt;
    }

    public void setRecordCreatedAt(Timestamp recordCreatedAt) {
        this.recordCreatedAt = recordCreatedAt;
    }

    public int getApptId() {
        return apptId;
    }

    public void setApptId(int apptId) {
        this.apptId = apptId;
    }

    public Timestamp getApptStartTime() {
        return apptStartTime;
    }

    public void setApptStartTime(Timestamp apptStartTime) {
        this.apptStartTime = apptStartTime;
    }

    public int getVetId() {
        return vetId;
    }

    public void setVetId(int vetId) {
        this.vetId = vetId;
    }

    public String getVetName() {
        return vetName;
    }

    public void setVetName(String vetName) {
        this.vetName = vetName;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getPetName() {
        return petName;
    }

    public void setPetName(String petName) {
        this.petName = petName;
    }
}

>>>>>>> Stashed changes
