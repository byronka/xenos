package com.renomad.qarma;

/**
	* Utils holds utilities that apply across many situations
	*/
public class Utils {

  /**
    * helps with boilerplate for validation of whether input
    * is null or empty.
    */
  public static void null_or_empty_string_validation(String value) {
    if (value == null || value == "") {
      System.err.println(
          "error: value was null or empty when it shouldn't have");
    }
  }

  public static int parse_int(String s) {
    int val;
    try
    {
         val = Integer.parseInt(s);
    }
    catch (Exception ex)
    {
         // bad data - set to sentinel
         val = Integer.MIN_VALUE;
    }
    return val;
  }
}
