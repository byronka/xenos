package com.renomad.qarma;

/**
	* Utils holds utilities that apply across many situations
	*/
public final class Utils {

	private Utils () {
		//we don't want anyone instantiating this
		//do nothing.
	}

  /**
    * helps with boilerplate for validation of whether input
    * is null or empty.
		* @return true if null or empty string
    */
  public static boolean null_or_empty_string_validation(String value) {
    return value == null || value.equals("");
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
