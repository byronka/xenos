<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%@include file="includes/check_auth.jsp" %>

<html>                                 
<head><title>The dashboard</title></head>
<body>
<%@include file="includes/header.jsp" %>

<h2>Welcome to the dashboard!</h2>
<p>Here are your requests:</p>
<%
  Request[] my_requests = 
    Request_utils.get_requests_for_user(user_id);
  for (Request r : my_requests) {
%>
	<p>
		<a href="request.jsp?request=<%=r.request_id %>">
			<%=r.title%>
		</a>
	</p>
<% } %>
<p>Here are other's requests:</p>
<%
  Request[] others_requests = 
    Request_utils.get_all_requests_except_for_user(user_id);
  for (Request r : others_requests) {
%>
	<p>
		<a href="request.jsp?request=<%=r.request_id %>">
			<%=r.title%>
		</a>
		<%=r.points%>
	</p>
<% } %>
</body>
</html>
