package com.renomad.xenos;

/**
  * This stores information about a location that might 
  * be relevant to a requestoffer.  Postal code, street
  * address, that sort of thing.
  * This class is immutable.
  */
public class User_location {

  public final int id;
  public final String str_addr_1;
  public final String str_addr_2;
  public final String city;
  public final String state;
  public final String postcode;
  public final String country;

  public User_location (
      int id, String str_addr_1, String str_addr_2, 
      String city, String state, String postcode, String country ) {
    this.id = id;
    this.str_addr_1 = str_addr_1;
    this.str_addr_2 = str_addr_2;
    this.city = city;
    this.state = state;
    this.postcode = postcode;
    this.country = country;
  }

}
