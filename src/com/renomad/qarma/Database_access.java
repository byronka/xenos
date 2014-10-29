package com.renomad.qarma;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.File;

public class Database_access {

  public static String getTextFromFile(String filepath) {
    FileReader fr = null;
    File file = new File(filepath);
    long length_of_array = file.length();
    char[] buffer = new char[(int)length_of_array+1];
    try {
      fr = new FileReader(filepath);
      fr.read(buffer);
      fr.close();
    } catch (FileNotFoundException e) {
      //handle the error
    } catch (IOException e) {
      //handle
    } catch (Exception e) {
      //handle
    }
     return new String(buffer);
  }

  public static void registerSqlDriver() {
    try {
      // The newInstance() call is a work around for some
      // broken Java implementations
      Class.forName("com.mysql.jdbc.Driver").newInstance();
      //new com.mysql.jdbc.Driver();
    } catch (Exception ex) {
      // handle the error
    }
  }

  public static void runSqlStatement(String sqlText, String connection_string) {
    try {
      Connection conn = DriverManager.getConnection(connection_string);
      Statement stmt = conn.createStatement();
      stmt.execute(sqlText);
      conn.close();
    } catch (SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }
  }

  public static void run_script_before_db_exists(String filepath) {
    String sqlText = getTextFromFile(filepath);
    runSqlStatement(sqlText,"jdbc:mysql://localhost/?user=qarmauser&password=hictstd!");
  }

  public static void run_script(String filepath) {
    String sqlText = getTextFromFile(filepath);
    runSqlStatement(sqlText,"jdbc:mysql://localhost/test?user=qarmauser&password=hictstd!");
  }

  public static void main(String[] args) {
    registerSqlDriver();
    run_script_before_db_exists("/home/byron/dev/byron_qarma/db_scripts/create_database.sql");
    run_script("/home/byron/dev/byron_qarma/db_scripts/create_usertable.sql");
  }
}
