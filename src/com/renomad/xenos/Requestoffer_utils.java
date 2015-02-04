package com.renomad.xenos;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import com.renomad.xenos.Database_access;
import com.renomad.xenos.Requestoffer;
import com.renomad.xenos.Others_Requestoffer;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
  * this class consists of methods that act upon Requestoffers
  */
public final class Requestoffer_utils {

  private Requestoffer_utils() {
    //private constructor.  This class is not allowed to be
    //instantiated.  do nothing here.
  }


  /**
    * given an array of words, we'll look up the local words
    * for statuses and see if any match.  If so, we'll return those
    * as an array of ints.
    * @param statuses the words we'll compare to see if 
    *  they are localized statuses
    * @param loc the localization object
    * @return an array of ints of statuses that were 
    *  found amongst the words.
    */
  public static Integer[] 
    parse_statuses_string(String statuses, Localization loc) {
    // 1. set the sql
    String get_statuses_sql = 
      "SELECT requestoffer_status_id FROM requestoffer_status";
    PreparedStatement pstmt = null;
    try {
      // 3. get the connection and set up a statement
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, get_statuses_sql);     
      // 4. execute a statement
      ResultSet resultSet = pstmt.executeQuery();
      // 5. check that we got results
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      ArrayList<Integer> status_ids_found 
        = new ArrayList<Integer>();
      while(resultSet.next()) {
        int rsid = resultSet.getInt("requestoffer_status_id");
        String localized_status = loc.get(rsid, "");
        if (statuses.contains(localized_status)) {
          status_ids_found.add(rsid);
        }
      }
      return status_ids_found.toArray(new Integer[status_ids_found.size()]);
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Integer[0];
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  /**
    * returns a list of localization values for the categories
    * @return List of Integers representing localization values 
    *   for categories, or null if nothing in db. The
    */
  public static ArrayList<Integer> get_all_categories() {
    // 1. set the sql
    String sqlText = 
      "SELECT category_id, requestoffer_category_value "+
      "FROM requestoffer_category; ";
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
    * sets the status of the requestoffer to taken for a given user.
    * @return true if successful at taking, false otherwise.
    */
  public static boolean take_requestoffer(int user_id, int requestoffer_id) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_procedures.sql take_requestoffer for
      // details on this stored procedure.
      
      cs = conn.prepareCall(String.format(
        "{call take_requestoffer(%d, %d)}" , user_id, requestoffer_id));
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
    * Gets a specific Requestoffer 
    * 
    * @param requestoffer_id the id of a particular Requestoffer
    * @return a single Requestoffer, or null if failure
    */
  public static Requestoffer get_a_requestoffer(int requestoffer_id) {
    
    String sqlText = 
      "SELECT r.requestoffer_id, r.datetime, r.description, r.points,"+
      "r.status, r.title, r.requestoffering_user_id, "+
      "GROUP_CONCAT(rc.category_id SEPARATOR ',') AS categories "+
      "FROM requestoffer r "+
      "JOIN requestoffer_to_category rtc ON rtc.requestoffer_id = r.requestoffer_id "+
      "JOIN requestoffer_category rc "+
        "ON rc.category_id = rtc.requestoffer_category_id "+
      "WHERE r.requestoffer_id = ? GROUP BY requestoffer_id";

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, requestoffer_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next();
      int rid = resultSet.getInt("requestoffer_id");
      String dt = resultSet.getString("datetime");
      String d = resultSet.getNString("description");
      int p = resultSet.getInt("points");
      int s = resultSet.getInt("status");
      String t = resultSet.getNString("title");
      int ru = resultSet.getInt("requestoffering_user_id");
      String ca = resultSet.getString("categories");
      Integer[] categories = parse_string_to_int_array(ca);
      Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,t,ru,categories);

      return requestoffer;
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
      this.categories = Utils.is_comma_delimited_numbers(categories) ? 
        categories 
        : "";
      this.statuses = Utils.is_comma_delimited_numbers(statuses) ? 
        statuses 
        : "";
      this.minpoints = minpoints;
      this.maxpoints = maxpoints;
      this.user_ids = Utils.is_comma_delimited_numbers(user_ids) ? 
        user_ids 
        : "";
    }

  }


