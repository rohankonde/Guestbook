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
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
	integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
	crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"
	integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp"
	crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"
	integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"
	crossorigin="anonymous"></script>
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
	<form class="form-horizontal" role="form" method="post" action="/ofysign">
	<div class="form-group">
		<label style="color:white" for="name" class="col-sm-2 control-label">Title</label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="name" name="title" placeholder="Enter Post Title" value="">
		</div>
	</div>
	
	<div class="form-group">
		<label style="color:white" for="message" class="col-sm-2 control-label">Content</label>
		<div class="col-sm-10">
			<textarea class="form-control" rows="4" name="content"></textarea>
		</div>
	</div>
	<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
	<div class="form-group">
		<div class="col-sm-10 col-sm-offset-2">
			<input id="submit" name="submit" type="submit" value="Submit" class="btn btn-primary">
		</div>
	</div>
	<input class="btn btn-primary" type="button" value="Back" onClick="history.go(-1);return true;">
	<div class="form-group">
		<div class="col-sm-10 col-sm-offset-2">
			<! Will be used to display an alert to the user>
		</div>
	</div>
<%-- </form>
    <form action="/ofysign" method="post">
      <div><textarea name="title" rows="1" cols="60"></textarea></div>
      <div><textarea name="content" rows="5" cols="60"></textarea></div>
      <div><input type="submit" value="Post" /></div>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
      <form><input Type="button" VALUE="Back" onClick="history.go(-1);return true;"></form>
    </form> --%>
  </body>
</html>