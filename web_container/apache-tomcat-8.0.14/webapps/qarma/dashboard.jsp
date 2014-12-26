<%@include file="includes/init.jsp" %>
<html>                                 
	<head>
		<link rel="stylesheet" href="dashboard.css" >
		<title><%=loc.get(16,"The dashboard")%></title>
	</head>

<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%
response.setHeader( "Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
response.setDateHeader("Expires", 0); // Proxies.
%>

<body>
<%@include file="includes/header.jsp" %>
<h2 class="my-requests-header"><%=loc.get(18, "Your requests")%>:</h2>
<div class="my-requests">
<%
  Request[] my_requests = 
    Request_utils.get_requests_for_user(user_id);
  for (Request r : my_requests) {
%>
	<p class="request">
		<a href="request.jsp?request=<%=r.request_id %>"> <%=r.titleSafe()%> </a>
		<span class="points"><%=r.points%></span>
		<a class="delete-button" href="request.jsp?request=<%=r.request_id%>&delete=true"><%=loc.get(21,"Delete")%></a>
	</p>
<% } %>
</div>
<h2 class="others-requests-header"><%=loc.get(19, "Other's requests")%>:</h2>
<div class="others-requests">
<%
  Request[] others_requests = 
    Request_utils.get_all_requests_except_for_user(user_id);
  for (Request r : others_requests) {
%>
	<p class="request">
		<a href="request.jsp?request=<%=r.request_id %>"> <%=r.titleSafe()%> </a>
		<span class="points"><%=r.points%></span>
		<a class="handle-button" href="request.jsp?request=<%=r.request_id%>&service=true"> <%=loc.get(20, "Handle")%> </a>
	</p>
<% } %>
</div>
</body>
</html>
