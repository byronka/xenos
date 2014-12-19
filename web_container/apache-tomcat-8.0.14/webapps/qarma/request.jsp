<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%@include file="includes/check_auth.jsp" %>

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

	boolean show_handle_button = 
		!is_requesting_user && !is_servicing && !is_deleting;
	boolean show_delete_info = 
			is_requesting_user && is_deleting;
	boolean show_message_input = 
			!is_requesting_user && is_servicing && !is_deleting;

	//handle bad scenarios
	if (is_requesting_user && is_servicing ||
			!is_requesting_user && is_deleting) {
		response.sendRedirect("general_error.jsp");
		return;
	}

	String msg = request.getParameter("message");

	if (msg != null && msg != "") {
		Request_utils.set_message(msg, r.request_id, user_id);
		response.sendRedirect(
			"request.jsp?request="+r.request_id+"&service=true");
		return;
	}

%>
<html>
<head><title>The request page</title></head>
<body>
<%@include file="includes/header.jsp" %>
	<p>Description: <%=r.description%>
	<p>Status: <%=r.get_status()%>
	<p>Date: <%=r.datetime%>
	<p>Points: <%=r.points%>
	<p>Title: <%=r.title%>
	<p>Categories: <%=r.get_categories_string()%>
	<%
	if (show_delete_info) {%>

		<p>
			Are you sure you want to delete this request? <%=r.points%> points
			will be refunded to you 
		</p>

		<p>
			<a href="delete_request.jsp?request=<%=r.request_id%>">Yes, delete!</a>
		</p>
		<p>
			<a href="dashboard.jsp">nevermind, don't delete it</a>
		</p>

		<%} if (show_handle_button) {%>

			<a href="request.jsp?request=<%=r.request_id%>&service=true">
				Handle
			</a>

			<%}
			String[] messages = Request_utils.get_messages(r.request_id);
		 	for (String m : messages) { %>

			<p><%=m%></p>

			<%} if (show_message_input) { %>
		<form method="POST" action="request.jsp?request=<%=r.request_id%>&service=true">
			<p>Message (up to 10,000 characters)</p>
			<input type="text" name="message" maxlength="10000" />
      <button type="submit">Send message</button>
		</form>
	<% } %>

</body>
</html>
