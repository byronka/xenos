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
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;


/**
  * Utilities methods used to work with users
  */
public final class Group_utils {

  private Group_utils() {
    //do nothing - prevent instantiation
  }


  /**
    * holds relevant details for view of a group.  Immutable.
    */
  public static class Group {

    private final Map<Integer, String> members;
    public final String description;
    public final String group_name;
    public final int owner_id; // the owner of this group
    public final String owner_username; 

    public Group(Map<Integer, String> members, String description, 
        String group_name, int owner_id, String owner_username) {
      this.members = new HashMap<Integer, String>(members);
      this.description = description;
      this.group_name = group_name;
      this.owner_id = owner_id;
      this.owner_username = owner_username;
    }

    public Map<Integer, String> get_members() {
			return new HashMap<Integer, String>(members);
    }
  }


  /**
    * a simple class used to display a user's membership to groups
    */
  public static class Group_id_and_name {
    public final int id;
    public final String name;
    public Group_id_and_name(int id, String name) {
      this.id = id;
      this.name = name;
    }
  }


  /**
    * the possible results from creating a new group.
    */
  public enum Create_group_result { OK, EMPTY_NAME, GENERAL_ERR}

  /**
    * creates a new user group.
    * @param group_name the name of the group, maximum 50 chars
    * @param group_desc the description of the group
    * @param owner_id the new owner of the group
    * @return an enum indicating success or a potential few errors, Create_group_result
    */
  public static Create_group_result create_new_group(String group_name, String group_desc, int owner_id) {

      if ( Utils.is_null_or_empty(group_name)) {
        return Create_group_result.EMPTY_NAME;
      }

      CallableStatement cs = null;
      try {
        Connection conn = Database_access.get_a_connection();
        cs = conn.prepareCall("{call create_user_group(?,?,?)}");
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


  /**
    * gets the groups a user is a member of
    * @param find_owned_groups if true, we return only those groups this
    *   user owns.  Otherwise, all groups they are member of.
    */
  public static Group_id_and_name[] get_groups_for_user(int user_id, boolean find_owned_groups) {
    String sqlText = 
      String.format(
        "SELECT ug.group_id, ug.name "+
        "FROM user_group ug " +
        "JOIN user_to_group utg ON utg.group_id = ug.group_id " +
        "WHERE utg.user_id = %d",
            user_id);

    if (find_owned_groups) {
      sqlText += String.format(" AND ug.owner_id = %d ", user_id);
    }

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Group_id_and_name[0];
      }

      ArrayList<Group_id_and_name> groups = new ArrayList<Group_id_and_name>();
      while(resultSet.next()) {
        int gid = resultSet.getInt("group_id");
        String name = resultSet.getNString("name");
        Group_id_and_name gian = new Group_id_and_name(gid, name);
        groups.add(gian); 
      }

      Group_id_and_name[] array_of_groups = 
        groups.toArray(new Group_id_and_name[groups.size()]);
      return array_of_groups;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Group_id_and_name[0];
    } finally {
      Database_access.close_statement(pstmt);
    }
  }


  /**
    * gets details of a particular group by id
    * @return a group with all sorts of fun stuff, or null if failure.
    */
  public static Group get_group(int group_id) {

    String sqlText = 
      String.format(
        "SELECT ug.name, ug.owner_id, owninguser.username AS owner_username, utg.user_id, gd.text, u.username "+
        "FROM user_group ug " +
        "JOIN user_to_group utg ON utg.group_id = ug.group_id " +
        "JOIN group_description gd ON gd.group_id = ug.group_id " +
        "JOIN user u ON u.user_id = utg.user_id " +
        "JOIN user owninguser ON owninguser.user_id = ug.owner_id " +
        "WHERE ug.group_id = %d",
            group_id);

    PreparedStatement pstmt = null;
    try {
      Connection conn = Database_access.get_a_connection();
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return null;
      }

      int oid = -1; // the owner id
      String name = ""; // the name of the group
      String owner_username = ""; 
      String description = ""; // the description of the group
      Map<Integer, String> members = new HashMap<Integer, String>();

      while(resultSet.next()) {
        // all the values for name, and owner id will be the same
        // so just grab them each time, they get overwritten each
        // time but so what.  The alternative is multiple queries,
        // which sucks more.
        name = resultSet.getNString("name");
        description = resultSet.getNString("text");
        owner_username = resultSet.getNString("owner_username");
        oid = resultSet.getInt("owner_id");

        // on the other hand, *these* values change each time
        int member_id = resultSet.getInt("user_id");
        String username = resultSet.getNString("username");

        members.put(member_id, username);
      }

      Group my_group = new Group(members, description, name, oid, owner_username);
      return my_group;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return null;
    } finally {
      Database_access.close_statement(pstmt);
    }
  }

}

