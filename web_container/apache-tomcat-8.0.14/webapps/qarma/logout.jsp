<%@ page import="com.renomad.qarma.Security" %>
<%
  int user_id = Security.check_if_allowed(request);
  if (user_id <= 0) { response.sendRedirect("sorry.htm"); }
  Security.unregister_user(user_id);
  response.sendRedirect("logged_out.htm");
%>
