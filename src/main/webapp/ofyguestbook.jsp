<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Collections"%>
<%@ page import="guestbook.Greeting"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
	<div class="bg"></div>
	<div class="jumbotron">
		<h1>The Rohan and Hari Blog</h1>
		<p class="lead">by Rohan Kondetimmanahalli and Hari Kosuru</p>
	</div>

	<%
		String guestbookName = request.getParameter("guestbookName");
		if (guestbookName == null) {
			guestbookName = "default";
		}
		
		String subscribed = request.getParameter("subscribed");
		if(subscribed == null){
			subscribed = "NO";
		}
		pageContext.setAttribute("subscribed", subscribed);

		pageContext.setAttribute("guestbookName", guestbookName);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		if (user != null) {
			pageContext.setAttribute("user", user);
	%>

	<p style="margin:0px;padding:0px;color:white">
		Hello, ${fn:escapeXml(user.nickname)}! (You can <a
			href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
			out</a>.)
	</p>

	<div class="row" style="margin-top:10px">
		<div class="col-sm-1">
			<form action="/newpost" method="post">
				<input class="btn btn-primary" type="submit" value="New Post">
			</form>
		</div>
		<div class="col-sm-1">
			<form action="/history" method="post">
				<input class="btn btn-primary" type="submit" value="View Post Archive">
			</form>
		</div>
			
	</div>
	<%
			if(subscribed.equals("YES")){
		%>
		<div class = "row" style="margin-top:10px">
		<div class="col-sm-1">
			<form action="/subscribe" method="post">
				<input class="btn btn-primary" type="submit" value="Unsubscribe">
			</form>
		</div></div>
		<%
			}else{
		%>
		<div class = "row" style="margin-top:10px">
		<div class="col-sm-1">
			<form action="/subscribe" method="post">
				<input class="btn btn-primary" type="submit" value="Subscribe">
			</form>
		</div></div>
		<% } %>	
	<%
		} else {
	%>

	<p style="margin:0px;padding:0px;color:white">
		Hello! <a
			href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
			in</a> to post.
	</p>
	<div class="row" style="margin-top:10px">
		<div class="col-sm-1">
			<form action="/history" method="post">
				<input class="btn btn-primary" type="submit" value="View Post Archive">
			</form>
		</div>	
	</div>

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
			for (int i = 0; i < Math.min(greetings.size(),5); i++) {
				Greeting greeting = greetings.get(i);
				pageContext.setAttribute("greeting_content", greeting.getContent());
				if (greeting.getUser() == null) {
	%>
	<p>An anonymous person wrote:</p>
	<%
		} else {
					pageContext.setAttribute("greeting_title", greeting.getTitle());
					pageContext.setAttribute("greeting_user", greeting.getUser());
					pageContext.setAttribute("greeting_date", greeting.getDate());
	%>
	<div class="container" style="margin:0px;padding:0px;margin-left:10px">
		<div class="row">
			<div class="col-sm-12">
				<h3 style="color:white">${fn:escapeXml(greeting_title)}</h3>
			</div>
			<!-- /col-sm-12 -->
		</div>
		<!-- /row -->
		<div class="row">
			<div class="col-sm-1">
				<div class="thumbnail">
					<img class="img-responsive user-photo"
						src="https://ssl.gstatic.com/accounts/ui/avatar_2x.png">
				</div>
				<!-- /thumbnail -->
			</div>
			<!-- /col-sm-1 -->

			<div class="col-sm-5">
				<div class="panel panel-default">
					<div class="panel-heading">
						<strong>${fn:escapeXml(greeting_user.nickname)}</strong> <span class="text-muted">posted
							on ${fn:escapeXml(greeting_date)}</span>
					</div>
					<div class="panel-body">${fn:escapeXml(greeting_content)}</div>
					<!-- /panel-body -->
				</div>
				<!-- /panel panel-default -->
			</div>
			<!-- /col-sm-5 -->
		</div>
		<!-- /row -->

	</div>
	<!-- /container -->
	<%-- <p style="font-size: 50; margin: 0px; padding: 0px">
		<b>${fn:escapeXml(greeting_title)}</b>
	</p>
	<p style="margin: 0px; padding: 0px">
		<b>${fn:escapeXml(greeting_user.nickname)}</b> at <i>${fn:escapeXml(greeting_date)}</i>:
	</p> --%>
	<%
		}
	%>
	<%-- <blockquote style="margin-bottom: 25px"">${fn:escapeXml(greeting_content)}</blockquote> --%>
	<%
		}
		}
	%>
	
	
</body>
</html>