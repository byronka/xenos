package com.renomad.xenos;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import com.renomad.xenos.Database_access;
import com.renomad.xenos.Requestoffer;
import com.renomad.xenos.Others_Requestoffer;
import com.renomad.xenos.Const;
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
    * holds a postcode and then details like city, state, location, whatev
    */
  public static class Postcode_and_detail {
    public final int postcode_id;
    public final String postcode;
    public final String detail;
    public Postcode_and_detail(int postcode_id, String postcode, String detail) {
      this.postcode_id = postcode_id;
      this.postcode = postcode;
      this.detail = detail;
    }
  }

  /**
    * this gets all the likely locations based on the values we are given.
    * we do a text search on the postcode within that country.  If we
    * find nothing we return an empty array.
    */
  public static Postcode_and_detail[]
    get_locations_from_postcode(int country_id, String postcode) {
    String sqlText = 
      "SELECT pc.postal_code, pcd.postal_code_id, pcd.details " +
      "FROM postal_code_details pcd " +
      "JOIN postal_codes pc ON pc.postal_code_id = pcd.postal_code_id "+
        "AND pc.country_id = pcd.country_id " +
      "WHERE pc.postal_code LIKE CONCAT('%',?,'%') AND pcd.country_id = ? ";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setString(1, postcode);
      pstmt.setInt(2, country_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Postcode_and_detail[0];
      }

      ArrayList<Postcode_and_detail> pad = new ArrayList<Postcode_and_detail>();
      while(resultSet.next()) {
        int pcode_id = resultSet.getInt("postal_code_id");
        String pcode = resultSet.getString("postal_code");
        String detail = resultSet.getNString("details");
        pad.add(new Postcode_and_detail(pcode_id, pcode, detail)); 
      }

      Postcode_and_detail[] array_of_pad = 
        pad.toArray(new Postcode_and_detail[pad.size()]);
      return array_of_pad;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Postcode_and_detail[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }

  }

  /**
    * get details for a location, as a string.
    * @return a string detail of location, like, "20165 sterling, Virginia"
    *   or null if nothing found.
    */
  public static String
    get_location_detail(int country_id, int postal_code_id) {

    String sqlText = 
      String.format(
        "SELECT pc.postal_code, pcd.details " +
        "FROM postal_code_details pcd " +
        "JOIN postal_codes pc " +
        "  ON pc.postal_code_id = pcd.postal_code_id " +
        "    AND pc.country_id = pcd.country_id " +
        "WHERE pc.postal_code_id = %d AND pc.country_id = %d", 
        postal_code_id, country_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next();
      String pcode = resultSet.getString("postal_code");
      String detail = resultSet.getNString("details");

      return pcode + ", " + detail;

    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }

  }

  /**
    * put the requestoffer into a 'draft' status,
    * hidden from everyone but the owner
    */
  public static boolean 
    retract_requestoffer(int user_id, int requestoffer_id ) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall(String.format(
        "{call retract_requestoffer(%d, %d)}" 
        , user_id, requestoffer_id));
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
    return true;
  }


  /**
    * put the requestoffer into an 'open' status,
    * so people can potentially handle it.
    */
  public static boolean 
    publish_requestoffer(int requestoffer_id, int user_id) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall(String.format(
        "{call publish_requestoffer(%d, %d)}" 
        , user_id, requestoffer_id));
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
    return true;
  }


  public static class EmailInformation {
    public final String email;
    public final String message;
    public final int user_id;
    public EmailInformation(String email, String message, int user_id) {
      this.email = email;
      this.message = message;
      this.user_id = user_id;
    }
  }


  /**
    */
  public static EmailInformation[] get_messages_for_user_email() {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      cs = conn.prepareCall("{call get_my_temporary_msgs_for_email()}");
      resultSet = cs.executeQuery();

      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new EmailInformation[0];
      }

      //keep adding rows of data while there is more data
      List<EmailInformation> ei = new ArrayList<EmailInformation>();
      while(resultSet.next()) {
        Integer user_id = resultSet.getInt("user_id");
        Integer msg_id = resultSet.getInt("message_localization_id");
        String text = resultSet.getNString("text");
        String email = resultSet.getNString("email");

        if (Utils.is_null_or_empty(email)) {
          continue;
        }

        if (!Utils.is_null_or_empty(text)) { // a user message
          ei.add(new EmailInformation(email, text, user_id));
        } else if (msg_id != null && msg_id > 0) { // a system message
          Localization loc = new Localization(user_id);
          String localizedText = "Favr system says: " + loc.get(msg_id,"");
          ei.add(new EmailInformation(email, localizedText, user_id));
        } else {    // an exceptional situation - shouldn't happen
          System.out.println("ERROR_GETTING_TEMP_MSG");
          System.out.println("there had to be no text and no msg_id");
          System.out.println("text: " + text);
          System.out.println("msg_id: " + msg_id);
        }
      }

      //convert arraylist to array
      EmailInformation[] emailArray = 
        ei.toArray(new EmailInformation[ei.size()]);
			return emailArray;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new EmailInformation[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
  }


  /**
    * returns unviewed messages, localized
    *  from the temporary_messages table
    * or an empty String array if there are none.
    */
  public static String[] 
    get_my_temporary_msgs(int user_id, Localization loc) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      cs = conn.prepareCall(String.format(
        "{call get_my_temporary_msgs_for_website(%d)}" , user_id ));
      resultSet = cs.executeQuery();

      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new String[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<String> temp_msgs = new ArrayList<String>();
      while(resultSet.next()) {
        Integer msg_id = resultSet.getInt("message_localization_id");
        String text = resultSet.getNString("text");

        if (!Utils.is_null_or_empty(text)) { // a user message
          temp_msgs.add(text);
        } else if (msg_id != null && msg_id > 0) { // a system message
          temp_msgs.add(loc.get(msg_id,""));
        } else {    // an exceptional situation - shouldn't happen
          temp_msgs.add("ERROR_GETTING_TEMP_MSG");
        }

      }

      //convert arraylist to array
      String[] array_of_msgs = 
        temp_msgs.toArray(new String[temp_msgs.size()]);
			return array_of_msgs;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new String[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
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
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      // 3. get the connection and set up a statement
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      // 4. execute a statement
      resultSet = pstmt.executeQuery();
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
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * this will cancel a transaction in "taken" status, that is, a
    * requestoffer that has someone servicing it.
    */
  public static boolean
    cancel_taken_requestoffer(
        int user_id, int requestoffer_id) {
      CallableStatement cs = null;
      Connection conn = Database_access.get_a_connection();
      try {
        cs = conn.prepareCall(String.format(
          "{call cancel_taken_requestoffer(%d, %d)}" 
          , user_id, requestoffer_id));
        cs.execute();
        return true;
      } catch (SQLException ex) {
        Database_access.handle_sql_exception(ex);
        return false;
      } finally {
        Database_access.close_statement(cs);
        Database_access.close_connection(conn);
      }
    }


  /**
    * indicate that you are interested in handling a particular
    * requestoffer.  This enters an item in service_requestoffer
    */
  public static boolean
    offer_to_take_requestoffer(int user_id, int requestoffer_id) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall(String.format(
        "{call offer_to_take_requestoffer(%d, %d)}" 
        , user_id, requestoffer_id));
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
    return true;

    }

  /**
    * sets the status of the requestoffer to taken for a given user.
    * @param new_handler_id the id of the user who will now handle this.
    * @param requestoffer_id the id of the requestoffer they will handle.
    * @return true if successful at taking, false otherwise.
    */
  public static boolean 
    choose_handler(int new_handler_id, int requestoffer_id) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      // see db_scripts/v1_procedures.sql take_requestoffer for
      // details on this stored procedure.
      
      cs = conn.prepareCall(String.format(
        "{call take_requestoffer(%d, %d)}" , new_handler_id, requestoffer_id));
      cs.execute();
    } catch (SQLException ex) {
			String msg = ex.getMessage();
			if (msg.contains("cannot take requestoffer")) {
      	return false;
			}
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
    return true;
  }


  /**
    * Gets an array of offers I made on requestoffers
    * 
    * @param user_id the user who made offers on requestoffers
    * @return an array of offers, or empty array if failure
    */
  public static Requestoffer[] 
    get_requestoffers_I_offered_to_service(int user_id) {
    
    String sqlText = 
      "SELECT r.requestoffer_id, r.datetime, r.description, r.points,"+
      "rs.status, r.requestoffering_user_id, r.handling_user_id, r.category "+
      "FROM requestoffer r "+
      "JOIN requestoffer_state rs "+
        "ON rs.requestoffer_id = r.requestoffer_id " +
      "JOIN requestoffer_service_request rsr "+
        "ON r.requestoffer_id = rsr.requestoffer_id " +
      "WHERE rsr.user_id = ? AND rsr.status = " + Const.Rsrs.NEW;

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Requestoffer[0];
      }

      ArrayList<Requestoffer> offers = 
        new ArrayList<Requestoffer>();
      while(resultSet.next()) {
        int rid = resultSet.getInt("requestoffer_id");
        String dt = resultSet.getString("datetime");
        String d = resultSet.getNString("description");
        int p = resultSet.getInt("points");
        int s = resultSet.getInt("status");
        int ru = resultSet.getInt("requestoffering_user_id");
        int hu = resultSet.getInt("handling_user_id");
        int ca = resultSet.getInt("category");
        Requestoffer requestoffer = 
          new Requestoffer(rid,dt,d,p,s,ru,hu,ca,"","");
        offers.add(requestoffer);
      }

      //convert arraylist to array
      Requestoffer[] array_of_offers = 
        offers.toArray(new Requestoffer[offers.size()]);

      return array_of_offers;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Requestoffer[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  public static class Service_request {

    public final int requestoffer_id;
    public final String desc;
    public final int user_id; // the user offering to handle it
    public final String date_created;
    public final String username;

    public Service_request(
        int requestoffer_id, 
        int user_id, 
        String date_created,
        String desc, String username) {
      this.requestoffer_id = requestoffer_id;
      this.user_id = user_id;
      this.date_created = date_created;
      this.desc = desc;
      this.username = username;
    }
  }


  /**
    * returns true if the user in user_id is indeed offering
    * to service this requestoffer
    * 
    * @param user_id a user potentially offering to 
    *   service the requestoffer
    * @return true if they are offering to service, 
    *   false otherwise.
    */
  public static boolean 
    is_offering_to_service(int user_id, int requestoffer_id) {
    
    String sqlText = 
      "SELECT COUNT(*) as the_count " +
      "FROM requestoffer_service_request " +
      "WHERE user_id = ? AND requestoffer_id = ? "+
      "AND status = " + Const.Rsrs.NEW;

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      pstmt.setInt( 2, requestoffer_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return false;
      }

      resultSet.next();
      int count = resultSet.getInt("the_count");
      if (resultSet.wasNull()) {
        return false;
      }
      return count == 1;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  public static class Country {

    public final String country_name;
    public final int country_id;
    public Country(String country_name, int country_id) {
      this.country_name = country_name;
      this.country_id = country_id;
    }
  }

  /**
    * gets the total list of countries
    */
  public static Country[] get_countries() {
    
    String sqlText = 
      "SELECT country_id, country_name FROM country ORDER BY country_id";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Country[0];
      }

      ArrayList<Country> countries = new ArrayList<Country>();
      while(resultSet.next()) {
        int id = resultSet.getInt("country_id");
        String name = resultSet.getNString("country_name");
        countries.add(new Country(name, id));
      }
      Country[] array_of_countries = 
        countries.toArray(new Country[countries.size()]);
      return array_of_countries;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Country[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * Gets the list of users that have offered to service my request
    * that are not selected or rejected.
    * 
    * @param user_id the user asking about servicers 
    *   for their requestoffers
    * @return an array of service requests, or empty array if failure
    */
  public static Service_request[] get_service_requests(int user_id) {
    
    String sqlText = 
      "SELECT rsr.requestoffer_id, rsr.user_id, rsr.date_created, " +
      "ro.description, u.username " +
      "FROM requestoffer_service_request rsr " +
      "JOIN requestoffer ro "+
        "ON ro.requestoffer_id = rsr.requestoffer_id " +
      "JOIN user u " +
        "ON u.user_id = rsr.user_id " +
      "WHERE ro.requestoffering_user_id = ? "+
      "AND rsr.status = " + Const.Rsrs.NEW;

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Service_request[0];
      }

      ArrayList<Service_request> service_requests = 
        new ArrayList<Service_request>();
      while(resultSet.next()) {
        int rid = resultSet.getInt("requestoffer_id");
        int uid = resultSet.getInt("user_id");
        String dt = resultSet.getString("date_created");
        String desc = resultSet.getNString("description");
        String username = resultSet.getNString("username");
        service_requests.add(new Service_request(rid, uid, dt, desc, username));
      }

      //convert arraylist to array
      Service_request[] array_of_service_requests = 
        service_requests.toArray(
            new Service_request[service_requests.size()]);

      return array_of_service_requests;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Service_request[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * gets uniques of service requests for the same request offer
    */
  public static Service_request[]
    combine_service_requests_by_requestoffer(Service_request[] srs) {
    Map<Integer, Service_request> service_requests = new HashMap<Integer, Service_request>();
    for (Service_request sr : srs) {
      if (service_requests.get(sr.requestoffer_id) == null) {
        service_requests.put(sr.requestoffer_id, sr);
      }
    }
    return service_requests.values().toArray(new Service_request[0]);
  }

  /**
    * Gets the list of users that have offered to service this request
    * 
    * @param the_rid the requestoffer in question
    * @return an array of service requests, or empty array if failure
    */
  public static Service_request[] 
    get_service_requests_for_requestoffer(int the_rid) {
    
    String sqlText = 
      "SELECT rsr.requestoffer_id, rsr.user_id, rsr.date_created, " +
      "ro.description, u.username " +
      "FROM requestoffer_service_request rsr " +
      "JOIN requestoffer ro "+
        "ON ro.requestoffer_id = rsr.requestoffer_id " +
      "JOIN user u " +
        "ON u.user_id = rsr.user_id " +
      "WHERE ro.requestoffer_id = ? "+
      "AND rsr.status = " + Const.Rsrs.NEW;

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, the_rid);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Service_request[0];
      }

      ArrayList<Service_request> service_requests = 
        new ArrayList<Service_request>();
      while(resultSet.next()) {
        int rid = resultSet.getInt("requestoffer_id");
        int uid = resultSet.getInt("user_id");
        String dt = resultSet.getString("date_created");
        String desc = resultSet.getNString("description");
        String username = resultSet.getNString("username");
        service_requests.add(new Service_request(rid, uid, dt, desc, username));
      }

      //convert arraylist to array
      Service_request[] array_of_service_requests = 
        service_requests.toArray(
            new Service_request[service_requests.size()]);

      return array_of_service_requests;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Service_request[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
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
      "rs.status, r.requestoffering_user_id, r.handling_user_id, r.category, pc.postal_code, pcd.details "+
      "FROM requestoffer r "+
      "JOIN requestoffer_state rs "+
        "ON rs.requestoffer_id = r.requestoffer_id " +
      "LEFT JOIN postal_codes pc ON pc.postal_code_id = r.postal_code_id AND pc.country_id = r.country_id " +
      "LEFT JOIN postal_code_details pcd ON pcd.postal_code_id = r.postal_code_id AND pcd.country_id = r.country_id " +
      "WHERE r.requestoffer_id = ? "+
      "GROUP BY requestoffer_id";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, requestoffer_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next();
      int rid = resultSet.getInt("requestoffer_id");
      String dt = resultSet.getString("datetime");
      String d = resultSet.getNString("description");
      int p = resultSet.getInt("points");
      int s = resultSet.getInt("status");
      int ru = resultSet.getInt("requestoffering_user_id");
      int hu = resultSet.getInt("handling_user_id");
      int ca = resultSet.getInt("category");
      String pc = resultSet.getString("postal_code");
      String det = resultSet.getNString("details");
      Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,ru,hu,ca,pc,det);

      return requestoffer;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * An object used to hold the values
    * necessary for advanced search.  Immutable.
    */
  public static class Search_Object {

    public final String startdate;
    public final String enddate;
    public final String description;

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

    public final String postcode; // postal code
    public final Double distance;


    public Search_Object(
        String startdate,
        String enddate,
        String categories,
        String description,
        String statuses,
        String user_ids,
        String postcode,
        String distance
        ) {
      this.startdate = startdate;
      this.enddate = enddate;
      this.categories = Utils.is_comma_delimited_numbers(categories) ? 
        categories 
        : null;
      this.description = description;
      this.statuses = Utils.is_comma_delimited_numbers(statuses) ? 
        statuses 
        : null;
      this.user_ids = Utils.is_comma_delimited_numbers(user_ids) ? 
        user_ids 
        : null;
      this.postcode = postcode;
      this.distance = Utils.parse_double(distance);
    }

  }

	/**
		* A helper class to get the Requestoffers and page count to their
		* destination.
		*/
	public static class OR_Package {

		private Others_Requestoffer[] or;
		public int page_count;

		public OR_Package(Others_Requestoffer[] or, int page_count) {
			this.or = Arrays.copyOf(or, or.length);
			this.page_count = page_count;
		}

		/**
			* Returns a copy of the Requestoffers array.  Why do this?
			* to stay immutable.  For thread safety and performance.  If
			* I am wrong about that, feel free to reconsider this piece.
			*/
		public Others_Requestoffer[] get_requestoffers() {
			Others_Requestoffer[] oro = Arrays.copyOf(or, or.length);
			return oro;
		}
	}


  /**
    * this gives the "stair step" that the user is at for the
    * value of rank_ladder they have.  It's a way to get a sense
    * of their recent rankings.  See youtrack issue X-172 for more info.
    * @return a value between 0 and 6 if valid input, or -1 otherwise.
    */
  public static int get_ladder_step(int rank_ladder_val) {
    if ( rank_ladder_val < -1 ) {
      return 0;
    }
    if ( rank_ladder_val == -1 ) {
      return 1;
    }
    if ( rank_ladder_val == 0 ) {
      return 2;
    }
    if ( rank_ladder_val == 1 ) {
      return 3;
    }
    if ( rank_ladder_val > 1 && rank_ladder_val <= 3 ) {
      return 4;
    }
    if ( rank_ladder_val > 3 && rank_ladder_val <= 7 ) {
      return 5;
    }
    if ( rank_ladder_val > 7 && rank_ladder_val <= 15 ) {
      return 6;
    }

    return -1;

  }


  /**
    * Gets information necessary for display on the dashboard,
    * about requestoffers that are not the currently logged-in user's.
    * 
    * @param ruid the id of the user asking for the requestoffers.
    * @param so an object that holds all the ways to search
    * the requestoffers.  Things like, dates, categories, etc.
    * @param page This method is used to display requestoffers, and we
    * include paging functionality - splitting the response into
    * pages of data.  Which page are we on?
    * @return an array of Others_Requestoffers that were *not* made 
    * by that user, or an empty array of Others_Requestoffers if failure or
    * none.
    */
  public static Requestoffer_utils.OR_Package get_others_requestoffers(
      int ruid, 
      Search_Object so, 
      int page) {

    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      // see db_scripts/v1_procedures.sql get_others_requestoffers for
      // details on this stored procedure.
      cs = conn.prepareCall("{call get_others_requestoffers(?,?,?,?,?,?,?,?,?,?,?)}" );
      cs.setInt(1, ruid);
      cs.setString(2, so.startdate);
      cs.setString(3, so.enddate);
      cs.setString(4, so.statuses);
      cs.setString(5, so.categories);
      cs.setString(6, so.user_ids);
      cs.setInt(7, page);
      cs.setString(8, so.description);
      cs.setString(9, so.postcode);
      if (so.distance != null) {
        cs.setDouble(10, so.distance);
      } else {
        cs.setNull(10, java.sql.Types.DOUBLE);
      }
      cs.registerOutParameter(11, java.sql.Types.INTEGER);
      resultSet = cs.executeQuery();
      int pages = cs.getInt(11);

      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new OR_Package(new Others_Requestoffer[0],1);
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
        int ca = resultSet.getInt("category");
        int ru = resultSet.getInt("requestoffering_user_id");
        int hu = resultSet.getInt("handling_user_id");
        float ra = resultSet.getFloat("rank_average");
        int rl = resultSet.getInt("rank_ladder");
        int offered_user_id = resultSet.getInt("been_offered");
        boolean has_been_offered = false;
        if (offered_user_id > 0) {
          has_been_offered = true;
        }
        String po = resultSet.getString("postal_code");
        Double di = resultSet.getDouble("distance");
        if (resultSet.wasNull()) {
          di = null;
        }
        String dtls = resultSet.getNString("details");
        if (resultSet.wasNull()) {
          dtls = null;
        }

        Others_Requestoffer requestoffer = 
          new Others_Requestoffer(
              dt,d,s,ra,rl,p,rid,ru,hu,ca, has_been_offered,po,dtls,di);
        requestoffers.add(requestoffer);
      }

      //convert arraylist to array
      Others_Requestoffer[] array_of_requestoffers = 
        requestoffers.toArray(new Others_Requestoffer[requestoffers.size()]);
			return new OR_Package(array_of_requestoffers,pages);
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
			return new OR_Package(new Others_Requestoffer[0],1);
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
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
    * Gets all the requestoffers a user is handling
    * 
    * @param user_id a particular user's id
    * @return an array of Requestoffers handled by that user., or empty array otherwise
    */
  public static Others_Requestoffer[] 
      get_requestoffers_I_am_handling(int user_id) {
    String sqlText = 
      
      "SELECT "+
        "r.requestoffer_id, "+
        "r.datetime, "+
        "r.description, "+
        "r.points, "+
        "r.category, "+
        "rs.status, "+
        "r.requestoffering_user_id, "+
        "r.handling_user_id "+
      "FROM requestoffer r "+
      "JOIN requestoffer_state rs "+
        "ON rs.requestoffer_id = r.requestoffer_id " +
      "WHERE r.handling_user_id = ? AND rs.status <> " + Const.Rs.CLOSED;

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
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
        int ru = resultSet.getInt("requestoffering_user_id");
        int hu = resultSet.getInt("handling_user_id");
        int ca = resultSet.getInt("category");
        Others_Requestoffer or = new Others_Requestoffer( dt, d, s, 0.0f, 0, p, rid, ru, hu, ca, false, "", "", 0.0);
        requestoffers.add(or);
      }

      //convert arraylist to array
      Others_Requestoffer[] array_of_requestoffers = 
        requestoffers.toArray(new Others_Requestoffer[requestoffers.size()]);
      return array_of_requestoffers;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Others_Requestoffer[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }

  /**
    * Gets all the requestoffers for the user.
    * 
    * @param user_id a particular user's id
    * @return an array of Requestoffers made by that user.
    */
  public static Requestoffer[] 
    get_requestoffers_for_user_by_status(int user_id, int status) {
    String sqlText = 
      
      "SELECT r.requestoffer_id, r.datetime, r.description, "+
      "r.points, rs.status, r.requestoffering_user_id, r.handling_user_id, r.category "+
      "FROM requestoffer r "+
      "JOIN requestoffer_state rs ON "+
        "rs.requestoffer_id = r.requestoffer_id " +
      "WHERE "+
        "(r.requestoffering_user_id = ? OR r.handling_user_id = ?) "+
        " AND rs.status = ?";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      pstmt.setInt( 2, user_id);
      pstmt.setInt( 3, status);
      resultSet = pstmt.executeQuery();
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
        int ru = resultSet.getInt("requestoffering_user_id");
        int hu = resultSet.getInt("handling_user_id");
        int ca = resultSet.getInt("category");
        Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,ru,hu,ca,"","");
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
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
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
    Connection conn = Database_access.get_a_connection();
    try {
      // see db_scripts/v1_procedures.sql delete_requestoffer for
      // details on this stored procedure.
      
      cs = conn.prepareCall(String.format(
        "{call delete_requestoffer(%d,%d)}"
        ,deleting_user_id, requestoffer_id));
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
    return true;
  }


  /**
    * Gets all the locations for a given requestoffer
    * 
    * @return the locations, or empty array otherwise.
    */
  public static User_location[] get_locations_for_requestoffer(int requestoffer_id) {
    
    String sqlText = 
    "SELECT l.location_id, pcd.details, pc.postal_code,  " + 
    "c.country_name " + 
    "FROM location l                                                  " + 
    "JOIN location_to_requestoffer ltr                                " + 
    "  ON ltr.location_id = l.location_id AND requestoffer_id = ?     " +
    "JOIN postal_codes pc "+
      "ON pc.country_id = l.country_id "+
        "AND pc.postal_code_id = l.postal_code_id " +
    "JOIN postal_code_details pcd " +
      "ON pcd.country_id = l.country_id "+
        "AND pcd.postal_code_id = l.postal_code_id " +
    "JOIN country c ON c.country_id = l.country_id ";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, requestoffer_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new User_location[0];
      }

      ArrayList<User_location> locations = new ArrayList<User_location>();
      while(resultSet.next()) {
        int lid = resultSet.getInt("location_id");
        String det = resultSet.getNString("details");
        String post = resultSet.getString("postal_code"); // non-unicode on purpose
        String country = resultSet.getNString("country_name");
        locations.add(new User_location(lid,det,post,country));
      }

      User_location[] array_of_user_locations = 
        locations.toArray(new User_location[locations.size()]);
      return array_of_user_locations;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new User_location[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * Gets a particular saved location by location id, must be
    * one owned by the user in user_id
    * 
    * @return that particular saved location, or null
    */
  public static User_location 
    get_location_for_user(int user_id, Integer location_id) {
    
    if (location_id == null) {
      return null;
    }

    // location id would be sufficient, but here I want to make
    //double sure that we aren't getting a location that the user doesn't
    //own.
    String sqlText = 
      "SELECT l.location_id, pcd.details, pc.postal_code, c.country_name " + 
      "FROM location l "+
      "JOIN location_to_user ltu "+
      "  ON ltu.location_id = l.location_id AND user_id = ? "+
      "JOIN postal_codes pc "+
        "ON pc.country_id = l.country_id "+
          "AND pc.postal_code_id = l.postal_code_id " +
      "JOIN postal_code_details pcd " +
        "ON pcd.country_id = l.country_id "+
          "AND pcd.postal_code_id = l.postal_code_id " +
      "JOIN country c ON c.country_id = l.country_id " +
      "WHERE l.location_id = ?";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      pstmt.setInt( 2, location_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next();
      int lid = resultSet.getInt("location_id");
      String det = resultSet.getNString("details");
      String post = resultSet.getString("postal_code"); // non-unicode on purpose
      String country = resultSet.getNString("country");
      User_location uloc = new User_location(lid,det,post,country);
      return uloc;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * Gets all the saved locations for a given user
    * 
    * @return all their saved locations, or empty array otherwise.
    */
  public static User_location[] get_my_saved_locations(int user_id) {
    
    String sqlText = 
      "SELECT l.location_id, pcd.details, pc.postal_code, c.country_name " + 
      "FROM location l "+
      "JOIN location_to_user ltu "+
      "  ON ltu.location_id = l.location_id AND user_id = ? "+
      "JOIN postal_codes pc "+
        "ON pc.country_id = l.country_id "+
          "AND pc.postal_code_id = l.postal_code_id " +
      "JOIN postal_code_details pcd " +
        "ON pcd.country_id = l.country_id "+
          "AND pcd.postal_code_id = l.postal_code_id " +
      "JOIN country c ON c.country_id = l.country_id ";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new User_location[0];
      }

      ArrayList<User_location> locations = new ArrayList<User_location>();
      while(resultSet.next()) {
        int lid = resultSet.getInt("location_id");
        String det = resultSet.getNString("details");
        String post = resultSet.getString("postal_code"); // non-unicode on purpose
        String country = resultSet.getNString("country");
        locations.add(new User_location(lid,det,post,country));
      }

      User_location[] array_of_user_locations = 
        locations.toArray(new User_location[locations.size()]);
      return array_of_user_locations;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new User_location[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * assign an existing location to the user's current location
    */
  public static boolean
    assign_location_to_current(int location_id, int user_id) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall("{call assign_location_to_current(?,?)}");
      cs.setInt(1, location_id);
      cs.setInt(2, user_id);
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
      return true;
    }


  /**
    * assign an existing location to a requestoffer
    */
  public static boolean
    assign_location_to_requestoffer(int location_id, int requestoffer_id) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall("{call assign_location_to_requestoffer(?,?)}");
      cs.setInt(1, location_id);
      cs.setInt(2, requestoffer_id);
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
    return true;

    }


  /**
    * add a location to the database.  That's an address.
    * We also link it to a requestoffer or user if provided.
    * returns an integer greater than 0 (the new location id) if good, 0 otherwise.
    * @param user_id if user_id is given, the new location will be associated
    * with that user.
    * @param requestoffer_id if requestoffer_id is given, the new location will be
    * associated with that requestoffer
    */
  public static int 
    put_location(int user_id, int requestoffer_id, 
        String str_addr_1, String str_addr_2, String city, 
        String state, String postcode, String country) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall("{call put_user_location(?,?,?,?,?,?,?,?,?)}");
      cs.setInt(1, user_id);
      cs.setInt(2, requestoffer_id);
      cs.setNString(3, str_addr_1);
      cs.setNString(4, str_addr_2);
      cs.setNString(5, city);
      cs.setNString(6, state);
      cs.setString(7, postcode); // postal code uses latin characters.
      cs.setNString(8, country);
      cs.registerOutParameter(9, java.sql.Types.INTEGER);
      cs.execute();
      int new_location_id = cs.getInt(9);
      return new_location_id;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return 0;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
  }

  // Put Requestoffer enum
  public enum Pro_enum { OK, DATA_TOO_LARGE, GENERAL_ERROR}

  public static class Put_requestoffer_result {
    public Pro_enum pe;
    public int id;
    public Put_requestoffer_result(Pro_enum pe, int id) {
      this.pe = pe;
      this.id = id;
    }
  }

  /**
    * given all the data to add a requestoffer, does so.
    * @param user_id the user's id
    * @param desc a description string, the core of the requestoffer
    * @param category the category for this requestoffer, 
    * @param coid country id - may be null, used with postal code id to get location
    * @param poid postal code id - may be null, used with country id to get location
    * @return an id result with an enum, OK if ok, DATA_TOO_LARGE if the 
    *  description is too big.  If not OK, id is -1.
    */
  public static Put_requestoffer_result put_requestoffer(
      int user_id, String desc, int category, Integer coid, Integer poid) {

    int new_requestoffer_id = -1; //need it here to be outside the "try".
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      // see db_scripts/v1_procedures.sql put_requestoffer for
      // details on this stored procedure.
      
      cs = conn.prepareCall("{call put_requestoffer(?,?,?,?,?,?,?)}");
      cs.setNString(1, desc);
      cs.setInt(2, user_id);
      cs.setInt(3, 1); //we make all requestoffers 1 point for now
      cs.setInt(4, category); 
      if (coid != null) {
        cs.setInt(5, coid);
      } else {
        cs.setNull(5, java.sql.Types.INTEGER);
      }
      if (poid != null) {
        cs.setInt(6, poid);
      } else {
        cs.setNull(6, java.sql.Types.INTEGER);
      }
      cs.registerOutParameter(7, java.sql.Types.INTEGER);
      cs.execute();
      new_requestoffer_id = cs.getInt(7);
    } catch (SQLException ex) {
      String msg = ex.getMessage();
			if (msg.contains("Data too long")) {
      	return new Put_requestoffer_result(Pro_enum.DATA_TOO_LARGE, -1);
			}
                  
      Database_access.handle_sql_exception(ex);
      return new Put_requestoffer_result(Pro_enum.GENERAL_ERROR, -1);
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
    return new Put_requestoffer_result(Pro_enum.OK, new_requestoffer_id);
  }


  /**
    * gets all the current requestoffer statuses, like OPEN, CLOSED, and TAKEN
    * @return an array of requestoffer status id's 
		* as an Integer array, or null if failure
    */
  public static Integer[] get_requestoffer_statuses() {
    // 1. set the sql
    String sqlText = 
      "SELECT requestoffer_status_id FROM requestoffer_status;";

    // 2. set up values we'll need outside the try
    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      // 3. get the connection and set up a statement
      pstmt = Database_access.prepare_statement(
          conn, sqlText);

      // 4. execute a statement
      resultSet = pstmt.executeQuery();

      // 5. check that we got results
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      // 6. get values from database and convert to an object
      //keep adding rows of data while there is more data
      ArrayList<Integer> statuses = new ArrayList<Integer>();
      while(resultSet.next()) {
        statuses.add(resultSet.getInt("requestoffer_status_id"));
      }

      //convert arraylist to array
      Integer[] my_array = 
				statuses.toArray(new Integer[statuses.size()]);
      return my_array;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
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
    * @param from_user_id the user creating the message
    * @param to_user_id the user receiving the message
    * @return true if successful
    */
  public static boolean 
    set_message(String msg, int requestoffer_id, 
        int from_user_id, int to_user_id) {

    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      // see db_scripts/v1_procedures.sql for
      // details on this stored procedure.
      cs = conn.prepareCall(String.format(
        "{call put_message(?,%d,%d,%d)}" 
				,from_user_id, to_user_id, requestoffer_id));
      cs.setNString(1, msg);
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
    return true;
  }


	/**
		* This sets the requestoffer's state to closed.
		* @param rid the requestoffer id
		* @param uid the requestoffering_user_id
		* @return true if successful, false otherwise
		*/
	public static boolean complete_transaction(
      int rid, int uid) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      // see db_scripts/v1_procedures.sql for
      // details on this stored procedure.
      cs = conn.prepareCall(String.format(
        "{call complete_ro_transaction(%d,%d)}" ,uid, rid ));
      cs.execute();
      return true;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
	}


  public static class MyMessages {

    public final int requestoffer_id;
    public final int from_user_id;
    public final int to_user_id;
    public String message;
    public String fname;
    public String tname;
    public String timestamp;
    public String desc;

    public MyMessages(String timestamp, int rid, int fuid, int tuid, 
        String msg, String fname, String tname, String desc) {
      this.requestoffer_id = rid;
      this.from_user_id = fuid;
      this.to_user_id = tuid;
      this.message = msg;
      this.timestamp = timestamp;
      this.fname = fname;
      this.tname = tname;
      this.desc = desc;
    }
  }


  /**
    * gets all the system messages (messages from system to me)
		* for a given user.
    * @param user_id the user requesting to see their own messages
    * @return an array of MyMessages, or empty array otherwise.
    */
  public static MyMessages[] 
    get_my_system_messages(int user_id, Localization loc) {
    String sqlText = 
      String.format(
      "SELECT ro.description, stum.timestamp, stum.requestoffer_id, "+
      "stum.text_id " +
      "FROM system_to_user_message stum "+
      "JOIN requestoffer ro "+
        "ON ro.requestoffer_id = stum.requestoffer_id " +
      "WHERE to_user_id = %d " +
      "ORDER BY timestamp DESC", user_id);
    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new MyMessages[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<MyMessages> mms = new ArrayList<MyMessages>();
      while(resultSet.next()) {
        String timestamp = resultSet.getString("timestamp");
        int text_id = resultSet.getInt("text_id");
        int rid = resultSet.getInt("requestoffer_id");
        String desc = resultSet.getNString("description");
        int fuid = 1; // the system user
        String fname = "System";
        String text = loc.get(text_id,"");
        String tname = "You";
        MyMessages mm = 
          new MyMessages(timestamp, rid,fuid,user_id,text,fname,tname, desc);
        mms.add(mm);
      }
      MyMessages[] array_of_messages = 
        mms.toArray(new MyMessages[mms.size()]);

      return array_of_messages;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new MyMessages[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * gets all the messages (correspondence between users) for a 
		* given user - all request offers, one user.
    * @param user_id the user requesting to see their own messages
    * @return an array of MyMessages, or empty array otherwise.
    */
  public static MyMessages[] get_my_conversations(int user_id) {
    String sqlText = 
      String.format(
      "SELECT ro.description, rm.timestamp, rm.requestoffer_id, "+
      "rm.message, "+
        "rm.from_user_id AS fuid, rm.to_user_id AS tuid,  "+
        "from_user.username AS fusername, "+
        "to_user.username AS tusername "+
      "FROM requestoffer_message rm "+
      "JOIN user from_user ON from_user.user_id = rm.from_user_id " +
      "JOIN user to_user ON to_user.user_id = rm.to_user_id " + 
      "JOIN requestoffer ro "+
        "ON ro.requestoffer_id = rm.requestoffer_id " +
      "JOIN requestoffer_state rs ON rs.requestoffer_id = ro.requestoffer_id " +
      "WHERE (from_user_id = %d OR to_user_id = %d) " +
        "AND rs.status <> " + Const.Rs.DRAFT + " " + 
      "ORDER BY timestamp DESC LIMIT 10", user_id, user_id);
    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new MyMessages[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<MyMessages> mms = new ArrayList<MyMessages>();
      while(resultSet.next()) {
        String timestamp = resultSet.getString("timestamp");
        String msg = resultSet.getNString("message");
        int rid = resultSet.getInt("requestoffer_id");
        int fuid = resultSet.getInt("fuid");
        int tuid = resultSet.getInt("tuid");
        String tname = resultSet.getNString("tusername");
        String fname = resultSet.getNString("fusername");
        String desc = resultSet.getNString("description");
        MyMessages mm = 
          new MyMessages(timestamp, rid,fuid,tuid,msg,fname,tname, desc);
        mms.add(mm);
      }
      MyMessages[] array_of_messages = 
        mms.toArray(new MyMessages[mms.size()]);

      return array_of_messages;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new MyMessages[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  public static class MessageWithDate {
    public final String message;
    public final String date;
    public MessageWithDate(String message, String date) {
      this.message = message;
      this.date = date;
    }
  }


  /**
    * gets all the messages (correspondence between users) for a 
		*  requestoffer.  
    * @param requestoffer_id the key for the messages
    * @param user_id the user requesting to see the messages.
    * @return an array of messages for this requestoffer, 
    * or empty array if failure.
    */
  public static MessageWithDate[] get_messages(int requestoffer_id, int user_id) {
    //sql here is: get messages for this requestoffer where I (user_id)
    // am one of the participants in the conversation
    String sqlText = 
      String.format(
      "SELECT message, timestamp FROM requestoffer_message "+
      "WHERE requestoffer_id = %d "+
      "AND (from_user_id = %d OR to_user_id = %d) " +
      "ORDER BY timestamp ASC ", 
        requestoffer_id, user_id, user_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new MessageWithDate[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<MessageWithDate> messages = new ArrayList<MessageWithDate>();
      while(resultSet.next()) {
        String msg = resultSet.getNString("message");
        String date = resultSet.getString("timestamp");
        messages.add(new MessageWithDate(msg, date));
      }

      //convert arraylist to array
      MessageWithDate[] array_of_messages = 
        messages.toArray(new MessageWithDate[messages.size()]);
      return array_of_messages;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new MessageWithDate[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * encapsulates the information needed by the view when showing
    * information about rankings between users
    */
  public static class Rank_detail {

    public int urdp_id; // the id of the user rank data point.
    public int judging_user_id;
    public String judging_username;
    public int judged_user_id;
    public String judged_username;
    public Boolean meritorious; // whether it was thumbs-up, null, thumbs-down
    public int ro_id; // the requestoffer id
    public String ro_desc; //the description of the requestoffer
    public String timestamp;
    public int status_id;
    public String comment; // the comment entered by the judging user

    public Rank_detail(
      int urdp_id,
      int judging_user_id,
      String judging_username,
      int judged_user_id,
      String judged_username,
      Boolean meritorious,
      int ro_id,
      String ro_desc,
      String timestamp,
      int status_id,
      String comment
        ) {
      this.urdp_id          = urdp_id;
      this.judging_user_id  = judging_user_id;
      this.judging_username = judging_username;
      this.judged_user_id   = judged_user_id;
      this.judged_username  = judged_username;
      this.meritorious      = meritorious;
      this.ro_id            = ro_id;
      this.ro_desc          = ro_desc;
      this.timestamp        = timestamp;
      this.status_id        = status_id;
      this.comment          = comment;
    }
  }



  /**
    * gets all the rankings associated with a given user, for display
    * @param user_id the user whose rankings we'll see.
    * @return an array of Rank_detail - see that class, or empty
    * array otherwise.
    */
  public static Rank_detail[] get_rank_detail(int user_id) {
    String sqlText = 

      String.format(
      "SELECT ju.username AS jusername, ju.user_id AS         "+
      "juser_id, u.username, u.user_id, urdp.date_entered,    "+
      "       urdp.meritorious,urdp.requestoffer_id,          "+
      "       ro.description, urdp.status_id, urdp.urdp_id,   "+
      "       urdpn.text                                      "+
      "FROM user_rank_data_point urdp                         "+
      "   LEFT JOIN user_rank_data_point_note urdpn           "+
      "     ON urdpn.urdp_id = urdp.urdp_id                   "+
      "   JOIN user ju ON ju.user_id = urdp.judge_user_id     "+
      "   JOIN user u ON u.user_id = urdp.judged_user_id      "+
      "   JOIN requestoffer ro                                "+
      "     ON ro.requestoffer_id = urdp.requestoffer_id      "+
      "WHERE ju.user_id = %d OR u.user_id = %d                "+
      "ORDER BY urdp.date_entered DESC                        ",
        user_id, user_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      resultSet = pstmt.executeQuery();

      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Rank_detail[0];
      }

      //keep adding rows of data while there is more data
      ArrayList<Rank_detail> rds = new ArrayList<Rank_detail>();
      while(resultSet.next()) {
        int juser_id = resultSet.getInt("juser_id");
        String jusername = resultSet.getNString("jusername");
        int uid = resultSet.getInt("user_id");
        String username = resultSet.getNString("username");
        Boolean meritorious = resultSet.getBoolean("meritorious");
        int urdp_id = resultSet.getInt("urdp_id");
        if (resultSet.wasNull()) {
          meritorious = null;
        }
        String comment = resultSet.getNString("text");
        if (resultSet.wasNull()) {
          comment = "";
        }
        String desc = resultSet.getNString("description");
        int ro_id = resultSet.getInt("requestoffer_id");
        String timestamp = resultSet.getString("date_entered");
        int status_id = resultSet.getInt("status_id");

        rds.add(new Rank_detail(urdp_id, juser_id, jusername, uid, username, meritorious, ro_id, desc, timestamp, status_id, comment));
      }

      //convert arraylist to array
      Rank_detail[] array_of_rds = 
        rds.toArray(new Rank_detail[rds.size()]);
      return array_of_rds;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Rank_detail[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * gets all the rank detail for a given user rank data point id
    * @param urdp_id the user rank data point id
    * @return details about a particular user rank data point, or
    *   null otherwise.
    */
  public static Rank_detail get_urdp_detail(int urdp_id) {
    String sqlText = 

      String.format(
      "SELECT ju.username AS jusername, ju.user_id AS         "+
      "juser_id, u.username, u.user_id, urdp.date_entered,    "+
      "       urdp.meritorious,urdp.requestoffer_id,          "+
      "       ro.description, urdp.status_id, urdp.urdp_id,   "+
      "       urdpn.text                                      "+
      "FROM user_rank_data_point urdp                         "+
      "   LEFT JOIN user_rank_data_point_note urdpn           "+
      "     ON urdpn.urdp_id = urdp.urdp_id                   "+
      "   JOIN user ju ON ju.user_id = urdp.judge_user_id     "+
      "   JOIN user u ON u.user_id = urdp.judged_user_id      "+
      "   JOIN requestoffer ro                                "+
      "     ON ro.requestoffer_id = urdp.requestoffer_id      "+
      "WHERE urdp.urdp_id = %d                                ",
        urdp_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      resultSet = pstmt.executeQuery();

      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      //keep adding rows of data while there is more data
      resultSet.next();
      int juser_id = resultSet.getInt("juser_id");
      String jusername = resultSet.getNString("jusername");
      int uid = resultSet.getInt("user_id");
      String username = resultSet.getNString("username");
      Boolean meritorious = null;
      String comment = "";
      String desc = resultSet.getNString("description");
      int ro_id = resultSet.getInt("requestoffer_id");
      String timestamp = resultSet.getString("date_entered");
      int status_id = resultSet.getInt("status_id");

      Rank_detail rd = new Rank_detail(urdp_id, juser_id, jusername, uid, username, meritorious, ro_id, desc, timestamp, status_id, comment);

      return rd;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * apply a ranking to the other user for a given
    * user id and requestoffer
    */
  public static boolean 
    rank_other_user(int user_id, int urdp_id, 
        boolean is_satis, String comment) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall(String.format(
        "{call rank_other_user(%d, %d, %b, ?)}" 
        , user_id, urdp_id, is_satis));
      cs.setNString(1, comment);
      cs.execute();
      return true;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
  }




}
