package model;

import java.sql.Date;

/**
 * LeaveRequest entity mapped to table LeaveRequest.
 */
public class LeaveRequest {
    private int leaveId;
    private int empId;
    private int managerId;
    private Date startDate;
    private Date endDate;
    private String reason;
    private String status; // Pending, Approved, Rejected

    public LeaveRequest() {
    }

    public LeaveRequest(int leaveId, int empId, int managerId, Date startDate, Date endDate,
                        String reason, String status) {
        this.leaveId = leaveId;
        this.empId = empId;
        this.managerId = managerId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.reason = reason;
        this.status = status;
    }

    public int getLeaveId() {
        return leaveId;
    }

    public void setLeaveId(int leaveId) {
        this.leaveId = leaveId;
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

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

