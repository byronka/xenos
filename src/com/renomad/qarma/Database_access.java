package com.renomad.qarma;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.Arrays;
import java.io.File;
import java.io.FileNotFoundException;
import com.renomad.qarma.Business_logic.Request;

public class Database_access {


  // ******************************
  // BUSINESS LOGIC CODE          *
  // ******************************

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
    * Gets a specific Request for the user.
    * 
    * @returns a single Request
    */
  public static Request get_a_request(int user_id, int request_id) {
		
    String sqlText = "SELECT * FROM request WHERE requesting_user = ? and request_id = ?";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);

    try {
      set_int(pstmt, 1, user_id);
      set_int(pstmt, 2, request_id);
      ResultSet resultSet = execute_query(pstmt);
      if (resultset_is_null_or_empty(resultSet)) {
        return new Request(0,"","",0,"","",0);
      }

      result_set_next(resultSet);
			int rid = get_integer(resultSet,  "request_id");
			String dt = get_string(resultSet,   "datetime");
			String d = get_nstring(resultSet,  "description");
			int p = get_integer(resultSet,  "points");
			String s = get_string(resultSet,   "status");
			String t = get_nstring(resultSet,  "title");
			int ru = get_integer(resultSet,      "requesting_user");
			Request request = new Request(rid,dt,d,p,s,t,ru);

      return request;
    } finally {
      close_statement(pstmt);
    }
  }

  /**
    * Gets all the requests for the user.
    * 
    * @returns an array of Request
    */
  public static Request[] get_all_requests(int user_id) {
    String sqlText = "SELECT * FROM request WHERE requesting_user = ?";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      set_int(pstmt, 1, user_id);
      ResultSet resultSet = execute_query(pstmt);
      if (resultset_is_null_or_empty(resultSet)) {
        return new Request[0];
      }

			//keep adding rows of data while there is more data
      ArrayList<Request> requests = new ArrayList<Request>();
      for(;result_set_next(resultSet) == true;) {
        int rid = get_integer(resultSet,  "request_id");
        String dt = get_string(resultSet,   "datetime");
        String d = get_nstring(resultSet,  "description");
        int p = get_integer(resultSet,  "points");
        String s = get_string(resultSet,   "status");
        String t = get_nstring(resultSet,  "title");
        int ru = get_integer(resultSet,      "requesting_user");
        Request request = new Request(rid,dt,d,p,s,t,ru);
        requests.add(request);
      }

      //convert arraylist to array
      Request[] array_of_requests = 
        requests.toArray(new Request[requests.size()]);
      return array_of_requests;
    } finally {
      close_statement(pstmt);
    }
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
        "VALUES (?, ?, ?, ?)";
      PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      set_string(pstmt, 1, first_name);
      set_string(pstmt, 2, last_name);
      set_string(pstmt, 3, email);
      set_string(pstmt, 4, password);
      int result = execute_update(pstmt);
      return result;
    } finally {
      close_statement(pstmt);
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

      if (resultset_is_null_or_empty(resultSet)) {
        return new String[0];
      }

			//keep adding rows of data while there is more data
      ArrayList<String> results = new ArrayList<String>();
      for(;result_set_next(resultSet) == true;) {
        results.add(get_nstring(resultSet, "user_name"));
      }
      //convert arraylist to array
      String[] array_of_users = 
        results.toArray(new String[results.size()]);
      return array_of_users;
    } finally {
      close_statement(pstmt);
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

      if(resultset_is_null_or_empty(resultSet)) {
        return 0; // no results on query - return user "0";
      }

      result_set_next(resultSet); //move to the first set of results.

      if (get_nstring(resultSet, "password").equals(password)) {
        return get_integer(resultSet, "user_id"); //success!
      }
      return 0; //password was bad - return user "0"
    } finally {
      close_statement(pstmt);
    }
  }

  /**
    * Takes a cookie string value and returns the user's name if valid and logged in.
    * 
    * @param cookie_value cookie we get from the user client
    * @returns the user's user_id if valid and logged in.
    */
    public static int 
      look_for_logged_in_user_by_cookie(String cookie_value) {
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

        if (resultset_is_null_or_empty(resultSet)) {
          return -1; //-1 is us saying we didn't get a user. ouch!
        }

        result_set_next(resultSet); //move to the first set of results.

        Integer user_id = null;
        if ((user_id = get_integer(resultSet, "user_id")) != null) {
          return user_id.intValue(); //yay success!
        }
      } finally {
        close_statement(pstmt);
      }
      return -1; //-1 is our way of saying we didn't find a user.
    }

  /**
    * stores information on the user when they login, things like
    * their ip, time they logged in, that they are in fact logged in,
    * etc.
    *
    * @param user_id the user's id, an int.
    * @param ip the user's ip.
    */
  public static void 
    register_details_on_user_login(int user_id, String ip) {

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
        close_statement(pstmt);
      }
  }

  /**
    * This method creates a new entry in the guid_to_user table
    * which is a lookup to see who is logged in.  The database
    * creates the text of the guid, and then we send that on as
    * the string for the cookie.
    * @param user_id the user id of the user.
    * @returns a piping hot cookie.
    */
  public static String get_new_cookie_for_user(int user_id) {

    if (user_id <= 0) {
      return null;
    }

    //set up a call to the stored procedure
    String proc_name = 
      "{call register_user_cookie(?)}"; //using JDBC escape syntax
    CallableStatement cs = get_a_callable_statement(proc_name);

    //set up a query for the new cookie value
    String sqlText = "SELECT guid FROM guid_to_user WHERE user_id = ?";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      //execute the stored proc, cleaning out 
      //junk entries and creating a new cooie
      set_int(cs, 1, user_id);
      execute(cs);

      //execute the query for the value, getting the 
      //value for the cookie we just made
      set_string(pstmt, 1, Integer.toString(user_id));
      ResultSet resultSet = execute_query(pstmt);

      if (resultset_is_null_or_empty(resultSet)) {
        return "BAD_COOKIE";
      }

      result_set_next(resultSet); //move to the first set of results.

      String guid = "";
      if ((guid = get_string(resultSet, "guid")).length() > 0) {
        return guid; //yay success!
      }
    } finally {
      close_statement(pstmt);
      close_statement(cs);
    }
    return ""; 
  }

  // ******************************
  // HELPERS AND BOILERPLATE CODE *
  // ******************************

  private static String CONNECTION_STRING_WITH_DB =
        "jdbc:mysql://localhost/test?user=qarmauser&password=password1";
  private static String CONNECTION_STRING_WITHOUT_DB =
        "jdbc:mysql://localhost/?user=qarmauser&password=password1";

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
      System.out.println("General exception: " + ex.toString());
    }
  }


  /**
    * Helper to get a Statement
    * Opens a connection each time it's run.
    * We don't have to worry about SQL injection here, 
    * it should only be called by our own code.
    * @returns A new Statement object.
    */
  private static Statement get_a_statement() throws SQLException {
    Connection conn = 
      DriverManager.getConnection(CONNECTION_STRING_WITH_DB);
    Statement stmt = conn.createStatement();
    return stmt;
  }
  /**
    * Helper to get a Statement, using connection string without db.
    * This is used to get a statement before the database is created.
    * Opens a connection each time it's run.
    * We don't have to worry about SQL injection here, 
    * it should only be called by our own code.
    * @returns A new Statement object.
    */
  private static Statement 
    get_a_statement_before_db_exists() throws SQLException {
    Connection conn = 
      DriverManager.getConnection(CONNECTION_STRING_WITHOUT_DB);
    Statement stmt = conn.createStatement();
    return stmt;
  }

  /**
    * Helper to get a PreparedStatement.
    *
    * Opens a connection each time it's run.
    * @returns A new PreparedStatement object.
    */
  private static PreparedStatement 
    get_a_prepared_statement(String queryText) {
    try {
      Connection conn = 
        DriverManager.getConnection(CONNECTION_STRING_WITH_DB);
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
    * example: you might call this with a string 
    * of "register_user_cookie(?)"
    * @param procedure_name the name of a procedure we've 
    *  already added.  See the database
    * @returns A callable statement ready for setting parameters.
    */
  private static CallableStatement get_a_callable_statement(String proc) {
    try {
      Connection conn = 
        DriverManager.getConnection(CONNECTION_STRING_WITH_DB);
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
    * @returns a boolean for success.
    */
  private static boolean execute(CallableStatement cs) {
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
    * @returns a ResultSet object that contains the data 
    * produced by the query
    */
  private static ResultSet execute_query(PreparedStatement pstmt) {
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
    * @returns either (1) the row count for SQL Data Manipulation 
    *  Language (DML) statements or (2) 0 for SQL statements 
    * that return nothing
    */
  private static int execute_update(PreparedStatement pstmt) {
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
    *A wrapper for PreparedStatement.execute() - used 
    * before database exists.
    *
    * Opens and closes a connection each time it's run.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
    * @returns true if the first result is a ResultSet object; false 
    *  if it is an update count or there are no results
    */
  public static boolean 
    run_sql_statement_before_db_exists(String sqlText) {
    Statement stmt = null;
    try {
      stmt = get_a_statement_before_db_exists();
      boolean result = stmt.execute(sqlText);
      return result;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
    } finally {
      close_statement(stmt);
    }
    return false;
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


  /**
    *A wrapper for Statement.execute, and running statements 
		* that have not come
		* from the user, so we don't have to worry about SQL Injection.
    *
		* Note: does not close connection.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
		* @param stmt the statement
    * @returns true if the first result is a ResultSet object; false 
    *  if it is an update count or there are no results
    */
  public static boolean execute_statement(String sqlText, Statement stmt) {
		boolean result = false;
		try {
			result = stmt.execute(sqlText);
		}	catch (SQLException ex) {
			handle_sql_exception(ex);
		}
		return result;
  }


  /**
    *A wrapper for PreparedStatement.execute(), 
		* used for setting up db schemas.
    *
    * Opens and closes a connection each time it's run.
    * @param sqlText the SQL text we will run - it must be a
    *  single statement.  Multiple combined statements will fail.
    * @returns true if the first result is a ResultSet object; false 
    *  if it is an update count or there are no results
    */
  public static boolean run_sql_statement(String sqlText) {
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
		boolean result = execute_prepared_statement(pstmt, sqlText);
		return result;
  }

	public static void run_multiple_statements(String file) {
		Statement stmt = null;
		try (Scanner s = new Scanner(new File(file))) {
			stmt = get_a_statement();
			s.useDelimiter("---DELIMITER---");
			while(s.hasNext()) {
				String next_statement = s.next();
				execute_statement(
						next_statement, stmt);
			}
		} catch (FileNotFoundException ex) {
			System.out.println(ex);
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		} finally {
    	close_statement(stmt);
		}
	}


  /**
    * helper method to check whether a newly-returned result set is
    * null or empty.  Note, this has to be run before any data is
    * retrieved from the result set.  Also note that the method
    * isBeforeFirst() returns false if there are no rows of data.
    * @param rs the result set we are checking
    * @returns true if the result set is null or has no data.
    */
  private static boolean resultset_is_null_or_empty(ResultSet rs) {
    try {
      return (rs == null || !rs.isBeforeFirst());
    } catch (SQLException ex) {
      System.out.println("ResultSet was null or empty");
      handle_sql_exception(ex);
    }
    return true; //true, because if something crashed here, the
                //result set may as well be empty
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
		} finally {
			close_statement(ps);
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
		* Wrapper around ResultSet.getString(String columnName)
		* We'll wrap these methods that throw SQLException
		* so we don't have to worry about it any  more
		*/
	private static String get_string(ResultSet rs, String columnName) {
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
	private static String get_nstring(ResultSet rs, String columnName) {
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
    */
  private static void null_or_empty_string_validation(String value) {
    if (value == null || value == "") {
      System.out.println(
          "error: value was null or empty when it shouldn't have");
    }
  }
}
