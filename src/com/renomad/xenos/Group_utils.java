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
  * Utilities methods used to work with groups
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
    * @return an enum indicating success or a potential 
    *    few errors, Create_group_result
    */
  public static Create_group_result 
    create_new_group(String group_name, String group_desc, int owner_id) {

      if ( Utils.is_null_or_empty(group_name)) {
        return Create_group_result.EMPTY_NAME;
      }

      CallableStatement cs = null;
      Connection conn = Database_access.get_a_connection();
      try {
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
      Database_access.close_resultset(resultSet);
        Database_access.close_statement(cs);
        Database_access.close_connection(conn);
      }

  }


  /**
    * gets the groups a user is a member of
    * @param find_owned_groups if true, we return only those groups this
    *   user owns.  Otherwise, all groups they are member of.
    */
  public static Group_id_and_name[] 
    get_groups_for_user(int user_id, boolean find_owned_groups) {
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
    Connection conn = Database_access.get_a_connection();
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Group_id_and_name[0];
      }

      ArrayList<Group_id_and_name> groups = 
        new ArrayList<Group_id_and_name>();
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
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * returns true if this user is a member of this group, false otherwise
    */
  public static boolean
    is_member_of_group(int user_id, int group_id) {
    String sqlText = 
      String.format(
        "SELECT COUNT(*) as the_count "+
        "FROM user_to_group " +
        "WHERE user_id = %d AND group_id = %d",
            user_id, group_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return false;
      }

      resultSet.next();
      int count = resultSet.getInt("the_count");

      return count == 1;
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
    * returns true if this user has an outstanding invitation to join
    */
  public static boolean
    has_been_invited(int user_id, int group_id) {
    String sqlText = 
      String.format(
        "SELECT COUNT(*) as the_count "+
        "FROM user_group_invite " +
        "WHERE user_id = %d AND group_id = %d",
            user_id, group_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return false;
      }

      resultSet.next();
      int count = resultSet.getInt("the_count");

      return count == 1;
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
    * gets details of a particular group by id
    * @return a group with all sorts of fun stuff, or null if failure.
    */
  public static Group get_group(int group_id) {

    String sqlText = 
      String.format(
        "SELECT ug.name, ug.owner_id, "+
        "owninguser.username AS owner_username, "+
        "utg.user_id, gd.text, u.username "+
        "FROM user_group ug " +
        "JOIN user_to_group utg ON utg.group_id = ug.group_id " +
        "JOIN group_description gd ON gd.group_id = ug.group_id " +
        "JOIN user u ON u.user_id = utg.user_id " +
        "JOIN user owninguser ON owninguser.user_id = ug.owner_id " +
        "WHERE ug.group_id = %d",
            group_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    try {
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

      Group my_group = 
        new Group(members, description, name, oid, owner_username);
      return my_group;
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
    * the possible results from sending an invite
    */
  public enum Send_invite_result { OK, DUPLICATE_INVITE, ALREADY_IN_GROUP, GENERAL_ERR}


  /**
    * sends an invite to a user.
    * @return true if success, false otherwise
    */
  public static Send_invite_result 
    send_group_invite_to_user(int owner_id, int group_id, int user_id) {
      CallableStatement cs = null;
      Connection conn = Database_access.get_a_connection();
      try {
        cs = conn.prepareCall(
            String.format(
              "{call send_group_invite_to_user(%d,%d,%d)}",
                owner_id, group_id, user_id));
        cs.execute();
        return Send_invite_result.OK;
      } catch (SQLException ex) {
        String msg = ex.getMessage();
        if (msg.equals("an invite has already been sent")) {
          return Send_invite_result.DUPLICATE_INVITE;
        } else if (msg.equals("this user already exists in the group")) {
          return Send_invite_result.ALREADY_IN_GROUP;
        } else {
          Database_access.handle_sql_exception(ex);
          return Send_invite_result.GENERAL_ERR;
        }
      } finally {
      Database_access.close_resultset(resultSet);
        Database_access.close_statement(cs);
        Database_access.close_connection(conn);
      }
  }


  /**
    * respond to an invite - accepted or rejected
    * @return true if success, false otherwise
    */
  public static boolean 
    respond_to_group_invite(boolean is_accepted, int group_id, 
        int user_id) {
      CallableStatement cs = null;
      Connection conn = Database_access.get_a_connection();
      try {
        cs = conn.prepareCall(
            String.format(
              "{call respond_to_group_invite(%b,%d,%d)}",
                is_accepted, group_id, user_id));
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
    * leave a group if you are a member, or remove a member from
    * your group if this is the owner doing it.
    * @return true if success, false otherwise
    */
  public static boolean leave_group(int group_id, int user_id) {
      CallableStatement cs = null;
      Connection conn = Database_access.get_a_connection();
      try {
        cs = conn.prepareCall(
            String.format(
              "{call leave_group(%d,%d)}", group_id, user_id));
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
    * leave a group if you are a member, or remove a member from
    * your group if this is the owner doing it.
    * @return true if success, false otherwise
    */
  public static boolean 
    remove_from_group(int owner_id, int group_id, int user_id) {
      CallableStatement cs = null;
      Connection conn = Database_access.get_a_connection();
      try {
        cs = conn.prepareCall(
            String.format(
              "{call remove_from_group(%d,%d,%d)}",
                owner_id, group_id, user_id));
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
    * gets a description for a user within a group.  Viewable only 
    * by group membes.
    * returns a description or empty string otherwise.
    */
  public static String 
    get_user_group_description(int group_id, int user_id) {
    String sqlText = 
      String.format(
        "SELECT text " +
        "FROM user_group_description " +
        "WHERE group_id = %d AND user_id = %d",
          group_id, user_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return "";
      }

      resultSet.next();
      String desc = resultSet.getNString("text");
      return desc;
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
    * sets a description for a user within a group.  Viewable only 
    * by group membes.
    */
  public static boolean 
    edit_user_group_description(int group_id, int user_id, String text) {
      CallableStatement cs = null;
      Connection conn = Database_access.get_a_connection();
      try {
        cs = conn.prepareCall(
            String.format(
              "{call edit_user_group_description(%d,%d,?)}",
                group_id, user_id));
        cs.setNString(1, text);
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
    * if you are an owner of a group and you extend an invitation to
    * someone, but then change your mind, you can use this to take
    * back the invitation, as long as it hasn't been accepted or 
    * rejected yet.  This method should only be called after first
    * checking that an invite exists for that user - if one exists,
    * then they haven't accepted or rejected - it gets deleted as soon
    * as they do.
    * @return true if success, false otherwise
    */
  public static boolean 
    retract_invitation(int owner_id, int group_id, int user_id) {
      CallableStatement cs = null;
      Connection conn = Database_access.get_a_connection();
      try {
        cs = conn.prepareCall(
            String.format(
              "{call retract_invitation(%d,%d,%d)}",
                owner_id, group_id, user_id));
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
    * a simple class used to display invite info for a group
    * used in a couple situations: listing the invites for a particular
    * user, and listing the invites sent out from a particular group.
    */
  public static class Invite_info {
    public final int group_id;
    public final String groupname;
    public final int user_id;
    public final String username;
    public final String date_sent;

    public Invite_info(int user_id, String username, 
        int group_id, String groupname, String date_sent) {
      this.group_id = group_id;
      this.groupname = groupname;
      this.user_id = user_id;
      this.username = username;
      this.date_sent = date_sent;
    }

  }


  /**
    * gets the invites a group has sent out.  Used to show the owner
    * of a group, and to allow that owner to retract invites if needed.
    * @return an array of invite infos, used for display on page, or
    * an empty array of them otherwise.
    */
  public static Invite_info[] get_invites_for_group(int group_id) {
    String sqlText = 
      String.format(
        "SELECT ugi.user_id, u.username, ugi.date_created " +
        "FROM user_group_invite ugi " +
        "JOIN user u ON u.user_id = ugi.user_id " +
        "WHERE ugi.group_id = %d ",
          group_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Invite_info[0];
      }

      ArrayList<Invite_info> invites = 
        new ArrayList<Invite_info>();
      while(resultSet.next()) {
        int uid = resultSet.getInt("user_id");
        String uname = resultSet.getNString("username");
        String dt = resultSet.getString("date_created");
        Invite_info ii = new Invite_info(uid, uname,-1,"", dt);
        invites.add(ii); 
      }

      Invite_info[] array_of_invites = 
        invites.toArray(new Invite_info[invites.size()]);
      return array_of_invites;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Invite_info[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * gets the invites offered to a particular user.
    * @return an array of invite infos, or
    * an empty array of them otherwise.
    */
  public static Invite_info[] get_invites_for_user(int user_id) {
    String sqlText = 
      String.format(
        "SELECT ug.group_id, ug.name, ugi.date_created " +
        "FROM user_group_invite ugi " +
        "JOIN user_group ug ON ug.group_id = ugi.group_id " +
        "WHERE ugi.user_id = %d ",
          user_id);

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Invite_info[0];
      }

      ArrayList<Invite_info> invites = 
        new ArrayList<Invite_info>();
      while(resultSet.next()) {
        int gid = resultSet.getInt("group_id");
        String gname = resultSet.getNString("name");
        String dt = resultSet.getString("date_created");
        Invite_info ii = new Invite_info(-1,"",gid, gname, dt);
        invites.add(ii); 
      }

      Invite_info[] array_of_invites = 
        invites.toArray(new Invite_info[invites.size()]);
      return array_of_invites;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return new Invite_info[0];
    } finally {
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }


  /**
    * gets the shared groups with another user
    * @param me the user id of my user
    * @param them the user id of the user I'm comparing to
    * @return group names and id's array, or empty array otherwise.
    */
  public static Group_id_and_name[] get_shared_groups(int me, int them) {
    String sqlText = 
      String.format(
        "SELECT DISTINCT user1.group_id, ug.name " +
        "FROM user_to_group user1 " +
        "JOIN user_to_group user2 " +
        "  ON user1.group_id = user2.group_id " +
        "JOIN user_group ug ON ug.group_id = user1.group_id " +
        "WHERE user1.user_id = %d AND user2.user_id = %d",
          me, them);
    

    PreparedStatement pstmt = null;
    Connection conn = Database_access.get_a_connection();
    try {
      pstmt = Database_access.prepare_statement(
          conn, sqlText);     
      ResultSet resultSet = pstmt.executeQuery();
      if (Database_access.resultset_is_null_or_empty(resultSet)) {
        return new Group_id_and_name[0];
      }

      ArrayList<Group_id_and_name> groups = 
        new ArrayList<Group_id_and_name>();
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
      Database_access.close_resultset(resultSet);
      Database_access.close_statement(pstmt);
      Database_access.close_connection(conn);
    }
  }

}

