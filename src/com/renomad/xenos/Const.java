package com.renomad.xenos;

/**
  * constants used in the system - a helper for some
  * values coming from the database. Important considerations:
  * In the interest of YAGNI (You Ain't Gonna Need It), there's
  * no need to have *all* the constants in the system here.  The
  * driver of this file is the fact that there were a number of
  * places in .jsp and .java files where we were using magic numbers.
  * For example, if (status == 106) { //blah }.  That makes for a 
  * painful development experience.  This file's purpose is to
  * alleviate that pain, and nothing else.  There are other places
  * where constants are used, for example, in auditing.  But in those
  * cases it is crucial that the developer have the table of values
  * in front of them while adding the audit code.  There is no clear
  * advantage to duplicating each of dozens of values in order to
  * represent it as a name, when it is perfectly clear looking at the
  * table.  Further, with so many values, it is likely an error in
  * transcription could occur.
  */
public final class Const {



  private Const() {
    // don't want anyone instantiating this.
    // private constructor should do the trick.
  }



  /**
    * Requestoffer statuses.  Note that these id's values
    * come from their localization values.
    */
  public final static class Rs {

    /**
      * a requestoffer open and available for handling
      */
    public static final int OPEN = 76;

    /**
      * a completed requestoffer - fully handled.
      */
    public static final int CLOSED = 77;

    /**
      * this requestoffer is being handled right now.
      */
    public static final int TAKEN = 78;

    /**
      * no one but the owner of the requestoffer can see it right now.
      */
    public static final int DRAFT = 109;
  }



  /**
    * Requestoffer_service_request_status - shows the state of
    * an offer to handle a requestoffer.  When the offer is first
    * made, it is new.  When the owner chooses to accept one, it
    * becomes accepted and all the others become rejected.
    * Note that these values come from their localization values.
    */
  public final static class Rsrs {
    public static final int NEW = 106;
    public static final int ACCEPTED = 107;
    public static final int REJECTED = 108;
  }

}
