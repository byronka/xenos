<%@ page import="com.renomad.xenos.Localization" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Const" %>
<%@ page import="com.renomad.xenos.User" %>
<% 
  int logged_in_user_id = com.renomad.xenos.Security.check_if_allowed(request, true);
  User logged_in_user = null;

  if (logged_in_user_id > 0) {
    logged_in_user = User_utils.get_user(logged_in_user_id);
  } else {
    logged_in_user_id = 0;
    Cookie cookie = new Cookie("xenos_cookie", "");
    cookie.setMaxAge(0);
    response.addCookie(cookie);
  }

  //set up an object to localize text
  Localization loc  = logged_in_user_id > 0 ? 
    new Localization(logged_in_user_id, request.getLocale())
    : new Localization(request.getLocale());

%>
