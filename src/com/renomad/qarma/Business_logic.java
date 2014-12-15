package com.renomad.qarma;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import com.renomad.qarma.Database_access;
import com.renomad.qarma.Utils;

import java.sql.Statement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;


public class Business_logic {


  /**
    * gets a name for display from the user table
    *
    * @return a string displaying first name, last name, email, or
		* null if not found.
    */
  public static String get_user_displayname(int user_id) {
    String sqlText = "SELECT CONCAT(first_name, ' ',last_name"+
			",' (', email,')') as user_displayname "+
			"FROM user "+
			"WHERE user_id = ?;";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
			pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();;
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next(); //move to the first set of results.
      String display_name = resultSet.getNString("user_displayname");
      return display_name;
		} catch (SQLException ex) {
			Database_access.handle_sql_exception(ex);
			return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }

	public static String get_category_localized(int category_id) {
		//for now, there is no localization file, so we'll just include
		//the English here.

			switch(category_id) {
				case 1:
					return "math";
				case 2:
					return "physics";
				case 3:
					return "economics";
				case 4:
					return "history";
				case 5:
					return "english";
				default:
					return "ERROR";
			}
		}

	public static String[] get_str_array_categories() {
			Map<Integer, String> categories = get_all_categories();
			java.util.Collection<String> c = categories.values();
			String[] cat_array = c.toArray(new String[0]);
      return cat_array;
	}


