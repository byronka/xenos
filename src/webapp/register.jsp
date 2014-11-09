<%@ page import="com.renomad.qarma.Database_access" %>
<html>
<head><title>Registration complete</title></head>
<body>

  <% 
    String first_name = request.getParameter("first_name");
    String last_name = request.getParameter("last_name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    Database_access.add_user(first_name, last_name, email, password);
    response.sendRedirect("thanks.htm");
  %>
</body>
</html>
