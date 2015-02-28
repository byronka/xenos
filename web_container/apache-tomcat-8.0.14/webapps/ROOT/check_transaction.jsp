<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(22,"Favor Details")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
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
  if (r.status == 77) {// closed
  	response.sendRedirect("general_error.jsp");
  }
%>
<body>

<p>
  <a href="transaction_complete.jsp?requestoffer=<%=r.requestoffer_id%>&satisfied=true" >
    Thumbs up
  </a>
</p>
<p>
  <a href="transaction_complete.jsp?requestoffer=<%=r.requestoffer_id%>&satisfied=false" >
    Thumbs down
  </a>
</p>
</body>
</html>