  /**
    * Gets information necessary for display on the dashboard,
    * about requestoffers that are not the currently logged-in user's.
    * 
    * @param ruid the id of the user asking for the requestoffers.
    * @param so an object that holds all the ways to search
    * the requestoffers.  Things like, dates, categories, titles, etc.
    * @param page This method is used to display requestoffers, and we
    * include paging functionality - splitting the response into
    * pages of data.  Which page are we on?
    * @return an array of Others_Requestoffers that were *not* made 
    * by that user, or an empty array of Others_Requestoffers if failure or
    * none.
    */
  public static Others_Requestoffer[] get_others_requestoffers(
      int ruid, 
      Search_Object so, 
      int page) {

    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_procedures.sql get_others_requestoffers for
      // details on this stored procedure.
      cs = conn.prepareCall(String.format(
        "{call get_others_requestoffers(%d,?,?,?,?,?,%d,%d,?,%d)}"
        ,ruid, so.minpoints, so.maxpoints, page));
      cs.setNString(1, so.title);
      cs.setString(2, so.startdate);
      cs.setString(3, so.enddate);
      cs.setString(4, so.statuses);
      cs.setString(5, so.categories);
      cs.setString(6, so.user_ids);
      ResultSet resultSet = cs.executeQuery();

      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Others_Requestoffer[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<Others_Requestoffer> requestoffers = 
        new ArrayList<Others_Requestoffer>();
      while(resultSet.next()) {
        int rid = resultSet.getInt("requestoffer_id");
        String dt = resultSet.getString("datetime");
        String d = resultSet.getNString("description");
        int p = resultSet.getInt("points");
        int s = resultSet.getInt("status");
        String t = resultSet.getNString("title");
        int ru = resultSet.getInt("requestoffering_user_id");
        int ra = resultSet.getInt("rank");
        String cats = resultSet.getString("categories");
        Integer[] cat_array = parse_string_to_int_array(cats);

        Others_Requestoffer requestoffer = 
          new Others_Requestoffer(t,dt,d,s,ra,p,rid,ru,cat_array);
        requestoffers.add(requestoffer);
      }

      //convert arraylist to array
      Others_Requestoffer[] array_of_requestoffers = 
        requestoffers.toArray(new Others_Requestoffer[requestoffers.size()]);
      return array_of_requestoffers;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Others_Requestoffer[0];
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
    * Gets all the requestoffers for the user.
    * 
    * @param user_id a particular user's id
    * @return an array of Requestoffers made by that user.
    */
  public static Requestoffer[] get_requestoffers_for_user(int user_id) {
    String sqlText = "SELECT * FROM requestoffer WHERE requestoffering_user_id = ?";
    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Requestoffer[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<Requestoffer> requestoffers = new ArrayList<Requestoffer>();
      while(resultSet.next()) {
        int rid = resultSet.getInt("requestoffer_id");
        String dt = resultSet.getString("datetime");
        String d = resultSet.getNString("description");
        int p = resultSet.getInt("points");
        int s = resultSet.getInt("status");
        String t = resultSet.getNString("title");
        int ru = resultSet.getInt("requestoffering_user_id");
        Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,t,ru);
        requestoffers.add(requestoffer);
      }

      //convert arraylist to array
      Requestoffer[] array_of_requestoffers = 
        requestoffers.toArray(new Requestoffer[requestoffers.size()]);
      return array_of_requestoffers;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }



  /**
    * deletes a requestoffer.
    * @param requestoffer_id the id of the requestoffer to delete
    * @param deleting_user_id the id of the user making the requestoffer
    * @return true if successful
    */
  public static boolean delete_requestoffer(int requestoffer_id, int deleting_user_id) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_procedures.sql delete_requestoffer for
      // details on this stored procedure.
      
      cs = conn.prepareCall(String.format(
        "{call delete_requestoffer(%d,%d)}"
        ,deleting_user_id, requestoffer_id));
      cs.executeQuery();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
    }
    return true;
  }



