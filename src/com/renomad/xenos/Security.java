package com.renomad.xenos;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import com.renomad.xenos.Database_access;
import com.renomad.xenos.Utils;

import java.sql.Statement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
  * Security holds methods necessary for authentication
  * and other similar items.
  */
public final class Security {

  private Security () {
    //we don't want anyone instantiating this
    //do nothing.
  }

  /**
    * Checks the database, given the user id, whether that
    * user is logged in
    */
  public static boolean user_is_logged_in(int user_id) {
    String sqlText = "SELECT is_logged_in FROM user WHERE user_id = ?";
    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = conn.prepareStatement(
					sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setInt( 1, user_id);
      ResultSet resultSet = pstmt.executeQuery();

      if(Database_access.resultset_is_null_or_empty(resultSet)) {
        return false; // no results on query - return not logged in
      }

      resultSet.next(); //move to the first set of results.
      return resultSet.getBoolean("is_logged_in");
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(pstmt);
    }

  }

  /**
		* simply sets "is_logged_in" to false in the database for the
		* given user.
    * @param user_id the user in question to set logged_in to false.
    */
  public static boolean set_user_not_logged_in(int user_id) {
    String sqlText = "UPDATE user SET is_logged_in = false;";
    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = conn.prepareStatement(
					sqlText, Statement.RETURN_GENERATED_KEYS);     
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false; //if a failure occurred.
    } finally {
      Database_access.close_statement(pstmt);
    }
    return true;
  }


  /**
    * checks the password based on the username, the user's unique key
    *
    * @return the user id if the password is correct for that 
		*  username, 0 otherwise
    */
  public static int check_login(String username, String password) {
    String salt = User_utils.get_user_salt(username);
    String hashed_pwd = User_utils.hash_password(password, salt);
    String sqlText = 
      "SELECT user_id "+
      "FROM user "+
      "WHERE username = ? AND password = ?";
    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = conn.prepareStatement(
					sqlText, Statement.RETURN_GENERATED_KEYS);     
      pstmt.setNString( 1, username);
      pstmt.setString( 2, hashed_pwd);
      ResultSet resultSet = pstmt.executeQuery();

      if(Database_access.resultset_is_null_or_empty(resultSet)) {
        return 0; // no results on query - return user "0";
      }

      resultSet.next(); //move to the first set of results.
      return resultSet.getInt("user_id"); //success!
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return 0;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  /**
    * stores information on the user when they login, things like
    * their ip, time they logged in, that they are in fact logged in,
    * etc.
    * also,
    * takes the user id, the ip, and a timestamp and encrypts
    * that into a string value which we will use as the cookie.
    * the value to encrypt will look like this:
    * USER_ID|IP|TIMESTAMP
    * for example:
    * "123|108.91.12.198|2014-01-02 13:04:19"
    * Notice the delimiter is a pipe symbol.
    * when we get the cookie, we'll extract those
    * values and use them to authenticate.
    *
    * @param user_id the user's id, an int.
    * @param ip the user's ip.
    * @return an encrypted cookie
    */
  public static String 
    register_user(int user_id, String ip) {

      if (user_id < 0) {
        System.err.println("error: user id was " + 
            user_id + " in register_details_on_user_login");
        return null;
      }
      String ip_address = ip;
      if (ip_address == null || ip_address.length() == 0) {
        ip = "error: no ip in request";
      }

      String sqlText = 
        "UPDATE user " + 
        "SET is_logged_in = 1, last_time_logged_in = UTC_TIMESTAMP(), " + 
        "last_ip_logged_in = ? " + 
        "WHERE user_id = ?";

      PreparedStatement pstmt = null;
      try {
        Connection conn = Database_access.get_a_connection();
        pstmt = conn.prepareStatement(
						sqlText, Statement.RETURN_GENERATED_KEYS);     
        pstmt.setString( 1, ip);
        pstmt.setInt( 2, user_id);
        Database_access.execute_update(pstmt);
        return "";
      } catch (SQLException ex) {
        Database_access.handle_sql_exception(ex);
        return null;
      } finally {
        Database_access.close_statement(pstmt);
      }
  }


  /**
    * tries logging out the user.  If successful, return true
    * @param user_id the user id in question
    * @return true if successful
    */
  public static boolean logout_user(int user_id) {
    if (user_id < 0) {
      System.err.println("error: user id was " + user_id + 
          " in set_user_not_logged_in()");
      return false;
    }
    return set_user_not_logged_in(user_id);
  }

  /**
    * we just look up the user.  If they are logged in, we
    * return the user id.  if failed, return -1;
    * @param r the request object
    * @return a valid user id if allowd.  -1 otherwise.
    */
  public static int check_if_allowed(HttpServletRequest r) {
    Cookie[] cookies = r.getCookies();
    Cookie c = find_security_cookie(cookies);
    if (c == null) {
      return -1;
    }
    Integer user_id = Utils.parse_int(c.getValue());
    if (user_id == null) { return -1; }
    if (user_id < 0) {
      System.err.println("error: user id was " + user_id + 
          " in user_is_logged_in()");
      return -1;
    }
    boolean is_logged_in = user_is_logged_in(user_id);
    if (is_logged_in) {
      return user_id;
    }
    return -1; //-1 means not allowed or failure.
  }

  /**
    * given all the cookies the client sent us, 
    * find the one that belongs to us. It will have a name
    * of "xenos_cookie"
    * @param all_cookies a string array of all the cookies for this domain.
    * @return the one cookie we want.
    */
  private static Cookie find_security_cookie(Cookie[] all_cookies) {
    if (all_cookies == null) {
      return null;
    }
    for (Cookie cookie : all_cookies) {
      if (cookie.getName().equals("xenos_cookie")) {
        return cookie;
      }
    }
    return null;
  }


}
