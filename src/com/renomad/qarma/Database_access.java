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
		close_prepared_statement(pstmt);
		return result;
  }

  public static int add_user(
			String first_name, String last_name, String email, String password) {
    //validation section
      null_or_empty_validation(first_name);
      null_or_empty_validation(last_name);
      null_or_empty_validation(email);
      null_or_empty_validation(password);

      String sqlText = 
        "INSERT INTO user (first_name, last_name, email, password) " +
        "values (?, ?, ?, ?)";
      PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      set_string(pstmt, 1, first_name);
      set_string(pstmt, 2, last_name);
      set_string(pstmt, 3, email);
      set_string(pstmt, 4, password);
      int result = execute_update(pstmt);
      return result;
    } finally {
      close_prepared_statement(pstmt);
    }
  }

  
  public static String[] get_all_users() {
      String sqlText = "SELECT * FROM user";
      ArrayList<String> results = new ArrayList<String>();
      PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      ResultSet resultSet = execute_query(pstmt);

      if (resultSet == null) {
        return new String[]{"no users found"};
      }

			//keep adding rows of data while there is more data
      for(;result_set_next(resultSet) == true;) {
        results.add(get_NString(resultSet, "user_name"));
      }
      String[] array_of_users = 
        results.toArray(new String[results.size()]);
      return array_of_users;
    } finally {
      close_prepared_statement(pstmt);
    }
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
		* Wrapper around PreparedStatement.execute(String text)
		* to avoid littering my code with try-catch
		*/
	private static boolean execute_prepared_statement(
			PreparedStatement ps, String sqlText) {
		try {
			return ps.execute(sqlText);
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		} 
		return false;
	}


	/**
		* Wrapper around PreparedStatement.setString(int, String)
		* to avoid littering my code with try-catch
		*/
	private static void set_string(PreparedStatement ps, int i, String s) {
		try {
			ps.setString(i, s);
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		}
	}


	/**
		* Wrapper around PreparedStatement.close() to avoid having to
		* litter my code with try-catch
		*/
	private static void close_prepared_statement(PreparedStatement ps) {
		try {
			ps.close();
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		}
	}

	/**
		* Wrapper around ResultSet.getNString(String columnName)
		* We'll wrap these methods that throw SQLException
		* so we don't have to worry about it any  more
		*/
	private static String get_NString(ResultSet rs, String columnName) {
		try {
			return rs.getNString(columnName);
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		}
		return "";
	}
  

  /**
    * helps with boilerplate for validation of whether input
    * is null or empty.
    * @throws Exception if the string is null or empty
    */
  private static void null_or_empty_validation(String value) {
    if (value == null || value == "") {
      System.out.println("value was null or empty when it shouldn't have");
    }
  }

  /**
    * checks the password based on the email, the user's unique key
    *
    * @returns true if the password is correct for that email.
    */
  public static boolean check_login(String email, String password) {
      null_or_empty_validation(email);
      null_or_empty_validation(password);

      String sqlText = "SELECT password FROM user WHERE email = ?";

      PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      set_string(pstmt, 1, email);
      ResultSet resultSet = execute_query(pstmt);

      if (resultSet == null) {
        System.out.println("no user found with email " + email);
      }

      result_set_next(resultSet); //move to the first set of results.

      if (get_NString(resultSet, "password").equals(password)) {
        return true; //success!
      }
      return false;
    } finally {
      close_prepared_statement(pstmt);
    }
  }

  /**
    * Takes a cookie string value and returns the user's name if valid and logged in.
    * 
    * @param cookie_value cookie we get from the user client
    * @returns the user's name if valid and logged in.
    */
    public static String look_for_logged_in_user_by_cookie(String cookie_value) {
        null_or_empty_validation(cookie_value);

        String sqlText = "SELECT email FROM user JOIN guid_to_user AS gtu " +
          "ON gtu.id = user.id WHERE gtu.guid = ? AND user.is_logged_in = 1";

        PreparedStatement pstmt = get_a_prepared_statement(sqlText);
      try {
        set_string(pstmt, 1, cookie_value);
        ResultSet resultSet = execute_query(pstmt);

        if (resultSet == null) {
          System.out.println("no user found with cookie value " + cookie_value);
          return "";
        }

        result_set_next(resultSet); //move to the first set of results.

        String email = "";
        if ((email = get_NString(resultSet, "email")).length() > 0) {
          return email; //yay success!
        }
      } finally {
        close_prepared_statement(pstmt);
      }
      return ""; 
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
