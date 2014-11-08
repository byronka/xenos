<%@ page import="com.renomad.qarma.Security" %>

  <% 
    Cookie[] cookies = request.getCookies();
    Cookie c = Security.find_our_cookie(cookies);
    if (Security.user_is_allowed(c)) {
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
