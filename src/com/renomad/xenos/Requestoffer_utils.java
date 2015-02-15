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
    * put the requestoffer into an 'open' status,
    * so people can potentially handle it.
    */
  public static boolean publish_requestoffer(int requestoffer_id, int user_id) {
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
    * @return true if successful at taking, false otherwise.
    */
  public static boolean 
    take_requestoffer(int user_id, int requestoffer_id) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_procedures.sql take_requestoffer for
      // details on this stored procedure.
      
      cs = conn.prepareCall(String.format(
        "{call take_requestoffer(%d, %d)}" , user_id, requestoffer_id));
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
      "WHERE rsr.user_id = ?";

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
    public final int user_id;
    public String date_created;

    public Service_request(
        int requestoffer_id, 
        int user_id, 
        String date_created) {
      this.requestoffer_id = requestoffer_id;
      this.user_id = user_id;
    }
  }


  /**
    * Gets the list of users that have offered to service my request
    * 
    * @param user_id the user asking about servicers for their requestoffers
    * @return an array of service requests, or empty array if failure
    */
  public static Service_request[] get_service_requests(int user_id) {
    
    String sqlText = 
      "SELECT rsr.requestoffer_id, rsr.user_id, rsr.date_created " +
      "FROM requestoffer_service_request rsr " +
      "JOIN requestoffer ro "+
        "ON ro.requestoffer_id = rsr.requestoffer_id " +
      "WHERE ro.requestoffering_user_id = ?";

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
        service_requests.add(new Service_request(rid, uid, dt));
      }

      //convert arraylist to array
      Service_request[] array_of_service_requests = 
        service_requests.toArray(new Service_request[service_requests.size()]);

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
      "r.status, r.requestoffering_user_id, r.handling_user_id, "+
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
      int ru = resultSet.getInt("requestoffering_user_id");
      int hu = resultSet.getInt("handling_user_id");
      String ca = resultSet.getString("categories");
      Integer[] categories = parse_string_to_int_array(ca);
      Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,ru,hu,categories);

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


    public Search_Object(
        String startdate,
        String enddate,
        String categories,
        String description,
        String statuses,
        String user_ids) {
      this.startdate = startdate;
      this.enddate = enddate;
      this.categories = Utils.is_comma_delimited_numbers(categories) ? 
        categories 
        : "";
      this.description = description;
      this.statuses = Utils.is_comma_delimited_numbers(statuses) ? 
        statuses 
        : "";
      this.user_ids = Utils.is_comma_delimited_numbers(user_ids) ? 
        user_ids 
        : "";
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
        "{call get_others_requestoffers(%d,?,?,?,?,?,%d,?,?)}"
        ,ruid, page));
      cs.setString(1, so.startdate);
      cs.setString(2, so.enddate);
      cs.setString(3, so.statuses);
      cs.setString(4, so.categories);
      cs.setString(5, so.user_ids);
      cs.setString(6, so.description);
      cs.registerOutParameter(7, java.sql.Types.INTEGER);
      ResultSet resultSet = cs.executeQuery();
      int pages = cs.getInt(7);

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
        int ru = resultSet.getInt("requestoffering_user_id");
        int hu = resultSet.getInt("handling_user_id");
        int ra = resultSet.getInt("rank");
        int offered_user_id = resultSet.getInt("been_offered");
        boolean has_been_offered = false;
        if (offered_user_id > 0) {
          has_been_offered = true;
        }
        String cats = resultSet.getString("categories");
        Integer[] cat_array = parse_string_to_int_array(cats);

        Others_Requestoffer requestoffer = 
          new Others_Requestoffer(
              dt,d,s,ra,p,rid,ru,hu,cat_array, has_been_offered);
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
    String sqlText = "SELECT requestoffer_id, datetime, description, "+
      "points, status, requestoffering_user_id, handling_user_id "+
      "FROM requestoffer WHERE handling_user_id = ?";
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
        int ru = resultSet.getInt("requestoffering_user_id");
        int hu = resultSet.getInt("handling_user_id");
        Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,ru,hu);
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
  public static Requestoffer[] get_requestoffers_for_user(int user_id) {
    String sqlText = "SELECT requestoffer_id, datetime, description, "+
      "points, status, requestoffering_user_id, handling_user_id "+
      "FROM requestoffer WHERE requestoffering_user_id = ?";
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
        int ru = resultSet.getInt("requestoffering_user_id");
        int hu = resultSet.getInt("handling_user_id");
        Requestoffer requestoffer = new Requestoffer(rid,dt,d,p,s,ru,hu);
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
    * @param categories the various categories for this requestoffer, 
    */
  public static Requestoffer_response put_requestoffer(
      int user_id, String desc, Integer[] categories) {

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

      cs = conn.prepareCall("{call put_requestoffer(?,?,?,?,?)}");
      cs.setNString(1, desc);
      cs.setInt(2, user_id);
      cs.setInt(3, 1); //we make all requestoffers 1 point for now
      cs.setString(4, categories_str);
      cs.registerOutParameter(5, java.sql.Types.INTEGER);
      cs.executeQuery();
      new_requestoffer_id = cs.getInt(5);
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Requestoffer_response(Requestoffer_response.Stat.ERROR, -1);
    } finally {
      Database_access.close_statement(cs);
    }
    //indicate all is well, along with the new id
    return new Requestoffer_response(Requestoffer_response.Stat.OK, new_requestoffer_id);
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

    ArrayList<Integer> selected_categories = new ArrayList<Integer>();
    for (Integer i : all_categories) {
      String c = loc.get(i,"");
      if (categories_str.contains(c)) {
        selected_categories.add(i);
      }
    }
    Integer[] my_array = 
      selected_categories.toArray(new Integer[selected_categories.size()]);
    return my_array;
  }


  /**
    * gets all the requestoffer categories that exist as 
    * a comma-delimited string in the locale of the user.
    */
  public static String get_categories_string(Localization loc) {
      List<Integer> c = get_all_categories();
      Integer[] cat_array = c.toArray(new Integer[c.size()]);
			StringBuilder sb = new StringBuilder(loc.get(cat_array[0],""));
			for(int i = 1; i < cat_array.length; i++) {
				sb
					.append(",")
					.append(loc.get(cat_array[i],""));
			}
			return sb.toString();
  }



	/**
		* returns a comma-delimited string of requestoffer_statuses
		*/
	public static String get_requestoffer_status_string(Localization loc) {
		Integer[] ros = get_requestoffer_statuses();
		StringBuilder sb = new StringBuilder(loc.get(ros[0],""));
		for(int i = 1; i < ros.length; i++) {
			sb
				.append(",")
				.append(loc.get(ros[i],""));
		}
		return sb.toString();
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
      int rid, int uid, boolean is_satisfied) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      // see db_scripts/v1_procedures.sql for
      // details on this stored procedure.
      cs = conn.prepareCall(String.format(
        "{call complete_ro_transaction(%d,%d,%b)}" 
        ,uid, rid, is_satisfied));
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
    }
    return true;
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
    * gets all the messages (correspondence between users) for a 
		* given user - all request offers, one user.
    * @param user_id the user requesting to see their own messages
    * @return an array of MyMessages, or empty array otherwise.
    */
  public static MyMessages[] get_my_messages(int user_id) {
    String sqlText = 
      String.format(
					"SELECT ro.description, rm.timestamp, rm.requestoffer_id, rm.message, "+
            "rm.from_user_id AS fuid, rm.to_user_id AS tuid,  "+
            "from_user.username AS fusername, to_user.username AS tusername "+
          "FROM requestoffer_message rm "+
          "JOIN user from_user ON from_user.user_id = rm.from_user_id " +
          "JOIN user to_user ON to_user.user_id = rm.to_user_id " + 
          "JOIN requestoffer ro ON ro.requestoffer_id = rm.requestoffer_id " +
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
      "AND (from_user_id = %d OR to_user_id = %d)", requestoffer_id, user_id, user_id);

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
      OK , ERROR
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
