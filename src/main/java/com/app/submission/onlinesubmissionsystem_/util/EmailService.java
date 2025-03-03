package com.app.submission.onlinesubmissionsystem_.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

public class EmailService {
    
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "pazzoamani@gmail.com";
    private static final String EMAIL_PASSWORD = "xmpz kpxu nazq rrdb";
    
    public static void sendEmail(String recipient, String subject, String body) {
        // Set properties
        Properties properties = new Properties();
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.auth", "true");   
        properties.put("mail.smtp.starttls.enable", "true");
        
        // Use jakarta.mail.Session instead of org.hibernate.Session
        jakarta.mail.Session session = jakarta.mail.Session.getInstance(properties, new Authenticator() {
            @Override
            protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                return new jakarta.mail.PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });
        
        try {
            // Create message - using jakarta.mail.Message
            jakarta.mail.Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(jakarta.mail.Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setText(body);
            
            // Send message
            Transport.send(message);
            
            System.out.println("Email sent successfully to " + recipient);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
} 