<%@ page import="com.renomad.qarma.Localization" %>
<%@ page import="com.renomad.qarma.User_utils" %>
<%@ page import="com.renomad.qarma.User" %>
<% 
	//Note that these objects below will thus be available to most pages.
  int user_id = com.renomad.qarma.Security.check_if_allowed(request);
  if (user_id <= 0) { 
  	response.sendRedirect("sorry.jsp"); 
  	return;
  }
  Localization loc  = new Localization(user_id, request.getLocale());
  User user = User_utils.get_user_displayname(user_id);
%>
