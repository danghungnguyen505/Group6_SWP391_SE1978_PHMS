package job;

import dal.AppointmentDAO;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import model.Appointment;

public class AutoCancelJob {
    private Timer timer;

    public void start() {
        timer = new Timer();
        // Run every minute to check for appointments to cancel
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                cancelPendingPaymentAppointments();
            }
        }, 0, 60 * 1000); // Run every 60 seconds (1 minute)
    }

    private void cancelPendingPaymentAppointments() {
        System.out.println("Running AutoCancelJob at " + new java.util.Date());
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> appointments = appointmentDAO.getPendingPaymentAppointments();
        
        int cancelledCount = 0;
        for (Appointment appt : appointments) {
            if (appointmentDAO.updateAppointmentStatus(appt.getApptId(), "Cancelled")) {
                cancelledCount++;
                System.out.println("Cancelled appointment ID: " + appt.getApptId() + " - Pending payment timeout");
            }
        }
        
        if (cancelledCount > 0) {
            System.out.println("Auto-cancelled " + cancelledCount + " appointments due to payment timeout");
        }
    }

    public void stop() {
        if (timer != null) {
            timer.cancel();
        }
    }
}
