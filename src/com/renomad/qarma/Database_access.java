package com.renomad.qarma;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import com.renomad.qarma.File_utilities;

public class Database_access {

  private static String CONNECTION_STRING_WITH_DB =
        "jdbc:mysql://localhost/test?user=root&password=hictstd!";
  private static String CONNECTION_STRING_WITHOUT_DB =
        "jdbc:mysql://localhost/?user=root&password=hictstd!";

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
      System.out.println("General exception: " + ex.toString());
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
      register_sql_driver();
      Connection conn = DriverManager.getConnection(CONNECTION_STRING_WITH_DB);
      PreparedStatement stmt = conn.prepareStatement(queryText);
      return stmt;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
    }
    return null;
  }


  /**
    *A wrapper for PreparedStatement.executeUpdate(PreparedStatement pstmt)
    *
    * Opens and closes a connection each time it's run.
    * @param pstmt The prepared statement
    * @return a ResultSet object that contains the data produced by the query; never null
    */
  public static ResultSet execute_query(PreparedStatement pstmt) {
    try {
      ResultSet result = pstmt.executeQuery();
      return result;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
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
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
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
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
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
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
    }
    return false;
  }

  
  public static int add_user(String first_name, String last_name, String email, String password) {
    //validation section
    if (first_name == null || first_name == "") {
      return 0;
    }
    if (last_name == null || last_name == "") {
      return 0;
    }
    if (email == null || email == "") {
      return 0;
    }
    if (password == null || password == "") {
      return 0;
    }

    String sqlText = "INSERT INTO user (first_name, last_name, email, password) values (?, ?, ?, ?)";
    try (PreparedStatement pstmt = get_a_prepared_statement(sqlText)){
      pstmt.setString(1, first_name);
      pstmt.setString(2, last_name);
      pstmt.setString(3, email);
      pstmt.setString(4, password);
      int result = execute_update(pstmt);
      return result;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
    }
    return 0; //if complete failure, return that we got 0.
  }

  
  public static String[] get_all_users() {
    String sqlText = "SELECT * FROM user";
    ArrayList<String> results = new ArrayList<String>();
    try (PreparedStatement pstmt = get_a_prepared_statement(sqlText)) {
      ResultSet resultSet = execute_query(pstmt);

      if (resultSet == null) {
        return new String[]{"no users found"};
      }

      for(;resultSet.next() == true;) {
        results.add(resultSet.getNString("user_name"));
      }
      String[] array_of_users = 
        results.toArray(new String[results.size()]);
      return array_of_users;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
    }
    return new String[]{"Errors during loading of users."};
  }
  

  /**
    * checks the password based on the email, the user's unique key
    *
    * @returns true if the password is correct for that email.
    */
  public static boolean check_login(String email, String password) {
    //validation section
    if (email == null || email == "") {
      return false;
    }
    if (password == null || password == "") {
      return false;
    }

    String sqlText = "SELECT password FROM user WHERE email = ?";

    try (PreparedStatement pstmt = get_a_prepared_statement(sqlText)){
      pstmt.setString(1, email);
      ResultSet resultSet = execute_query(pstmt);

      if (resultSet == null) {
        return false; //no user found with that email.
      }

      resultSet.next(); //move to the first set of results.
      if (resultSet.next()) {
        throw new Exception("somehow there is more than one email of " + email);
      }

      if (resultSet.getNString("password").equals(password)) {
        return true; //success!
      }

    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
    }
    return false; //if complete failure, return that we got 0.
  }


  /**
    * provides a few boilerplate println's for sql exceptions
    */
  private static void handle_sql_exception(SQLException ex) {
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
  }

}
