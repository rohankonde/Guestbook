package guestbook;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id; 

@Entity
public class Subscriber {
	@Id Long id;
	User user;
	
	private Subscriber(){}
	
	public Subscriber(User user){
		this.user = user;
	}
	
	public String getEmail(){
		return user.getEmail();
	}
	
	@Override
	public boolean equals(Object obj){
		if(obj == null)
			return false;
		
		if(!Subscriber.class.isAssignableFrom(obj.getClass()))
			return false;
		
		final Subscriber other = (Subscriber) obj;
		
		if(this.user.getEmail().equals(other.user.getEmail()))
			return true;
		return false;
	}
}
