<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%
response.setHeader(
	"Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
response.setDateHeader("Expires", 0); // Proxies.
%>
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
		<a href="request.jsp?request=<%=r.request_id%>&delete=true">Delete</a>
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
