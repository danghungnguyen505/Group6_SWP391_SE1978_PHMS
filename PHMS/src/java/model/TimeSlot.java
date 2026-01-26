package model;

import java.sql.Date;

public class TimeSlot {
    private int vetId;
    private String vetName;
    private Date workDate;
    private String timeSlot; // e.g., "08:00-09:00"
    private int hour; // 8, 9, 10, 11, 12, 13, 14, 15, 16
    private boolean available;
    private boolean hasSchedule; // Vet has schedule for this date
    private String shiftType; // "Morning" or "Afternoon"

    public TimeSlot() {
    }

    public TimeSlot(int vetId, String vetName, Date workDate, int hour, boolean available) {
        this.vetId = vetId;
        this.vetName = vetName;
        this.workDate = workDate;
        this.hour = hour;
        this.available = available;
        this.timeSlot = String.format("%02d:00-%02d:00", hour, hour + 1);
        this.shiftType = hour < 13 ? "Morning" : "Afternoon";
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

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public int getHour() {
        return hour;
    }

    public void setHour(int hour) {
        this.hour = hour;
        this.timeSlot = String.format("%02d:00-%02d:00", hour, hour + 1);
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public boolean isHasSchedule() {
        return hasSchedule;
    }

    public void setHasSchedule(boolean hasSchedule) {
        this.hasSchedule = hasSchedule;
    }

    public String getShiftType() {
        return shiftType;
    }

    public void setShiftType(String shiftType) {
        this.shiftType = shiftType;
    }
}
