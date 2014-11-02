package com.renomad.qarma;

import com.renomad.qarma.Database_access;

public class Tester {

  public static String[] cool() {
    String[] mystrings = {
      "apple", "banana" 
    };
    return mystrings;
  }

  public static void add_user(String username) {
    Database_access.add_user(username);
  }

}
