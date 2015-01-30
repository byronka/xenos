package com.renomad.xenos;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;

/**
  * Utils holds utilities that apply across many situations
  */
public final class Utils {

  private Utils () {
    //we don't want anyone instantiating this
    //do nothing.
  }


  /**
    * Will add an audit record
    * @param action_id the id of the action performed (e.g. 1 for create)
    *  see the database table "audit_actions" for available options.
    * @param user_id the id of the user causing the action
    * @param target_id the id of the target, usually a request.
    * @return true if successful at creating the audit, false otherwise.
    */
  public static boolean 
    create_audit(int action_id, int user_id, int target_id, String notes) {
    CallableStatement cs = null;
    try {
      Connection conn = Database_access.get_a_connection();
      cs = conn.prepareCall(String.format(
            "{call add_audit(%d,%d,%d,?)}",action_id,user_id,target_id));
      cs.setNString(1, notes);
      cs.executeUpdate();
      return true;
    } catch (SQLException ex) {
      Database_access.handle_sql_exception(ex);
      return false;
    } finally {
      Database_access.close_statement(cs);
    }
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
    * a helper method to convert integer arrays to strings
    * delimited by commas, like going from [1,2,3] to "1,2,3"
    */
  public static String int_array_to_string(Integer[] arr) {

    if (arr.length == 0) return "";

    StringBuilder s = new StringBuilder();
    s.append(arr[0].toString());
    for(int i = 1; i < arr.length;i++) {
      s.append(",").append(arr[i].toString());
    }
    return s.toString();
  }


  public static boolean is_valid_date(String date) {
    return get_date_search_query(date).length() > 0;
  }

  /**
    * We'll just check to see that the string entered is valid per our
    * specs.  
    * formats allowed:   (explanation in parens)
    * A) date            (a single date) ex: 2014-12-18
    * B) date-date       (a date range) ex: 2014-12-18-2014-12-22
    * C) date-           (a date range, starting at date, ending forever)
    * D) -date           (a date range, starting in the past, 
    *                                               ending at date)
    * Note that dates are inclusive.  the date range above would be from
    * the 0:00:00.0000 point of the first day to the 23:59:59:9999 point
    * of the last day.
    */
  public static String get_date_search_query(String date) {
    //a proper date will look like:
    // 2014-12-18
    // or 0000 to 9999, dash, 0 to 12, number varying between 1 and 31

    String return_sql_string = "";
    //a basic date regular expression.
    String date_ex = "([0-9]{4}-[0-9]{1,2}-[0-9]{1,2})"; 

    //either
    // a) date range, blah-blah     
    //      blah being there 0 or 1 times, followed by exactly
    //      no space, then dash, then exactly no space, then blah again.
    // or
    // b) a single date, no spaces.
    String full_expression = 
      String.format("%s{0,1}(-)%s{0,1}|%s", date_ex, date_ex, date_ex); 

    //with the capture groups I've set up, if group 3 is non-null, then
    //it's a single date.  otherwise, if group 1 and 2 are non-null, then
    //it's a range

    Pattern p = Pattern.compile(full_expression);
    Matcher m = p.matcher(date);

    //first check - did we find anything?
    if (m.find()) { // we only look once.
      String fd_string = m.group(1);
      String dash_string = m.group(2);
      String ld_string = m.group(3);
      String single_date_string = m.group(4);
      boolean first_date_in_range = is_good_date_value(fd_string);
      boolean dash = !Utils.is_null_or_empty(dash_string);
      boolean last_date_in_range = is_good_date_value(ld_string);
      boolean single_date = is_good_date_value(single_date_string);


      int count_true = 0;

      boolean case_A = !dash && single_date;
      if (case_A) {
        count_true++;
        return_sql_string = 
          String.format(
              "AND r.datetime BETWEEN '%s 00:00:00' AND "+
              "'%s 23:59:59.999' ",single_date_string, single_date_string);
      }

      boolean case_B = dash &&
                      !single_date &&
                      first_date_in_range && last_date_in_range;
      if (case_B) {
        count_true++;
        return_sql_string = 
          String.format(
              "AND r.datetime > '%s 00:00:00' AND "+
              "r.datetime < '%s 23:59:59.999' ",fd_string, ld_string);
      }

      boolean case_C = dash &&
        !single_date &&
        first_date_in_range && !last_date_in_range;

      if (case_C) {
        count_true++;
        return_sql_string = 
          String.format(
              "AND r.datetime > '%s 00:00:00' ",fd_string);
      }

      boolean case_D = dash && 
        !single_date && 
        !first_date_in_range && 
        last_date_in_range;

      if (case_D) {
        count_true++;
        return_sql_string = 
          String.format(
              "AND r.datetime < '%s 23:59:59.999' ",ld_string);
      }

      //second check - make sure one and *only one* case is true
      if (count_true == 1) {
        return return_sql_string;
      }
    }

    //if we got here, we didn't meet the precise criteria.
    return "";
  }

//                        Yearly calendar:
//                        ================
//                              2015
//        January               February               March          
//  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
//               1  2  3   1  2  3  4  5  6  7   1  2  3  4  5  6  7  
//   4  5  6  7  8  9 10   8  9 10 11 12 13 14   8  9 10 11 12 13 14  
//  11 12 13 14 15 16 17  15 16 17 18 19 20 21  15 16 17 18 19 20 21  
//  18 19 20 21 22 23 24  22 23 24 25 26 27 28  22 23 24 25 26 27 28  
//  25 26 27 28 29 30 31                        29 30 31              
//                                                                    
//  
//         April                  May                   June          
//  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
//            1  2  3  4                  1  2      1  2  3  4  5  6  
//   5  6  7  8  9 10 11   3  4  5  6  7  8  9   7  8  9 10 11 12 13  
//  12 13 14 15 16 17 18  10 11 12 13 14 15 16  14 15 16 17 18 19 20  
//  19 20 21 22 23 24 25  17 18 19 20 21 22 23  21 22 23 24 25 26 27  
//  26 27 28 29 30        24 25 26 27 28 29 30  28 29 30              
//                        31                                          
//  
//          July                 August              September        
//  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
//            1  2  3  4                     1         1  2  3  4  5  
//   5  6  7  8  9 10 11   2  3  4  5  6  7  8   6  7  8  9 10 11 12  
//  12 13 14 15 16 17 18   9 10 11 12 13 14 15  13 14 15 16 17 18 19  
//  19 20 21 22 23 24 25  16 17 18 19 20 21 22  20 21 22 23 24 25 26   
//  26 27 28 29 30 31     23 24 25 26 27 28 29  27 28 29 30            
//                        30 31                                        
//  
//        October               November              December        
//  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
//               1  2  3   1  2  3  4  5  6  7         1  2  3  4  5  
//   4  5  6  7  8  9 10   8  9 10 11 12 13 14   6  7  8  9 10 11 12  
//  11 12 13 14 15 16 17  15 16 17 18 19 20 21  13 14 15 16 17 18 19  
//  18 19 20 21 22 23 24  22 23 24 25 26 27 28  20 21 22 23 24 25 26  
//  25 26 27 28 29 30 31  29 30                 27 28 29 30 31       


  /**
    * checks that the date format checks out, specifically
    * the first number is between 0 and 9999, second is between 1 and 12,
    * third is between 1 and 31 depending on month
    * @param date a date value such as "2013-11-27"
    */
  private static boolean is_good_date_value(String date) {
    if (is_null_or_empty(date)) { 
      return false;
    }

    //a basic date regular expression. Note we capture year, month, day.
    String date_ex = "([0-9]{4})-([0-9]{2})-([0-9]{2})"; 
    Pattern p = Pattern.compile(date_ex);
    Matcher m = p.matcher(date);
    try {
      if (m.find()) {
        Integer year = Integer.parseInt(m.group(1));
        Integer month = Integer.parseInt(m.group(2));
        Integer day = Integer.parseInt(m.group(3));

        if (year == null || month == null || day == null) {
          return false;
        }

        if (year < 0 || year > 9999) {
          return false;
        }

        //valid numbers are 1 through 12 inclusive
        if (month < 1 || month > 12) { 
          return false;
        }
        
     // Months with 31 days: Ja(1), Mar(3), May(5), Jul(7), Aug(8),
     // Oct(10), Dec (12)
     // Months with 30 days: Apr(4), Jun(6), Sept(9), Nov(11)
     // Months with 28 days: Feb(2)
     // see year calendar above.
        if (day < 1) {
          return false;
        }

        switch(month) {
          case 1 : case  3 : case  5 : case  7 : 
          case  8 : case  10 : case  12:
            if (day > 31) {return false;}
          case 4 : case  6 : case  9 : case  11:
            if (day > 30) {return false;}
          case 2:
            if (day > 28) {return false;}
          default:

        }

      }
    } catch (Exception ex) {
      return false;
    }
    //if we got here without hitting a snag, it's a win!
    return true;
  }


  /**
   * Safe render is crucial to displaying text that came from the outside,
   * Like from a user or third party app.  This is to protect against some
   * security vulnerabilities.  Specifically, like those where the user
   * maliciously writes their name as &lt;script&gt;alert(1)&lt;/script&gt;
   * This makes things safe by taking the important, special characters for
   * less-than and greater-than and making them their equivalent codes.  The
   * browsers will know how to render this.
   * @param s the string from the database
   * @return a string safe for display in a browser.
   */
  public static String safe_render(String s) {
    if (is_null_or_empty(s)) {
      return s;
    } else {
      return s.replaceAll("<", "&lt;")
          .replaceAll(">", "&gt;");
    }
  }

  /**
    * gets all the parameters from a query string
    * @param qs a query string from a url string
    * @return a map of params to values, as strings.  It is
    * incumbent upon you to convert strings as needed. if qs
    * is null or empty, we return an empty map.
    */
  public static Map<String, String> parse_qs(String qs) {
    if (is_null_or_empty(qs)) {return new HashMap<String,String>();}
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


  /**
    * gets an integer from the value, avoiding boilerplate.
    * @param my_int a potential int
    * @return an Integer, or null if failed parsing.
    */
  public static Integer parse_int(String my_int) {
      try {
        Integer value = Integer.valueOf(my_int);
        return value;
      } catch (Exception ex) {
        return null;
      }
    }


  /**
    * this is a helper method to verify that the string
    * passed in consists of integers separated by commas.
    * This is used in places like query strings, and we want
    * to use this to verify we are not getting mangled numbers
    * or are under security attack.
    * @return true if valid comma delimited integers, false otherwise
    */
  public static boolean is_comma_delimited_numbers(String numbers) {
    if (is_null_or_empty(numbers)) {
      return false;
    }

    String[] split_values = numbers.split(",");
    for(String sv : split_values) {
      if (parse_int(sv) == null) {
        return false;
      }
    }
    return true;
  }


}
