<%@include file="includes/init.jsp" %>
<html>                                 
	<head>
		<link rel="stylesheet" href="dashboard.css" >
		<title><%=loc.get(16,"The dashboard")%></title>
	</head>

<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%@ page import="com.renomad.qarma.Utils" %>
<%@ page import="com.renomad.qarma.Others_Request" %>

<body>
<%@include file="includes/header.jsp" %>
<h2 class="my-requests-header"><%=loc.get(18, "Your requests")%>:</h2>
<div class="my-requests">
<%
  Request[] my_requests = 
    Request_utils.get_requests_for_user(user_id);
  for (Request r : my_requests) {
%>
	<div class="request">
		<a href="request.jsp?request=<%=r.request_id %>"> <%=r.titleSafe()%> </a>
		<span class="points"><%=r.points%></span>
		<a 
			class="delete-button" 
			href="request.jsp?request=<%=r.request_id%>&delete=true">
			<%=loc.get(21,"Delete")%>
		</a>
	</div>
<% } %>
</div>
<h2 class="others-requests-header">
	<%=loc.get(19, "Other's requests")%>:
</h2>
<div class="others-requests">
<%
  Others_Request[] others_requests = 
    Request_utils.get_all_requests_except_for_user(user_id);
  for (Others_Request r : others_requests) {
%>
	<div class="request">
		<a href="request.jsp?request=<%=r.request_id %>">
			<%=r.titleSafe()%> 
		</a>
		<div class="points"><%=r.points%></div>
		<div class="rank"><%=r.rank%></div>
		<div class="description"><%=r.descriptionSafe()%></div>
		<div class="status"><%=loc.get(Request_utils.get_status_localization_value(r.status),"")%></div>
		<div class="datetime"><%=r.datetime%></div>
		<div class="requesting-user-id"><%=r.requesting_user_id%></div>
		<%for (Integer c : r.get_categories()) {%>
			<div class="category"><%=loc.get(c,"")%></div>
		<%}%>
		<a 
			class="handle-button" 
			href="request.jsp?request=<%=r.request_id%>&service=true"> 
			<%=loc.get(20, "Handle")%> 
		</a>
	</div>
<% } %>
</div>
</body>
</html>
