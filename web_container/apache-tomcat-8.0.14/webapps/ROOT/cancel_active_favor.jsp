<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<title><%=loc.get(126,"Cancel an active Favor")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  String qs = request.getQueryString();
  Requestoffer my_requestoffer = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (my_requestoffer == null || my_requestoffer.status != Const.Rs.TAKEN) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  //handle bad scenario - if this user is not either the handler or owner.

  if (logged_in_user_id != my_requestoffer.requestoffering_user_id && 
      logged_in_user_id != my_requestoffer.handling_user_id) {
    response.sendRedirect("general_error.jsp");
    return;
  }


%>
<body>
  <%@include file="includes/header.jsp" %>

  <div class="container">
  <p>
    <%=loc.get(129,"If you would like to cancel this active Favor, click the confirm button below.  This will give you the chance provide a grade for the other person, as well as giving them a chance to grade you.")%>
  </p>
  <p>
    <a class="button" href="transaction_cancel.jsp?requestoffer=<%=my_requestoffer.requestoffer_id%>">
      <%=loc.get(95, "Confirm")%> 
    </a>
  </p>
  <%@include file="includes/footer.jsp" %>
</body>
