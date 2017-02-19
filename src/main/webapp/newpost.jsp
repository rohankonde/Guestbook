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
	%>
	
    <form action="/ofysign" method="post">
      <div><textarea name="title" rows="1" cols="60"></textarea></div>
      <div><textarea name="content" rows="5" cols="60"></textarea></div>
      <div><input type="submit" value="Post" /></div>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
      <form><input Type="button" VALUE="Back" onClick="history.go(-1);return true;"></form>
    </form>
  </body>
</html>