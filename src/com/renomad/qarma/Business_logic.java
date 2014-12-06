package com.renomad.qarma;

import com.renomad.qarma.Database_access;
import com.renomad.qarma.Utilities;

public class Business_logic {


  /**
    * gets a full Request object by request_id, verifying the
    * user can access it.
    */
  public static Request get_a_request(int user_id, int request_id) {
    return Database_access.get_a_request(user_id, request_id);
  }

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
      String desc, String status, 
      String points, String title) {
    int p = Utilities.parse_int(points);
    String date = getCurrentDateSqlFormat();
    return Database_access.add_request(user_id,desc,status, date, p, title);
  }


  /**
    * given the query string, we will find the proper string
    * and convert that to a request, and return that.
    */
  public static Request parse_querystring_and_get_request(
      int user_id, String query_string) {
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
    return get_a_request(user_id, request_id);
  }


  public static Request[] get_requests_for_user(int user_id) {
    return Database_access.get_requests_for_user(user_id);
  }


  /**
    * adds a user.  if successful, returns true
    */
  public static boolean add_user(
			String first_name, String last_name, String email, String password) {
    return Database_access.add_user(first_name, last_name, email, password);
  }


  public static String[] get_all_users() {
    return Database_access.get_all_users();
  }


  /**
    * Request encapsulates a user's request.  It is an immutable object.
    * note that the fields are public, but final.  Once this object
    * gets constructed, there is no changing it.  You have to create a
    * new one.
    */
  public static class Request {

    Request ( int request_id, String datetime, String description, 
        int points, String status, String title, int requesting_user) {
      this.request_id       =  request_id;
      this.datetime         =  datetime;
      this.description      =  description;
      this.points           =  points;
      this.status           =  status;
      this.title            =  title;
      this.requesting_user  =  requesting_user;
    }

    public final int request_id;
    public final String datetime;
    public final String description;
    public final int points;
    public final String status;
    public final String title;
    public final int requesting_user;
  }



}
