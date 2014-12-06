package com.renomad.qarma;

import java.io.IOException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.renomad.qarma.Database_access;
import com.renomad.qarma.Utilities;

public class Security {

  public static int check_login(String username, String password) {
    return Database_access.check_login(username, password);
  }

  public static void register_user(int user_id,
      String ip_address) {
    Database_access.register_details_on_user_login(user_id, ip_address);
  }

  /**
    * tries logging out the user.  If successful, return true
    * @param the user id in question
    * @returns true if successful
    */
  public static boolean logout_user(int user_id) {
    return Database_access.set_user_not_logged_in(user_id);
  }

  private static int get_int_from_cookie(Cookie c) {
    return Utilities.parse_int(c.getValue());
  }


  /**
    * we just look up the user.  If they are logged in, we
    * return the user id.  if failed, return -1;
    * @param the request object
    * @returns a valid user id if allowd.  -1 otherwise.
    */
  public static int check_if_allowed(HttpServletRequest r) {
    Cookie[] cookies = r.getCookies();
    Cookie c = find_our_cookie(cookies);
    if (c == null) {
      return -1;
    }
    int user_id = get_int_from_cookie(c);
    if (user_id == Integer.MIN_VALUE) { return -1; }
    boolean is_logged_in = Database_access.user_is_logged_in(user_id);
    if (is_logged_in) {
      return user_id;
    }
    return -1; //-1 means not allowed or failure.
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

  public boolean user_is_logged_in(int user_id) {
    return Database_access.user_is_logged_in(user_id);
  }

}
