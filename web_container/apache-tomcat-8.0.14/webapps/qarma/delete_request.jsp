<%@include file="includes/header.jsp" %>

<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%
	String qs = request.getQueryString();
	int request_id = 
		Integer.parseInt(Request_utils.parse_qs(qs).get("request"));
	boolean success = Request_utils.delete_request(request_id, user_id);
	if (!success) {
		response.sendRedirect("error_deleting.jsp");
		} else {
	response.sendRedirect(
		String.format("request_deleted.jsp?request=%d",request_id));
		}
%>
