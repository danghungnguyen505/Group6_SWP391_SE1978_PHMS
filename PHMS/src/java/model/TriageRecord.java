<<<<<<< Updated upstream
package model;

import java.sql.Timestamp;

/**
 * TriageRecord entity mapped to table TriageRecord.
 */
public class TriageRecord {
    private int triageId;
    private int apptId;
    private int recepId;
    private String conditionLevel;
    private String initialSymptoms;
    private Timestamp triageTime;

    public TriageRecord() {
    }

    public int getTriageId() {
        return triageId;
    }

    public void setTriageId(int triageId) {
        this.triageId = triageId;
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

    public String getConditionLevel() {
        return conditionLevel;
    }

    public void setConditionLevel(String conditionLevel) {
        this.conditionLevel = conditionLevel;
    }

    public String getInitialSymptoms() {
        return initialSymptoms;
    }

    public void setInitialSymptoms(String initialSymptoms) {
        this.initialSymptoms = initialSymptoms;
    }

    public Timestamp getTriageTime() {
        return triageTime;
    }

    public void setTriageTime(Timestamp triageTime) {
        this.triageTime = triageTime;
    }
}

=======
package model;

import java.sql.Timestamp;

/**
 * TriageRecord entity mapped to table TriageRecord.
 */
public class TriageRecord {
    private int triageId;
    private int apptId;
    private int recepId;
    private String conditionLevel;
    private String initialSymptoms;
    private Timestamp triageTime;

    public TriageRecord() {
    }

    public int getTriageId() {
        return triageId;
    }

    public void setTriageId(int triageId) {
        this.triageId = triageId;
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

    public String getConditionLevel() {
        return conditionLevel;
    }

    public void setConditionLevel(String conditionLevel) {
        this.conditionLevel = conditionLevel;
    }

    public String getInitialSymptoms() {
        return initialSymptoms;
    }

    public void setInitialSymptoms(String initialSymptoms) {
        this.initialSymptoms = initialSymptoms;
    }

    public Timestamp getTriageTime() {
        return triageTime;
    }

    public void setTriageTime(Timestamp triageTime) {
        this.triageTime = triageTime;
    }
}

>>>>>>> Stashed changes
