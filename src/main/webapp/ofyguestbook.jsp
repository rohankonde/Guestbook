<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>
   	<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
  </head>

  <body>
  	
	<%
	
	    String guestbookName = request.getParameter("guestbookName");	
	    if (guestbookName == null) {
	        guestbookName = "default";
	    }
	
	    pageContext.setAttribute("guestbookName", guestbookName);
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();

	    if (user != null) {	
	      pageContext.setAttribute("user", user);
	%>

	<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
	
	<form action="/newpost" method="post">
    	<input type="submit" value="NEW POST" />
	</form>
	
	<%
	    } else {
	%>

	<p>Hello!
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
	to post.</p>
	
	
	<%
	    }
	%>
	
	<%
		ObjectifyService.register(Greeting.class);
		List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
		Collections.sort(greetings);
		Collections.reverse(greetings);
	
	    if (greetings.isEmpty()) {
	        %>
	        <p>Blog has no posts.</p>
	        <%
	    } else {
	        for (int i = 0; i < 5; i++) {
	        	Greeting greeting = greetings.get(i);
	            pageContext.setAttribute("greeting_content",
	                                     greeting.getContent());
	            if (greeting.getUser() == null) {
	                %>
	                <p>An anonymous person wrote:</p>
	                <%
	            } else {
	            	pageContext.setAttribute("greeting_title", greeting.getTitle());
	                pageContext.setAttribute("greeting_user",
	                                         greeting.getUser());
	                pageContext.setAttribute("greeting_date", greeting.getDate());
	
	                %>
	                <p style = "font-size:50;margin:0px;padding:0px"><b>${fn:escapeXml(greeting_title)}</b></p>
	                <p style = "margin:0px;padding:0px"><b>${fn:escapeXml(greeting_user.nickname)}</b> at <i>${fn:escapeXml(greeting_date)}</i>:</p>
	                <%
	            }
	            %>
	            <blockquote style = margin-bottom:25px">${fn:escapeXml(greeting_content)}</blockquote>
	            <%
	        }
	    }
	%>
	<form action="/history" method="post">
    	<input type="submit" value="View Post Archive" />
	</form>
  </body>
</html>