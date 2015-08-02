<%@include file="includes/securepage.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%

	request.setCharacterEncoding("UTF-8");
  boolean is_satisfied = 
    Boolean.parseBoolean(request.getParameter("is_satis"));
  int urdp_id = Utils.parse_int(request.getParameter("urdp_id"));
  String comment = request.getParameter("is_satis_comment");

	boolean result = Requestoffer_utils.
		rank_other_user(logged_in_user_id, urdp_id, is_satisfied, comment);

	if (result == true) {
		response.sendRedirect("judging_confirmed.jsp");
	} else { // it should only be false if an error occurred
  	response.sendRedirect("general_error.jsp");
	}
%>
