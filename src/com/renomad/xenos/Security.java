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
import java.sql.CallableStatement;

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
    * checks that the invite code given exists in the table
    * @return true if success, false otherwise
    */
  public static boolean is_valid_invite_code(String invite_code) {
    // 1. set the sql
    String check_icode_sql = 
      "SELECT COUNT(*) AS icodes_found FROM invite_code WHERE value = ?";
    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, check_icode_sql);     
      pstmt.setString(1,invite_code);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return false;
      }

      resultSet.next();
      int count_icodes_found = resultSet.getInt("icodes_found");
      if (count_icodes_found == 1) { //if and only if it's 1 do we proceed.
        return true;
      }
      return false;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * given a user id, sets up an invite code tied to that
    * user and adds an audit.
    * @return an invite code or empty string if failure.
    */
  public static String generate_invite_code(int user_id) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall("{call generate_invite_code(?,?)}");
      cs.setInt(1, user_id);
      cs.registerOutParameter(2, java.sql.Types.VARCHAR);
      cs.execute();
      String invite_code = cs.getString(2);
      return invite_code;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return "";
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
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
          " logout_user ");
      return false;
    }
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall(
          String.format("{call user_logout(%d)}" , user_id));
      cs.execute();
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
    return true;
  }


  /**
    * checks the password based on the username, the user's unique key
    *
    * @return the user id if the password is correct for that 
		*  username, 0 otherwise
    */
  public static int check_login(String username, String password, String ip_address) {
    String salt = User_utils.get_user_salt(username);
    String hashed_pwd = User_utils.hash_password(password, salt);
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall("{call check_login(?,?,?,?)}");
      cs.setNString( 1, username.trim()); //chop off whitespace front and back
      cs.setString( 2, hashed_pwd);
      cs.setString( 3, ip_address);
      cs.registerOutParameter(4, java.sql.Types.INTEGER);
      cs.execute();
      Integer user_id_found = cs.getInt(4);
			if (cs.wasNull()) {
				return 0;
			}
      return user_id_found;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return 0;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
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

      // simple guard clauses for empty values
      if (user_id < 0) {
        System.err.println("error: user id was " + 
            user_id + " in register_details_on_user_login");
        return null;
      }
      String ip_address = ip;
      if (ip_address == null || ip_address.length() == 0) {
        ip = "error: no ip in requestoffer";
      }

    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      // see db_scripts/v1_setup.sql for
      // details on this stored procedure.
      
      cs = conn.prepareCall(String.format(
        "{call register_user_and_get_cookie(%d, ?,?)}" 
        , user_id));
      cs.setString(1,ip);
      cs.registerOutParameter(2, java.sql.Types.VARCHAR);
      cs.execute();
      String cookie = cs.getString(2);
      return cookie;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return "ERROR_IN_ENCRYPTING_COOKIE";
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
  }



  /**
    * We go looking for the cookie.  Once we get that, we send it
    * to a stored procedure which checks that it is valid, and if
    * so, it returns the user id.  if failed, return -1;
    * @param r the requestoffer object
    * @param update_last_activity if this is true, then running this
    * command will update the timestamp for the last activity on the user
    * this is used to work with timeout on users.  It should be false
    * in cases like getting temporary messages, where it's the script
    * running the command, not the user taking action.
    * @return a valid user id if allowd.  -1 otherwise.
    */
  public static int 
    check_if_allowed(HttpServletRequest r, boolean update_last_activity) {
    Cookie[] cookies = r.getCookies();
    Cookie c = find_security_cookie(cookies);
    if (c == null) {
      return -1;
    }
    String cookie_value = c.getValue();
    String ip_address = Utils.get_remote_address(r);

    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      // see db_scripts/v1_setup.sql for
      // details on this stored procedure.
      
      cs = conn.prepareCall(
          "{call decrypt_cookie_and_check_validity(?,?,?,?)}"); 
      cs.setString(1, cookie_value);
      cs.setBoolean(2, update_last_activity);
      cs.setString(3, ip_address);
      cs.registerOutParameter(4, java.sql.Types.INTEGER);
      cs.executeQuery();
      int user_id = cs.getInt(4);
      return user_id;
    } catch (SQLException ex) {
      String msg = ex.getMessage();
      if (!msg.contains("null when trying to unencrypt cookie")) {
        Database_access.handle_sql_exception(ex);
      }
      return -1;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
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
