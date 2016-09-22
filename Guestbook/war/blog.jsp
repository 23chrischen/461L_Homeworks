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
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
 </head>

 

  <body>

 

<%

    String blogName = request.getParameter("blogName");

    if (blogName == null) {

        blogName = "Dog Blog";

    }

    pageContext.setAttribute("blogName", blogName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<p>Hi, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<p>Hello!

<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to include your name with greetings you post.</p>

<%

    }

%>

 

<%

	ObjectifyService.register(BlogPost.class);

	List<BlogPost> blogPosts = ObjectifyService.ofy().load().type(BlogPost.class).list();   

	Collections.sort(blogPosts); 
	

    if (blogPosts.isEmpty()) {

        %>

        <p>Our blog '${fn:escapeXml(blogName)}' has no messages.</p>

        <%

    } else {

        %>

        <p>Messages in Guestbook '${fn:escapeXml(blogName)}'.</p>

        <%

        for (BlogPost blogPost : blogPosts) {

			pageContext.setAttribute("blog_date", blogPost.getDate()); 
			
            %>

                <p>Posted on <b>${fn:escapeXml(blog_date)}</b></p>

            <%
                
            pageContext.setAttribute("blog_content",

                                     blogPost.getContent());

            if (blogPost.getUser() == null) {

                %>

                <p>An anonymous person wrote:</p>

                <%

            } else {

                pageContext.setAttribute("blog_user",

                                         blogPost.getUser());

                %>

                <p><b>${fn:escapeXml(blog_user.nickname)}</b> wrote:</p>

                <%

            }

            %>

            <blockquote>${fn:escapeXml(blog_content)}</blockquote>

            <%

        }

    }

%>

 

    <form action="/ofysign" method="post">

      <div><textarea name="content" rows="3" cols="60"></textarea></div>

      <div><input type="submit" value="Post Greeting" /></div>

      <input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>

    </form>

 

  </body>

</html>