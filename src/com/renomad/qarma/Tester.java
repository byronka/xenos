package com.renomad.qarma;

import com.renomad.qarma.Database_access;
import java.util.ArrayList;

public class Tester {

  public static String[] get_users() {
    ArrayList<String> all_users = Database_access.get_all_users();
    String[] array_of_users = all_users.toArray(new String[all_users.size()]);
    return array_of_users;
  }

  public static void add_user(String username) {
    Database_access.add_user(username);
  }

}