  /**
    * given all the data to add a requestoffer, does so.
    * @param user_id the user's id
    * @param desc a description string, the core of the requestoffer
    * @param points the points are the currency for the requestoffer
    * @param title the short title for the requestoffer
    * @param categories the various categories for this requestoffer, 
    */
  public static Requestoffer_response put_requestoffer(
      int user_id, String desc, int points, 
      String title, Integer[] categories) {

    int new_requestoffer_id = -1; //need it here to be outside the "try".
    CallableStatement cs = null;
    String categories_str = "";
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_procedures.sql put_requestoffer for
      // details on this stored procedure.
      
      //convert categories into proper format: e.g. (1),(2),(3)
      if (categories.length > 0) {
        StringBuilder sb = 
          new StringBuilder(String.format("(%d)", categories[0]));
        for (int i = 1; i < categories.length; i++) {
          sb.append(String.format(",(%d)",categories[i]));
        }
        categories_str = sb.toString();
      }

      cs = conn.prepareCall(String.format(
        "{call put_requestoffer(?,%d,?,%d,?,?)}"
        ,user_id, points));
      cs.setNString(1, desc);
      cs.setNString(2, title);
      cs.setString(3, categories_str);
      cs.registerOutParameter(4, java.sql.Types.INTEGER);
      cs.executeQuery();
      new_requestoffer_id = cs.getInt(4);
    } catch (SQLException ex) {
      //look for the error from the trigger to check points
      if (ex.getMessage()
          .contains("user lacks points to make this requestoffer")) {
        return new Requestoffer_response(Requestoffer_response.Stat.LACK_POINTS, -1);
      }

      Database_access.handle_sql_exception(ex);
      return new Requestoffer_response(Requestoffer_response.Stat.ERROR, -1);
    } finally {
      Database_access.close_statement(cs);
    }
    //indicate all is well, along with the new id
    return new Requestoffer_response(Requestoffer_response.Stat.OK, new_requestoffer_id);
  }


  /**
    * gets all the requestoffer categories that exist as an
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
    * gets all the current requestoffer statuses, like OPEN, CLOSED, and TAKEN
    * @return an array of requestoffer statuses, or null if failure.
    */
  public static Requestoffer_status[] get_requestoffer_statuses() {
    // 1. set the sql
    String sqlText = 
      "SELECT requestoffer_status_id, requestoffer_status_value "+
      "FROM requestoffer_status;";

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
        return new Requestoffer_status[0];
      }

      // 6. get values from database and convert to an object
      //keep adding rows of data while there is more data
      ArrayList<Requestoffer_status> statuses = 
        new ArrayList<Requestoffer_status>();
      while(resultSet.next()) {
        int sid = resultSet.getInt("requestoffer_status_id");
        String sv = resultSet.getString("requestoffer_status_value");
        Requestoffer_status status = new Requestoffer_status(sid,sv);
        statuses.add(status);
      }

      // 7. if necessary, create array of objects for return
      //convert arraylist to array
      Requestoffer_status[] my_array = 
        statuses.toArray(new Requestoffer_status[statuses.size()]);
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
    * and convert that to a requestoffer, and return that.
    * @param qs this is the query string used in requestoffer.jsp and
    * other places where there is a string with the id of a particular
    * requestoffer.
    * @return a requestoffer object or null if no match
    */
  public static 
    Requestoffer parse_querystring_and_get_requestoffer(String qs) {
      int id = -1;
      try {
        id = Integer.parseInt(Utils.parse_qs(qs).get("requestoffer"));
      } catch (Exception ex) {
        System.err.println(
            "Error(6): couldn't parse int from querystring " + qs);
        System.err.println(ex);
        return null;
      }
      return get_a_requestoffer(id);
    }


  /**
    * sets a new message into the database.  These are used for
    * correspondence between users of the system on a given requestoffer.
    * @param msg the message to store.
    * @param requestoffer_id the id of the requestoffer
    * @param user_id the user creating the message
    * @return true if successful
    */
  public static boolean 
    set_message(String msg, int requestoffer_id, int user_id) {

    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_procedures.sql for
      // details on this stored procedure.
      cs = conn.prepareCall(String.format(
        "{call put_message(?,%d,%d)}" ,user_id, requestoffer_id));
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
    * gets all the messages (correspondence between users) for a requestoffer.
    * @param requestoffer_id the key for the messages
    * @return an array of messages for this requestoffer, 
    * or empty array if failure.
    */
  public static String[] get_messages(int requestoffer_id) {
    String sqlText = 
      "SELECT message FROM requestoffer_message WHERE requestoffer_id = ?";
    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, requestoffer_id);
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
    * a type solely used to set the response from putting a requestoffer
    */
  public static class Requestoffer_response { 

    /**
      * an enum demarcating the general status
      * of a response from making a requestoffer.
      * This gets included in Requestoffer_response
      * to allow filtering.
      */
    public enum Stat {
      LACK_POINTS, OK , ERROR
    }
    public final Stat status;

    /**
      * the id of the newly-created requestoffer.
      */
    public final int id;

    public Requestoffer_response(Stat s, int id) {
      this.status = s;
      this.id = id;
    }
  
  }


}