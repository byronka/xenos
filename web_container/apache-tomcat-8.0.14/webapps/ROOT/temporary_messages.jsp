<%@ page import="com.renomad.xenos.Localization" %>
<%@ page import="com.renomad.xenos.Utils" %>

<% 
  int user_id = com.renomad.xenos.Security.check_if_allowed(request, false);
  String[] msgs = new String[0];
  if (user_id > 0) { // don't do anything unless it's a valid user
    Localization loc = new Localization(user_id, request.getLocale());

    msgs = com.renomad.xenos.Requestoffer_utils.
          get_my_temporary_msgs(user_id, loc);
  }
%>

<!DOCTYPE html>
<%
  for (String msg : msgs) { 
%>

<div><%=com.renomad.xenos.Utils.safe_render(msg)%></div>

<% } %>

