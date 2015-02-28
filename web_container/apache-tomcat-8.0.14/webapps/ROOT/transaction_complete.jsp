<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%

  String qs = request.getQueryString();
  java.util.Map<String, String> qs_params = Utils.parse_qs(qs);
  boolean is_satisfied = Boolean.parseBoolean(qs_params.get("satisfied"));
  Requestoffer r = Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }
	boolean result = Requestoffer_utils.
		complete_transaction(r.requestoffer_id, user_id, is_satisfied);
	if (result == true) {
		response.sendRedirect(
			"requestoffer_closed.jsp?requestoffer=" + r.requestoffer_id);
	} else {
  	response.sendRedirect("general_error.jsp");
	}
%>
