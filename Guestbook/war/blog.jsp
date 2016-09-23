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
            <a href="/createPost.jsp">
                <button>Create Post</button>
            </a>
        <%
    } else {
%>

            <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">
                <button>Sign in</button>
            </a>
            <button>Login to create post</button>

        <%
    }
%>

        <% 
        	String numStr = request.getParameter("numPosts"); 
        	int numPosts = 4; // Default num posts to show
        	if(numStr != null) {
        		try { 
        			numPosts = Integer.parseInt(numStr); 
        		} catch (Exception e) {
        			numPosts = -1;
        		} 
        	} int showMore = (numPosts <= 0 ? 1 : numPosts*2);
        	int showLess = (numPosts <= 1 ? 1 : numPosts/2); 
        %>
        <a href="/blog.jsp?numPosts=<%= showMore%>">
            <button>Show More</button>
        </a>
        <a href="/blog.jsp?numPosts=<%= showLess%>">
            <button>Show Less</button>
        </a>
        <a href="/blog.jsp?numPosts=-1">
            <button>Show All</button>
        </a>

    </div>
    <div>
        <form action="/CronServlet" method="post">
            <div align="center">
                <br>
                    <input type="Email" name="title" cols="30" placeholder="Email">
                            </div>
                            <input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
                            <div align="center">
                                <div>
                        			<button type="submit" name="subscribe">Subscribe</button>
                        			<button type="submit" name="unsubscribe">Unsubscribe</button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <% ObjectifyService.register(BlogPost.class); List<BlogPost> blogPosts = ObjectifyService.ofy().load().type(BlogPost.class).list(); Collections.sort(blogPosts); if(numPosts > 0) { blogPosts = blogPosts.subList(0, numPosts); } if (blogPosts.isEmpty())
                    { %>

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

                </body>
            </html>
