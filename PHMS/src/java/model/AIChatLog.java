<<<<<<< Updated upstream
package model;

import java.sql.Timestamp;

/**
 * AIChatLog entity mapped to table AIChatLog.
 */
public class AIChatLog {
    private int logId;
    private int userId;
    private String questionRaw;
    private String aiResponse;
    private Timestamp createdAt;

    public AIChatLog() {
    }

    public AIChatLog(int logId, int userId, String questionRaw, String aiResponse, Timestamp createdAt) {
        this.logId = logId;
        this.userId = userId;
        this.questionRaw = questionRaw;
        this.aiResponse = aiResponse;
        this.createdAt = createdAt;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getQuestionRaw() {
        return questionRaw;
    }

    public void setQuestionRaw(String questionRaw) {
        this.questionRaw = questionRaw;
    }

    public String getAiResponse() {
        return aiResponse;
    }

    public void setAiResponse(String aiResponse) {
        this.aiResponse = aiResponse;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

=======
package model;

import java.sql.Timestamp;

/**
 * AIChatLog entity mapped to table AIChatLog.
 */
public class AIChatLog {
    private int logId;
    private int userId;
    private String questionRaw;
    private String aiResponse;
    private Timestamp createdAt;

    public AIChatLog() {
    }

    public AIChatLog(int logId, int userId, String questionRaw, String aiResponse, Timestamp createdAt) {
        this.logId = logId;
        this.userId = userId;
        this.questionRaw = questionRaw;
        this.aiResponse = aiResponse;
        this.createdAt = createdAt;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getQuestionRaw() {
        return questionRaw;
    }

    public void setQuestionRaw(String questionRaw) {
        this.questionRaw = questionRaw;
    }

    public String getAiResponse() {
        return aiResponse;
    }

    public void setAiResponse(String aiResponse) {
        this.aiResponse = aiResponse;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

>>>>>>> Stashed changes
