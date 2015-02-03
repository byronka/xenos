package com.renomad.xenos;



/**
  * Requestoffer_status is the enumeration of requestoffer statuses.  
  * It is an immutable object.
  * note that the fields are public, but final.  Once this object
  * gets constructed, there is no changing it.  You have to create a
  * new one.
  */
public class Requestoffer_status {

  public final int status_id;
  public final String status_value;

  public Requestoffer_status ( int status_id, String status_value) {
    this.status_id       =  status_id;
    this.status_value    =  status_value;
  }

}
