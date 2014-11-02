package com.renomad.qarma;

import java.sql.Connection;
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
    * @return A new Statement object.
    */
  private static Statement get_a_statement_before_db_exists() throws SQLException {
    Connection conn = DriverManager.getConnection(CONNECTION_STRING_WITHOUT_DB);
    Statement stmt = conn.createStatement();
    return stmt;
  }

  /**
    * Helper to get a Statement.
    *
    * Opens a connection each time it's run.
    * @return A new Statement object.
    */
  private static Statement get_a_statement() throws SQLException {
    Connection conn = DriverManager.getConnection(CONNECTION_STRING_WITH_DB);
    Statement stmt = conn.createStatement();
    return stmt;
  }


  /**
    *A wrapper for Statement.execute_update(String sql)
    *
    * Opens and closes a connection each time it's run.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
    * @return either (1) the row count for SQL Data Manipulation 
    *  Language (DML) statements or (2) 0 for SQL statements that return nothing
    * @throws SQLException
    */
  public static int execute_update(String sqlText) {
    try (Statement stmt = get_a_statement()){
      int result = stmt.executeUpdate(sqlText);
      return result;
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }
    return 0;
  }
  

  /**
    *A wrapper for Statement.execute() - used before database exists.
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
    *A wrapper for Statement.execute()
    *
    * Opens and closes a connection each time it's run.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
    * @return true if the first result is a ResultSet object; false 
    *  if it is an update count or there are no results
    */
  public static boolean run_sql_statement(String sqlText) {
    try (Statement stmt = get_a_statement()){
      boolean result = stmt.execute(sqlText);
      return result;
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }
    return false;
  }

  public static int add_user(String username) {
      String sqlText = "INSERT INTO user (user_name) values ('dan')";
      int result = execute_update(sqlText);
      return result;
  }

}
