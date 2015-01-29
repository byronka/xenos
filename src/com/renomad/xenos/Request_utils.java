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

    int new_request_id = -1; //need it here to be outside the "try".
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_setup.sql put_request for
      // details on this stored procedure.
      
      //convert categories into proper format: e.g. (1),(2),(3)
      String categories_str = "";
      if (categories.length > 0) {
        StringBuilder sb = 
          new StringBuilder(String.format("(%d)", categories[0]));
        for (int i = 1; i < categories.length; i++) {
          sb.append(String.format(",(%d)",categories[i]));
        }
        categories_str = sb.toString();
      }

      cs = conn.prepareCall(String.format(
        "{call put_request(?,%d,?,%d,?,?)}"
        ,user_id, points));
      cs.setNString(1, desc);
      cs.setNString(2, title);
      cs.setString(3, categories_str);
      cs.registerOutParameter(4, java.sql.Types.INTEGER);
      cs.executeQuery();
      new_request_id = cs.getInt(4);
    } catch (SQLException ex) {
      //look for the error from the trigger to check points
      if (ex.getMessage()
          .contains("user lacks points to make this request")) {
        return new Request_response(Request_response.Stat.LACK_POINTS, -1);
      }

      Database_access.handle_sql_exception(ex, cs);
      return new Request_response(Request_response.Stat.ERROR, -1);
    } finally {
      Database_access.close_statement(cs);
    }
    //indicate all is well, along with the new id
    return new Request_response(Request_response.Stat.OK, new_request_id);
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

    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_setup.sql get_others_requests for
      // details on this stored procedure.
      cs = conn.prepareCall(String.format(
        "{call put_message(?,%d,%d)}" ,user_id, request_id));
      cs.setNString(1, msg);
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
    }
    return true;
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
