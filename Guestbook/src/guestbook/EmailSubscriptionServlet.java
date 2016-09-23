package guestbook;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.http.*;
import guestbook.EmailAddr;
import com.googlecode.objectify.ObjectifyService;

public class EmailSubscriptionServlet extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse resp)
              throws IOException {
    		boolean saved = false;

    		final Logger _logger = Logger.getLogger(EmailSubscriptionServlet.class.getName());
    		String s = req.getParameter("email");
    		EmailAddr email = new EmailAddr(s);
    		ObjectifyService.register(EmailAddr.class);
    		List<EmailAddr> emails = ObjectifyService.ofy().load().type(EmailAddr.class).list();
    		String emailListStr = "Email list consists of: \n";
    		for (EmailAddr e : emails) {
    			emailListStr = emailListStr + e.getEmail() + "\n";
    			if (e.equals(email)) {
    				saved = true;
    			}
    		}
    		_logger.info(emailListStr);
    		
    		if (req.getParameter("subscribe") != null && !saved) {  
            	ObjectifyService.ofy().save().entity(email).now();
            	_logger.info("Subscribing " + email.getEmail());
    		}
    		
    		else if (req.getParameter("unsubscribe") != null && saved) {
    			for (int i = emails.size() - 1; i >= 0; i--) {
    				if(emails.get(i).equals(email))
                    	_logger.info("Unsubscribing " + email.getEmail());
    					ObjectifyService.ofy().delete().key(emails.get(i).getKey()).now();  
    					emails.remove(i);
    			}
    		}
    		
    		resp.sendRedirect("/blog.jsp");

    }
}