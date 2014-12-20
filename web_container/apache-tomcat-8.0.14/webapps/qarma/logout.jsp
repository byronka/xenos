<%@ page import="com.renomad.qarma.Security" %>
<%
  int user_id = Security.check_if_allowed(request);
  if (user_id <= 0) { response.sendRedirect("sorry.jsp"); }
  boolean success = Security.logout_user(user_id);
  if (success) {
    Cookie cookie = new Cookie("qarma_cookie", "");
    cookie.setMaxAge(0);
    response.addCookie(cookie);
    response.sendRedirect("logged_out.jsp");
  } else {
    response.sendRedirect("sorry.jsp");
  }
%>
