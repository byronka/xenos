package com.renomad.qarma;

public class Utilities {


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
