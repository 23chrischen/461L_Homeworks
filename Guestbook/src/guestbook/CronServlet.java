package guestbook;

import java.io.IOException;
import java.util.Properties;
import java.util.logging.Logger;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.*;
@SuppressWarnings("serial")

public class CronServlet extends HttpServlet {
	private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());

public void doGet(HttpServletRequest req, HttpServletResponse resp)
throws IOException {
	System.out.println("Tries to send an email."); 
    // Recipient email.
    String to = "pascalequeralt@gmail.com";

    // Sender's email ID needs to be mentioned
    String from = "test@gmail.com";

    // Get system properties
    Properties properties = new Properties();

    // Get the default Session object.
    Session session = Session.getDefaultInstance(properties, null);

    try{
       // Create a default MimeMessage object.
       MimeMessage message = new MimeMessage(session);
       // Set From: header field of the header.
       message.setFrom(new InternetAddress(from));
       // Set To: header field of the header.
       message.addRecipient(Message.RecipientType.TO,
                                new InternetAddress(to));
       // Set Subject: header field
       message.setSubject("This is the Subject Line!");
       // Now set the actual message
       message.setText("This is actual message");
       // Send message
       Transport.send(message);
       
       String title = "Send Email";
       String res = "Sent message successfully....";
       String docType =
       "<!doctype html public \"-//w3c//dtd html 4.0 " +
       "transitional//en\">\n";
       System.out.println(docType +
       "<html>\n" +
       "<head><title>" + title + "</title></head>\n" +
       "<body bgcolor=\"#f0f0f0\">\n" +
       "<h1 align=\"center\">" + title + "</h1>\n" +
       "<p align=\"center\">" + res + "</p>\n" +
       "</body></html>");
    }catch (MessagingException mex) {
       mex.printStackTrace();
    }
}
@Override
public void doPost(HttpServletRequest req, HttpServletResponse resp)
throws ServletException, IOException {

	doGet(req, resp);
}
}