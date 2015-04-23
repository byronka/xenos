package com.renomad.xenos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;

/**
  * This class provides general utilities for access to the database.
  */
public final class Database_access {

  private Database_access () {
    //we don't want anyone instantiating this
    //do nothing.
  }


  /**
    * provides a few boilerplate println's for sql exceptions
    */
  public static void handle_sql_exception(SQLException ex) {
    System.err.println("SQLException: " + ex.getMessage());
    System.err.println("SQLState: " + ex.getSQLState());
    System.err.println("VendorError: " + ex.getErrorCode());
    System.err.println("Stacktrace: ");
    Thread.dumpStack();
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
      //this is the normal place for getting connections if 
      //coming from a web server.
      ds = get_a_datasource();
      conn = get_a_connection(ds);
    } else {
      System.out.println("we are skipping Tomcat connections");
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
    * Helper to get a connection.  
    */
  private static Connection get_a_connection(javax.sql.DataSource ds) {
    try { 
      if (ds != null) {
        Connection con = ds.getConnection();
        return con;
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
      ds = (javax.sql.DataSource)envContext.lookup("jdbc/xenos_db");
    } catch (javax.naming.NamingException e) {
      System.err.println("a naming exception occurred.  details: ");
      System.err.println(e);
    }
    return ds;
  }


  /**
    * a helper method to avoid some of the boilerplate.
    */
  public static PreparedStatement 
    prepare_statement(Connection conn, String sqlText) 
    throws SQLException {
      return conn.prepareStatement(
          sqlText, Statement.RETURN_GENERATED_KEYS);
  }

  /**
    * helper method to check whether a newly-returned result set is
    * null or empty.  Note, this has to be run before any data is
    * retrieved from the result set.  Also note that the method
    * isBeforeFirst() returns false if there are no rows of data.
    * @param rs the result set we are checking
    * @return true if the result set is null or has no data.
    */
  public static boolean 
    resultset_is_null_or_empty(ResultSet rs) throws SQLException {
    return rs == null || !rs.isBeforeFirst();
  }


  /**
    * Wrapper around ResultSet.close() to avoid having to
    * litter my code with try-catch
    */
  public static void close_resultset(ResultSet rs) {
    try {
      if (rs != null && !rs.isClosed()) {
        rs.close();
        rs = null;
      }
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    }
  }


  /**
    * Wrapper around Statement.close() to avoid having to
    * litter my code with try-catch
    */
  public static void close_statement(Statement s) {
    try {
      if (s != null && !s.isClosed()) {
        s.close();
        s = null;
      }
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    }
  }


  /**
    * closes a connection if it exists, relieving need for boilerplate
    */
  public static void close_connection(Connection c) {
    try {
      if (c != null && !c.isClosed()) {
        c.close();
        c = null;
      }
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    }
  }



}
