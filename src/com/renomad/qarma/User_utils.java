package com.renomad.qarma;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;
import com.renomad.qarma.Database_access;
import com.renomad.qarma.Utils;

import java.sql.Statement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
	* utilties methods used to work with users
	*/
public final class User_utils {

	private User_utils() {
		//do nothing - prevent instantiation
	}


  /** * gets a name for display from the user table
    *
    * @return a string displaying first name, last name, email, or
		* null if not found.
    */
  public static String get_user_displayname(int user_id) {
    String sqlText = "SELECT CONCAT(first_name, ' ',last_name,' (', email,'), ',points,' points') as user_displayname FROM user WHERE user_id = ?;";
		PreparedStatement pstmt = null;
    try {
			Connection conn = Database_access.get_a_connection();
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
			pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next(); //move to the first set of results.
      String display_name = resultSet.getString("user_displayname");
      return display_name;
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
      is_bad |= Utils.null_or_empty_string_validation(first_name);
      is_bad |= Utils.null_or_empty_string_validation(last_name);
      is_bad |= Utils.null_or_empty_string_validation(email);
      is_bad |= Utils.null_or_empty_string_validation(password);
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
			pstmt = conn.prepareStatement(sqlText, Statement.RETURN_GENERATED_KEYS);     
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

