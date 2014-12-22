package com.renomad.qarma;


/**
	* User encapsulates the core traits of a user.  It is an immutable object.
	* note that the fields are public, but final.  Once this object
	* gets constructed, there is no changing it.  You have to create a
	* new one.
	*/
public class User {

	public final String first_name;
	public final String last_name;
	public final String email;
	public final String password;
	public final int points;

	public User (
			String first_name, 
			String last_name, String email, String password, int points) {
		this.first_name = first_name;
		this.last_name = last_name;
		this.email = email;
		this.password = password;
		this.points = points;
	}
	
	/**
	 * A html-cleaned version of first_name
	 * @return html-cleaned text
	 */
	public String first_nameSafe() {
		return Utils.safe_render(first_name);
	}
	
	/**
	 * A html-cleaned version of last_name
	 * @return html-cleaned text
	 */
	public String last_nameSafe() {
		return Utils.safe_render(last_name);
	}
	
	/**
	 * A html-cleaned version of email
	 * @return html-cleaned text
	 */
	public String emailSafe() {
		return Utils.safe_render(email);
	}
	
}
