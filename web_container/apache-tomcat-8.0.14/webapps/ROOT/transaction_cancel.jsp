<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%

  //get query string information
  String qs = request.getQueryString();
  java.util.Map<String, String> qs_params = Utils.parse_qs(qs);
  boolean is_satisfied = Boolean.getBoolean(qs_params.get("satisfied"));
  Requestoffer r = Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  // make sure the user doing this is one of the valid users to do so.
   if (user_id != r.requestoffering_user_id && 
      user_id != r.handling_user_id) {
    response.sendRedirect("general_error.jsp");
    return;
  } 

	boolean result = Requestoffer_utils.
		cancel_taken_requestoffer(user_id, r.requestoffer_id, is_satisfied);
	if (result == true) {
		response.sendRedirect("offer_canceled.jsp?");
	} else {
  	response.sendRedirect("general_error.jsp");
	}
%>