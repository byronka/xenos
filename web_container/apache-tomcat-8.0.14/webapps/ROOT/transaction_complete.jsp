<%@include file="includes/securepage.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  String qs = request.getQueryString();
  Requestoffer r = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }
  if (r.status == Const.Rs.CLOSED) {
  	response.sendRedirect("general_error.jsp");
  }

	boolean result = Requestoffer_utils.
		complete_transaction(r.requestoffer_id, logged_in_user_id);
	if (result == true) {
		response.sendRedirect(
			"requestoffer_closed.jsp?requestoffer=" + r.requestoffer_id);
	} else {
  	response.sendRedirect("general_error.jsp");
	}
%>
