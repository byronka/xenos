package com.renomad.qarma;


import com.renomad.qarma.Database_access;
import com.renomad.qarma.Utils;
import java.util.ArrayList;

import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
	* Utilities methods used to work with users
	*/
public final class User_utils {

	private User_utils() {
		//do nothing - prevent instantiation
	}


	/**
    * gets an array of user ids by names of users. used in searching
    * requests by users.  
    * @param usernames an array of user usernames
	* @return an array of user ids instead of the names, or null
	* if failure or none found.
	*/
	public static Integer[]
		get_user_ids_by_names(String[] usernames) {

		//go defensive!
		if (usernames.length == 0) {return null;}

		StringBuilder sb = new StringBuilder();
		//add the first name
		
		sb.append("'")
		.append(usernames[0].replaceAll("'", ""))
		.append("'");
		
    //add subsequent names
		for(int i = 1; i < usernames.length; i++) {
			sb.append(",")
			.append("'")
			.append(usernames[i].replaceAll("'", ""))
			.append("'");
		}
		String delimited_string_usernames = sb.toString();

    String sqlText = 
    		String.format("SELECT user_id FROM user WHERE username IN (%s)", 
    				delimited_string_usernames);
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = Database_access.prepare_statement(
					conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

			ArrayList<Integer> user_ids = new ArrayList<Integer>();
      while(resultSet.next()) {	
				user_ids.add(resultSet.getInt("user_id"));
			}
			return user_ids.toArray(new Integer[user_ids.size()]);
		} catch (SQLException ex) {
			Database_access.handle_sql_exception(ex);
			return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
	}


	/**
		* gets the points for a given user.
		* @param user_id the id for the user
		* @return the number of points that user has, or -1 if SQL failure.
		*/
	public static int get_user_points(int user_id) {
    String sqlText = "SELECT points FROM user WHERE user_id = ?;";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = Database_access.prepare_statement(
					conn, sqlText);     
			pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return -1;
      }

      resultSet.next(); //move to the first set of results.
      int points = resultSet.getInt("points");
      return points;
		} catch (SQLException ex) {
			Database_access.handle_sql_exception(ex);
			return -1;
    } finally {
      Database_access.close_statement(pstmt);
    }

	}

  /** * gets the user's preferred language
    *
    * @return an int representing the user's preferred language, or
		* null if they have no preferred language or error.
    */
  public static Integer get_user_language(int user_id) {
    String sqlText = "SELECT language FROM user WHERE user_id = ?;";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = Database_access.prepare_statement(
					conn, sqlText);     
			pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next(); //move to the first set of results.
      int lang = resultSet.getInt("language");
			if (resultSet.wasNull()) {
				return null;
			}
			return lang;
		} catch (SQLException ex) {
			Database_access.handle_sql_exception(ex);
			return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }

  
  /** *
   * gets a user object
   *  
    * @return a User object filled with username and points, or
		* null if not found.
    */
  public static User get_user(int user_id) {
    String sqlText = "SELECT username,points FROM user WHERE user_id = ?;";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = Database_access.prepare_statement(
					conn, sqlText);     
			pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next(); //move to the first set of results.
      String username = resultSet.getString("username");
      int points = resultSet.getInt("points");
      return new User(username, "", points);
		} catch (SQLException ex) {
			Database_access.handle_sql_exception(ex);
			return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }
  

  /**
    * adds a user.  Will check that values were entered for required
    * fields, and if so, will create the user.  Note that at that
    * point, the database has constraints which might cause failure
    * still.  See put_user's overload.
		* @return true if successful
    */
  public static boolean put_user(String username, String password) {
			boolean is_bad = false;

      //just check non-empty.  Later we do deeper checks.
      is_bad |= Utils.is_null_or_empty(username);
      is_bad |= Utils.is_null_or_empty(password);
			if (is_bad) {
				return false;
			}
			User u = new User(username, password, 100);
			return put_user(u);
  }


  /**
    * This overload of put_user stores the new user's values into the
    * database, but beware!  There are constraints set up in the
    * database that prevent corrupt data.  Like, for example, you
    * should not be allowed to have duplicate emails or usernames in
    * the database.  Further, you should not be able to have a
    * username the same as an email address.
    * @return true if successful, false if failure or any constraints
    * violated (like, uniqueness of username or email, for example)
    */
  private static boolean put_user(User user) {

		// 1. set the sql
      String sqlText = 
        "INSERT INTO user (username, password, points) " +
        "VALUES (?, ?, ?)";
		// 2. set up values we'll need outside the try
		boolean result = false;
		PreparedStatement pstmt = null;
    try {
			// 3. get the connection and set up a statement
			Connection conn = Database_access.get_a_connection();
			pstmt = Database_access.prepare_statement(
					conn, sqlText);     
			// 4. set values into the statement
      pstmt.setString( 1, user.username);
      pstmt.setString( 2, user.password);
      pstmt.setInt( 3, user.points);
			// 5. execute a statement
      result = Database_access.execute_update(pstmt) > 0;
			// 10. cleanup and exceptions
			return result;
		} catch (SQLException ex) {
			Database_access.handle_sql_exception(ex);
			return false;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


}

