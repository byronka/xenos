<%@ page import="com.renomad.qarma.Security" %>
<%@ page import="com.renomad.qarma.Business_logic" %>
<% int user_id = Security.check_if_allowed(request);
  if (user_id <= 0) { response.sendRedirect("sorry.htm"); }
%>

<html>                                 
<head><title>The dashboard</title></head>
<body>
<%@include file="includes/header.jsp" %>

<h2>Welcome to the dashboard!</h2>
<p>Here are your requests:</p>
<%
  Business_logic.Request[] requests = 
    Business_logic.get_all_requests(user_id);
  for (Business_logic.Request r : requests) {
%>
<p><a href="request.jsp?request=<%=r.request_id %>"><%=r.description%></a></p>
<% } %>
</body>
</html>
