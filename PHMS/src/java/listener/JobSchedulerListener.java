package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import job.AutoCancelJob;
import job.NotificationJob;

@WebListener
public class JobSchedulerListener implements ServletContextListener {
    private NotificationJob notificationJob;
    private AutoCancelJob autoCancelJob;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Starting scheduled jobs...");
        
        // Start notification job
        notificationJob = new NotificationJob();
        notificationJob.start();
        
        // Start auto-cancel job
        autoCancelJob = new AutoCancelJob();
        autoCancelJob.start();
        
        System.out.println("Scheduled jobs started successfully");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Stopping scheduled jobs...");
        
        if (notificationJob != null) {
            notificationJob.stop();
        }
        
        if (autoCancelJob != null) {
            autoCancelJob.stop();
        }
        
        System.out.println("Scheduled jobs stopped");
    }
}
