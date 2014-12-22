package com.renomad.qarma;

import com.renomad.qarma.Business_logic;
import java.util.Arrays;

/**
	* Request encapsulates a user's request.  It is an immutable object.
	* note that the fields are public, but final.  Once this object
	* gets constructed, there is no changing it.  You have to create a
	* new one.
	*/
public class Request {

	public final int request_id;
	public final String datetime;
	public final String description;
	public final int points;
	public final int status;
	public final String title;
	public final int requesting_user_id;
	private Integer[] categories;

	/**
		* This constructor is probably used for sending a new
		* request to be added to the database, therefore we won't
		* have the request id yet.
		*/
	public Request ( String datetime, String description, 
			int points, int status, String title, 
			int requesting_user_id, Integer[] categories) {
		this(-1, datetime, description, points,
				status, title, requesting_user_id, categories);
	}

	/** 
		* This constructor is for those cases where we are getting 
		* data from the database.  It's difficult to get categories
		* at the same time, so we don't use it here.
		*/
	public Request ( int request_id, String datetime, String description, 
			int points, int status, String title, int requesting_user_id) {
		this(request_id, datetime, description, points,
				status, title, requesting_user_id, new Integer[0]);
	}

	public Request ( int request_id, String datetime, String description, 
			int points, int status, String title, int requesting_user_id,
			Integer[] categories) {
		this.request_id       =  request_id;
		this.datetime         =  datetime;
		this.description      =  description;
		this.points           =  points;
		this.status           =  status;
		this.title            =  title;
		this.requesting_user_id  =  requesting_user_id;
		this.categories       =  categories;
	}

	public Integer[] get_categories() {
		Integer[] c = Arrays.copyOf(categories, categories.length);
		return c;
	}

	public String get_status() {
		return Business_logic.get_request_status_localized(status);
	}
	
	/**
	 * Renders description after cleaning for html
	 * @return a html-safe rendering of description
	 */
	public String descriptionSafe() {
		return Utils.safe_render(description);
	}
	
	/**
	 * Renders title after cleaning for html
	 * @return a html-safe rendering of title
	 */
	public String titleSafe() {
		return Utils.safe_render(title);
	}


	public String get_categories_string() {
		StringBuilder sb = new StringBuilder("");
		for (Integer c : categories) {
			sb.append(Business_logic.get_category_localized(c)).append(" ");
		}
		return sb.toString();
	}


}
