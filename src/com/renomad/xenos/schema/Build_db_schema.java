package com.renomad.xenos.schema;

import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

/**
  * Note that because of the way this class obtains its
  * database connection, it is necessary to entirely distance
  * itself from the available methods in Database_access.  That
  * is the reason why you see so much duplication in methods
  * between this class and that one.  They are similar, except
  * that this one uses its own driver rather than relying on
  * the container.
  */
public final class Build_db_schema {

  private Build_db_schema () {
    //we don't want anyone instantiating this
    //do nothing.
  }

  /**
    *Boilerplate code necessary to register the mysql db driver.
    */
  static {
    try {
      // The newInstance() call is a work around for some
      // broken Java implementations
      Class.forName("com.mysql.jdbc.Driver").newInstance();
      //new com.mysql.jdbc.Driver();
    } catch (Exception ex) {
      System.err.println("General exception: " + ex.toString());
    }
  }


  /**
    * Helper to get a Statement, using connection string without db.
    * This is used to get a statement before the database is created.
    * Opens a connection each time it's run.
    * We don't have to worry about SQL injection here, 
    * it should only be called by our own code.
    * @return A new Statement object.
    */
  private static Statement 
    get_a_statement_before_db_exists() throws SQLException {
    Connection conn = 
      DriverManager.getConnection(System.getProperty("CONNECTION_STRING_WITHOUT_DB"));
    Statement stmt = conn.createStatement();
    return stmt;
  }


  public static void main(String[] args) {
    int version = -1;
    try {
      version = get_db_version();
    } catch (SQLException ex) {
      create_database(); //will create the db and set version to 0
      version = 0;
    }
    if (version == 0) { run("db_scripts/v1_setup.sql"); }
  }

  private static void run(String sql) {
      run_multiple_statements(sql);
  }


  public static int get_db_version() throws SQLException {
    String sqlText = "Select config_value FROM config " +
                    "WHERE config_item = 'db_version'";
    Statement stmt = null;
    try {
      stmt = get_a_statement();
      ResultSet resultSet = stmt.executeQuery(sqlText);
      if (resultset_is_null_or_empty(resultSet)) {
        return -1; //an out-of-bounds value
      }

      result_set_next(resultSet);
      int v = get_integer(resultSet,  "config_value");
      return v;
    } finally {
      close_statement(stmt);
    }
  }

  /**
    * Wrapper around ResultSet.getInt(String columnName)
    * We'll wrap these methods that throw SQLException
    * so we don't have to worry about it any  more
    */
  private static Integer get_integer(ResultSet rs, String columnName) {
    try {
      return rs.getInt(columnName);
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    }
    return null;
  }

  /**
    * Wrapper around ResultSet.next() to avoid
    * littering my code with try-next
    */


  private static boolean result_set_next(ResultSet  rs) {
    try {
      return rs.next();
    } catch(SQLException ex) {
      handle_sql_exception(ex);
    } 
    return false;
  }
  /**
    * Helper to get a Statement
    * Opens a connection each time it's run.
    * We don't have to worry about SQL injection here, 
    * it should only be called by our own code.
    * @return A new Statement object.
    */
  private static Statement get_a_statement() throws SQLException {
    Connection conn = 
      DriverManager.getConnection(System.getProperty("CONNECTION_STRING_WITH_DB"));
    Statement stmt = conn.createStatement();
    return stmt;
  }

  private static void create_database() {
    //create the database
      run_sql_statement_before_db_exists(
				"CREATE DATABASE xenos_database " +
				"DEFAULT CHARACTER SET utf8 " + 
				"COLLATE utf8_general_ci " +
				"DEFAULT COLLATE utf8_general_ci; ");

    //create the config table
      run_sql_statement(
        "CREATE TABLE config "+
				"(config_item VARCHAR(200), config_value VARCHAR(200));");

    //set the version to 0
      run_sql_statement(
        "INSERT config "+
				"(config_item, config_value) values ('db_version', '0');");
  }

  /**
    *A wrapper for PreparedStatement.execute(), 
    * used for setting up db schemas.
    *
    * Opens and closes a connection each time it's run.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
    * @return true if the first result is a ResultSet object; false 
    *  if it is an update count or there are no results
    */
  public static boolean run_sql_statement(String sqlText) {
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    boolean result = execute_prepared_statement(pstmt, sqlText);
    return result;
  }

  public static void run_multiple_statements(String file) {
    Statement stmt = null;
    try (Scanner s = new Scanner(new File(file), "UTF-8")) {
      stmt = get_a_statement();
      s.useDelimiter("---DELIMITER---");
      while(s.hasNext()) {
        String next_statement = s.next();
        execute_statement(
            next_statement, stmt);
      }
    } catch (FileNotFoundException ex) {
      System.err.println(ex);
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } finally {
      close_statement(stmt);
    }
  }



