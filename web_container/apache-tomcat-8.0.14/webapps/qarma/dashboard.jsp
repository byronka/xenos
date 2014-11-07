<%@ page import="com.renomad.qarma.Security" %>

  <% 
    if (Security.user_is_allowed(request)) {
      response.sendRedirect("dashboard.htm");
    } else {
      response.sendRedirect("sorry.htm");
    }
  %>

<html>                                 
<head><title>The dashboard</title></head>
<body>
<h2>Welcome to the dashboard!</h2>
<p>This is the dashboard, you can only see this if you are logged in...right?</p>
</body>
</html>
