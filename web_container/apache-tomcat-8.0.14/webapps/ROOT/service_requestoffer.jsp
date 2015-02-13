<%@include file="includes/header.jsp" %>
<!DOCTYPE html>
<html>
<head><title>Handle a requestoffer</title></head>

<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%
  String qs = requestoffer.getQueryString();
  Requestoffer r = Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }
  boolean is_requestoffering_user = user_id == r.requestoffering_user_id;
  if (is_requestoffering_user) {
    response.sendRedirect("general_error.jsp");
  }
%>
<body>
  <p>Description: <%=r.description%>
  <p>Status: <%=r.get_status()%>
  <p>Date: <%=r.datetime%>
  <p>Points: <%=r.points%>
  <p>Title: <%=r.title%>
  <p>Categories: <%=r.get_categories_string()%>
</body>
</html>

