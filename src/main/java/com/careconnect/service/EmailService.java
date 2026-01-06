package com.careconnect.service;

import java.io.InputStream;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {

    public static void sendEmail(String toEmail, String subject, String body) {
        final Properties props = new Properties();
        final Properties mailProps = new Properties();

        try (InputStream input = EmailService.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                System.out.println("Sorry, unable to find db.properties");
                return;
            }
            props.load(input);

            mailProps.put("mail.smtp.host", props.getProperty("mail.smtp.host"));
            mailProps.put("mail.smtp.port", props.getProperty("mail.smtp.port"));
            mailProps.put("mail.smtp.auth", props.getProperty("mail.smtp.auth"));
            mailProps.put("mail.smtp.starttls.enable", props.getProperty("mail.smtp.starttls.enable"));

            final String username = props.getProperty("mail.user");
            final String password = props.getProperty("mail.password");

            Session session = Session.getInstance(mailProps, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);

            System.out.println("✅ Email Sent Successfully to " + toEmail);

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ Failed to send email: " + e.getMessage());
        }
    }
}
