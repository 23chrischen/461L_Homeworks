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

    <button><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a></button>

<%
    } else {
%>
	
	<button><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></button>
	
<%
    }
%>

  <input type="submit" id="createpost" value="Create Post"/>
  <button>Subscribe</button>
  <button>Unsubscribe</button>
  </div>

<%
	ObjectifyService.register(BlogPost.class);
	List<BlogPost> blogPosts = ObjectifyService.ofy().load().type(BlogPost.class).list();   
	Collections.sort(blogPosts); 
	
    if (blogPosts.isEmpty()) {
        %>

        <p>Our blog '${fn:escapeXml(blogName)}' has no messages.</p>

        <%
    } else {
        
        for (BlogPost blogPost : blogPosts) {

			      pageContext.setAttribute("blog_date", blogPost.getDate()); 

            pageContext.setAttribute("blog_user", blogPost.getUser()); 

            pageContext.setAttribute("blog_title", blogPost.getTitle()); 
            
            pageContext.setAttribute("blog_content", blogPost.getContent());

            %>

              <div class="blogpost">
                <p class="title">${fn:escapeXml(blog_title)}</p>
                <p class="author-date">Posted by ${fn:escapeXml(blog_user.nickname)} on ${fn:escapeXml(blog_date)}</p>
                <blockquote>${fn:escapeXml(blog_content)}</blockquote>

              </div>

            <%

        }
    }
%>



    <form action="/ofysign" method="post">
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Post Blog" /></div>
      <input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
    </form>

  </body>
</html>