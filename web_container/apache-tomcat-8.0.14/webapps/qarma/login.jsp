<%@ page import="com.renomad.qarma.Database_access" %>

  <% 
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    if (Database_access.check_login(username, password)) {
      response.sendRedirect("dashboard.htm");
    } else {
      response.sendRedirect("sorry.htm");
    }
  %>
