<%@include file="includes/header.jsp" %>
<html>
<head><title>Handle a request</title></head>

<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%
	String qs = request.getQueryString();
	Request r = Request_utils.parse_querystring_and_get_request(qs);
	if (r == null) {
		response.sendRedirect("general_error.jsp");
		return;
	}
	boolean is_requesting_user = user_id == r.requesting_user_id;
	if (is_requesting_user) {
		response.sendRedirect("general_error.jsp");
	}
%>
<body>
	<p>Description: <%=r.description%>
	<p>Status: <%=r.get_status()%>
	<p>Date: <%=r.datetime%>
	<p>Points: <%=r.points%>
	<p>Title: <%=r.title%>
	<p>Categories: <%=r.get_categories_string()%>
</body>
</html>

