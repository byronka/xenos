package com.renomad.qarma;

import java.io.IOException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.renomad.qarma.Database_access;

public class Security {

  public static int check_login(String username, String password) {
    return Database_access.check_login(username, password);
  }

  public static String register_user(int user_id,
      String ip_address) {
    Database_access.register_details_on_user_login(user_id, ip_address);
    String cookie_value = Database_access.get_new_cookie_for_user(user_id);
    return cookie_value;
  }

  public static int check_if_allowed(HttpServletRequest r) {
    Cookie[] cookies = r.getCookies();
    Cookie c = find_our_cookie(cookies);
    int user_id = get_user_from_cookie(c);
    return user_id;
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
  public static int get_user_from_cookie(Cookie c) {
    if (c == null) {
      return -1;
    }
    String cookie_value = c.getValue();
    int user_id = 
      Database_access.look_for_logged_in_user_by_cookie(cookie_value);
    return user_id;
  }
  

}
