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
    * sets a description that will be publicly viewable
    * for the user.
    * @param coid the country id
    * @param poid the postal code id - the code in our database, *not* the actual postal code
    * @return true if successful, false otherwise
    */
  public static boolean edit_user_current_location(
      int user_id, Integer coid, Integer poid) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      cs = conn.prepareCall("{call edit_user_current_location(?,?,?)}");
      cs.setInt(1,user_id);
      if (coid != null) {
        cs.setInt(2, coid);
      } else {
        cs.setNull(2, java.sql.Types.INTEGER);
      }
      if (poid != null) {
        cs.setInt(3, poid);
      } else {
        cs.setNull(3, java.sql.Types.INTEGER);
      }
      cs.execute();
      return true;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
  }


  /**
    * the possible results from setting a new email.
    */
  public enum Set_email_result { OK, GENERAL_ERR, EXISTING_EMAIL}

  /**
    * sets an email for a user
    * @return true if successful, false otherwise
    */
  public static Set_email_result set_email (
      int user_id, String email) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall("{call set_email(?,?)}");
      cs.setInt(1,user_id);
      cs.setNString(2,email);
      cs.execute();
      return Set_email_result.OK;
    } catch (SQLException ex) {
      String msg = ex.getMessage();
      if (msg.contains("Duplicate entry")) {
        return Set_email_result.EXISTING_EMAIL;
      }
      Database_access.handle_sql_exception(ex);
      return Set_email_result.GENERAL_ERR;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
  }


  /**
    * sets a description that will be publicly viewable
    * for the user.
    * @return true if successful, false otherwise
    */
  public static boolean edit_description(
      int user_id, String description) {
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall("{call set_user_description(?,?)}");
      cs.setInt(1,user_id);
      cs.setNString(2,description);
      cs.execute();
      return true;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
      Database_access.close_connection(conn);
    }
  }


  /**
    * gets the user's current email, or "(none)" if none.
    */
  public static String
    get_current_email(int user_id) {
    String sqlText = 
      "SELECT email "+
      "FROM user "+
      "WHERE user_id = ?";
    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return "";
      }

      resultSet.next(); //move to the first set of results.
      String email = resultSet.getNString("email");
      if (Utils.is_null_or_empty(email)) {
        return "(none)";
      }
      return email;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return "(none)";
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * returns the publicly viewable description of a 
    * user, or empty string otherwise.
    */
  public static String
    get_user_description(int user_id) {
    String sqlText = 
      "SELECT text "+
      "FROM user_description "+
      "WHERE user_id = ?";
    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return "";
      }

      resultSet.next(); //move to the first set of results.
      String text = resultSet.getNString("text");
      return text;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return "";
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }

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
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      resultSet = pstmt.executeQuery();
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
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * given a name, gets the user id
    * @return the id for this user, or -1 if not found
    */
  public static int get_user_id_by_name(String username) {

    String sqlText = 
      "SELECT user_id "+
      "FROM user WHERE username = ?";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setNString(1, username);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return -1;
      }

      resultSet.next();
      int uid = resultSet.getInt("user_id");
      return uid;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return -1;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * returns true if this user has already offered to handle
    * this request, or false if otherwise.
    */
  public static boolean 
    has_offered_to_service(int requestoffer_id, int user_id) {
    String sqlText = 
      "SELECT COUNT(*) AS count_of_offered "+
      "FROM requestoffer_service_request "+
      "WHERE user_id = ? AND requestoffer_id = ?";
    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      pstmt.setInt( 2, requestoffer_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return false;
      }

      resultSet.next(); //move to the first set of results.
      int count = resultSet.getInt("count_of_offered");
      boolean has_offered = count > 0;
      return has_offered;
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
    * gets the salt for a given user.
    * @param username the username for the user
    * @return the salt for the user, used in hashing 
    *   password, or empty if failure
    */
  public static String get_user_salt(String username) {
    String sqlText = "SELECT salt FROM user WHERE username = ?;";
    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setNString( 1, username);
      resultSet = pstmt.executeQuery();
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
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
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
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
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
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
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
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
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
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * gets a user's salt
    *  
    * @return a salt string for a given user, or null if not found.
    */
  public static String get_user_salt(int user_id) {
    String sqlText = 
      "SELECT salt FROM user WHERE user_id = ?;";
    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next(); //move to the first set of results.
      String salt = resultSet.getString("salt");
      return salt;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }

  
  /**
    * gets a user object
    *  
    * @return a User object, or null if not found.
    */
  public static User get_user(int user_id) {
    String sqlText = 
      "SELECT COUNT(urdp.judged_user_id) AS urdp_count,"+
      "u.username,u.points,  " +
      "u.timeout_seconds, u.rank_average, u.rank_ladder, "+
      "pc.postal_code, u.postal_code_id, u.country_id  " +
      "FROM user u  " +
      "LEFT JOIN user_rank_data_point urdp  " +
      "  ON urdp.judged_user_id = u.user_id "+
        "AND urdp.is_inside_window = 1 " +
      "LEFT JOIN postal_codes pc ON pc.postal_code_id = u.postal_code_id "+
        "AND pc.country_id = u.country_id " +
      "WHERE u.user_id = ?  " +
      "GROUP BY urdp.judged_user_id ";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setInt( 1, user_id);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      resultSet.next(); //move to the first set of results.
      String username = resultSet.getNString("username");
      int points = resultSet.getInt("points");
      int timeout_seconds = resultSet.getInt("timeout_seconds");
      float rank_av = resultSet.getFloat("rank_average");
      int rank_ladder = resultSet.getInt("rank_ladder");
      int urdp_count = resultSet.getInt("urdp_count");
      Integer postal_code_id = resultSet.getInt("postal_code_id");
      if (resultSet.wasNull()) {
        postal_code_id = null;
      }
      Integer country_id = resultSet.getInt("country_id");
      if (resultSet.wasNull()) {
        country_id = null;
      }
      String postal_code = resultSet.getString("postal_code");
      if (resultSet.wasNull()) {
        postal_code = "";
      }
      return new User(username, "", points, 
          timeout_seconds, rank_av, rank_ladder, 
          urdp_count, postal_code_id, country_id, postal_code);
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * changes the user's password. This service will change
    * the user's password no matter what - it is assumed that
    * the developer has checked beforehand that the user
    * is indeed valid, like by running check_login() first.
    * @param executing_user_id the user causing the password change.
    * @param user_id the user whose password we'll change
    * @param new_password this will be their new password
    * @return true if successful at changing the password
    */
  public static boolean change_password(
      int executing_user_id, int user_id, String new_password) {
    String salt = get_user_salt(user_id);
    String hashed_pwd = hash_password(new_password, salt);
    CallableStatement cs = null;
    Connection conn = Database_access.get_a_connection();
    try {
      cs = conn.prepareCall("{call change_password(?,?,?)}");
      cs.setInt(1,executing_user_id);
      cs.setInt(2,user_id);
      cs.setString(3,hashed_pwd);
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
    * the possible results from creating a new user.
    */
  public enum Put_user_result { OK, GENERAL_ERR, INVALID_ENTRY, EXISTING_USERNAME, INVALID_INVITE_CODE}


  /**
    * adds a user.  Will check that values were entered for required
    * fields, and if so, will create the user.  Note that at that
    * point, the database has constraints which might cause failure
    * still.  
    * @param invite_code users generate a code to invite 
    * their buddies to the system.  With this code, the user 
    *  is allowed to register. (disabled during beta)
    * @return true if successful
    */
  public static Put_user_result 
    put_user(String username, String password, String ip_address, String invite_code) {

      if ( Utils.is_null_or_empty(username) ||
           Utils.is_null_or_empty(password) ||
           password.length() < 8) {
        return Put_user_result.INVALID_ENTRY;
      }

    if (username.trim().indexOf(" ") > -1) {
      //no spaces allowed in username
      return Put_user_result.INVALID_ENTRY;
    }

      CallableStatement cs = null;
      Connection conn = Database_access.get_a_connection();
      try {
        cs = conn.prepareCall("{call create_new_user(?,?,?,?,?)}");
        cs.setNString(1,username);
        //make a salt we'll use for hashing.
        String salt = Long.toString(
						ThreadLocalRandom.current().nextLong(Long.MAX_VALUE));
        String hashed_pwd = hash_password(password, salt);
        cs.setString(2,hashed_pwd);
        cs.setString(3,salt);
        cs.setString(4,ip_address);
        cs.setString(5,invite_code);
        cs.execute();
      } catch (SQLException ex) {
				String msg = ex.getMessage();
				if (msg.contains("Duplicate entry") ||
					msg.contains("username matches existing")) {
					return Put_user_result.EXISTING_USERNAME;
				}
        if (msg.contains("invite code is invalid")) {
					return Put_user_result.INVALID_INVITE_CODE;
        }
        Database_access.handle_sql_exception(ex);
        return Put_user_result.GENERAL_ERR;
      } finally {
        Database_access.close_statement(cs);
        Database_access.close_connection(conn);
      }
      return Put_user_result.OK;
  }


  public static boolean is_valid_invite_code (String icode) {

    if ( Utils.is_null_or_empty(icode)) {
      return false;
    }

    String sqlText = 
      "SELECT user_id " +
      "FROM invite_code " +
      "WHERE value = ?";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setString( 1, icode);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return false;
      }

      resultSet.next(); //move to the first set of results.
      int inviter_id = resultSet.getInt("user_id");
      return inviter_id > 0;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  public static Put_user_result is_valid_username (String username, String icode) {

    if ( Utils.is_null_or_empty(username)) {
      return Put_user_result.INVALID_ENTRY;
    }

    if (username.trim().indexOf(" ") > -1) {
      //no spaces allowed in username
      return Put_user_result.INVALID_ENTRY;
    }

    // Note: this is turned off in the beta.  Turn it
    // back on for full version.
    // if (!is_valid_invite_code(icode)) {
    //  return Put_user_result.INVALID_INVITE_CODE;
    //}

    String sqlText = 
      "SELECT COUNT(*) AS existing_username_count "+
      "FROM user u  " +
      "WHERE (u.username = ? OR u.email = ?) ";

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    ResultSet resultSet = null;
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      pstmt.setNString( 1, username);
      pstmt.setNString( 2, username);
      resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return Put_user_result.GENERAL_ERR;
      }

      resultSet.next(); //move to the first set of results.
      int count = resultSet.getInt("existing_username_count");
      if (count > 0) {
        return Put_user_result.EXISTING_USERNAME;
      }
      if (count < 0) {
        return Put_user_result.GENERAL_ERR;
      }
      return Put_user_result.OK;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return  Put_user_result.GENERAL_ERR;
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
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

