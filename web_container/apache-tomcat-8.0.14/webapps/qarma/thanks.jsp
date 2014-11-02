<%@ page import="com.renomad.qarma.Tester" %>
<html>
<head><title>First JSP</title></head>
<body>

  <% 
    String name = request.getParameter("nametext");
    Tester.add_user(name);
  %>
  <h3>You're awesome! thanks so much for entering your name!</h3>
</body>
</html>
