<%@include file="includes/securepage.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<title><%=loc.get(22,"Favor Details")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  String qs = request.getQueryString();
  Requestoffer the_requestoffer = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (the_requestoffer == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }
  if (the_requestoffer.status == Const.Rs.CLOSED) {
  	response.sendRedirect("general_error.jsp");
  }
%>
<body>
  <%@include file="includes/header.jsp" %>

  <div class="container">
    <p>
      Click on <a class="button" href="transaction_complete.jsp?requestoffer=<%=the_requestoffer.requestoffer_id%>">confirm</a> if you are sure you want to complete
      this Favor.  You will be given an opportunity to provide feedback
      for the other user afterwards.
    </p>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
</html>
