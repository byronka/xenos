<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%@include file="includes/check_auth.jsp" %>

<html>
<head><title>Request has been deleted</title></head>
<body>
<%@include file="includes/header.jsp" %>
<%
	String qs = request.getQueryString();
	int request_id = 
		Integer.parseInt(Request_utils.parse_qs(qs).get("request"));
%>
<h2>Request <%=request_id%> deleted</h2>
<p>
	This request has been deleted, its points have 
	been refunded to you
</p>
<p>Click <a href="dashboard.jsp">here</a> to return to the dashboard</p>
</body>
</html>

