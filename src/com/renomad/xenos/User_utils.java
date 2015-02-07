package com.renomad.xenos;


import com.renomad.xenos.Database_access;
import com.renomad.xenos.Utils;
import java.util.ArrayList;

import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;

import java.util.concurrent.ThreadLocalRandom;

/**
  * Utilities methods used to work with users
  */
public final class User_utils {

  private User_utils() {
    //do nothing - prevent instantiation
  }


  /**
    * gets an array of user ids by names of users. used in searching
    * requestoffers by users.  
    * @param usernames an array of user usernames
    * @return a string representing an array of user ids instead of the
    *   names, or empty string if failure or none found.
    */
  public static String
    get_user_ids_by_names(String[] usernames) {

    //go defensive!
    if (usernames.length == 0) {return null;}

    StringBuilder sb = new StringBuilder();
    //add the first name
    
    //the replaceAll here is to prevent SQL injection.
    sb.append("'")
    .append(usernames[0].replaceAll("'", ""))
    .append("'");
    
    //add subsequent names
    //the replaceAll here is to prevent SQL injection.
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
        return "";
      }

      StringBuilder user_ids_sb = new StringBuilder();
      resultSet.next();
      user_ids_sb.append(resultSet.getInt("user_id"));

      while(resultSet.next()) {  
        user_ids_sb
          .append(",")
          .append(resultSet.getInt("user_id"));
      }

      return user_ids_sb.toString();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return "";
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  /**
    * gets the salt for a given user.
    * @param username the username for the user
    * @return the salt for the user, used in hashing 
    *   password, or empty if failure
    */
  public static String get_user_salt(String username) {
    String sqlText = "SELECT salt FROM user WHERE username = ?;";
    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setNString( 1, username);
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return "";
      }

      resultSet.next(); //move to the first set of results.
      String salt = resultSet.getString("salt");
      return salt;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return "";
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
    * @return a User object, or null if not found.
    */
  public static User get_user(int user_id) {
    String sqlText = 
      "SELECT username,points, timeout_seconds "+
      "FROM user WHERE user_id = ?;";
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
      String username = resultSet.getNString("username");
      int points = resultSet.getInt("points");
      int timeout_seconds = resultSet.getInt("timeout_seconds");
      return new User(username, "", points, timeout_seconds);
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

      if ( Utils.is_null_or_empty(username) ||
           Utils.is_null_or_empty(password)) {
        return false;
      }

      CallableStatement cs = null;
      try {
        Connection conn = Database_access.get_a_connection();
        // see db_scripts/v1_setup.sql delete_requestoffer for
        // details on this stored procedure.
        
        cs = conn.prepareCall("{call create_new_user(?,?,?)}");
        cs.setNString(1,username);
        //make a salt we'll use for hashing.
        String salt = Long.toString(
						ThreadLocalRandom.current().nextLong(Long.MAX_VALUE));
        String hashed_pwd = hash_password(password, salt);
        cs.setString(2,hashed_pwd);
        cs.setString(3,salt);
        cs.executeQuery();
      } catch (SQLException ex) {
				String msg = ex.getMessage();
				if (msg.contains("Duplicate entry") ||
					msg.contains("username matches existing")) {
					return false;
				}
        Database_access.handle_sql_exception(ex);
        return false;
      } finally {
        Database_access.close_statement(cs);
      }
      return true;
  }


  /**
    * Just like it says: concatenates the salt and password, and then
    * generates a hash from it.  We'll go with Sha256.
    * FYI: look up "salt" as it relates to hashing.  It's a way to combat
    * rainbow tables in hash attacks.
    */
  public static String hash_password(String password, String salt) {
    String value_to_hash = password + salt;
    byte[] hashed_bytes = Utils.get_sha_256(value_to_hash);
    return Utils.bytes_to_hex(hashed_bytes); 
  }



}

