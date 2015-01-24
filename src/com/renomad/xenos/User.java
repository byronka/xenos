package com.renomad.xenos;


/**
  * User encapsulates the core traits of a user.  It is an immutable object.
  * note that the fields are public, but final.  Once this object
  * gets constructed, there is no changing it.  You have to create a
  * new one.
  */
public class User {

  public final String username;
  public final String password;
  public final int points;

  public User (
      String username, String password, int points) {
    this.username = username;
    this.password = password;
    this.points = points;
  }
  
  
}
