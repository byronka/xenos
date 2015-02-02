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
  public final int timeout_seconds;

  public User (
      String username, String password, int points, int timeout_seconds) {
    this.username = username;
    this.password = password;
    this.points = points;
    this.timeout_seconds = timeout_seconds;
  }
  
  
}
