package com.renomad.xenos;

import java.util.Arrays;

/**
  * Requestoffer encapsulates a user's requestoffer.  It is an immutable object.
  * note that the fields are public, but final.  Once this object
  * gets constructed, there is no changing it.  You have to create a
  * new one.
  */
public class Requestoffer {

  public final int requestoffer_id;
  public final String datetime;
  public final String description;
  public final int points;
  public final int status;
  public final int requestoffering_user_id;
  public final int handling_user_id;
  public final int category;

  /**
    * This constructor is probably used for sending a new
    * requestoffer to be added to the database, therefore we won't
    * have the requestoffer id yet.
    */
  public Requestoffer ( String datetime, String description, 
      int points, int status, 
      int requestoffering_user_id, 
      int handling_user_id, int category) {
    this(-1, datetime, description, points,
        status, requestoffering_user_id, handling_user_id, category);
  }

  public Requestoffer ( int requestoffer_id, String datetime, 
      String description, int points, int status, 
      int requestoffering_user_id, int handling_user_id,
      int category) {
    this.requestoffer_id       =  requestoffer_id;
    this.datetime         =  datetime;
    this.description      =  description;
    this.points           =  points;
    this.status           =  status;
    this.requestoffering_user_id  =  requestoffering_user_id;
    this.handling_user_id  =  handling_user_id;
    this.category       =  category;
  }

}
