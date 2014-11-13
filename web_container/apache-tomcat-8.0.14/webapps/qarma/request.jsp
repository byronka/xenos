<%@ page import="com.renomad.qarma.Security" %>
<%@ page import="com.renomad.qarma.Database_access" %>
<% int user_id = Security.check_if_allowed(request);
  if (user_id <= 0) { response.sendRedirect("sorry.htm"); }
%>

<html>                                 
<head><title>The request page</title></head>
<body>
<h2>Here is a request in more detail!</h2>
<%
  String qs = null;
  int request_id = 0;
  int value_index = 0;
  String request_string = "request=";
  int rsl = request_string.length();
  //if we have a query string and it has request= in it.
  if ((qs = request.getQueryString()) != null &&
      (value_index = qs.indexOf(request_string)) >= 0) {
      value_index = Integer.parseInt(qs.substring(rsl));
  }
%>
<p><%=value_index%></p>
</body>
</html>
