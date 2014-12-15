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

public final class Database_access {

	private Database_access () {
		//we don't want anyone instantiating this
		//do nothing.
	}

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

	/**
		* this provides a {@link java.sql.Connection Connection} object.
		* The cool thing is that it tests to see whether we are in
		* testing mode, which is set by a magic property when running.
		* if it's a test, then we use a standard connection rather
		* than a connection from a pool managed by Tomcat.
		*/
	public static Connection get_a_connection() {
		Boolean in_testing = Boolean.parseBoolean(
				System.getProperty("TESTING_DATABASE_CODE_WITHOUT_TOMCAT"));
		boolean regular_usage = !in_testing;
    javax.sql.DataSource ds = null;
		Connection conn = null;

		if (regular_usage) {
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
				return ds.getConnection();
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
		return rs == null || !rs.isBeforeFirst();
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
