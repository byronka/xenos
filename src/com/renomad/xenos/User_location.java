package com.renomad.xenos;

/**
  * This stores information about a location that might 
  * be relevant to a requestoffer.  Postal code, place details, 
  *  that sort of thing.
  * This class is immutable.
  */
public class User_location {

  public final int id;
  public final String details;
  public final String postcode;
  public final String country;

  public User_location (
      int id, String details, String postcode, String country ) {
    this.id = id;
    this.details = details;
    this.postcode = postcode;
    this.country = country;
  }

}
