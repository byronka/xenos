<%@ page import="com.renomad.qarma.Request_utils" %>
<%@ page import="com.renomad.qarma.Request" %>
<%@include file="includes/check_auth.jsp" %>

<%
	String qs = request.getQueryString();
	int request_id = Request_utils.parse_qs_for_request_id(qs);
	boolean success = Request_utils.delete_request(request_id, user_id);
	if (!success) {
		response.sendRedirect("error_deleting.jsp");
		} else {
	response.sendRedirect(
		String.format("request_deleted.jsp?request=%d",request_id));
		}
%>
