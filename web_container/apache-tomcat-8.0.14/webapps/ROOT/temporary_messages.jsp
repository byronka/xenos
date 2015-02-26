<%@include file="includes/init.jsp" %>
<%
  String[] msgs = 
    com.renomad.xenos.Requestoffer_utils.
      get_my_temporary_msgs(user_id, loc);
%>

<!DOCTYPE html>
<%
  for (String msg : msgs) { 
%>

<div><%=com.renomad.xenos.Utils.safe_render(msg)%></div>

<% } %>

