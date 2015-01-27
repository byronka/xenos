package com.renomad.xenos;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import com.renomad.xenos.Database_access;
import com.renomad.xenos.Request;
import com.renomad.xenos.Others_Request;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
  * this class consists of methods that act upon Requests
  */
public final class Request_utils {

  private Request_utils() {
    //private constructor.  This class is not allowed to be
    //instantiated.  do nothing here.
  }


  /**
    * given an array of words, we'll look up the local words
    * for statuses and see if any match.  If so, we'll return those
    * as an array of ints.
    * @param stats the words we'll compare to see if 
    *  they are localized statuses
    * @param loc the localization object
    * @return an array of ints of statuses that were 
    *  found amongst the words.
    */
  public static Integer[] 
    parse_statuses_string(String[] stats, Localization loc) {
    //get all the localized statuses
    //compare those with stats
    //return the id's of statuses that were found.
    return new Integer[0];
  }


  /**
    * returns a list of localization values for the categories
    * @return List of Integers representing localization values 
    *   for categories, or null if nothing in db. The
    */
  public static ArrayList<Integer> get_all_categories() {
    // 1. set the sql
    String sqlText = 
      "SELECT category_id, request_category_value "+
      "FROM request_category; ";
    // 2. set up values we'll need outside the try
    PreparedStatement pstmt = null;
    try {
      // 3. get the connection and set up a statement
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      // 4. execute a statement
      ResultSet resultSet = pstmt.executeQuery();
      // 5. check that we got results
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      // 6. get values from database and convert to an object
      //keep adding rows of data while there is more data
      ArrayList<Integer> categories = new ArrayList<Integer>();
      while(resultSet.next()) {
        int rcid = resultSet.getInt("category_id");
        categories.add(rcid); 
      }

      return categories;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  /**
    * Gets a specific Request 
    * 
    * @param request_id the id of a particular Request
    * @return a single Request, or null if failure
    */
  public static Request get_a_request(int request_id) {
    
    String sqlText = 
      "SELECT r.request_id, r.datetime, r.description, r.points,"+
      "r.status, r.title, r.requesting_user_id, "+
      "GROUP_CONCAT(rc.category_id SEPARATOR ',') AS categories "+
      "FROM request r "+
      "JOIN request_to_category rtc ON rtc.request_id = r.request_id "+
      "JOIN request_category rc "+
        "ON rc.category_id = rtc.request_category_id "+
      "WHERE r.request_id = ? GROUP BY request_id";

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, request_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next();
      int rid = resultSet.getInt("request_id");
      String dt = resultSet.getString("datetime");
      String d = resultSet.getNString("description");
      int p = resultSet.getInt("points");
      int s = resultSet.getInt("status");
      String t = resultSet.getNString("title");
      int ru = resultSet.getInt("requesting_user_id");
      String ca = resultSet.getString("categories");
      Integer[] categories = parse_string_to_int_array(ca);
      Request request = new Request(rid,dt,d,p,s,t,ru,categories);

      return request;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  /**
    * An object used to hold the values
    * necessary for advanced search.  Immutable.
    */
  public static class Search_Object {

    public final String startdate;
    public final String enddate;

    public final String title;

    /**
      * categories as an array of numbers, delimited by commas
      */
    public final String categories;

    /**
      * statuses as an array of numbers, delimited by commas
      */           
    public final String statuses;

    /**
      * user ids as an array of numbers, delimited by commas
      */
    public final String user_ids;


    public final Integer minpoints;
    public final Integer maxpoints;

    public Search_Object(
        String startdate,
        String enddate,
        String title,
        String categories,
        String statuses,
        Integer minpoints,
        Integer maxpoints,
        String user_ids) {
      this.startdate = startdate;
      this.enddate = enddate;
      this.title = title;
      this.categories = categories;
      this.statuses = statuses;
      this.minpoints = minpoints;
      this.maxpoints = maxpoints;
      this.user_ids = user_ids;
    }

  }


  /**
    * Gets information necessary for display on the dashboard,
    * about requests that are not the currently logged-in user's.
    * 
    * @param ruid the id of the user asking for the requests.
    * @param so an object that holds all the ways to search
    * the requests.  Things like, dates, categories, titles, etc.
    * @param page This method is used to display requests, and we
    * include paging functionality - splitting the response into
    * pages of data.  Which page are we on?
    * @return an array of Others_Requests that were *not* made 
    * by that user, or an empty array of Others_Requests if failure or
    * none.
    */
  public static Others_Request[] get_others_requests(
      int ruid, 
      Search_Object so, 
      int page) {

    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_setup.sql get_others_requests for
      // details on this stored procedure.
      cs = conn.prepareCall(String.format(
        "{call get_others_requests(%d,?,?,?,?,?,%d,%d,?,%d)}"
        ,ruid, so.minpoints, so.maxpoints, page));
      cs.setNString(1, so.title);
      cs.setString(2, so.startdate);
      cs.setString(3, so.enddate);
      cs.setString(4, so.statuses);
      cs.setString(5, so.categories);
      cs.setString(6, so.user_ids);
      ResultSet resultSet = cs.executeQuery();

      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Others_Request[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<Others_Request> requests = 
        new ArrayList<Others_Request>();
      while(resultSet.next()) {
        int rid = resultSet.getInt("request_id");
        String dt = resultSet.getString("datetime");
        String d = resultSet.getNString("description");
        int p = resultSet.getInt("points");
        int s = resultSet.getInt("status");
        String t = resultSet.getNString("title");
        int ru = resultSet.getInt("requesting_user_id");
        int ra = resultSet.getInt("rank");
        String cats = resultSet.getString("categories");
        Integer[] cat_array = parse_string_to_int_array(cats);

        Others_Request request = 
          new Others_Request(t,dt,d,s,ra,p,rid,ru,cat_array);
        requests.add(request);
      }

      //convert arraylist to array
      Others_Request[] array_of_requests = 
        requests.toArray(new Others_Request[requests.size()]);
      return array_of_requests;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Others_Request[0];
    } finally {
      Database_access.close_statement(cs);
    }
  }


  /**
    * This will take a string of numerals separated by commas
    * and return an Integer array of those.
    * for example, given "1,2,3" it will return an array having
    * [1,2,3]
    * @return an Integer array, or an empty Integer array if no
    * string numbers found.
    */
  private static Integer[] parse_string_to_int_array(String value) {
    if (!Utils.is_null_or_empty(value)) {
      String[] numerals = value.split(",");
      Integer[] return_array = new Integer[numerals.length];
      for (int i = 0; i < numerals.length; i++) {
        return_array[i] = Integer.parseInt(numerals[i]);
      }
      return return_array;
    }
    return new Integer[0];
  }


  /**
    * Gets all the requests for the user.
    * 
    * @param user_id a particular user's id
    * @return an array of Requests made by that user.
    */
  public static Request[] get_requests_for_user(int user_id) {
    String sqlText = "SELECT * FROM request WHERE requesting_user_id = ?";
    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Request[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<Request> requests = new ArrayList<Request>();
      while(resultSet.next()) {
        int rid = resultSet.getInt("request_id");
        String dt = resultSet.getString("datetime");
        String d = resultSet.getNString("description");
        int p = resultSet.getInt("points");
        int s = resultSet.getInt("status");
        String t = resultSet.getNString("title");
        int ru = resultSet.getInt("requesting_user_id");
        Request request = new Request(rid,dt,d,p,s,t,ru);
        requests.add(request);
      }

      //convert arraylist to array
      Request[] array_of_requests = 
        requests.toArray(new Request[requests.size()]);
      return array_of_requests;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }



  

  /**
    * deletes a request.
    * @param request_id the id of the request to delete
    * @param deleting_user_id the id of the user making the request
    * @return true if successful
    */
  public static boolean delete_request(int request_id, int deleting_user_id) {
    // 0. Get this request object in memory, we need some values
    //    for auditing purposes and deducting points
    Request request_to_delete = get_a_request(request_id);
    if (request_to_delete == null) {
      return false;
    }

    // 1. set the sql
    String delete_request_sql = 
      "DELETE FROM request WHERE request_id = ?";
    String update_points_sql = 
      "UPDATE user SET points = points + ? WHERE user_id = ?";

    int result = -1; //default to a guard value that indicates failure
    PreparedStatement del_pstmt = null; //the deletion statement
    PreparedStatement up_pts_pstmt = null; //updating the points statement
    Connection conn = null;
    try {
      // 3. get the connection and set up a statement
      conn = Database_access.get_a_connection();

      //check if the user wanting the delete is the one who
      //created the Request.  If not, deny!
      //note: we may change this in the future to allow admin privs.
      if (deleting_user_id != request_to_delete.requesting_user_id) {
        conn.rollback();
        return false;
      }

      //delete the request
      del_pstmt = Database_access
        .prepare_statement(conn, delete_request_sql);
      del_pstmt.setInt(1, request_id); 
      Database_access.execute_update(del_pstmt);

      up_pts_pstmt = Database_access
        .prepare_statement(conn, update_points_sql);
      up_pts_pstmt.setInt(1,request_to_delete.points); 
      up_pts_pstmt.setInt(2,request_to_delete.requesting_user_id); 
      Database_access.execute_update(up_pts_pstmt);

      //get audit info notes
      String my_notes = create_deletion_audit_notes(request_to_delete);

      final int delete_action = 2;

      Utils.create_audit(delete_action, deleting_user_id, request_id, my_notes);

    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(del_pstmt);
      Database_access.close_statement(up_pts_pstmt);
    }
    return true;
  }


  /**
    * adds information for the audit of a deletion.  The special
    * thing here is that since we are actually losing info ( we
    * are really deleting this row) we want to keep some meta
    * data for the future just in case.  So we collect some of
    * the title, description, points, creation date, etc. as notes
    */
  private static String create_deletion_audit_notes(Request r) {

      //description - get no more than 20 chars
      String descr = r.description;
      String cropped_desc = descr.length() <= 30 ? 
        descr : 
        descr.substring(0,30);

      //title - get no more than 10 chars
      String title = r.title;
      String cropped_title = title.length() <= 20 ? 
        title : 
        title.substring(0,20);

      String date_created = r.datetime.substring(0,10);
      int points = r.points;

      //get the status string, localized to English
      final int admin_user_id = 1;
      Localization loc  = new Localization(admin_user_id);
      int loc_status_value = 
         get_status_localization_value(r.status);
      String status_string = loc.get(loc_status_value, "");

      String my_notes = String.format("%s|%s|created:%s|pts:%d|st:%s", 
          cropped_title, 
          cropped_desc, 
          date_created, 
          points, 
          status_string);

      return my_notes;
  }


  /**
    * given all the data to add a request, does so.
    * @param user_id the user's id
    * @param desc a description string, the core of the request
    * @param points the points are the currency for the request
    * @param title the short title for the request
    * @param categories the various categories for this request, 
    */
  public static Request_response put_request(
      int user_id, String desc, int points, 
      String title, Integer[] categories) {

    //set up a request object to store this stuff
    int status = 1; //always starts open
    Request request = new Request(
        "", desc, points, status, title, user_id, categories);

    //send parsed data to the database
    Request_response response = put_request(request);
    return response;
  }


  /**
    * gets all the request categories that exist as an
    * array of their localization values, as Integers.
    * @return a Integer array of all categories' localization values,
    * useful for calling to the localization mechanism.  See
    * com.renomad.xenos.Localization
    */
  public static Integer[] get_category_local_values() {
      List<Integer> c = get_all_categories();
      Integer[] cat_array = c.toArray(new Integer[c.size()]);
      return cat_array;
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
  public static Integer[] 
    parse_categories_string(String categories_str, Localization loc) {
    List<Integer> all_categories = get_all_categories();
    
    //guard clauses
    if (all_categories == null) {return new Integer[0];}
    if (categories_str == null || 
        categories_str.length() == 0) {return new Integer[0];}

    String lower_case_categories_str = categories_str.toLowerCase();
    ArrayList<Integer> selected_categories = new ArrayList<Integer>();
    for (Integer i : all_categories) {
      String c = loc.get(i,"").toLowerCase();
      if (lower_case_categories_str.contains(c)) {
        selected_categories.add(i);
      }
    }
    Integer[] my_array = 
      selected_categories.toArray(new Integer[selected_categories.size()]);
    return my_array;
  }


  /**
    * This assembles the sql statement to insert categories
    * into the request_to_category table when we create a request.
    */
  private static String assemble_categories_sql(Request r) {
    StringBuilder sb = new StringBuilder("");
    sb.append("INSERT into request_to_category ")
      .append("(request_id,request_category_id) ")
      .append("VALUES (?, ?)"); 

    for (int i = 1; i < r.get_categories().length; i++) {
      sb.append(",(?, ?)");
    }

    String update_categories_sql = sb.toString();
    return update_categories_sql;
  }


  /**
    * Adds a request into the request table
    * @return a request_response either indicating the new request id,
    *  or an int below 0 indicating failure and an error type.
    */
  private static Request_response
    insert_into_request_table(Connection c, Request r, String sql) {

    PreparedStatement req_pstmt = null;
    int result = -1;

    try {
      req_pstmt = Database_access.prepare_statement(c, sql);

      //set values for adding request
      req_pstmt.setNString(1, r.description);
      req_pstmt.setInt( 2, r.points);
      req_pstmt.setInt( 3, r.status);
      req_pstmt.setNString( 4, r.title);
      req_pstmt.setInt( 5, r.requesting_user_id);

      result = Database_access.execute_update(req_pstmt);
      // 6. check results of statement, if good, continue, if bad, rollback
      //if we get a -1 for our id, the request insert didn't go through.  
      //so rollback.
      if (result < 0) {
        System.err.println(
          "Error(2):Transaction is being rolled back for request_id: " +
          result);
        c.rollback();
        return new Request_response(Request_response.Stat.ERROR, -1);
      }
      req_pstmt.close();
    } catch (SQLException ex) {
      //look for the error from the trigger to check points
      if (ex.getMessage()
          .contains("user lacks points to make this request")) {
        return new Request_response(Request_response.Stat.LACK_POINTS, -1);
      }
      Database_access.handle_sql_exception(ex, req_pstmt);
      return new Request_response(Request_response.Stat.ERROR, -1);
    }

    return new Request_response(Request_response.Stat.OK, result);
  }


  /**
    * Adds to the request_to_category table for a new request
    * @param result the id of the newly-created request.  we'll use
    *  this for setting the categories properly.
    * @param sql the sql we'll use to add categories.  Dynamically created
    * @return null if successful, Request_response otherwise.
    */
  private static Request_response 
    update_categories_for_request(
        Connection c, String sql, int result, Request r) {

    PreparedStatement cat_pstmt = null;
    Integer[] cats = r.get_categories();
    try {
      cat_pstmt = Database_access.prepare_statement(c, sql);
      for (int i = 0; i < cats.length; i++ ) {
        int category_id = cats[i];
        cat_pstmt.setInt( 2*i+1, result);
        cat_pstmt.setInt( 2*i+2, category_id);
      }
      Database_access.execute_update(cat_pstmt);
      cat_pstmt.close();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex, cat_pstmt);
      return new Request_response(Request_response.Stat.ERROR, -1);
    } 
    return null;
  }


  /**
    * Deducts points from the user.  Note there is a trigger to check
    * the user has the required points, so if we get to this point
    * we're good. Trigger is: trg_error_if_user_lacks_points_for_rqst
    * @return null if successful, Request_response otherwise.
    */
  private static Request_response 
    deduct_user_points(Connection c, String sql, Request r) {

    PreparedStatement up_points_pstmt = null;

    try {
      up_points_pstmt = Database_access.prepare_statement(c, sql);

      up_points_pstmt.setInt(1, r.points);
      up_points_pstmt.setInt(2, r.requesting_user_id);

      Database_access.execute_update(up_points_pstmt);

      up_points_pstmt.close();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex, up_points_pstmt);
      return new Request_response(Request_response.Stat.ERROR, -1);
    }
    return null;
  }


  /**
    * adds a Request to the database.  This is a bit complex because
    * we have to do multiple things to do this right:
    * We have to make sure the user has enough points for the request
    * (checking the user's points is handled in a trigger, see
    *  trg_error_if_user_lacks_points_for_rqst in v1_setup.sql)
    * We have to add the request
    * We have to add to the request_to_categories table
    * We have to deduct points from the user
    * If anything goes wrong, everything needs to roll back
    * @param request a request object
    * @return the id of the new request. -1 if not successful.  also an
    * enum that designates the error if one exists, like lacking points
    */
  private static Request_response put_request(Request request) {

    String update_request_sql = 
      "INSERT into request (description, datetime, points, " + 
      "status, title, requesting_user_id) "+
      "VALUES (?, UTC_TIMESTAMP(), ?, ?, ?, ?)"; 
    String update_categories_sql = assemble_categories_sql(request);
    String update_points_sql = 
      "UPDATE user SET points = points - ? WHERE user_id = ?";

    Connection conn = null;
    try {
      conn = Database_access.get_a_connection();
      conn.setAutoCommit(false);
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
    }

    //If any of the following, A, B, or C, fail, then we want to
    //immediately return a response indicating error and halt
    //execution here.

    int request_id = -1; //this will hold the newly inserted request id

    Request_response response = null;

    // A) Insert the request
    response = 
      insert_into_request_table(conn, request, update_request_sql);
    if (response.status != Request_response.Stat.OK) {
      Database_access.close_connection(conn);
      return response;
    } else {
      request_id = response.id;
    }


    // B) Update the categories
    response = update_categories_for_request(
        conn, update_categories_sql, request_id, request);
    if (response != null) {
      Database_access.close_connection(conn);
      return response;
    }

    // C) Deduct points from user
    response = deduct_user_points(conn, update_points_sql, request);
    if (response != null) {
      Database_access.close_connection(conn);
      return response;
    }

    //if we got to this point, we saw no errors along the way.
    try {
      conn.commit();
      Utils.create_audit(1, request.requesting_user_id, request_id, "");
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
    } finally {
      if (conn != null) {
        try {
          conn.close();
        } catch (SQLException ex) {
          Database_access.handle_sql_exception(ex);
        }
      }
    }
    //indicate all is well, along with the new id
    return new Request_response(Request_response.Stat.OK, request_id);
  }


  /**
    * gets all the current request statuses, like OPEN, CLOSED, and TAKEN
    * @return an array of request statuses, or null if failure.
    */
  public static Request_status[] get_request_statuses() {
    // 1. set the sql
    String sqlText = 
      "SELECT request_status_id, request_status_value "+
      "FROM request_status;";

    // 2. set up values we'll need outside the try
    PreparedStatement pstmt = null;
    try {
      // 3. get the connection and set up a statement
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);

      // 4. execute a statement
      ResultSet resultSet = pstmt.executeQuery();

      // 5. check that we got results
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Request_status[0];
      }

      // 6. get values from database and convert to an object
      //keep adding rows of data while there is more data
      ArrayList<Request_status> statuses = 
        new ArrayList<Request_status>();
      while(resultSet.next()) {
        int sid = resultSet.getInt("request_status_id");
        String sv = resultSet.getString("request_status_value");
        Request_status status = new Request_status(sid,sv);
        statuses.add(status);
      }

      // 7. if necessary, create array of objects for return
      //convert arraylist to array
      Request_status[] my_array = 
        statuses.toArray(new Request_status[statuses.size()]);
      return my_array;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }




  /**
    * given the query string, we will find the proper string
    * and convert that to a request, and return that.
    * @param qs this is the query string used in request.jsp and
    * other places where there is a string with the id of a particular
    * request.
    * @return a request object or null if no match
    */
  public static 
    Request parse_querystring_and_get_request(String qs) {
      int id = -1;
      try {
        id = Integer.parseInt(Utils.parse_qs(qs).get("request"));
      } catch (Exception ex) {
        System.err.println(
            "Error(6): couldn't parse int from querystring " + qs);
        System.err.println(ex);
        return null;
      }
      return get_a_request(id);
    }


  /**
    * sets a new message into the database.  These are used for
    * correspondence between users of the system on a given request.
    * @param msg the message to store.
    * @param request_id the id of the request
    * @param user_id the user creating the message
    * @return true if successful
    */
  public static boolean 
    set_message(String msg, int request_id, int user_id) {

    // 1. set the sql
      String sqlText = 
      "INSERT INTO request_message "+
      "(message, request_id, user_id, timestamp)"+
      "SELECT DISTINCT "+
        "CONCAT(u.username,' says:', ?), ?, u.user_id, UTC_TIMESTAMP() "+
      "FROM user u "+
      "JOIN request_message rm ON rm.user_id = u.user_id "+
      "WHERE u.user_id = ? LIMIT 1";

    // 2. set up values we'll need outside the try
    boolean result = false;
    PreparedStatement pstmt = null;
    try {
      // 3. get the connection and set up a statement
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      // 4. set values into the statement
      pstmt.setNString( 1, msg );
      pstmt.setInt( 2, request_id);
      pstmt.setInt( 3, user_id);
      // 5. execute a statement
      result = Database_access.execute_update(pstmt) > 0;
      // 10. cleanup and exceptions
      return result;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(pstmt);
    }

  }

  /**
    * gets all the messages (correspondence between users) for a request.
    * @param request_id the key for the messages
    * @return an array of messages for this request, 
    * or empty array if failure.
    */
  public static String[] get_messages(int request_id) {
    String sqlText = 
      "SELECT message FROM request_message WHERE request_id = ?";
    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, request_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new String[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<String> messages = new ArrayList<String>();
      while(resultSet.next()) {
        String msg = resultSet.getNString("message");
        messages.add(msg);
      }

      //convert arraylist to array
      String[] array_of_messages = 
        messages.toArray(new String[messages.size()]);
      return array_of_messages;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new String[0];
    } finally {
      Database_access.close_statement(pstmt);
    }
  }

  
  /**
    * a type solely used to set the response from putting a request
    */
  public static class Request_response { 

    /**
      * an enum demarcating the general status
      * of a response from making a request.
      * This gets included in Request_response
      * to allow filtering.
      */
    public enum Stat {
      LACK_POINTS, OK , ERROR
    }
    public final Stat status;

    /**
      * the id of the newly-created request.
      */
    public final int id;

    public Request_response(Stat s, int id) {
      this.status = s;
      this.id = id;
    }
  
  }


  /**
    * acts as a simple lookup table between the status
    * value and the index into localized values
    * Since there are so few statuses, probably no harm.  If the
    * paradigm changes so there are lots of statuses, change this
    * paradigm.
    */
  public static int get_status_localization_value(int status) {
    switch(status) {
      case 1:
        return 76; //open
      case 2:
        return 77; //closed
      case 3:
        return 78; //taken
      default:
        return -1;
    }
  }

}
