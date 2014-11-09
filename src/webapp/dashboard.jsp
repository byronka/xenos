<%@ page import="com.renomad.qarma.Security" %>
<% boolean allowed = Security.check_if_allowed(request);
    if (!allowed) { response.sendRedirect("sorry.htm"); }
%>

<html>                                 
<head><title>The dashboard</title></head>
<body>
<h2>Welcome to the dashboard!</h2>
<p>Here are your requests:</p>
</body>
</html>
