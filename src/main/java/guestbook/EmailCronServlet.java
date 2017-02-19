package guestbook;

import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

@SuppressWarnings("serial")
public class EmailCronServlet extends HttpServlet {
	private static final Logger _logger = Logger.getLogger(EmailCronServlet.class.getName());

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		System.out.println("Cron Job Executed");
		resp.sendRedirect("/newpost.jsp");
		try {
			_logger.info("Cron Job has been executed");

			  String to = "rohankonde@yahoo.com";//change accordingly  
		      String from = "rohankonde@utexas.edu";
		      String host = "localhost";//or IP address  
		  
		     //Get the session object  
		      Properties properties = System.getProperties();  
		      properties.setProperty("mail.smtp.host", host);  
		      Session session = Session.getDefaultInstance(properties);  
		  
		     //compose the message  
		    
	         MimeMessage message = new MimeMessage(session);  
	         message.setFrom(new InternetAddress(from));  
	         message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));  
	         message.setSubject("Ping");  
	         message.setText("Hello, this is example of sending email  ");  
	  
	         // Send message  
	         //Transport.send(message);  
	         System.out.println("message sent successfully....");  

		} catch (Exception ex) {
			// Log any exceptions in your Cron Job
		}
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
