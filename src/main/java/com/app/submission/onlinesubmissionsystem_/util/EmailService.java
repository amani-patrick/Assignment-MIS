package com.app.submission.onlinesubmissionsystem_.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class EmailService {
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static String EMAIL_USERNAME;
    private static String EMAIL_PASSWORD;

    // Load email credentials from config.properties
    static {
        try (InputStream input = EmailService.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                System.err.println("⚠️ Error: config.properties file not found!");
            } else {
                Properties properties = new Properties();
                properties.load(input);
                EMAIL_USERNAME = properties.getProperty("EMAIL_USERNAME");
                EMAIL_PASSWORD = properties.getProperty("EMAIL_PASSWORD");

                if (EMAIL_USERNAME == null || EMAIL_PASSWORD == null) {
                    System.err.println("⚠️ Error: Missing email credentials in config.properties!");
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void sendEmail(String recipient, String subject, String body) {
        if (EMAIL_USERNAME == null || EMAIL_PASSWORD == null) {
            System.err.println("⚠️ Error: Cannot send email, missing credentials.");
            return;
        }

        // Set email properties
        Properties properties = new Properties();
        properties.put("mail.smtp.host", SMTP_HOST);
        properties.put("mail.smtp.port", SMTP_PORT);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        // Configure session with authentication
        jakarta.mail.Session session = jakarta.mail.Session.getInstance(properties, new Authenticator() {
            @Override
            protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                return new jakarta.mail.PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        try {
            // Create email message
            jakarta.mail.Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(jakarta.mail.Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setText(body);

            // Send email
            Transport.send(message);
            System.out.println("✅ Email sent successfully to " + recipient);
        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("❌ Failed to send email.");
        }
    }
}
