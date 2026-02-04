/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author zoxy4
 */
public class TimeSlot {
    private String timeLabel;
    private String timeValue;
    private boolean isAvailable;
    public TimeSlot(String timeLabel, String timeValue, boolean isAvailable) {
        this.timeLabel = timeLabel;
        this.timeValue = timeValue;
        this.isAvailable = isAvailable;
    }

    public TimeSlot() {
    }

    public String getTimeLabel() {
        return timeLabel;
    }

    public void setTimeLabel(String timeLabel) {
        this.timeLabel = timeLabel;
    }

    public String getTimeValue() {
        return timeValue;
    }

    public void setTimeValue(String timeValue) {
        this.timeValue = timeValue;
    }

    public boolean isAvailable() { 
        return isAvailable;
    }

    public void setAvailable(boolean isAvailable) { 
        this.isAvailable = isAvailable;
    }
    
}
