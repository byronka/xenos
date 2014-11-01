package com.renomad.qarma;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import com.renomad.qarma.File_utilities;

public class Database_access {

  /**
    *Boilerplate code necessary to run the java mysql connector.
    */
  private static void registerSqlDriver() {
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
    *A wrapper for Statement.execute()
    *
    * Opens and closes a connection each time it's run.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
    * @param connection_string The connection string we'll use to connect.
    * @return true if the first result is a ResultSet object; false 
    *  if it is an update count or there are no results
    */
  private static boolean runSqlStatement(
      String sqlText, 
      String connection_string) {
    boolean result = false;
    try {
      Connection conn = DriverManager.getConnection(connection_string);
      Statement stmt = conn.createStatement();
      result = stmt.execute(sqlText);
      conn.close();
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }
    return result;
  }


  private static void run_script_from_file_before_db_exists(String filepath) {
    String sqlText = File_utilities.get_text_from_file(filepath);
    runSqlStatement(
        sqlText,
        "jdbc:mysql://localhost/?user=qarmauser&password=hictstd!");
  }


  public static void run_script_from_file(String filepath) {
    String sqlText = File_utilities.get_text_from_file(filepath);
    runSqlStatement(
        sqlText,
        "jdbc:mysql://localhost/test?user=qarmauser&password=hictstd!");
  }


  public static void main(String[] args) {
    registerSqlDriver();
    run_script_from_file_before_db_exists(
        "/home/byron/dev/byron_qarma/db_scripts/create_database.sql");
    run_script_from_file(
        "/home/byron/dev/byron_qarma/db_scripts/create_usertable.sql");
  }
}