  /**
    *A wrapper for Statement.execute, and running statements 
    * that have not come
    * from the user, so we don't have to worry about SQL Injection.
    *
    * Note: does not close connection.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
    * @param stmt the statement
    * @return true if the first result is a ResultSet object; false 
    *  if it is an update count or there are no results
    */
  public static boolean execute_statement(String sqlText, Statement stmt) {
    boolean result = false;
    try {
      result = stmt.execute(sqlText);
    }  catch (SQLException ex) {
      handle_sql_exception(ex);
    }
    return result;
  }


  /**
    * Helper to get a PreparedStatement.
    *
    * Opens a connection each time it's run.
    * @return A new PreparedStatement object.
    */
  private static PreparedStatement 
    get_a_prepared_statement(String queryText) {
    try {
      Connection conn = DriverManager.getConnection(System.getProperty("CONNECTION_STRING_WITH_DB"));
      PreparedStatement stmt = conn.prepareStatement(queryText);
      return stmt;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.err.println("General exception: " + ex.toString());
    } 
    return null;
  }
  

  /**
    * This method sets you up to call stored procedures in the database.
    * example: you might call this with a string 
    * of "{call blahdy_blahblah(?)}"; ,using JDBC escape syntax
    * @param procedure_name the name of a procedure we've 
    *  already added.  See the database
    * @return A callable statement ready for setting parameters.
    */
  private static CallableStatement get_a_callable_statement(String proc) {
    try {
      Connection conn = DriverManager.getConnection(System.getProperty("CONNECTION_STRING_WITH_DB"));
      CallableStatement cs = conn.prepareCall(proc);
      return cs;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.err.println("General exception: " + ex.toString());
    }
    return null;
  }


  /**
    *A wrapper for CallableStatement.execute()
    *
    * Opens and closes a connection each time it's run.
    * @return a boolean for success.
    */
  private static boolean execute(CallableStatement cs) {
    try {
      boolean result = cs.execute();
      return result;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.err.println("General exception: " + ex.toString());
    }
    return false;
  }


  /**
    *A wrapper for PreparedStatement.executeUpdate(PreparedStatement pstmt)
    *
    * Opens and closes a connection each time it's run.
    * @param pstmt The prepared statement
    * @return a ResultSet object that contains the data 
    * produced by the query
    */
  private static ResultSet execute_query(PreparedStatement pstmt) {
    try {
      ResultSet result = pstmt.executeQuery();
      return result;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.err.println("General exception: " + ex.toString());
    }
    return null;
  }


  /**
    *A wrapper for PreparedStatement.executeUpdate(PreparedStatement pstmt)
    *
    * Opens and closes a connection each time it's run.
    * @param pstmt The prepared statement
    * @return a boolean indicating whether this succeeded.  If it
    * hits an exception, that's when we return false.  if success, true.
    */
  private static boolean execute_update(PreparedStatement pstmt) {
    try {
      pstmt.executeUpdate();
    } catch (SQLException ex) {
      handle_sql_exception(ex);
      return false;
    } catch (Exception ex) {
      System.err.println("General exception: " + ex.toString());
      return false;
    }
    return true;
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


  /**
    * helper method to check whether a newly-returned result set is
    * null or empty.  Note, this has to be run before any data is
    * retrieved from the result set.  Also note that the method
    * isBeforeFirst() returns false if there are no rows of data.
    * @param rs the result set we are checking
    * @return true if the result set is null or has no data.
    */
  private static boolean resultset_is_null_or_empty(ResultSet rs) {
    try {
      return (rs == null || !rs.isBeforeFirst());
    } catch (SQLException ex) {
      System.err.println("ResultSet was null or empty");
      handle_sql_exception(ex);
    }
    return true; //true, because if something crashed here, the
                //result set may as well be empty
  }





  /**
    * Wrapper around PreparedStatement.execute(String text)
    * to avoid littering my code with try-catch
    */
  private static boolean execute_prepared_statement(
      PreparedStatement ps, String sqlText) {
    try {
      return ps.execute(sqlText);
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } finally {
      close_statement(ps);
    }
    return false;
  }


  /**
    * Wrapper around PreparedStatement.close() to avoid having to
    * litter my code with try-catch
    */
  private static void close_statement(Statement s) {
    try {
      Connection c = null;
      if (s != null && !s.isClosed()) {
        c = s.getConnection();
        s.close();
      }
      close_connection_with_commit(c);
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    }
  }

  /**
    * A wrapper to close connections given a connection without
    * having to include the necessary try-catch nonsense
    * note this handles null statements just fine.
    * we want to close the connection after every statement.
    * @param c a connection object.
    */
  private static void close_connection_with_commit(Connection c) {
    try {
      if (c != null && !c.isClosed()) {
        c.close();
      }
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } 
  }

  public static boolean run_sql_statement_before_db_exists(String sqlText) {
    Statement stmt = null;
    try {
        stmt = get_a_statement_before_db_exists();
        boolean result = stmt.execute(sqlText);
        return result;
      } catch (SQLException ex) {
        handle_sql_exception(ex);
      } catch (Exception ex) {
        System.err.println("General exception: " + ex.toString());
      } finally {
          close_statement(stmt);
      }
    return false;
  }


}
