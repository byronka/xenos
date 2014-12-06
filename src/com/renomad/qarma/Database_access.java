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
import com.renomad.qarma.Business_logic.Request_status;

public class Database_access {


  // ******************************
  // BUSINESS LOGIC CODE          *
  // ******************************


  
  /**
    * adds a Request to the database
    *
    */
  public static boolean add_request(
      int user_id,
      String desc, int status, 
      String date, int points, String title ) {
    
      if (user_id < 0) {
        System.out.println(
            "error: user id was " + user_id + " in add_request");
        return false;
      }

      String sqlText = 
        "INSERT into request (description, datetime, points, " + 
        "status, title, requesting_user) VALUES (?, ?, ?, ?, ?, ?)"; 

      PreparedStatement pstmt = get_a_prepared_statement(sqlText);
      try {
        set_string(pstmt, 1, desc);
        set_string(pstmt, 2, date);
        set_integer(pstmt, 3, points);
        set_integer(pstmt, 4, status);
        set_string(pstmt, 5, title);
        set_integer(pstmt, 6, user_id);
        return execute_update(pstmt);
      } finally {
        close_statement(pstmt);
      }
  }

	public static Request_status[] get_request_statuses() {
    String sqlText = 
      "SELECT request_status_id, request_status_value FROM request_status;";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);

