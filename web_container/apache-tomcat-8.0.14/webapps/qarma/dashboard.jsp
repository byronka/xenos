<%@include file="includes/header.jsp" %>
<html>                                 
	<head><title><%=loc.get(16,"The dashboard")%></title></head>

<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%
response.setHeader(
	"Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
response.setDateHeader("Expires", 0); // Proxies.
%>

<body>
<h2><%=loc.get(17, "Welcome to the dashboard!")%></h2>
<p><%=loc.get(18, "Here are your requests")%>:</p>
<%
  Request[] my_requests = 
    Request_utils.get_requests_for_user(user_id);
  for (Request r : my_requests) {
%>
	<p>
		<a href="request.jsp?request=<%=r.request_id %>">
			<%=r.titleSafe()%>
		</a>
		<a href="request.jsp?request=<%=r.request_id%>&delete=true"><%=loc.get(21,"Delete")%></a>
	</p>
<% } %>
<p><%=loc.get(19, "Here are other's requests")%>:</p>
<%
  Request[] others_requests = 
    Request_utils.get_all_requests_except_for_user(user_id);
  for (Request r : others_requests) {
%>
	<p>
		<a href="request.jsp?request=<%=r.request_id %>">
			<%=r.titleSafe()%>
		</a>
		<%=r.points%>
	<a href="request.jsp?request=<%=r.request_id%>&service=true">
		<%=loc.get(20, "Handle")%>
	</a>
	</p>
<% } %>
</body>
</html>
