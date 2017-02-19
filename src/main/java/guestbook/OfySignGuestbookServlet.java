//rak2369
//https://solar-study-157203.appspot.com/ofyguestbook.jsp?guestbookName=default
package guestbook;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.googlecode.objectify.Objectify;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.*;

import static com.googlecode.objectify.ObjectifyService.ofy;

public class OfySignGuestbookServlet extends HttpServlet {
	static{
    	ObjectifyService.register(Greeting.class);
    }
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();    
       
        String guestbookName = req.getParameter("guestbookName");
        Key<Greeting> guestbookKey = Key.create(Greeting.class, guestbookName);

        String content = req.getParameter("content");
        String title = req.getParameter("title");
        Date date = new Date();

        
        Greeting greeting = new Greeting(user, content, title);
        ofy().save().entity(greeting).now();
        resp.sendRedirect("/ofyguestbook.jsp?guestbookName=" + guestbookName);
    }
}