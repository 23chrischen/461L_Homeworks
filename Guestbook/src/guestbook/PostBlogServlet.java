//http://guestbook-objectify.appspot.com/

package guestbook;

 
import static com.googlecode.objectify.ObjectifyService.ofy;
import com.googlecode.objectify.ObjectifyService;

import com.google.appengine.api.users.User;

import com.google.appengine.api.users.UserService;

import com.google.appengine.api.users.UserServiceFactory;

 

import java.io.IOException;

import java.util.Date;

 

import javax.servlet.http.HttpServlet;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

public class PostBlogServlet extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {

        UserService userService = UserServiceFactory.getUserService();

        User user = userService.getCurrentUser();

        String content = req.getParameter("content");
        
        String title = "Fix title later"; 

        BlogPost blogPost = new BlogPost(user, title, content);

        ObjectifyService.ofy().save().entity(blogPost).now();

        resp.sendRedirect("/blog.jsp?blogName=" + blogPost.getUser());

    }

}