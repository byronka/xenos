package com.renomad.qarma;

import com.renomad.qarma.Database_access;

public class Business_logic {


  public static Request get_a_request(int user_id, int request_id) {
    return Database_access.get_a_request(user_id, request_id);
  }


  public static Request[] get_all_requests(int user_id) {
    return Database_access.get_all_requests(user_id);
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
