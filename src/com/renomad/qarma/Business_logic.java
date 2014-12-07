package com.renomad.qarma;

import com.renomad.qarma.Database_access;
import com.renomad.qarma.Utilities;

public class Business_logic {


  private static String getCurrentDateSqlFormat() {
    //all this just to get the date in a nice format for SQL!
    // like this: 2014-11-23 20:02:01
    java.util.Calendar cal = java.util.Calendar.getInstance();
    java.util.Date date = cal.getTime();
    java.text.SimpleDateFormat myformat = new java.text.SimpleDateFormat("yyyy-MM-dd kk:mm:ss"); 
    String formattedDate = null;
    try {
      formattedDate = myformat.format(date);
    } catch (Exception e1) {
      System.out.println("somehow, there was a failure with formatting the date!");
      System.out.println(e1);
    }
    return formattedDate;
  }
  
  public static boolean add_request(
      int user_id,
      String desc, int status, 
      String points, String title) {
    int p = Utilities.parse_int(points);
    String date = getCurrentDateSqlFormat();
    return Database_access.add_request(user_id,desc,status, date, p, title);
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
    return Database_access.get_a_request(request_id);
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

    Request_status ( int status_id, String status_value) {
      this.status_id       =  status_id;
      this.status_value    =  status_value;
    }

    public final int status_id;
    private final String status_value;

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

    Request ( int request_id, String datetime, String description, 
        int points, int status, String title, int requesting_user_id) {
			this(request_id, datetime, description, points,
					status, title, requesting_user_id, new Integer[0]);
		}

    Request ( int request_id, String datetime, String description, 
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
    private final int status;
    public final String title;
    public final int requesting_user_id;
		private final Integer[] categories;

		public String get_categories() {
    	//for now, there is no localization file, so we'll just include
			//the English here.
			String category = "";
			for(Integer c : categories) {

				switch(c) {
					case 1:
						category += "math";
						break;
					case 2:
						category += "physics";
						break;
					case 3:
						category += "economics";
						break;
					case 4:
						category += "history";
						break;
					case 5:
						category += "english";
						break;
					default:
						category += "ERROR";
				}
				category += ",";

			}
			return category;
		}

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
  }



}
