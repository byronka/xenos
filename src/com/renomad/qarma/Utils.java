package com.renomad.qarma;

import java.util.HashMap;
import java.util.Map;

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
  public static boolean is_null_or_empty(String value) {
    return value == null || value.equals("");
  }
  
  
  /**
   * Safe render is crucial to displaying text that came from the outside,
   * Like from a user or third party app.  This is to protect against some
   * security vulnerabilities.  Specifically, like those where the user maliciously
   * writes their name as &lt;script&gt;alert(1)&lt;/script&gt;
   * This makes things safe by taking the important, special characters for
   * less-than and greater-than and making them their equivalent codes.
   * The browsers will know how to render this.
   * @param s the string from the database
   * @return a string safe for display in a browser.
   */
  public static String safe_render(String s) {
	  return s.replaceAll("<", "&lt;")
			  .replaceAll(">", "&gt;");
  }

	/**
		* gets all the parameters from a query string
		* @param qs a query string from a url string
		* @return a map of params to values, as strings.  It is
		* incumbent upon you to convert strings as needed.
		*/
	public static Map<String, String> parse_qs(String qs) {
		String[] params = qs.split("&");
		if (params.length == 0) {
			return null;
		}
		Map<String,String> values = new HashMap<String,String>();
		for (String p : params) {
			String[] items = p.split("=");
			if (items.length != 2) {
				continue;
			}
			values.put(items[0], items[1]);
		}
		return values;
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
