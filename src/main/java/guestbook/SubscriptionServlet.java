package guestbook;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

public class SubscriptionServlet extends HttpServlet{
	static{
    	ObjectifyService.register(Subscriber.class);
    }
	//public static Set<String> emailList = new HashSet<String>();
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        boolean subExists = false;
        long id = 0;
        
		List<Subscriber> subscribers = ObjectifyService.ofy().load().type(Subscriber.class).list();
        Key<Subscriber> subKey = Key.create(Subscriber.class, "subscriber");
        
        Subscriber newSub = new Subscriber(user);
        for(Subscriber sub:subscribers){
        	if(sub.equals(newSub)){
        		subExists = true;
        		id = sub.id;
        	}
        }
        
        if(subExists){
        	ofy().delete().type(Subscriber.class).id(id).now();
        	resp.sendRedirect("/ofyguestbook.jsp?subscribed=NO");
        }else{
        	
        	ofy().save().entity(newSub).now();
        	resp.sendRedirect("/ofyguestbook.jsp?subscribed=YES");
        }
    }
}
