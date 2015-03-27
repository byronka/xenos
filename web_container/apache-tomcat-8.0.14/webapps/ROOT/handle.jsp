<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(94,"Handle requestoffer")%></title>
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  String qs = request.getQueryString();
  Requestoffer r = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  if (r == null || r.status != 76) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  //handle bad scenario - if the offering user *is* the owning user.

  if (logged_in_user_id == r.requestoffering_user_id) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  java.util.Map<String,String> params = Utils.parse_qs(qs);
  String is_confirmed = params.get("confirm");
  if (is_confirmed != null && is_confirmed.equals("true")) {
  if (Requestoffer_utils.offer_to_take_requestoffer(
    logged_in_user_id, r.requestoffer_id)) {
    response.sendRedirect("offer_received.jsp");
    return;
    } else {
      response.sendRedirect("general_error.jsp");
    }
  }
  if (r == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }


%>
<body>
  <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>
  <div class="container">
  <p><%=loc.get(121,"If you would like to take this requestoffer, click the confirm button below")%></p>
    <a class="button" href="handle.jsp?requestoffer=<%=r.requestoffer_id%>&confirm=true"><%=loc.get(95, "Confirm")%></a>
    <a class="button" href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id%>"><%=loc.get(130, "Cancel")%></a>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
