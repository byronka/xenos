package com.renomad.xenos;

/**
  * constants used in the system - a helper for some
  * values coming from the database.
  */
public final class Const {

  private Const() {
    // don't want anyone instantiating this.
    // private constructor should do the trick.
  }

  /**
    * Requestoffer statuses
    */
  public final static class Rs {
    public static final int OPEN = 76;
    public static final int CLOSED = 77;
    public static final int TAKEN = 78;
    public static final int DRAFT = 109;
  }

}
