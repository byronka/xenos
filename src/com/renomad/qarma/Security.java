package com.renomad.qarma;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.renomad.qarma.Database_access;

public class Security {


  public static String register_user(int user_id,
      String ip_address) {
    Database_access.register_details_on_user_login(user_id, ip_address);
    Database_access.get_new_cookie_for_user(user_id);
  }


  public static Cookie find_our_cookie(Cookie[] all_cookies) {
    if (all_cookies == null) {
      return null;
    }
    for (Cookie cookie : all_cookies) {
      if (cookie.getName().equals("qarma_cookie")) {
        return cookie;
      }
    }
    return null;
  }

  /**
    * check if the user is allowed to access this page.
    *
    * @param c Our cookie, which we will look 
    *   at to determine if the user is valid.
    */
  public static boolean user_is_allowed(Cookie c) {
    if (c == null) {
      return false;
    }
    String cookie_value = c.getValue();
    String user_email = 
      Database_access.look_for_logged_in_user_by_cookie(cookie_value);
    return (user_email.length() > 0);
  }
  

  public void set_security_for_user(HttpServletResponse r) {


  }

}
