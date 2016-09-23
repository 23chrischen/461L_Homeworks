<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="guestbook.BlogPost" %>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
	</head>
	<body>
		<img src="dog-header.jpg" width="100%"></img>
		<%
			UserService userService = UserServiceFactory.getUserService();
			User user = userService.getCurrentUser();
			%>
		<div class="button-header">
			<%
				//Check if user is logged in or not
				if (user != null) {
				  pageContext.setAttribute("user", user);
				%>
			<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">
			<button>Sign Out</button>
			</a>
			<%
				} else {
					response.sendRedirect("/blog.jsp");
				}
			%>
		</div>
		<form action="/ofysign" method="post">
			<div align="center">
				Blog Post Title:<br>
				<input type="text" name="title" cols="30"><br>
				Post Content:<br>
				<textarea name="content" rows="20" cols="65"></textarea>
			</div>
			<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
			
			<div align="center" class="post-cancel">
			<div id="post-cancel"><a href="/blog.jsp"><button type="button">Cancel</button></a></div>
			
			<div id="post-cancel"><input type="submit" value="Post Blog"/></div>
			
			</div>
			
		</form>
	</body>
</html>