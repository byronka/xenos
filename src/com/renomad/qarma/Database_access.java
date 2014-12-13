package com.renomad.qarma;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.Arrays;
import java.io.File;
import java.io.FileNotFoundException;
import com.renomad.qarma.Business_logic.Request;
import com.renomad.qarma.Business_logic.Request_status;

public class Database_access {


  // ******************************
  // BUSINESS LOGIC CODE          *
  // ******************************

  /**
    * adds a Request to the database
		* @param request a request object
    * @return the id of the new request. -1 if not successful.
    */
  public static int add_request(Request request) {

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
			conn = get_a_connection();
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
			result = execute_update(req_pstmt);

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
			execute_update(cat_pstmt);

			// 9. commit 
			conn.commit();

			// 10. cleanup and exceptions
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		} finally {
			if (conn != null) {
				try {
					conn.setAutoCommit(true);
				} catch (SQLException ex) {
					handle_sql_exception(ex);
				}
			}
			close_statement(req_pstmt);
			close_statement(cat_pstmt);
		}
    return result;
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
			Connection conn = get_a_connection();
      pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);

			// 4. execute a statement
      ResultSet resultSet = pstmt.executeQuery();;

			// 5. check that we got results
      if (resultset_is_null_or_empty(resultSet)) {
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
			handle_sql_exception(ex);
			return null;
    } finally {
      close_statement(pstmt);
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


	/**
		* returns a Map of localized categories, indexed by database id.
		* @return Map of strings, indexed by id, or null if nothing in db.
		*/
	public static Map<Integer,String> get_all_categories() {
		// 1. set the sql
    String sqlText = 
			"SELECT request_category_id FROM request_category; ";
		// 2. set up values we'll need outside the try
		PreparedStatement pstmt = null;
    try {
			// 3. get the connection and set up a statement
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
			// 4. execute a statement
      ResultSet resultSet = pstmt.executeQuery();;
			// 5. check that we got results
      if (resultset_is_null_or_empty(resultSet)) {
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
			handle_sql_exception(ex);
			return null;
    } finally {
      close_statement(pstmt);
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
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, request_id);
      ResultSet resultSet = pstmt.executeQuery();;
      if (resultset_is_null_or_empty(resultSet)) {
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
			handle_sql_exception(ex);
			return null;
    } finally {
      close_statement(pstmt);
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
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, request_id);
      ResultSet resultSet = pstmt.executeQuery();;
      if (resultset_is_null_or_empty(resultSet)) {
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
			handle_sql_exception(ex);
			return null;
    } finally {
      close_statement(pstmt);
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
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();;
      if (resultset_is_null_or_empty(resultSet)) {
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
			handle_sql_exception(ex);
			return null;
    } finally {
      close_statement(pstmt);
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
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();;
      if (resultset_is_null_or_empty(resultSet)) {
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
			handle_sql_exception(ex);
			return null;
    } finally {
      close_statement(pstmt);
    }
  }


  public static boolean add_user(
			String first_name, String last_name, String email, String password) {
    //validation section

		// 1. set the sql
      String sqlText = 
        "INSERT INTO user (first_name, last_name, email, password) " +
        "VALUES (?, ?, ?, ?)";
		// 2. set up values we'll need outside the try
		boolean result = false;
		PreparedStatement pstmt = null;
    try {
			// 3. get the connection and set up a statement
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
			// 4. set values into the statement
      pstmt.setString( 1, first_name);
      pstmt.setString( 2, last_name);
      pstmt.setString( 3, email);
      pstmt.setString( 4, password);
			// 5. execute a statement
      result = execute_update(pstmt) > 0;
			// 10. cleanup and exceptions
			return result;
		} catch (SQLException ex) {
			handle_sql_exception(ex);
			return false;
    } finally {
      close_statement(pstmt);
    }
  }

  
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
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
			pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();;
      if (resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next(); //move to the first set of results.
      String display_name = resultSet.getNString("user_displayname");
      return display_name;
		} catch (SQLException ex) {
			handle_sql_exception(ex);
			return null;
    } finally {
      close_statement(pstmt);
    }
  }

	
  // ******************************
  // SECURITY CODE                *
  // ******************************


  /**
    * Checks the database, given the user id, whether that
    * user is logged in
    */
  public static boolean user_is_logged_in(int user_id) {
    String sqlText = "SELECT is_logged_in FROM user WHERE user_id = ?";
		PreparedStatement pstmt = null;
    try {
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();;

      if(resultset_is_null_or_empty(resultSet)) {
        return false; // no results on query - return not logged in
      }

      resultSet.next(); //move to the first set of results.
      return resultSet.getBoolean("is_logged_in");
		} catch (SQLException ex) {
			handle_sql_exception(ex);
			return false;
    } finally {
      close_statement(pstmt);
    }

  }

  /**
    * simply sets "is_logged_in" to false in the database for the given user.
    * @param user_id the user in question to set logged_in to false.
    * @return a boolean on whether the operation succeeded.
    */
  public static boolean set_user_not_logged_in(int user_id) {
    String sqlText = "UPDATE user SET is_logged_in = false;";
		boolean is_successful = false;
		PreparedStatement pstmt = null;
    try {
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      is_successful = execute_update(pstmt) > 0;
      return is_successful;
		} catch (SQLException ex) {
			handle_sql_exception(ex);
			return false;
    } finally {
      close_statement(pstmt);
    }
  }


  /**
    * checks the password based on the email, the user's unique key
    *
    * @return the user id if the password is correct for that email.
    */
  public static int check_login(String email, String password) {
    String sqlText = "SELECT password,user_id FROM user WHERE email = ?";
		PreparedStatement pstmt = null;
    try {
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setString( 1, email);
      ResultSet resultSet = pstmt.executeQuery();;

      if(resultset_is_null_or_empty(resultSet)) {
        return 0; // no results on query - return user "0";
      }

      resultSet.next(); //move to the first set of results.

      if (resultSet.getNString("password").equals(password)) {
        return resultSet.getInt("user_id"); //success!
      }
      return 0; //password was bad - return user "0"
		} catch (SQLException ex) {
			handle_sql_exception(ex);
			return 0;
    } finally {
      close_statement(pstmt);
    }
  }


  /**
    * stores information on the user when they login, things like
    * their ip, time they logged in, that they are in fact logged in,
    * etc.
    *
    * @param user_id the user's id, an int.
    * @param ip the user's ip.
    */
  public static void 
    register_details_on_user_login(int user_id, String ip) {

      String sqlText = 
        "UPDATE user " + 
        "SET is_logged_in = 1, last_time_logged_in = NOW(), " + 
        "last_ip_logged_in = ? " + 
        "WHERE user_id = ?";

			PreparedStatement pstmt = null;
			try {
				Connection conn = get_a_connection();
				pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
        pstmt.setString( 1, ip);
        pstmt.setInt( 2, user_id);
        execute_update(pstmt);
			} catch (SQLException ex) {
				handle_sql_exception(ex);
      } finally {
        close_statement(pstmt);
      }
  }


  // ******************************
  // HELPERS AND BOILERPLATE CODE *
  // ******************************


  /**
		* this overload of the method will also rollback commits.
    */
  private static void handle_sql_exception(SQLException ex, Statement stmt) {
		try {
			Connection conn = stmt.getConnection();
			if (conn != null) {
				System.err.print("Transaction is being rolled back");
				conn.rollback();
			}
		} catch(SQLException excep) {
			handle_sql_exception(excep); //inner exception
		} finally {
			handle_sql_exception(ex);  //exception from parameter list
		}
	}


  /**
    * provides a few boilerplate println's for sql exceptions
    */
  private static void handle_sql_exception(SQLException ex) {
    System.err.println("SQLException: " + ex.getMessage());
    System.err.println("SQLState: " + ex.getSQLState());
    System.err.println("VendorError: " + ex.getErrorCode());
    System.err.println("Stacktrace: ");
    Thread.currentThread().dumpStack();
  }

	private static Connection get_a_connection() {
		Boolean in_testing = Boolean.parseBoolean(
				System.getProperty("TESTING_DATABASE_CODE_WITHOUT_TOMCAT"));
    javax.sql.DataSource ds = null;
		Connection conn = null;

		if (!in_testing) {
			//this is the normal place for getting connections if coming from a web server.
			ds = get_a_datasource();
			conn = get_a_connection(ds);
		} else {
    	//if this is set, we might be coming from Junit and don't want
			//to use connection pools from tomcat
			try {
				// The newInstance() call is a work around for some
				// broken Java implementations
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				//new com.mysql.jdbc.Driver();
				conn = DriverManager.getConnection(
						System.getProperty("CONNECTION_STRING_WITH_DB"));
			} catch (SQLException ex) {
				handle_sql_exception(ex);
			} catch (Exception ex) {
				System.err.println("General exception: " + ex.toString());
			}
		}

		return conn;
	}


	/**
		* Helper to get a connection.  This is to be used for cases
		* where you need to run multiple statements on a single connection.
		* @return a connection set up for multiple statements in transaction.
		*/
	private static Connection get_a_connection(javax.sql.DataSource ds) {
		try { 
			if (ds != null) {
				Connection conn = ds.getConnection();
				return conn;
			}
		} catch (SQLException ex) {
    	handle_sql_exception(ex);
		}
		return null; //if we hit an exception.
	}

	/**
		* Helper to get a datasource which will give us a Connection
		* from the connection pool.  Tomcat handles this, mostly.  We use
		* the lookup service to find the datasource, it is configured
		* in WEB-INF and META-INF
		* @return a hot spanking datasource.  Use this to get a connection.
		*/
	private static javax.sql.DataSource get_a_datasource() {
    javax.sql.DataSource ds = null;
    try {
      javax.naming.Context initContext = 
				new javax.naming.InitialContext();
      javax.naming.Context envContext  = 
				(javax.naming.Context)initContext.lookup("java:/comp/env");
      ds = (javax.sql.DataSource)envContext.lookup("jdbc/qarma_db");
    } catch (javax.naming.NamingException e) {
      System.err.println("a naming exception occurred.  details: ");
      System.err.println(e);
    }
		return ds;
	}


  /**
    *A wrapper for PreparedStatement.executeUpdate(PreparedStatement pstmt)
    *
    * Opens and closes a connection each time it's run.
    * @param pstmt The prepared statement
    * @return an integer that represents the new or updated id.
    */
  private static int execute_update(PreparedStatement pstmt) throws SQLException {
		int id = -1; // -1 means no key was generated.
		pstmt.executeUpdate();
		ResultSet rs = pstmt.getGeneratedKeys();
		if(!resultset_is_null_or_empty(rs)) {
			rs.next();
			id = rs.getInt(1);
		}
    return id;
  }
  


  /**
    * helper method to check whether a newly-returned result set is
    * null or empty.  Note, this has to be run before any data is
    * retrieved from the result set.  Also note that the method
    * isBeforeFirst() returns false if there are no rows of data.
    * @param rs the result set we are checking
    * @return true if the result set is null or has no data.
    */
  private static boolean resultset_is_null_or_empty(ResultSet rs) throws SQLException {
		return (rs == null || !rs.isBeforeFirst());
  }


	/**
		* Wrapper around PreparedStatement.close() to avoid having to
		* litter my code with try-catch and to close things in the proper order.
		*/
	private static void close_statement(Statement s) {
		try {
      Connection c = null;
      if (s != null && !s.isClosed()) {
        c = s.getConnection();
        s.close();
      }
			if (c != null && !c.isClosed()) {
        c.close();
			}
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		}
	}


}
