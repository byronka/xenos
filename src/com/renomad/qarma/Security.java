package com.renomad.qarma;

import javax.servlet.http.Cookie;
import javax.servlet.HttpServletRequest;
import com.renomad.qarma.Database_access;

public class Security {


  private static String find_the_cookie(Cookie[] all_cookies) {
    for (Cookie cookie : all_cookies) {
      if (cookie.getName().equals("qarma_cookie") {
        return cookie.getValue();
      }
    }
    return "";
  }


  public static bool user_is_allowed(HttpServletRequest r) {
    Cookie[] all_cookies = request.getCookies();
    find_the_cookie(all_cookies);
    String password = request.getParameter("password");
    if (Database_access.check_login(username, password)) {
      response.sendRedirect("dashboard.htm");
    } else {
      response.sendRedirect("sorry.htm");
    }

  }
  

  public set_security_for_user(HttpServletResponse r) {


  }

}
