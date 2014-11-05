<%@ page import="com.renomad.qarma.Database_access" %>

  <% 
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    if (Database_access.check_login(email, password)) {
      response.sendRedirect("dashboard.htm");
    } else {
      response.sendRedirect("sorry.htm");
    }
  %>
