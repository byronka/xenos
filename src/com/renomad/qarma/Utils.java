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
    */
  public static void null_or_empty_string_validation(String value) {
    if (value == null || value.equals("")) {
      System.err.println(
          "error: value was null or empty when it shouldn't have");
    }
  }

  public static String getCurrentDateSqlFormat() {
    //all this just to get the date in a nice format for SQL!
    // like this: 2014-11-23 20:02:01
    java.util.Calendar cal = java.util.Calendar.getInstance();
    java.util.Date date = cal.getTime();
    java.text.SimpleDateFormat myformat = 
			new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
    String formattedDate = null;
    try {
      formattedDate = myformat.format(date);
    } catch (Exception e1) {
      System.err.println(
					"somehow, there was a failure with formatting the date!");
      System.err.println(e1);
    }
    return formattedDate;
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
