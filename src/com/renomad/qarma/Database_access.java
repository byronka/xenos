package com.renomad.qarma;

import java.nio.file.Paths;
import java.nio.file.Path;
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


  /**
    *This method gets used for a sole purpose - running 
    * the create database script
    */
  private static void create_database() {
    String filepath = get_db_script_full_path("create_database.sql");
    String sqlText = File_utilities.get_text_from_file(filepath);
    runSqlStatement(
        sqlText,
        "jdbc:mysql://localhost/?user=qarmauser&password=hictstd!");
  }


  /**
    *This gets used for updating the schema of the database
    */
  public static void run_script_from_file(String script_name) {
    String filepath = get_db_script_full_path(script_name);
    String sqlText = File_utilities.get_text_from_file(filepath);
    runSqlStatement(
        sqlText,
        "jdbc:mysql://localhost/test?user=qarmauser&password=hictstd!");
  }

  /**
    *Converts the script names to full path names
    */
  private static String get_db_script_full_path(String script_name) {
    //the following works because we run the 
    // program from the directory above db_scripts
    Path db_scripts = Paths.get("db_scripts").toAbsolutePath();
    String resolved_name = db_scripts.resolve(script_name).toString();
    return resolved_name;
  }


  public static void main(String[] args) {
    registerSqlDriver(); //necessary boilerplate
    create_database();
    run_script_from_file("create_usertable.sql");
  }
}
