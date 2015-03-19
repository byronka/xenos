<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
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
    Click on <a href="transaction_complete.jsp?requestoffer=<%=r.requestoffer_id%>">confirm</a> if you are sure you want to complete
    this Favor.  You will be given an opportunity to provide feedback
    for the other user afterwards.
  </p>
</body>
</html>
