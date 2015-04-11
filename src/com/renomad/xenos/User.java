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
  public final float rank_av; // shows average rank - only show this if urdp_count > 30
  public final int rank_ladder; // shows contemporary status on rank
  public final int urdp_count; // count of rankings in this rolling window
  public final Integer postal_code_id; 
  public final Integer country_id; 
  public final String postal_code;


  public User (
      String username, String password, int points, 
      int timeout_seconds, float rank_av, int rank_ladder, 
      int urdp_count, Integer postal_code_id, 
      Integer country_id, String postal_code) {
    this.username = username;
    this.password = password;
    this.points = points;
    this.timeout_seconds = timeout_seconds;
    this.rank_av = rank_av;
    this.rank_ladder = rank_ladder;
    this.urdp_count = urdp_count;
    this.postal_code_id = postal_code_id;
    this.country_id = country_id;
    this.postal_code = postal_code;
  }
  
  
}
