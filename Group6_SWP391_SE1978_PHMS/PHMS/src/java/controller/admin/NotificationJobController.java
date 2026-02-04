package controller.admin;

import dal.AppointmentDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import model.Appointment;
import model.User;
import util.EmailUtil;

/**
 * Non-UI job to send daily reminder emails at 8:00 AM for upcoming appointments.
 * Can be triggered manually or by external scheduler (Windows Task Scheduler / Cron).
 * 
 * Business logic:
 * - Send email to PetOwner for appointments scheduled TODAY (status = Confirmed)
 * - Email includes appointment details: time, pet name, vet name, service type
 */
@WebServlet(name = "NotificationJobController", urlPatterns = {"/admin/jobs/daily-reminder"})
public class NotificationJobController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        
        // Allow access without login for scheduler (or require admin for manual trigger)
        boolean isManualTrigger = account != null;
        if (isManualTrigger && (!"ClinicManager".equalsIgnoreCase(account.getRole())
                && !"Admin".equalsIgnoreCase(account.getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
            return;
        }
        
        AppointmentDAO apptDAO = new AppointmentDAO();
        UserDAO userDAO = new UserDAO();
        
        // Get today's date
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date todayStart = cal.getTime();
        
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        Date todayEnd = cal.getTime();
        
        // Get appointments scheduled for today with status Confirmed
        List<Appointment> todayAppointments = apptDAO.getAppointmentsByDateRange(
                new Timestamp(todayStart.getTime()),
                new Timestamp(todayEnd.getTime()),
                "Confirmed"
        );
        
        int successCount = 0;
        int failCount = 0;
        StringBuilder log = new StringBuilder();
        
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        
        for (Appointment appt : todayAppointments) {
            try {
                // Get owner email from pet
                User ownerUser = userDAO.getOwnerByPetId(appt.getPetId());
                
                if (ownerUser == null || ownerUser.getEmail() == null || ownerUser.getEmail().trim().isEmpty()) {
                    log.append("Skipped appointment #").append(appt.getApptId())
                       .append(" - Owner email not found\n");
                    failCount++;
                    continue;
                }
                
                String email = ownerUser.getEmail();
                String subject = "Nhắc nhở lịch hẹn khám thú cưng hôm nay - VetCare Pro";
                
                StringBuilder emailBody = new StringBuilder();
                emailBody.append("Xin chào ").append(ownerUser.getFullName()).append(",\n\n");
                emailBody.append("Đây là email nhắc nhở tự động từ hệ thống VetCare Pro.\n\n");
                emailBody.append("Bạn có lịch hẹn khám thú cưng vào HÔM NAY:\n\n");
                emailBody.append("Thông tin lịch hẹn:\n");
                emailBody.append("- Mã lịch hẹn: #").append(appt.getApptId()).append("\n");
                emailBody.append("- Thời gian: ").append(dateFormat.format(appt.getStartTime()))
                         .append(" lúc ").append(timeFormat.format(appt.getStartTime())).append("\n");
                emailBody.append("- Thú cưng: ").append(appt.getPetName()).append("\n");
                emailBody.append("- Bác sĩ: ").append(appt.getVetName()).append("\n");
                emailBody.append("- Dịch vụ: ").append(appt.getType()).append("\n\n");
                emailBody.append("Vui lòng đến đúng giờ để được phục vụ tốt nhất.\n\n");
                emailBody.append("Trân trọng,\n");
                emailBody.append("Đội ngũ VetCare Pro\n");
                
                boolean sent = EmailUtil.sendEmail(email, subject, emailBody.toString());
                
                if (sent) {
                    successCount++;
                    log.append("Sent reminder to ").append(email).append(" for appointment #")
                       .append(appt.getApptId()).append("\n");
                } else {
                    failCount++;
                    log.append("Failed to send email to ").append(email).append(" for appointment #")
                       .append(appt.getApptId()).append("\n");
                }
            } catch (Exception e) {
                failCount++;
                log.append("Error processing appointment #").append(appt.getApptId())
                   .append(": ").append(e.getMessage()).append("\n");
            }
        }
        
        // Response
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().println("=== Daily Reminder Job Execution ===");
        response.getWriter().println("Date: " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));
        response.getWriter().println("Total appointments found: " + todayAppointments.size());
        response.getWriter().println("Successfully sent: " + successCount);
        response.getWriter().println("Failed: " + failCount);
        response.getWriter().println("\n=== Detailed Log ===");
        response.getWriter().println(log.toString());
    }
}
