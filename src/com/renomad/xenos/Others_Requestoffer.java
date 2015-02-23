package com.renomad.xenos;

import com.renomad.xenos.Requestoffer;

/**
  * a class used to display a succinct summary of other users' Requestoffers
  * We add a few items here that will be necessary for display.
  * Immutable, because this is and so is Requestoffer.
  */
public class Others_Requestoffer extends Requestoffer {

  /**
    * rank is the rank of the user who created the requestoffer.
    */
  public final float rank;
  public final String postcodes;
  public final String cities;
  public final boolean has_been_offered; // if the user requesting to see the requestoffers has already offered to handle this.

  public Others_Requestoffer(
      String date, String desc, int status,
      float rank, int points, int requestoffer_id, 
      int requestoffering_user_id,
      int handling_user_id, Integer[] categories, 
      boolean has_been_offered, String postcodes, String cities) {
    super(requestoffer_id, date, desc, points,
        status, requestoffering_user_id, handling_user_id, categories);
    this.rank = rank;
    this.has_been_offered = has_been_offered;
    this.postcodes = postcodes;
    this.cities = cities;
  }

}
