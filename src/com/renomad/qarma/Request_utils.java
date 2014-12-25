package com.renomad.qarma;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import com.renomad.qarma.Database_access;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
	* this class consists of methods that act upon Requests
	*/
public final class Request_utils {

	private Request_utils() {
		//private constructor.  This class is not allowed to be
		//instantiated.  do nothing here.
	}

	/**
		* returns a Map of localized request categories, 
		* indexed by database id.
		* @return Map of strings, indexed by id, or null if nothing in db.
		*/
	public static Map<Integer, String> get_all_categories() {
		// 1. set the sql
    String sqlText = 
			"SELECT request_category_id FROM request_category; ";
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
      Map<Integer, String> categories = new HashMap<Integer,String>();
      while(resultSet.next()) {
        int rcid = resultSet.getInt("request_category_id");
				String category = Business_logic.get_category_localized(rcid);
        categories.put(rcid, category); 
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
		* gets an array of request categories for a given request
		*
		* @param request_id the id of the request to check categories
		* @return an array of Strings, 
		* representing the categories, or null if failure.
		*/
	public static Integer[] get_categories_for_request(int request_id) {
    String sqlText = 
			"SELECT request_category_id "+
				"FROM request_to_category "+
				"WHERE request_id = ?;";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = Database_access.prepare_statement(
					conn, sqlText);     
      pstmt.setInt( 1, request_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Integer[0];
      }

			//keep adding rows of data while there is more data
      ArrayList<Integer> categories = new ArrayList<Integer>();
      while(resultSet.next()) {
        int rcid = resultSet.getInt("request_category_id");
        categories.add(rcid);
      }

      //convert arraylist to array
      Integer[] array_of_categories = 
        categories.toArray(new Integer[categories.size()]);
      return array_of_categories;
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
    * @return a single Request
    */
  public static Request get_a_request(int request_id) {
		
    String sqlText = 
      "SELECT request_id, datetime,description,points,"+
			"status,title,requesting_user_id "+
			"FROM request "+
			"WHERE request_id = ?";

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
			Integer[] categories = get_categories_for_request(request_id);
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
    * Gets all the requests for the user.
    * 
		* @param user_id the id of a given user
    * @return an array of Requests that were *not* made by that user
    */
  public static Request[] get_all_requests_except_for_user(int user_id) {
    String sqlText = "SELECT * FROM request WHERE requesting_user_id <> ?";
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
		* @param id the id of the request to delete
		* @param deleting_user_id the id of the user making the request
		* @return true if successful
		*/
	public static boolean delete_request(int id, int deleting_user_id) {
		// 1. set the sql
		String get_points_in_request_sql = 
			"SELECT points, requesting_user_id FROM request WHERE request_id = ?";
		String delete_request_sql = 
			"DELETE FROM request WHERE request_id = ?";
		String update_points_sql = 
			"UPDATE user SET points = points + ? WHERE user_id = ?";

		int result = -1; //default to a guard value that indicates failure
		PreparedStatement get_pts_pstmt = null; //getting the points statement
		PreparedStatement del_pstmt = null; //the deletion statement
		PreparedStatement up_pts_pstmt = null; //updating the points statement
		Connection conn = null;
		try {
			// 3. get the connection and set up a statement
			conn = Database_access.get_a_connection();

			//get the points on the request
      get_pts_pstmt  = conn.prepareStatement(get_points_in_request_sql);
			get_pts_pstmt.setInt(1, id); 
			ResultSet resultSet = get_pts_pstmt.executeQuery();
			// check that we got results
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
				System.err.println(
						"Error(3): Transaction is being rolled back "+
						"for request_id: " + result);
				conn.rollback();
        return false;
      }
			//get those points and the user
      resultSet.next();
			int points = resultSet.getInt("points");
			int user_id = resultSet.getInt("requesting_user_id");

			//check if the user wanting the delete is the one who
			//created the Request.  If not, deny!
			//note: we may change this in the future to allow admin privs.
			if (deleting_user_id != user_id) {
				conn.rollback();
				return false;
			}

			//delete the request
      del_pstmt = Database_access
				.prepare_statement(conn, delete_request_sql);
			del_pstmt.setInt(1, id); 
			Database_access.execute_update(del_pstmt);

      up_pts_pstmt = Database_access
				.prepare_statement(conn, update_points_sql);
			up_pts_pstmt.setInt(1,points); 
			up_pts_pstmt.setInt(2,user_id); 
			Database_access.execute_update(up_pts_pstmt);
		} catch (SQLException ex) {
			Database_access.handle_sql_exception(ex);
			return false;
		} finally {
			Database_access.close_statement(get_pts_pstmt);
			Database_access.close_statement(del_pstmt);
			Database_access.close_statement(up_pts_pstmt);
		}
    return true;
  }

  /**
    * given all the data to add a request, does so.
    * if any parts fail, this will return false.
    * @param user_id the user's id
    * @param desc a description string, the core of the request
    * @param points the points are the currency for the request
    * @param title the short title for the request
    * @param categories the various categories for this request, 
		*  provided to us here as a single string.  
		*  Comes straight from the client, we have to parse it.
		* @return id of new request, or -1 if failed to add
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
		* array of String.
		* @return a String array of all categories
		*/
	public static String[] get_str_array_categories() {
			Map<Integer, String> categories = get_all_categories();
			java.util.Collection<String> c = categories.values();
			String[] cat_array = c.toArray(new String[0]);
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
	public static Integer[] parse_categories_string(String categories_str) {
    
		Map<Integer,String> all_categories = get_all_categories();
    
    //guard clauses
    if (all_categories == null) {return new Integer[0];}
    if (categories_str == null || 
				categories_str.length() == 0) {return new Integer[0];}

		String lower_case_categories_str = categories_str.toLowerCase();
		ArrayList<Integer> selected_categories = new ArrayList<Integer>();
		for (Integer i : all_categories.keySet()) {
    	String c = Business_logic.get_category_localized(i);
			if (lower_case_categories_str.contains(c)) {
				selected_categories.add(i);
			}
		}
    Integer[] my_array = 
			selected_categories.toArray(new Integer[selected_categories.size()]);
		return my_array;
	}


  /**
    * adds a Request to the database
		* @param request a request object
		* @return the id of the new request. -1 if not successful.  also an
		* enum that designates the error if one exists, like lacking points
    */
  private static Request_response put_request(Request request) {

		// 1. set the sql
		String update_request_sql = 
			"INSERT into request (description, datetime, points, " + 
			"status, title, requesting_user_id) VALUES (?, now(), ?, ?, ?, ?)"; 

     //assembling dynamic SQL to add categories
		StringBuilder sb = new StringBuilder("");
			sb.append("INSERT into request_to_category ")
			.append("(request_id,request_category_id) ")
			.append("VALUES (?, ?)"); 
		for (int i = 1; i < request.get_categories().length; i++) {
		 sb.append(",(?, ?)");
		}
		String update_categories_sql = sb.toString();

		String check_points_sql = "SELECT points FROM user WHERE user_id = ?";
		String update_points_sql = "UPDATE user SET points = points - ? WHERE user_id = ?";

		// 2. set up values we'll need outside the try 
		int result = -1; //default to a guard value that indicates failure
		PreparedStatement req_pstmt = null;
		PreparedStatement cat_pstmt = null;
		PreparedStatement ck_points_pstmt = null;
		PreparedStatement up_points_pstmt = null;
		Connection conn = null;
	
		try {
			//get the connection and set to not auto-commit.  Prepare the statements
			// 3. get the connection and set up a statement
			conn = Database_access.get_a_connection();
			conn.setAutoCommit(false);
      req_pstmt  = Database_access.prepare_statement(
					conn, update_request_sql);
      cat_pstmt  = Database_access.prepare_statement(
					conn, update_categories_sql);
      ck_points_pstmt  = conn.prepareStatement(check_points_sql);
      up_points_pstmt  = Database_access.prepare_statement(
					conn, update_points_sql);

			// execute a statement to check points for user
			ck_points_pstmt.setInt( 1, request.requesting_user_id);
      ResultSet resultSet = ck_points_pstmt.executeQuery();

			// check that we got results
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
				System.err.println(
						"Error(1): Transaction is being rolled back "+
						"for request_id: " + result);
				conn.rollback();
        return new Request_response(Request_response.Stat.ERROR, -1);
      }

			//get those points
      resultSet.next();
			int points = resultSet.getInt("points");

			//if the user doesn't have enough points for making this request.
			if (points < request.points) {
				conn.rollback();
        return new Request_response(Request_response.Stat.LACK_POINTS, -1);
			}

			// 4. set values into the statement
			//set values for adding request
			req_pstmt.setString(1, request.description);
			req_pstmt.setInt( 2, request.points);
			req_pstmt.setInt( 3, request.status);
			req_pstmt.setString( 4, request.title);
			req_pstmt.setInt( 5, request.requesting_user_id);

			// 5. execute a statement
			//execute one of the updates
			result = Database_access.execute_update(req_pstmt);

			// 6. check results of statement, if good, continue 
			// if bad, rollback
			//if we get a -1 for our id, the request insert didn't go through.  
			//so rollback.
			if (result < 0) {
				System.err.println(
						"Error(2):Transaction is being rolled back for request_id: " + result);
				conn.rollback();
        return new Request_response(Request_response.Stat.ERROR, -1);
			}

			// 7. set values for next statement 
			//set values for adding categories
			for (int i = 0; i < request.get_categories().length; i++ ) {
				int category_id = request.get_categories()[i];
				cat_pstmt.setInt( 2*i+1, result);
				cat_pstmt.setInt( 2*i+2, category_id);
			}

			// 8. run next statement 
			Database_access.execute_update(cat_pstmt);
			
			// 9. set values for updating points.
			up_points_pstmt.setInt(1, request.points);
			up_points_pstmt.setInt(2, request.requesting_user_id);

			// 10. update the points
			Database_access.execute_update(up_points_pstmt);

			// 11. commit 
			conn.commit();

			// 12. cleanup and exceptions
		} catch (SQLException ex) {
			Database_access.handle_sql_exception(ex);
		} finally {
			if (conn != null) {
				try {
					conn.setAutoCommit(true);
				} catch (SQLException ex) {
					Database_access.handle_sql_exception(ex);
				}
			}
			Database_access.close_statement(req_pstmt);
			Database_access.close_statement(cat_pstmt);
			Database_access.close_statement(ck_points_pstmt);
			Database_access.close_statement(up_points_pstmt);
		}
    return new Request_response(Request_response.Stat.OK, result);
  }


	/**
		* gets all the current request statuses, like OPEN, CLOSED, and TAKEN
		* @return an array of request statuses, or null if failure.
		*/
	public static Request_status[] get_request_statuses() {
		// 1. set the sql
    String sqlText = 
      "SELECT request_status_id, request_status_value FROM request_status;";

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
				System.err.println("Error(6): couldn't parse int from querystring " + qs);
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
	public static boolean set_message(String msg, int request_id, int user_id) {

		// 1. set the sql
      String sqlText = 
			"INSERT INTO request_message "+
			"(message, request_id, user_id, timestamp)"+
			"SELECT DISTINCT "+
				"CONCAT(u.first_name,' says:', ?), ?, u.user_id, now() "+
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
      pstmt.setString( 1, msg );
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
    String sqlText = "SELECT message FROM request_message WHERE request_id = ?";
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
        String msg = resultSet.getString("message");
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
		* HTML safely gets all the messages (correspondence between users) for a request.
		* @param request_id the key for the messages
		* @return a HTML-safe array of messages for this request, 
		* or empty array if failure.
		*/
	public static String[] get_messagesSafe(int request_id) {
		String[] messages = get_messages(request_id);
		String[] clean_messages = new String[messages.length];
		for (int i = 0; i < messages.length; i++) {
			clean_messages[i] = Utils.safe_render(messages[i]);
		}
		return clean_messages;
	}


	/**
		* a type solely used to set the response from putting a request
		*/
	public static class Request_response { 
		public enum Stat {
			LACK_POINTS, OK , ERROR
		}
		public final Stat s;
		public final int id;

		public Request_response(Stat s, int id) {
			this.s = s;
			this.id = id;
		}
	
	}

}
