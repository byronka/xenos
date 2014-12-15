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
    */
  public static boolean set_user_not_logged_in(int user_id) {
    String sqlText = "UPDATE user SET is_logged_in = false;";
		PreparedStatement pstmt = null;
    try {
			Connection conn = get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
		} catch (SQLException ex) {
			handle_sql_exception(ex);
			return false; //if a failure occurred.
    } finally {
      close_statement(pstmt);
    }
		return true;
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
  public static void handle_sql_exception(SQLException ex, Statement stmt) {
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
  public static void handle_sql_exception(SQLException ex) {
    System.err.println("SQLException: " + ex.getMessage());
    System.err.println("SQLState: " + ex.getSQLState());
    System.err.println("VendorError: " + ex.getErrorCode());
    System.err.println("Stacktrace: ");
    Thread.currentThread().dumpStack();
  }

	public static Connection get_a_connection() {
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
  public static int execute_update(PreparedStatement pstmt) throws SQLException {
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
  public static boolean resultset_is_null_or_empty(ResultSet rs) throws SQLException {
		return (rs == null || !rs.isBeforeFirst());
  }


	/**
		* Wrapper around PreparedStatement.close() to avoid having to
		* litter my code with try-catch and to close things in the proper order.
		*/
	public static void close_statement(Statement s) {
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
