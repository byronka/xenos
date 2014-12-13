package com.renomad.qarma;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import com.renomad.qarma.Database_access;
import com.renomad.qarma.Utils;

public class Business_logic {

		public static String[] get_all_categories() {
    	Map<Integer,String> categories = Database_access.get_all_categories();
			java.util.Collection<String> c = categories.values();
			String[] cat_array = c.toArray(new String[0]);
			return cat_array;
		}

  private static String getCurrentDateSqlFormat() {
    //all this just to get the date in a nice format for SQL!
    // like this: 2014-11-23 20:02:01
    java.util.Calendar cal = java.util.Calendar.getInstance();
    java.util.Date date = cal.getTime();
    java.text.SimpleDateFormat myformat = 
			new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
    String formattedDate = null;
    try {
      formattedDate = myformat.format(date);
    } catch (Exception e1) {
      System.err.println(
					"somehow, there was a failure with formatting the date!");
      System.err.println(e1);
    }
    return formattedDate;
  }
  

  /**
    * given all the data to add a request, does so.
    * if any parts fail, this will return false.
    * @param user_id the user's id
    * @param desc a description string, the core of the request
    * @param status look in the database for request status.  e.g. open, closed, taken
    * @param points the points are the currency for the request
    * @param title the short title for the request
    * @param categories the various categories for this request, provided to us here as a single string.  Comes straight from the client, we have to parse it.
    * @return false if an error occured.
    */
  public static boolean add_request(
      int user_id, String desc, int status, 
      String points, String title, String categories) {

		if (user_id < 1) {
			System.err.println(
				"error: user id was below 1: it was " + user_id + " in add_request");
			return false;
		}

		//extract useful information from what the client sent us
    int p = Utils.parse_int(points);
    String date = getCurrentDateSqlFormat();

    //parse out the categories from a string the client gave us
		Integer[] categories_array = parse_categories_string(categories);
		
		if (categories_array.length == 0) {return false;}

    //send parsed data to the database
    int new_request_id = 
      Database_access.add_request(user_id,desc,status, date, p
					, title, categories_array);

    if (new_request_id == -1) {
      System.err.println(
          "error adding request at Business_logic.add_request()");
      return false;
    }

    return true;
  }


	/**
		* Convert a single string containing multiple categories into 
		* an array of integers representing those categories.
		* the easy way to handle this is to get all the categories and then
		* indexof() the string for them.
    * @param categories_str a single string that contains 0 or more 
		* category words, localized.  This value comes straight 
		* unchanged from the client.
		* @return an integer array of the applicable categories
		*/
	private static Integer[] parse_categories_string(String categories_str) {
    
		Map<Integer,String> all_categories = 
			Database_access.get_all_categories();
    
    //guard clauses
    if (all_categories == null) {return new Integer[0];}
    if (categories_str.length() == 0) {return new Integer[0];}

		String lower_case_categories_str = categories_str.toLowerCase();
		ArrayList<Integer> selected_categories = new ArrayList<Integer>();
		for (Integer i : all_categories.keySet()) {
    	String c = Database_access.get_category_localized(i);
			if (lower_case_categories_str.contains(c)) {
				selected_categories.add(i);
			}
		}
    Integer[] my_array = 
			selected_categories.toArray(new Integer[selected_categories.size()]);
		return my_array;
	}

	public static String get_user_displayname(int user_id) {
  	return Database_access.get_user_displayname(user_id);
	}


  /**
    * given the query string, we will find the proper string
    * and convert that to a request, and return that.
    */
  public static 
		Request parse_querystring_and_get_request(String query_string) {
    String qs = null;
    int request_id = 0;
    int value_index = 0;
    String request_string = "request=";
    int rsl = request_string.length();
    //if we have a query string and it has request= in it.
    if ((qs = query_string) != null &&
        (value_index = qs.indexOf(request_string)) >= 0) {
        request_id = Integer.parseInt(qs.substring(rsl));
    }
    Request r = Database_access.get_a_request(request_id);
		if (r == null) {
			return new Request(0,"","",0,1,"",0);
		}
		return r;
  }


  public static Request[] get_requests_for_user(int user_id) {
    return Database_access.get_requests_for_user(user_id);
  }


  public static Request[] get_all_requests_except_for_user(int user_id) {
    return Database_access.get_all_requests_except_for_user(user_id);
  }


  /**
    * adds a user.  if successful, returns true
    */
  public static boolean add_user(
			String first_name, String last_name, String email, String password) {
      Utils.null_or_empty_string_validation(first_name);
      Utils.null_or_empty_string_validation(last_name);
      Utils.null_or_empty_string_validation(email);
      Utils.null_or_empty_string_validation(password);
    return Database_access.add_user(first_name, last_name, email, password);
  }


	public static Request_status[] get_request_statuses() {
		return Database_access.get_request_statuses();
	}


  /**
    * Request_status is the enumeration of request statuses.  
		* It is an immutable object.
    * note that the fields are public, but final.  Once this object
    * gets constructed, there is no changing it.  You have to create a
    * new one.
    */
  public static class Request_status {

    public Request_status ( int status_id, String status_value) {
      this.status_id       =  status_id;
      this.status_value    =  status_value;
    }

    public final int status_id;
    public final String status_value;

		public String get_status_value() {
    	//for now, there is no localization file, so we'll just include
			//the English here.
			switch(status_id) {
				case 1:
					return "open";
				case 2:
					return "closed";
				case 3:
					return "taken";
				case 4:
					return "ERROR_STATUS_DEV_FIX_ME";
			}
			return "";
		}

  }

  /**
    * Request encapsulates a user's request.  It is an immutable object.
    * note that the fields are public, but final.  Once this object
    * gets constructed, there is no changing it.  You have to create a
    * new one.
    */
  public static class Request {

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


    public final int request_id;
    public final String datetime;
    public final String description;
    public final int points;
    public final int status;
    public final String title;
    public final int requesting_user_id;
		public final Integer[] categories;


		public String get_status() {
    	//for now, there is no localization file, so we'll just include
			//the English here.
			switch(status) {
				case 1:
					return "open";
				case 2:
					return "closed";
				case 3:
					return "taken";
				default:
					return "ERROR_STATUS_DEV_FIX_ME";
			}
		}

		public String get_categories() {
			String cat_string = "";
			for (Integer c : categories) {
				cat_string += Database_access.get_category_localized(c);
				cat_string += ", ";
			}
			return cat_string;
		}
  }



}
