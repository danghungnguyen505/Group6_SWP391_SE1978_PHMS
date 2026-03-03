/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author zoxy4
 */
import java.sql.Date;
import java.sql.Time;
public class StaffScheduleVeterinarian {
private int scheduleId;
    private int empId;        // Map với cột emp_id trong bảng Schedule cũ
    private String staffName; // Lấy từ bảng Users/Employee
    private String role;      // Lấy từ bảng Users/Employee
    private Date workDate;
    private String shiftTime; // Raw shift_time from DB (e.g. "09:00 AM-09:30 AM")
    private Time startTime;   // Dùng để hiển thị trên lịch
    private Time endTime;     // Dùng để hiển thị trên lịch
    private String status;    // Thêm status 

    public StaffScheduleVeterinarian() {
    }

    // Getters & Setters
    public int getScheduleId() { return scheduleId; }
    public void setScheduleId(int scheduleId) { this.scheduleId = scheduleId; }

    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }

    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Date getWorkDate() { return workDate; }
    public void setWorkDate(Date workDate) { this.workDate = workDate; }

    public String getShiftTime() { return shiftTime; }
    public void setShiftTime(String shiftTime) { this.shiftTime = shiftTime; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
