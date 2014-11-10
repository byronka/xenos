<%@ page import="com.renomad.qarma.Security" %>
<%@ page import="com.renomad.qarma.Database_access" %>
<% int user_id = Security.check_if_allowed(request);
  if (user_id <= 0) { response.sendRedirect("sorry.htm"); }
%>

<html>                                 
<head><title>The dashboard</title></head>
<body>
<h2>Welcome to the dashboard!</h2>
<p>Here are your requests:</p>
<%
  Database_access.Request[] requests = 
    Database_access.get_all_requests(user_id);
  for (Database_access.Request r : requests) {
%>
<p><%=r.description%>a request</p>
<% } %>
</body>
</html>
