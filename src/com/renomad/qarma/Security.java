package com.renomad.qarma;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.renomad.qarma.Database_access;

public class Security {


  private static Cookie find_our_cookie(Cookie[] all_cookies) {
    for (Cookie cookie : all_cookies) {
      if (cookie.getName().equals("qarma_cookie")) {
        return cookie;
      }
    }
    return null;
  }

  public static boolean user_is_allowed(HttpServletRequest r) {
    Cookie[] all_cookies = r.getCookies();
    Cookie my_cookie = find_our_cookie(all_cookies);
    if (my_cookie == null) {
      return false;
    }
    String cookie_value = my_cookie.getValue();
    String user_email = Database_access.look_for_logged_in_user_by_cookie(cookie_value);
    return (user_email.length() > 0);
  }
  

  public void set_security_for_user(HttpServletResponse r) {


  }

}
