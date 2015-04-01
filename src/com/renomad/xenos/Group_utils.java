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

  public static Group get_group(int group_id) {
    return null;
  }

}

