package com.renomad.xenos;


import com.renomad.xenos.Database_access;
import com.renomad.xenos.Utils;

import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;

import java.util.concurrent.ThreadLocalRandom;
import java.util.Arrays;


/**
  * Utilities methods used to work with users
  */
public final class Group_utils {

  private Group_utils() {
    //do nothing - prevent instantiation
  }

  public static class Group {

    private final String[] usernames;
    private final int[] user_ids; // the members of this group
    public final String description;
    public final int owner_id; // the owner of this group

    public Group(String[] usernames, int[] user_ids, 
        String description, int owner_id) {
			this.usernames = Arrays.copyOf(usernames, usernames.length);
			this.user_ids = Arrays.copyOf(user_ids, user_ids.length);
      this.description = description;
      this.owner_id = owner_id;
    }
  }


  /**
    * the possible results from creating a new group.
    */
  public enum Create_group_result { OK, EMPTY_DESC, EMPTY_NAME, GENERAL_ERR}

  /**
    * creates a new user group.
    * @param group_name the name of the group, maximum 50 chars
    * @param group_desc the description of the group
    * @param owner_id the new owner of the group
    * @return an enum indicating success or a potential few errors, Create_group_result
    */
  public static Group create_new_group(String group_name, String group_desc, int owner_id) {

      if ( Utils.is_null_or_empty(group_name)) {
        return Create_group_result.EMPTY_NAME;
      }

      if ( Utils.is_null_or_empty(group_desc)) {
        return Create_group_result.EMPTY_DESC;
      }

      CallableStatement cs = null;
      try {
        Connection conn = Database_access.get_a_connection();
        cs = conn.prepareCall("{call create_new_user_group(?,?,?)}");
        cs.setNString(1,group_name);
        cs.setNString(2,group_desc);
        cs.setInt(3,owner_id);
        cs.execute();
        return Create_group_result.OK;
      } catch (SQLException ex) {
        Database_access.handle_sql_exception(ex);
        return Create_group_result.GENERAL_ERR;
      } finally {
        Database_access.close_statement(cs);
      }

  }

  public static Group get_group(int group_id) {
    return null;
  }

}

