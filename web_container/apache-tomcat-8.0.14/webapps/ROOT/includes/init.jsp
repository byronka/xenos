<%@ page import="com.renomad.xenos.Localization" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.User" %>
<%@include file="mobile_check.jsp" %>
<% 
  //Note that these objects below will thus be available to most pages.
  int user_id = com.renomad.xenos.Security.check_if_allowed(request);
  if (user_id <= 0) { 
    response.sendRedirect("sorry.jsp"); 
    return;
  }
  Localization loc  = new Localization(user_id, request.getLocale());
  User user = User_utils.get_user(user_id);

	

%>