	/**
		* returns a Map of localized categories, indexed by database id.
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
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
			// 4. execute a statement
      ResultSet resultSet = pstmt.executeQuery();;
			// 5. check that we got results
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

			// 6. get values from database and convert to an object
			//keep adding rows of data while there is more data
      Map<Integer, String> categories = new HashMap<Integer,String>();
      while(resultSet.next()) {
        int rcid = resultSet.getInt("request_category_id");
				String category = get_category_localized(rcid);
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
		* gets an array of categories for a given request
		*
		*@return an array of Strings, representing the categories, or null if failure.
		*/
	public static Integer[] get_categories_for_request(int request_id) {
    String sqlText = 
			"SELECT request_category_id "+
				"FROM request_to_category "+
				"WHERE request_id = ?;";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, request_id);
      ResultSet resultSet = pstmt.executeQuery();;
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
    * Gets a specific Request for the user.
    * 
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
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, request_id);
      ResultSet resultSet = pstmt.executeQuery();;
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
    * @return an array of Request
    */
  public static Request[] get_all_requests_except_for_user(int user_id) {
    String sqlText = "SELECT * FROM request WHERE requesting_user_id <> ?";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();;
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Request[0];
      }

			//keep adding rows of data while there is more data
      ArrayList<Request> requests = new ArrayList<Request>();
      for(;resultSet.next() == true;) {
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
    * @return an array of Request
    */
  public static Request[] get_requests_for_user(int user_id) {
    String sqlText = "SELECT * FROM request WHERE requesting_user_id = ?";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();;
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Request[0];
      }

			//keep adding rows of data while there is more data
      ArrayList<Request> requests = new ArrayList<Request>();
      for(;resultSet.next() == true;) {
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
    * given all the data to add a request, does so.
    * if any parts fail, this will return false.
    * @param user_id the user's id
    * @param desc a description string, the core of the request
    * @param status look in the database for request status.  e.g. open, closed, taken
    * @param points the points are the currency for the request
    * @param title the short title for the request
    * @param categories the various categories for this request, 
		*  provided to us here as a single string.  
		*  Comes straight from the client, we have to parse it.
    */
  public static void put_request(
      int user_id, String desc, int points, 
			String title, Integer[] categories) {

    String date = Utils.getCurrentDateSqlFormat();

		//set up a request object to store this stuff
		int status = 1; //always starts open
		Request request = new Request(
				-1, date, desc, points, status, title, user_id, categories);

    //send parsed data to the database
    int new_request_id = put_request(request);

    if (new_request_id == -1) {
      System.err.println(
          "error adding request at Business_logic.put_request()");
    }

  }



  /**
    * adds a Request to the database
		* @param request a request object
    * @return the id of the new request. -1 if not successful.
    */
  public static int put_request(Request request) {

		// 1. set the sql
		String update_request_sql = 
			"INSERT into request (description, datetime, points, " + 
			"status, title, requesting_user_id) VALUES (?, ?, ?, ?, ?, ?)"; 

     //assembling dynamic SQL to add categories
		String update_categories_sql = 
			"INSERT into request_to_category "+
			"(request_id,request_category_id) "+
			"VALUES (?, ?)"; 
		for (int i = 1; i < request.categories.length; i++) {
		 update_categories_sql += ",(?, ?)";
		}

		// 2. set up values we'll need outside the try 
		int result = -1; //default to a guard value that indicates failure
		PreparedStatement req_pstmt = null;
		PreparedStatement cat_pstmt = null;
		Connection conn = null;
	
		try {
			//get the connection and set to not auto-commit.  Prepare the statements
			// 3. get the connection and set up a statement
			conn = Database_access.get_a_connection();
			conn.setAutoCommit(false);
      req_pstmt  = conn.prepareStatement(
					update_request_sql, Statement.RETURN_GENERATED_KEYS);
      cat_pstmt  = conn.prepareStatement(
					update_categories_sql, Statement.RETURN_GENERATED_KEYS);

			// 4. set values into the statement
			//set values for adding request
			req_pstmt.setString(1, request.description);
			req_pstmt.setString( 2, request.datetime);
			req_pstmt.setInt( 3, request.points);
			req_pstmt.setInt( 4, request.status);
			req_pstmt.setString( 5, request.title);
			req_pstmt.setInt( 6, request.requesting_user_id);

			// 5. execute a statement
			//execute one of the updates
			result = Database_access.execute_update(req_pstmt);

			// 6. check results of statement, if good, continue 
			// if bad, rollback
			//if we get a -1 for our id, the request insert didn't go through.  
			//so rollback.
			if (result < 0) {
				System.err.println(
						"Transaction is being rolled back for request_id: " + result);
				conn.rollback();
				return -1;
			}

			// 7. set values for next statement 
			//set values for adding categories
			for (int i = 0; i < request.categories.length; i++ ) {
				int category_id = request.categories[i];
				cat_pstmt.setInt( 2*i+1, result);
				cat_pstmt.setInt( 2*i+2, category_id);
			}

			// 8. run next statement 
			Database_access.execute_update(cat_pstmt);

			// 9. commit 
			conn.commit();

			// 10. cleanup and exceptions
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
		}
    return result;
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
    	String c = get_category_localized(i);
			if (lower_case_categories_str.contains(c)) {
				selected_categories.add(i);
			}
		}
    Integer[] my_array = 
			selected_categories.toArray(new Integer[selected_categories.size()]);
		return my_array;
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
    Request r = get_a_request(request_id);
		if (r == null) {
			return new Request(0,"","",0,1,"",0);
		}
		return r;
  }


  /**
    * adds a user.  if successful, returns true
    */
  public static boolean put_user(
			String first_name, String last_name, String email, String password) {
      Utils.null_or_empty_string_validation(first_name);
      Utils.null_or_empty_string_validation(last_name);
      Utils.null_or_empty_string_validation(email);
      Utils.null_or_empty_string_validation(password);
			User u = new User(first_name, last_name, email, password);
    return put_user(u);
  }


  public static boolean put_user(User user) {

		// 1. set the sql
      String sqlText = 
        "INSERT INTO user (first_name, last_name, email, password) " +
        "VALUES (?, ?, ?, ?)";
		// 2. set up values we'll need outside the try
		boolean result = false;
		PreparedStatement pstmt = null;
    try {
			// 3. get the connection and set up a statement
			Connection conn = Database_access.get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
			// 4. set values into the statement
      pstmt.setString( 1, user.first_name);
      pstmt.setString( 2, user.last_name);
      pstmt.setString( 3, user.email);
      pstmt.setString( 4, user.password);
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
      pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);

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
    * Request_status is the enumeration of request statuses.  
		* It is an immutable object.
    * note that the fields are public, but final.  Once this object
    * gets constructed, there is no changing it.  You have to create a
    * new one.
    */
  public static class Request_status {

    public Request_status ( int status_id, String status_value) {
      this.status_id       =  status_id;
      this.status_value    =  status_value;
    }

    public final int status_id;
    public final String status_value;

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
    * User encapsulates the core traits of a user.  It is an immutable object.
    * note that the fields are public, but final.  Once this object
    * gets constructed, there is no changing it.  You have to create a
    * new one.
    */
	public static class User {

		public User (String first_name, String last_name, String email, String password) {
			this.first_name = first_name;
			this.last_name = last_name;
			this.email = email;
			this.password = password;
		}
		public final String first_name;
		public final String last_name;
		public final String email;
		public final String password;
	}

  /**
    * Request encapsulates a user's request.  It is an immutable object.
    * note that the fields are public, but final.  Once this object
    * gets constructed, there is no changing it.  You have to create a
    * new one.
    */
  public static class Request {

    public Request ( int request_id, String datetime, String description, 
        int points, int status, String title, int requesting_user_id) {
			this(request_id, datetime, description, points,
					status, title, requesting_user_id, new Integer[0]);
		}

    public Request ( int request_id, String datetime, String description, 
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
    public final int status;
    public final String title;
    public final int requesting_user_id;
		public final Integer[] categories;


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

		public String get_categories() {
			String cat_string = "";
			for (Integer c : categories) {
				cat_string += get_category_localized(c);
				cat_string += ", ";
			}
			return cat_string;
		}
  }



}
