/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.io.InputStream;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import jakarta.servlet.ServletContext; 
import java.io.UnsupportedEncodingException;
import java.util.Random;

/**
 *
 * @author Nguyen Dang Hung
 */

public class SendMail {

    public static String getRandomOTP() {
        Random rd = new Random();
        int number = rd.nextInt(999999);
        return String.format("%06d", number);
    }
    
    private static Session createEmailSession(ServletContext context) throws Exception {
        InputStream input = context.getResourceAsStream("/WEB-INF/Email.properties");
        if (input == null) {
            throw new Exception("File config not found at /WEB-INF/Email.properties");
        }

        Properties configProps = new Properties();
        configProps.load(input);

        final String user = configProps.getProperty("email");
        final String pass = configProps.getProperty("pass");

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.mime.charset", "UTF-8");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });
    }

    public static void sendRecoveryOTP(ServletContext context, String toEmail, String otpCode) throws Exception {
        Session session = createEmailSession(context);
        String fromEmail = session.getProperty("mail.smtp.user");

        String subject = "[VetCare Pro] Mã xác thực khôi phục mật khẩu";
        String message = "<!DOCTYPE html>\n"
                + "<html lang=\"vi\">\n"
                + "<body style=\"font-family: Arial, sans-serif;\">\n"
                + "    <div style=\"background-color: #f3f4f6; padding: 20px;\">\n"
                + "        <div style=\"background-color: #ffffff; padding: 30px; border-radius: 8px; max-width: 500px; margin: 0 auto;\">\n"
                + "            <h2 style=\"color: #2563eb; text-align: center;\">VetCare Pro</h2>\n"
                + "            <p>Xin chào,</p>\n"
                + "            <p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>\n"
                + "            <p>Mã xác thực (OTP) của bạn là:</p>\n"
                + "            <h1 style=\"color: #2563eb; text-align: center; letter-spacing: 5px;\">" + otpCode + "</h1>\n"
                + "            <p>Mã này sẽ hết hạn trong vòng 5 phút.</p>\n"
                + "            <p>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>\n"
                + "            <hr style=\"border: none; border-top: 1px solid #eee;\" />\n"
                + "            <p style=\"font-size: 12px; color: #666; text-align: center;\">VetCare Pro - Chăm sóc thú cưng toàn diện</p>\n"
                + "        </div>\n"
                + "    </div>\n"
                + "</body>\n"
                + "</html>";

        send(session, toEmail, subject, message);
    }

    public static void sendBookingConfirmation(ServletContext context, String toEmail, String customerName, 
                                               String date, String time, String doctorName, String serviceName) throws Exception {
        Session session = createEmailSession(context); // Gọi hàm phụ

        String subject = "[VetCare Pro] Xác nhận lịch hẹn khám";
        String message = "<!DOCTYPE html>\n"
                + "<html lang=\"vi\">\n"
                + "<body style=\"font-family: Arial, sans-serif;\">\n"
                + "    <div style=\"background-color: #f0fdf4; padding: 20px;\">\n"
                + "        <div style=\"background-color: #ffffff; padding: 30px; border-radius: 8px; max-width: 600px; margin: 0 auto; border: 1px solid #bbf7d0;\">\n"
                + "            <h2 style=\"color: #166534; text-align: center;\">Đặt Lịch Thành Công!</h2>\n"
                + "            <p>Xin chào <strong>" + customerName + "</strong>,</p>\n"
                + "            <p>Cảm ơn bạn đã tin tưởng VetCare Pro. Lịch hẹn của bạn đã được xác nhận:</p>\n"
                + "            <table style=\"width: 100%; margin-bottom: 20px;\">\n"
                + "                <tr><td><strong>Ngày:</strong></td><td>" + date + "</td></tr>\n"
                + "                <tr><td><strong>Giờ:</strong></td><td>" + time + "</td></tr>\n"
                + "                <tr><td><strong>Bác sĩ:</strong></td><td>" + doctorName + "</td></tr>\n"
                + "                <tr><td><strong>Dịch vụ:</strong></td><td>" + serviceName + "</td></tr>\n"
                + "            </table>\n"
                + "            <p>Vui lòng đến trước 10 phút để làm thủ tục check-in.</p>\n"
                + "            <a href=\"http://localhost:8080/PHMS/home\" style=\"display: block; background-color: #166534; color: white; text-align: center; padding: 10px; text-decoration: none; border-radius: 5px;\">Xem chi tiết tại Website</a>\n"
                + "        </div>\n"
                + "    </div>\n"
                + "</body>\n"
                + "</html>";

        send(session, toEmail, subject, message);
    }

    private static void send(Session session, String to, String sub, String msg) throws MessagingException, UnsupportedEncodingException {
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress("no-reply@vetcarepro.com", "VetCare Pro Support")); 
        message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject(sub, "UTF-8");
        message.setContent(msg, "text/html; charset=UTF-8");
        Transport.send(message);
    }
}