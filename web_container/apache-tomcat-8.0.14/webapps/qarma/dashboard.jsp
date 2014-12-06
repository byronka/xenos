<%@ page import="com.renomad.qarma.Business_logic" %>
<%@include file="includes/check_auth.jsp" %>

<html>                                 
<head><title>The dashboard</title></head>
<body>
<%@include file="includes/header.jsp" %>

<h2>Welcome to the dashboard!</h2>
<p>Here are your requests:</p>
<%
  Business_logic.Request[] requests = 
    Business_logic.get_requests_for_user(user_id);
  for (Business_logic.Request r : requests) {
%>
	<p>
		<a href="request.jsp?request=<%=r.request_id %>">
			<%=r.description%>
		</a>
	</p>
<% } %>
<p>Here are other's requests:</p>
<%
  Business_logic.Request[] requests = 
    Business_logic.get_requests_for_user(user_id);
  for (Business_logic.Request r : requests) {
%>
	<p>
		<a href="request.jsp?request=<%=r.request_id %>">
			<%=r.description%>
		</a>
	</p>
<% } %>
</body>
</html>
