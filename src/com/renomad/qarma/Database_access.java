package com.renomad.qarma;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
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
  static {
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
    * This method sets you up to call stored procedures in the database.
    * example: you might call this with a string of "register_user_cookie(?)"
    * @param procedure_name the name of a procedure we've already added.  See the database
    * @return A callable statement ready for setting parameters.
    */
  private static CallableStatement get_a_callable_statement(String proc) {
    try {
      Connection conn = DriverManager.getConnection(CONNECTION_STRING_WITH_DB);
      CallableStatement cs = conn.prepareCall(proc);
      return cs;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
    }
    return null;
  }


  /**
    *A wrapper for CallableStatement.execute()
    *
    * Opens and closes a connection each time it's run.
    * @return a boolean for success.
    */
  public static boolean execute(CallableStatement cs) {
    try {
      boolean result = cs.execute();
      return result;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
    }
    return false;
  }


  /**
    *A wrapper for PreparedStatement.executeUpdate(PreparedStatement pstmt)
    *
    * Opens and closes a connection each time it's run.
    * @param pstmt The prepared statement
    * @return a ResultSet object that contains the data produced by the query
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
      null_or_empty_string_validation(first_name);
      null_or_empty_string_validation(last_name);
      null_or_empty_string_validation(email);
      null_or_empty_string_validation(password);

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

  
  /**
    * gets an array of all the users names.
    *
    * @returns an array of users.  If it's an array, we don't have to
    * import anything special into the jsp when we use it, that's why
    * I don't use an arraylist.
    */
  public static String[] get_all_users() {
    String sqlText = "SELECT * FROM user";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      ResultSet resultSet = execute_query(pstmt);

      if (null_or_empty_resultset_validation(resultSet)) {
        return new String[]{"no users found"};
      }

			//keep adding rows of data while there is more data
      ArrayList<String> results = new ArrayList<String>();
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
		* Wrapper around CallableStatement.setInt(int, Int)
		* to avoid littering my code with try-catch
		*/
	private static void set_int(CallableStatement cs, int i, int x) {
		try {
			cs.setInt(i, x);
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		}
	}

	/**
		* Wrapper around PreparedStatement.setInt(int, Int)
		* to avoid littering my code with try-catch
		*/
	private static void set_int(PreparedStatement ps, int i, int x) {
		try {
			ps.setInt(i, x);
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		}
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
	private static void close_callable_statement(CallableStatement cs) {
		try {
			cs.close();
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
		* Wrapper around ResultSet.getInt(String columnName)
		* We'll wrap these methods that throw SQLException
		* so we don't have to worry about it any  more
		*/
	private static int get_integer(ResultSet rs, String columnName) {
		try {
			return rs.getInt(columnName);
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		}
		return 0; //default to returning 0 if this call fails.
	}
  

	/**
		* Wrapper around ResultSet.getString(String columnName)
		* We'll wrap these methods that throw SQLException
		* so we don't have to worry about it any  more
		*/
	private static String get_String(ResultSet rs, String columnName) {
		try {
			return rs.getString(columnName);
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		}
		return "";
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
    * helps with boilerplate for validation of whether result set
    * is null or empty.
    */
  private static boolean null_or_empty_resultset_validation(ResultSet rs) {
    if (result_is_null_or_empty(resultSet)) {
      System.out.println("error: ResultSet was empty");
      return true;
    }
    return false;
  }


  /**
    * helps with boilerplate for validation of whether input
    * is null or empty.
    */
  private static void null_or_empty_string_validation(String value) {
    if (value == null || value == "") {
      System.out.println("error: value was null or empty when it shouldn't have");
    }
  }

  /**
    * checks the password based on the email, the user's unique key
    *
    * @returns the user id if the password is correct for that email.
    */
  public static int check_login(String email, String password) {
      null_or_empty_string_validation(email);
      null_or_empty_string_validation(password);

      String sqlText = "SELECT password,user_id FROM user WHERE email = ?";

      PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      set_string(pstmt, 1, email);
      ResultSet resultSet = execute_query(pstmt);

      null_or_empty_resultset_validation(resultSet);

      result_set_next(resultSet); //move to the first set of results.

      if (get_NString(resultSet, "password").equals(password)) {
        return get_integer(resultSet, "user_id"); //success!
      }
      return 0; //0 means no user found.
    } finally {
      close_prepared_statement(pstmt);
    }
  }

  /**
    * Takes a cookie string value and returns the user's name if valid and logged in.
    * 
    * @param cookie_value cookie we get from the user client
    * @returns the user's user_id if valid and logged in.
    */
    public static int look_for_logged_in_user_by_cookie(String cookie_value) {
        null_or_empty_string_validation(cookie_value);

        String sqlText = 
          "SELECT user.user_id " +
          "FROM user JOIN guid_to_user AS gtu " +
          "ON gtu.user_id = user.user_id " +
          "WHERE gtu.guid = ? AND user.is_logged_in = 1";

        PreparedStatement pstmt = get_a_prepared_statement(sqlText);
      try {
        set_string(pstmt, 1, cookie_value);
        ResultSet resultSet = execute_query(pstmt);

        if (null_or_empty_resultset_validation(resultSet) {
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
      * helper method to check whether a newly-returned result set is
      * null or empty.  Note, this has to be run before any data is
      * retrieved from the result set.  Also note that the method
      * isBeforeFirst() returns false if there are no rows of data.
      * @param rs the result set we are checking
      * @returns true if the result set is null or has no data.
      */
    private static boolean result_is_null_or_empty(ResultSet rs) {
      try {
        return (rs == null || !rs.isBeforeFirst());
      } catch (SQLException ex) {
        handle_sql_exception(ex);
      }
      return true; //true, because if something crashed here, the
                  //result set may as well be empty
    }

  /**
    * stores information on the user when they login, things like
    * their ip, time they logged in, that they are in fact logged in,
    * etc.
    *
    * @param user_id the user's id, an int.
    * @param ip the user's ip.
    */
  public static void register_details_on_user_login(int user_id, 
      String ip) {

      if (user_id < 0) {
        System.out.println("error: user id was " + user_id);
        return;
      }

      if (ip == null || ip.length() == 0) {
        ip = "error: no ip in request";
      }

      String sqlText = 
        "UPDATE user " + 
        "SET is_logged_in = 1, last_time_logged_in = NOW(), " + 
        "last_ip_logged_in = ? " + 
        "WHERE user_id = ?";

      PreparedStatement pstmt = get_a_prepared_statement(sqlText);
      try {
        set_string(pstmt, 1, ip);
        set_int(pstmt, 2, user_id);
        execute_update(pstmt);
      } finally {
        close_prepared_statement(pstmt);
      }
  }

  /**
    * This method creates a new entry in the guid_to_user table
    * which is a lookup to see who is logged in.  The database
    * creates the text of the guid, and then we send that on as
    * the string for the cookie.
    * @param user_id the user id of the user.
    * @return a piping hot cookie.
    */
  public static String get_new_cookie_for_user(int user_id) {

    if (user_id <= 0) {
      return null;
    }

    //set up a call to the stored procedure
    String proc_name = "{call register_user_cookie(?)}"; //using JDBC escape syntax
    CallableStatement cs = get_a_callable_statement(proc_name);

    //set up a query for the new cookie value
    String sqlText = "SELECT guid FROM guid_to_user WHERE user_id = ?";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      //execute the stored proc
      set_int(cs, 1, user_id);
      execute(cs);

      //execute the query for the value
      set_string(pstmt, 1, Integer.toString(user_id));
      ResultSet resultSet = execute_query(pstmt);


      if (null_or_empty_resultset_validation(resultSet)) {
        return "BAD_COOKIE";
      }

      result_set_next(resultSet); //move to the first set of results.

      String guid = "";
      if ((guid = get_String(resultSet, "guid")).length() > 0) {
        return guid; //yay success!
      }
    } finally {
      close_prepared_statement(pstmt);
      close_callable_statement(cs);
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
      System.out.println("Stacktrace: ");
      Thread.currentThread().dumpStack();
  }

}