    try {
      ResultSet resultSet = execute_query(pstmt);
      if (resultset_is_null_or_empty(resultSet)) {
        return new Request_status[0];
      }

			//keep adding rows of data while there is more data
      ArrayList<Request_status> statuses = 
				new ArrayList<Request_status>();
      for(;result_set_next(resultSet) == true;) {
				int sid = get_integer(resultSet,  "request_status_id");
				String sv = get_string(resultSet,   "request_status_value");
				Request_status status = new Request_status(sid,sv);
        statuses.add(status);
			}

      //convert arraylist to array
      Request_status[] my_array = 
        statuses.toArray(new Request_status[statuses.size()]);
      return my_array;
    } finally {
      close_statement(pstmt);
    }
	}

  /**
    * Gets a specific Request for the user.
    * 
    * @returns a single Request
    */
  public static Request get_a_request(int request_id) {
		
    String sqlText = 
      "SELECT request_id, datetime,description,points,status,title,requesting_user FROM request WHERE request_id = ?";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);

    try {
      set_integer(pstmt, 1, request_id);
      ResultSet resultSet = execute_query(pstmt);
      if (resultset_is_null_or_empty(resultSet)) {
        return new Request(0,"","",0,1,"",0);
      }

      result_set_next(resultSet);
			int rid = get_integer(resultSet,  "request_id");
			String dt = get_string(resultSet,   "datetime");
			String d = get_nstring(resultSet,  "description");
			int p = get_integer(resultSet,  "points");
			int s = get_integer(resultSet,   "status");
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
  public static Request[] get_all_requests_except_for_user(int user_id) {
    String sqlText = "SELECT * FROM request WHERE requesting_user <> ?";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      set_integer(pstmt, 1, user_id);
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
        int s = get_integer(resultSet,   "status");
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

		


  /**
    * Gets all the requests for the user.
    * 
    * @returns an array of Request
    */
  public static Request[] get_requests_for_user(int user_id) {
    String sqlText = "SELECT * FROM request WHERE requesting_user = ?";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      set_integer(pstmt, 1, user_id);
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
        int s = get_integer(resultSet,   "status");
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


  public static boolean add_user(
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
      boolean is_successful = execute_update(pstmt);
      return is_successful;
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
    String sqlText = "SELECT user_id FROM user";
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

	
  // ******************************
  // SECURITY CODE                *
  // ******************************


  /**
    * Checks the database, given the user id, whether that
    * user is logged in
    */
  public static boolean user_is_logged_in(int user_id) {
    if (user_id < 0) {
      System.out.println("error: user id was " + user_id + 
          " in user_is_logged_in()");
    }

    String sqlText = "SELECT is_logged_in FROM user WHERE user_id = ?";

    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      set_integer(pstmt, 1, user_id);
      ResultSet resultSet = execute_query(pstmt);

      if(resultset_is_null_or_empty(resultSet)) {
        return false; // no results on query - return not logged in
      }

      result_set_next(resultSet); //move to the first set of results.
      return get_boolean(resultSet, "is_logged_in");
    } finally {
      close_statement(pstmt);
    }

  }

  /**
    * simply sets "is_logged_in" to false in the database for the given user.
    * @param user_id the user in question to set logged_in to false.
    * @returns a boolean on whether the operation succeeded.
    */
  public static boolean set_user_not_logged_in(int user_id) {
    if (user_id < 0) {
      System.out.println("error: user id was " + user_id + 
          " in set_user_not_logged_in()");
      return false;
    }

    String sqlText = "UPDATE user SET is_logged_in = false;";
    PreparedStatement pstmt = get_a_prepared_statement(sqlText);
    try {
      boolean is_successful = execute_update(pstmt);
      return is_successful;
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
        System.out.println("error: user id was " + user_id + " in register_details_on_user_login");
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
        set_integer(pstmt, 2, user_id);
        execute_update(pstmt);
      } finally {
        close_statement(pstmt);
      }
  }


  // ******************************
  // HELPERS AND BOILERPLATE CODE *
  // ******************************


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
    * Helper to get a Statement
    * Opens a connection each time it's run.
    * We don't have to worry about SQL injection here, 
    * it should only be called by our own code.
    * @returns A new Statement object.
    */
  private static Statement get_a_statement() throws SQLException {
    javax.sql.DataSource ds = null;
    try {
      javax.naming.Context initContext = new javax.naming.InitialContext();
      javax.naming.Context envContext  = (javax.naming.Context)initContext.lookup("java:/comp/env");
      ds = (javax.sql.DataSource)envContext.lookup("jdbc/qarma_db");
    } catch (javax.naming.NamingException e) {
      System.out.println("a naming exception occurred.  details: ");
      System.out.println(e);
    }
    Connection conn = ds.getConnection();
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
      javax.naming.Context initContext = new javax.naming.InitialContext();
      javax.naming.Context envContext  = (javax.naming.Context)initContext.lookup("java:/comp/env");
      javax.sql.DataSource ds = (javax.sql.DataSource)envContext.lookup("jdbc/qarma_db");
      Connection conn = ds.getConnection();
      PreparedStatement stmt = conn.prepareStatement(queryText);
      return stmt;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (javax.naming.NamingException e) {
      System.out.println("a naming exception occurred.  details: ");
      System.out.println(e);
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
    }
    return null;
  }
  

  /**
    * This method sets you up to call stored procedures in the database.
    * example: you might call this with a string 
    * of "{call blahdy_blahblah(?)}"; ,using JDBC escape syntax
    * @param procedure_name the name of a procedure we've 
    *  already added.  See the database
    * @returns A callable statement ready for setting parameters.
    */
  private static CallableStatement get_a_callable_statement(String proc) {
    try {
      javax.naming.Context initContext = new javax.naming.InitialContext();
      javax.naming.Context envContext  = (javax.naming.Context)initContext.lookup("java:/comp/env");
      javax.sql.DataSource ds = (javax.sql.DataSource)envContext.lookup("jdbc/qarma_db");
      Connection conn = ds.getConnection();
      CallableStatement cs = conn.prepareCall(proc);
      return cs;
    } catch (SQLException ex) {
      handle_sql_exception(ex);
    } catch (javax.naming.NamingException e) {
      System.out.println("a naming exception occurred.  details: ");
      System.out.println(e);
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
    * @returns a boolean indicating whether this succeeded.  If it
    * hits an exception, that's when we return false.  if success, true.
    */
  private static boolean execute_update(PreparedStatement pstmt) {
    try {
      pstmt.executeUpdate();
    } catch (SQLException ex) {
      handle_sql_exception(ex);
      return false;
    } catch (Exception ex) {
      System.out.println("General exception: " + ex.toString());
      return false;
    }
    return true;
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
	private static void set_integer(CallableStatement cs, int i, int x) {
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
	private static void set_integer(PreparedStatement ps, int i, int x) {
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
		* Wrapper around ResultSet.getBoolean(String columnName)
		* We'll wrap these methods that throw SQLException
		* so we don't have to worry about it any  more
		*/
	private static boolean get_boolean(ResultSet rs, String columnName) {
		try {
			return rs.getBoolean(columnName);
		} catch (SQLException ex) {
			handle_sql_exception(ex);
		}
		return false;
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
