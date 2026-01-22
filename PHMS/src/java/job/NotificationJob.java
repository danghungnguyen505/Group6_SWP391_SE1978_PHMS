package job;

import dal.AppointmentDAO;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import model.Appointment;
import util.EmailUtil;

public class NotificationJob {
    private Timer timer;

    public void start() {
        timer = new Timer();
        // Schedule task to run daily at 8:00 AM
        // Calculate delay until next 8:00 AM
        long delay = calculateDelayTo8AM();
        
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                sendAppointmentReminders();
            }
        }, delay, 24 * 60 * 60 * 1000); // Run every 24 hours
    }

    private long calculateDelayTo8AM() {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int currentHour = cal.get(java.util.Calendar.HOUR_OF_DAY);
        int currentMinute = cal.get(java.util.Calendar.MINUTE);
        
        // If it's before 8:00 AM, schedule for today at 8:00 AM
        // Otherwise, schedule for tomorrow at 8:00 AM
        if (currentHour < 8 || (currentHour == 8 && currentMinute == 0)) {
            cal.set(java.util.Calendar.HOUR_OF_DAY, 8);
            cal.set(java.util.Calendar.MINUTE, 0);
            cal.set(java.util.Calendar.SECOND, 0);
            cal.set(java.util.Calendar.MILLISECOND, 0);
        } else {
            cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
            cal.set(java.util.Calendar.HOUR_OF_DAY, 8);
            cal.set(java.util.Calendar.MINUTE, 0);
            cal.set(java.util.Calendar.SECOND, 0);
            cal.set(java.util.Calendar.MILLISECOND, 0);
        }
        
        return cal.getTimeInMillis() - System.currentTimeMillis();
    }

    private void sendAppointmentReminders() {
        System.out.println("Running NotificationJob at " + new java.util.Date());
        AppointmentDAO appointmentDAO = new AppointmentDAO();
        List<Appointment> appointments = appointmentDAO.getAppointmentsForNotification();
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        
        for (Appointment appt : appointments) {
            if (appt.getOwnerEmail() != null && !appt.getOwnerEmail().isEmpty()) {
                String subject = "Nhắc nhở lịch hẹn - PHMS";
                String body = String.format(
                    "Xin chào,\n\n" +
                    "Bạn có lịch hẹn sắp tới:\n" +
                    "Thú cưng: %s\n" +
                    "Bác sĩ: %s\n" +
                    "Thời gian: %s\n" +
                    "Loại khám: %s\n\n" +
                    "Vui lòng đến đúng giờ.\n\n" +
                    "Trân trọng,\nPHMS Team",
                    appt.getPetName(),
                    appt.getVetName(),
                    sdf.format(appt.getStartTime()),
                    appt.getType()
                );
                
                EmailUtil.sendEmail(appt.getOwnerEmail(), subject, body);
            }
        }
        
        System.out.println("Sent " + appointments.size() + " reminder emails");
    }

    public void stop() {
        if (timer != null) {
            timer.cancel();
        }
    }
}
