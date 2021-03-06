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
  public final float rank_av;
  public final int rank_ladder;
  public final Double distance; //distance from user's current location to this requestoffer
  public final boolean has_been_offered; // if the user requesting to see the requestoffers has already offered to handle this.

  public Others_Requestoffer(
      String date, String desc, int status,
      float rank_av, int rank_ladder, int points, int requestoffer_id, 
      int requestoffering_user_id,
      int handling_user_id, int category, 
      boolean has_been_offered, String postcode, String details, Double distance) {
    super(requestoffer_id, date, desc, points,
        status, requestoffering_user_id, handling_user_id, category, postcode, details);
    this.rank_av = rank_av;
    this.rank_ladder = rank_ladder;
    this.has_been_offered = has_been_offered;
    this.distance = distance;
  }

}
