<%@ page import="com.renomad.xenos.Security" %>
<%
  int user_id = Security.check_if_allowed(request);
  if (user_id <= 0) { response.sendRedirect("sorry.jsp"); return;}
  boolean success = Security.logout_user(user_id);
  if (success) {
    Cookie cookie = new Cookie("xenos_cookie", "");
    cookie.setMaxAge(0);
    response.addCookie(cookie);
    response.sendRedirect("logged_out.jsp");
  } else {
    response.sendRedirect("sorry.jsp");
  }
%>
