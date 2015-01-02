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
		* given an array of words, we'll look up the local words
		* for statuses and see if any match.  If so, we'll return those
		* as an array of ints.
		* @param stats the words we'll compare to see if they are localized statuses
		* @param loc the localization object
		* @return an array of ints of statuses that were found amongst the words.
		*/
	public Integer[] parse_statuses_string(String[] stats, Localization loc) {
		//get all the localized statuses
		//compare those with stats
		//return the id's of statuses that were found.
		return new Integer[0];
	}

	/**
		* gets an array of user ids by names of users.
		* @param usernames an array of user usernames
		* @return an arraylist of user ids instead of the names, or null
		* if failure or none found.
		*/
	public static ArrayList<Integer> 
		get_user_ids_by_names(String[] usernames) {

		//go defensive!
		if (usernames.length == 0) {return null;}

		StringBuilder sb = new StringBuilder();
		//add the first name
		sb.append("\"").append(usernames[0]).append("\"");
		for(String usr : usernames) {
			sb.append(",").append("\"").append(usr).append("\"");
		}
		String delimited_string_usernames = sb.toString();

    String sqlText = "SELECT user_id FROM user WHERE username IN (?)";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = Database_access.prepare_statement(
					conn, sqlText);     
			pstmt.setNString( 1, delimited_string_usernames);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

			ArrayList<Integer> user_ids = new ArrayList<Integer>();
      while(resultSet.next()) {	
				user_ids.add(resultSet.getInt("user_id"));
			}
      return user_ids;
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
    * @return a User object filled with first name, last name, email, and points, or
		* null if not found.
    */
  public static User get_user(int user_id) {
    String sqlText = "SELECT first_name,last_name,email,points FROM user WHERE user_id = ?;";
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
      String first_name = resultSet.getString("first_name");
      String last_name = resultSet.getString("last_name");
      String email = resultSet.getString("email");
      int points = resultSet.getInt("points");
      return new User(first_name, last_name, email, "", points);
		} catch (SQLException ex) {
			Database_access.handle_sql_exception(ex);
			return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }
  

  /**
    * adds a user.  if successful, returns true
		* @return true if successful
    */
  public static boolean put_user(
			String first_name, String last_name, String email, String password) {
			boolean is_bad = false;
      is_bad |= Utils.is_null_or_empty(first_name);
      is_bad |= Utils.is_null_or_empty(last_name);
      is_bad |= Utils.is_null_or_empty(email);
      is_bad |= Utils.is_null_or_empty(password);
			if (is_bad) {
				return false;
			}
			User u = new User(first_name, last_name, email, password, 100);
			return put_user(u);
  }


  private static boolean put_user(User user) {

		// 1. set the sql
      String sqlText = 
        "INSERT INTO user (first_name, last_name, email, password, points) " +
        "VALUES (?, ?, ?, ?, ?)";
		// 2. set up values we'll need outside the try
		boolean result = false;
		PreparedStatement pstmt = null;
    try {
			// 3. get the connection and set up a statement
			Connection conn = Database_access.get_a_connection();
			pstmt = Database_access.prepare_statement(
					conn, sqlText);     
			// 4. set values into the statement
      pstmt.setString( 1, user.first_name);
      pstmt.setString( 2, user.last_name);
      pstmt.setString( 3, user.email);
      pstmt.setString( 4, user.password);
      pstmt.setInt( 5, user.points);
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

