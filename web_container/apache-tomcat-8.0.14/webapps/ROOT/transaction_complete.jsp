<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  boolean is_satisfied = Boolean.parseBoolean(request.getParameter("is_satis"));
  int requestoffer_id = Utils.parse_int(request.getParameter("ro_id"));
  String comment = request.getParameter("is_satis_comment");

	boolean result = Requestoffer_utils.
		complete_transaction(requestoffer_id, user_id, is_satisfied, comment);
	if (result == true) {
		response.sendRedirect(
			"requestoffer_closed.jsp?requestoffer=" + r.requestoffer_id);
	} else {
  	response.sendRedirect("general_error.jsp");
	}
%>
