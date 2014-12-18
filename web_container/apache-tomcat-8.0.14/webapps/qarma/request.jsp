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
	if (r == null) {
		response.sendRedirect("general_error.jsp");
		return;
	}
	boolean is_requesting_user = user_id == r.requesting_user_id;
	boolean is_servicing = qs.indexOf("service=true") > 0;
	boolean is_deleting = qs.indexOf("delete=true") > 0;

	//handle bad scenarios
	if (is_requesting_user && is_servicing ||
			!is_requesting_user && is_deleting) {
		response.sendRedirect("general_error.jsp");
	}
%>
	<p>Description: <%=r.description%>
	<p>Status: <%=r.get_status()%>
	<p>Date: <%=r.datetime%>
	<p>Points: <%=r.points%>
	<p>Title: <%=r.title%>
	<p>Categories: <%=r.get_categories_string()%>
	<%
	if (is_deleting) {%>
	<p>
		Are you sure you want to delete this request? <%=r.points%> points
		will be refunded to you 
	</p>
	<p>
		<a href="delete_request.jsp?request=<%=r.request_id%>">Yes, delete!</a>
	</p>
		<p><a href="dashboard.jsp">nevermind, don't delete it</a></p>

	<%} else if (!is_requesting_user) {%>

	<a href="request.jsp?request=<%=r.request_id%>&service=true">
		Handle
	</a>

	<%} 
	if (is_servicing) { 
 		String msg = request.getParameter("message"); 
	%>
		<form method="POST" action="request.jsp">
			<p>Message</p>
			<input type="text" name="message" value="<%=msg%>"/>
      <button type="submit">Send message</button>
		</form>
	<% } %>

</body>
</html>
