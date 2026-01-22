package model;

import java.sql.Date;

public class Schedule {
    private int scheduleId;
    private int empId;
    private int managerId;
    private Date workDate;
    private String shiftTime;
    private String vetName;

    public Schedule() {
    }

    public Schedule(int scheduleId, int empId, int managerId, Date workDate, String shiftTime) {
        this.scheduleId = scheduleId;
        this.empId = empId;
        this.managerId = managerId;
        this.workDate = workDate;
        this.shiftTime = shiftTime;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getEmpId() {
        return empId;
    }

    public void setEmpId(int empId) {
        this.empId = empId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public String getShiftTime() {
        return shiftTime;
    }

    public void setShiftTime(String shiftTime) {
        this.shiftTime = shiftTime;
    }

    public String getVetName() {
        return vetName;
    }

    public void setVetName(String vetName) {
        this.vetName = vetName;
    }
}
