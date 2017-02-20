package guestbook;

import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.googlecode.objectify.ObjectifyService;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

@SuppressWarnings("serial")
public class EmailCronServlet extends HttpServlet {
	private static final Logger _logger = Logger.getLogger(EmailCronServlet.class.getName());

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		_logger.info("Cron Job has been executed");
		System.out.println("Cron Job Executed");
		
		//Sendgrid mail
		String from = "rohankonde@utexas.edu";
	    String host = "localhost";//or IP address 
	    
	    Properties properties = new Properties();  
	    Session session = Session.getDefaultInstance(properties, null);  
	    
	    Message message = new MimeMessage(session);  
        
	    Date myDate = new Date();
	    Calendar cal = Calendar.getInstance();
	    cal.setTime(myDate);
	    cal.add(Calendar.DAY_OF_YEAR,-1);
	    Date dayBefore = cal.getTime();
	    
	    ObjectifyService.register(Greeting.class);
		List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
		Collections.sort(greetings);
		Collections.reverse(greetings);
		StringBuilder emailBody = new StringBuilder();
		
		System.out.println("Before Greetings");
		for(Greeting greet:greetings){
			if(greet.getDateObject().compareTo(dayBefore) > 0){
				emailBody.append("Title: "  + greet.getTitle() + "\n");
				emailBody.append("Author: "  + greet.getUser().getNickname() + "\n");
				emailBody.append("Date: "  + greet.getDate() + "\n");
				emailBody.append("Post: "  + greet.getContent() + "\n");
				emailBody.append("\n\n\n");
			}
		}
		System.out.println(emailBody.toString());
        
        try {
        	message.setFrom(new InternetAddress(from, "RH BLOG ADMINS"));
			message.setSubject("DAILY FEED From Rohan/Hari Blog ");
			message.setText(emailBody.toString());  
			System.out.println("Pre-Message Details");
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("PreMSG FAILED");
		}  
        
		ObjectifyService.register(Subscriber.class);
		List<Subscriber> subs = ObjectifyService.ofy().load().type(Subscriber.class).list();
		
		for(Subscriber sub:subs){
			try { 
				 System.out.println("setting recipient to " + sub.getEmail());
		         message.addRecipient(Message.RecipientType.TO,new InternetAddress(sub.getEmail()));  
		         System.out.println("about to send");
		         Transport.send(message);  
		         System.out.println("message sent successfully....");  

			} catch (AddressException e) {
				System.out.println("shittyaddress");
		    } catch (MessagingException e) {
		    	System.out.println("shittymessaghe");
		    } catch (Exception ex) {
				// Log any exceptions in your Cron Job
				System.out.println("FAILED TO SEND MESSAGE");
			}
		}
		
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
