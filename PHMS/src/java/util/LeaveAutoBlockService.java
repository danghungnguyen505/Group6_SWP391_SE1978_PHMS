package util;

import dal.AppointmentDAO;
import dal.ScheduleVeterianrianDAO;
import java.sql.Date;

/**
 * Non-UI logic to auto-block schedules and appointments
 * when a staff's leave request is approved.
 */
public class LeaveAutoBlockService {

    /**
     * Auto cancel appointments and remove schedules for the given staff and date.
     * Assumes empId corresponds to vet_id in Appointment for vets.
     */
    public static void autoBlockForLeave(int empId, Date leaveDate) {
        if (leaveDate == null) return;
        // Cancel upcoming appointments for that day (Pending/Confirmed)
        AppointmentDAO apptDao = new AppointmentDAO();
        apptDao.cancelAppointmentsForEmpOnDate(empId, leaveDate);

        // Remove working schedules for that day so they are not bookable anymore
        ScheduleVeterianrianDAO scheduleDao = new ScheduleVeterianrianDAO();
        scheduleDao.deleteSchedulesByEmpAndDate(empId, leaveDate);
    }
}

