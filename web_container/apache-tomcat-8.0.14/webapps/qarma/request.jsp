<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%@include file="includes/check_auth.jsp" %>

<html>
<head><title>The request page</title></head>
<body>
<%@include file="includes/header.jsp" %>
<%
	String qs = request.getQueryString();
	Request r = Request_utils.parse_querystring_and_get_request(qs);
	boolean in_deleting = (qs.indexOf("delete=true") > 0);
%>
	<p>Description: <%=r.description%>
	<p>Status: <%=r.get_status()%>
	<p>Date: <%=r.datetime%>
	<p>Points: <%=r.points%>
	<p>Title: <%=r.title%>
	<p>Requesting user: <%=r.requesting_user_id%>
	<p>Categories: <%=r.get_categories_string()%>
	<%if (in_deleting) {%>
	<p>Are you sure you want to delete this request? <%=r.points%> points will be refunded to you</p>
	<p><a href="delete_request.jsp?request=<%=r.request_id%>">Yes, delete!</a></p>
		<p><a href="dashboard.jsp">nevermind, don't delete it</a></p>
	<%}%>
</body>
</html>
