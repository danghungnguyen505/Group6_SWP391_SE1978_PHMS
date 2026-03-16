package model;

import java.sql.Timestamp;

public class ChatMessage {

    private int messageId;
    private int senderId;
    private int receiverId;
    private String messageText;
    private Timestamp sentTime;
    private String senderName;
public ChatMessage(int senderId, int receiverId, String message) {
    this.senderId = senderId;
    this.receiverId = receiverId;
    this.messageText = message;
}
    public ChatMessage() {}

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public int getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }

    public String getMessageText() {
        return messageText;
    }

    public void setMessageText(String messageText) {
        this.messageText = messageText;
    }

    public Timestamp getSentTime() {
        return sentTime;
    }

    public void setSentTime(Timestamp sentTime) {
        this.sentTime = sentTime;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }
}