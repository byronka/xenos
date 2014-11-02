package com.renomad.qarma;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import com.renomad.qarma.File_utilities;

public class Database_access {

  private static String CONNECTION_STRING_WITH_DB =
        "jdbc:mysql://localhost/test?user=qarmauser&password=hictstd!";
  private static String CONNECTION_STRING_WITHOUT_DB =
        "jdbc:mysql://localhost/?user=qarmauser&password=hictstd!";

  /**
    *Boilerplate code necessary to run the java mysql connector.
    */
  public static void register_sql_driver() {
    try {
      // The newInstance() call is a work around for some
      // broken Java implementations
      Class.forName("com.mysql.jdbc.Driver").newInstance();
      //new com.mysql.jdbc.Driver();
    } catch (Exception ex) {
      // handle the error
    }
  }

  /**
    * Helper to get a Statement, using connection string without db.
    * This is used to get a statement before the database is created.
    * Opens a connection each time it's run.
    * We don't have to worry about SQL injection here, it should only be called by our own code.
    * @return A new Statement object.
    */
  private static Statement get_a_statement_before_db_exists() throws SQLException {
    Connection conn = DriverManager.getConnection(CONNECTION_STRING_WITHOUT_DB);
    Statement stmt = conn.createStatement();
    return stmt;
  }

  /**
    * Helper to get a PreparedStatement.
    *
    * Opens a connection each time it's run.
    * @return A new PreparedStatement object.
    */
  private static PreparedStatement get_a_prepared_statement(String queryText) {
    try {
      Connection conn = DriverManager.getConnection(CONNECTION_STRING_WITH_DB);
      PreparedStatement stmt = conn.prepareStatement(queryText);
      return stmt;
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }
    return null;
  }


  /**
    *A wrapper for PreparedStatement.executeUpdate(PreparedStatement pstmt)
    *
    * Opens and closes a connection each time it's run.
    * @param pstmt The prepared statement
    * @return either (1) the row count for SQL Data Manipulation 
    *  Language (DML) statements or (2) 0 for SQL statements that return nothing
    */
  public static int execute_update(PreparedStatement pstmt) {
    try {
      int result = pstmt.executeUpdate();
      return result;
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }
    return 0;
  }
  

  /**
    *A wrapper for PreparedStatement.execute() - used before database exists.
    *
    * Opens and closes a connection each time it's run.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
    * @return true if the first result is a ResultSet object; false 
    *  if it is an update count or there are no results
    */
  public static boolean run_sql_statement_before_db_exists(String sqlText) {
    try (Statement stmt = get_a_statement_before_db_exists()){
      boolean result = stmt.execute(sqlText);
      return result;
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }
    return false;
  }

  /**
    *A wrapper for PreparedStatement.execute(), used for setting up db schemas.
    *
    * Opens and closes a connection each time it's run.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
    * @return true if the first result is a ResultSet object; false 
    *  if it is an update count or there are no results
    */
  public static boolean run_sql_statement(String sqlText) {
    try (PreparedStatement stmt = get_a_prepared_statement(sqlText)){
      boolean result = stmt.execute(sqlText);
      return result;
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }
    return false;
  }

  
  /**
    *A wrapper for PreparedStatement.setString(..) so I don't have to handle exceptions
    *
    *@param pstmt the PreparedStatement to work with.
    *@param parameterIndex the indexed element in the query to replace text with.
    *@param x the sql query
    */
  public static void set_string(PreparedStatement pstmt, int parameterIndex, String x) {
    try {
      pstmt.setString(parameterIndex, x);
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }
  }

  public static int add_user(String username) {
      String sqlText = "INSERT INTO user (user_name) values (?)";
      PreparedStatement pstmt = get_a_prepared_statement(sqlText);
      set_string(pstmt, 1, username);
      int result = execute_update(pstmt);
      return result;
  }

}
