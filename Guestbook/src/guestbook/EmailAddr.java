package guestbook;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class EmailAddr implements Comparable<EmailAddr> {

    @Id Long id;
    String email;

    private EmailAddr() {}

    public EmailAddr(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }
    
    public Key<EmailAddr> getKey() {
    	return Key.create(EmailAddr.class, id);
    }
    
    @Override
    public int compareTo(EmailAddr other) {
    	return this.getEmail().compareTo(other.getEmail());
    }
    
    @Override
    public boolean equals(Object other) {
    	if (other.getClass() != EmailAddr.class)
    		return false;
    	else
    		return this.getEmail().equals(((EmailAddr) other).getEmail());
    }
}