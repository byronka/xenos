package com.renomad.xenos;

import java.util.ArrayList;
import java.util.Arrays;
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
    * put the requestoffer into a 'draft' status,
    * hidden from everyone but the owner
    */
  public static boolean 
    retract_requestoffer(int user_id, int requestoffer_id ) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      cs = conn.prepareCall(String.format(
        "{call retract_requestoffer(%d, %d)}" 
        , user_id, requestoffer_id));
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
    * put the requestoffer into an 'open' status,
    * so people can potentially handle it.
    */
  public static boolean 
    publish_requestoffer(int requestoffer_id, int user_id) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      cs = conn.prepareCall(String.format(
        "{call publish_requestoffer(%d, %d)}" 
        , user_id, requestoffer_id));
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
    * returns unviewed messages, localized
    *  from the temporary_messages table
    * or an empty String array if there are none.
    */
  public static String[] 
    get_my_temporary_msgs(int user_id, Localization loc) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      cs = conn.prepareCall(String.format(
        "{call get_my_temporary_msgs(%d)}" , user_id ));
      ResultSet resultSet = cs.executeQuery();

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
      Database_access.close_statement(cs);
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
    * this will cancel a transaction in "taken" status, that is, a
    * requestoffer that has someone servicing it.
    */
  public static boolean
    cancel_taken_requestoffer(
        int user_id, int requestoffer_id) {
      CallableStatement cs = null;
      try {
        Connection conn = Database_access.get_a_connection();
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
      }
    }


  /**
    * indicate that you are interested in handling a particular
    * requestoffer.  This enters an item in service_requestoffer
    */
  public static boolean
    offer_to_take_requestoffer(int user_id, int requestoffer_id) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      cs = conn.prepareCall(String.format(
        "{call offer_to_take_requestoffer(%d, %d)}" 
        , user_id, requestoffer_id));
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
    * sets the status of the requestoffer to taken for a given user.
    * @param new_handler_id the id of the user who will now handle this.
    * @param requestoffer_id the id of the requestoffer they will handle.
    * @return true if successful at taking, false otherwise.
    */
  public static boolean 
    choose_handler(int new_handler_id, int requestoffer_id) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
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
    }
    return true;
  }


  public static class Offer_I_made {

    public final int requestoffer_id;
    public String description;
    public String date_created;

    public Offer_I_made(
        int requestoffer_id, 
        String description, 
        String date_created) {
      this.requestoffer_id = requestoffer_id;
      this.description = description;
      this.date_created = date_created;
    }
  }


  /**
    * Gets an array of offers I made on requestoffers
    * 
    * @param user_id the user who made offers on requestoffers
    * @return an array of offers, or empty array if failure
    */
  public static Offer_I_made[] 
    get_requestoffers_I_offered_to_service(int user_id) {
    
    String sqlText = 
      "SELECT ro.requestoffer_id, ro.description, "+
        "rsr.date_created " +
      "FROM requestoffer_service_request rsr " +
      "JOIN requestoffer ro "+
        "ON ro.requestoffer_id = rsr.requestoffer_id " +
      "WHERE rsr.user_id = ? AND rsr.status = 106";

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Offer_I_made[0];
      }

      ArrayList<Offer_I_made> offers = 
        new ArrayList<Offer_I_made>();
      while(resultSet.next()) {
        int rid = resultSet.getInt("requestoffer_id");
        String desc = resultSet.getNString("description");
        String dt = resultSet.getString("date_created");
        offers.add(new Offer_I_made(rid, desc, dt));
      }

      //convert arraylist to array
      Offer_I_made[] array_of_offers = 
        offers.toArray(new Offer_I_made[offers.size()]);

      return array_of_offers;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Offer_I_made[0];
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  public static class Service_request {

    public final int requestoffer_id;
    public String desc;
    public final int user_id;
    public String date_created;

    public Service_request(
        int requestoffer_id, 
        int user_id, 
        String date_created,
        String desc) {
      this.requestoffer_id = requestoffer_id;
      this.user_id = user_id;
      this.date_created = date_created;
      this.desc = desc;
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
      "ro.description " +
      "FROM requestoffer_service_request rsr " +
      "JOIN requestoffer ro "+
        "ON ro.requestoffer_id = rsr.requestoffer_id " +
      "WHERE ro.requestoffering_user_id = ? AND rsr.status = 106";

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Service_request[0];
      }

      ArrayList<Service_request> service_requests = 
        new ArrayList<Service_request>();
      while(resultSet.next()) {
        int rid = resultSet.getInt("requestoffer_id");
        int uid = resultSet.getInt("user_id");
        String dt = resultSet.getString("date_created");
        String desc = resultSet.getString("description");
        service_requests.add(new Service_request(rid, uid, dt, desc));
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
      Database_access.close_statement(pstmt);
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
      "rs.status, r.requestoffering_user_id, r.handling_user_id, r.category "+
      "FROM requestoffer r "+
      "JOIN requestoffer_state rs "+
        "ON rs.requestoffer_id = r.requestoffer_id " +
      "WHERE r.requestoffer_id = ? "+
      "GROUP BY requestoffer_id";

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
      int ru = resultSet.getInt("requestoffering_user_id");
      int hu = resultSet.getInt("handling_user_id");
      int ca = resultSet.getInt("category");
      Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,ru,hu,ca);

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

    public final Float minrank; //the user's ranking - might be null.
    public final Float maxrank; //the user's ranking - might be null.

    public final String postcode; // postal code


    public Search_Object(
        String startdate,
        String enddate,
        String categories,
        String description,
        String statuses,
        String user_ids,
        String minrank,
        String maxrank,
        String postcode
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
      this.minrank = Utils.parse_float(minrank);
      this.maxrank = Utils.parse_float(maxrank);
      this.postcode = postcode;
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
			this.or = or;
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
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_procedures.sql get_others_requestoffers for
      // details on this stored procedure.
      cs = conn.prepareCall(String.format(
        "{call get_others_requestoffers(?,?,?,?,?,?,?,?,?,?,?,?)}"
        ,ruid, page));
      cs.setInt(1, ruid);
      cs.setString(2, so.startdate);
      cs.setString(3, so.enddate);
      cs.setString(4, so.statuses);
      cs.setString(5, so.categories);
      cs.setString(6, so.user_ids);
      cs.setInt(7, page);
      cs.setString(8, so.description);
      if (so.minrank != null) {
        cs.setFloat(9, so.minrank);
      } else {
        cs.setNull(9, java.sql.Types.FLOAT);
      }
      if (so.maxrank != null) {
        cs.setFloat(10, so.maxrank);
      } else {
        cs.setNull(10, java.sql.Types.FLOAT);
      }
      cs.setString(11, so.postcode);
      cs.registerOutParameter(12, java.sql.Types.INTEGER);
      ResultSet resultSet = cs.executeQuery();
      int pages = cs.getInt(12);

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
        String po = resultSet.getString("postal_code");
        Double di = resultSet.getDouble("distance");
        if (resultSet.wasNull()) {
          di = null;
        }
        String ci = resultSet.getNString("city");
        if (offered_user_id > 0) {
          has_been_offered = true;
        }

        Others_Requestoffer requestoffer = 
          new Others_Requestoffer(
              dt,d,s,ra,rl,p,rid,ru,hu,ca, has_been_offered,po,ci,di);
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
    * Gets all the requestoffers a user is handling
    * 
    * @param user_id a particular user's id
    * @return an array of Requestoffers handled by that user.
    */
  public static Requestoffer[] 
      get_requestoffers_I_am_handling(int user_id) {
    String sqlText = 
      
      "SELECT r.requestoffer_id, r.datetime, r.description, "+
      "r.points, r.category, rs.status, r.requestoffering_user_id, r.handling_user_id "+
      "FROM requestoffer r "+
      "JOIN requestoffer_state rs "+
        "ON rs.requestoffer_id = r.requestoffer_id " +
      "WHERE r.handling_user_id = ? AND rs.status <> 77"; // 77 is closed.

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
      ArrayList<Requestoffer> requestoffers = 
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
        Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,ru,hu,ca);
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
        "r.requestoffering_user_id = ? "+
        " AND rs.status = ?";

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      pstmt.setInt( 2, status);
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
        int ru = resultSet.getInt("requestoffering_user_id");
        int hu = resultSet.getInt("handling_user_id");
        int ca = resultSet.getInt("category");
        Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,ru,hu,ca);
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
    * Gets all the locations for a given requestoffer
    * 
    * @return the locations, or empty array otherwise.
    */
  public static User_location[] get_locations_for_requestoffer(int requestoffer_id) {
    
    String sqlText = 
    "SELECT l.location_id, l.address_line_1, l.address_line_2, l.city," + 
    "      l.state, l.postal_code, l.country                          " + 
    "FROM location l                                                  " + 
    "JOIN location_to_requestoffer ltr                                " + 
    "  ON ltr.location_id = l.location_id AND requestoffer_id = ?     ";

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, requestoffer_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new User_location[0];
      }

      ArrayList<User_location> locations = new ArrayList<User_location>();
      while(resultSet.next()) {
        int lid = resultSet.getInt("location_id");
        String sa1 = resultSet.getNString("address_line_1");
        String sa2 = resultSet.getNString("address_line_2");
        String city = resultSet.getNString("city");
        String state = resultSet.getNString("state");
        String post = resultSet.getString("postal_code"); // non-unicode on purpose
        String country = resultSet.getNString("country");
        locations.add(new User_location(lid,sa1,sa2,city,state,post,country));
      }

      User_location[] array_of_user_locations = 
        locations.toArray(new User_location[locations.size()]);
      return array_of_user_locations;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new User_location[0];
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  /**
    * Gets a particular saved location by location id, must be
    * one owned by the user in user_id
    * 
    * @return that particular saved location, or null
    */
  public static User_location get_location_for_user(int user_id, int location_id) {
    
    // location id would be sufficient, but here I want to make
    //double sure that we aren't getting a location that the user doesn't
    //own.
    String sqlText = 
      "SELECT l.location_id, l.address_line_1, " +
      "l.address_line_2, l.city," + 
      "l.state, l.postal_code, l.country " + 
      "FROM location l "+
      "JOIN location_to_user ltu "+
      "  ON ltu.location_id = l.location_id AND user_id = ? "+
      "WHERE l.location_id = ?";

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      pstmt.setInt( 2, location_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next();
      int lid = resultSet.getInt("location_id");
      String sa1 = resultSet.getNString("address_line_1");
      String sa2 = resultSet.getNString("address_line_2");
      String city = resultSet.getNString("city");
      String state = resultSet.getNString("state");
      String post = resultSet.getString("postal_code"); // non-unicode on purpose
      String country = resultSet.getNString("country");
      User_location uloc = new User_location(lid,sa1,sa2,city,state,post,country);
      return uloc;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  /**
    * Gets all the saved locations for a given user
    * 
    * @return all their saved locations, or empty array otherwise.
    */
  public static User_location[] get_my_saved_locations(int user_id) {
    
    String sqlText = 
"SELECT l.location_id, l.address_line_1, l.address_line_2, l.city," + 
"      l.state, l.postal_code, l.country                          " + 
"FROM location l                                                  " + 
"JOIN location_to_user ltu                                        " + 
"  ON ltu.location_id = l.location_id AND user_id = ?             ";

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new User_location[0];
      }

      ArrayList<User_location> locations = new ArrayList<User_location>();
      while(resultSet.next()) {
        int lid = resultSet.getInt("location_id");
        String sa1 = resultSet.getNString("address_line_1");
        String sa2 = resultSet.getNString("address_line_2");
        String city = resultSet.getNString("city");
        String state = resultSet.getNString("state");
        String post = resultSet.getString("postal_code"); // non-unicode on purpose
        String country = resultSet.getNString("country");
        locations.add(new User_location(lid,sa1,sa2,city,state,post,country));
      }

      User_location[] array_of_user_locations = 
        locations.toArray(new User_location[locations.size()]);
      return array_of_user_locations;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new User_location[0];
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  /**
    * assign an existing location to the user's current location
    */
  public static boolean
    assign_location_to_current(int location_id, int user_id) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      cs = conn.prepareCall("{call assign_location_to_current(?,?)}");
      cs.setInt(1, location_id);
      cs.setInt(2, user_id);
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
    * assign an existing location to a requestoffer
    */
  public static boolean
    assign_location_to_requestoffer(int location_id, int requestoffer_id) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      cs = conn.prepareCall("{call assign_location_to_requestoffer(?,?)}");
      cs.setInt(1, location_id);
      cs.setInt(2, requestoffer_id);
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
    try {
      Connection conn = Database_access.get_a_connection();
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
      cs.executeQuery();
      int new_location_id = cs.getInt(9);
      return new_location_id;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return 0;
    } finally {
      Database_access.close_statement(cs);
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
    * @return an id result with an enum, OK if ok, DATA_TOO_LARGE if the 
    *  description is too big.  If not OK, id is -1.
    */
  public static Put_requestoffer_result put_requestoffer(
      int user_id, String desc, int category) {

    int new_requestoffer_id = -1; //need it here to be outside the "try".
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_procedures.sql put_requestoffer for
      // details on this stored procedure.
      
      cs = conn.prepareCall("{call put_requestoffer(?,?,?,?,?)}");
      cs.setNString(1, desc);
      cs.setInt(2, user_id);
      cs.setInt(3, 1); //we make all requestoffers 1 point for now
      cs.setInt(4, category); 
      cs.registerOutParameter(5, java.sql.Types.INTEGER);
      cs.executeQuery();
      new_requestoffer_id = cs.getInt(5);
    } catch (SQLException ex) {
      String msg = ex.getMessage();
			if (msg.contains("Data too long")) {
      	return new Put_requestoffer_result(Pro_enum.DATA_TOO_LARGE, -1);
			}
                  
      Database_access.handle_sql_exception(ex);
      return new Put_requestoffer_result(Pro_enum.GENERAL_ERROR, -1);
    } finally {
      Database_access.close_statement(cs);
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
        "{call put_message(?,%d,%d)}" 
				,user_id, requestoffer_id));
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
		* This sets the requestoffer's state to closed.
		* @param rid the requestoffer id
		* @param uid the requestoffering_user_id
		* @return true if successful, false otherwise
		*/
	public static boolean complete_transaction(
      int rid, int uid) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
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
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
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
      Database_access.close_statement(pstmt);
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
      "WHERE from_user_id = %d OR to_user_id = %d " +
      "ORDER BY timestamp DESC", user_id, user_id);
    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
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
      Database_access.close_statement(pstmt);
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
  public static String[] get_messages(int requestoffer_id, int user_id) {
    //sql here is: get messages for this requestoffer where I (user_id)
    // am one of the participants in the conversation
    String sqlText = 
      String.format(
      "SELECT message FROM requestoffer_message "+
      "WHERE requestoffer_id = %d "+
      "AND (from_user_id = %d OR to_user_id = %d) " +
      "ORDER BY timestamp ASC ", 
        requestoffer_id, user_id, user_id);

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
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
      "WHERE ju.user_id = %d OR u.user_id = %d                ",
        user_id, user_id);

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();

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
      Database_access.close_statement(pstmt);
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
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();

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
      Database_access.close_statement(pstmt);
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
    try {
      Connection conn = Database_access.get_a_connection();
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
    }
  }




}
