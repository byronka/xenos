<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(94,"Handle requestoffer")%></title>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
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

  java.util.Map<String,String> params = Utils.parse_qs(qs);
  String is_confirmed = params.get("confirm");
  if (is_confirmed != null && is_confirmed.equals("true")) {
  if (Requestoffer_utils.offer_to_take_requestoffer(
    user_id, r.requestoffer_id)) {
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

  //handle bad scenarios

  if (user_id == r.requestoffering_user_id) {
    response.sendRedirect("general_error.jsp");
    return;
  }

%>
<body>
  <%@include file="includes/header.jsp" %>
    <p>If you would like to take this requestoffer, click the confirm button below</p>
    <a href="handle.jsp?requestoffer=<%=r.requestoffer_id%>&confirm=true"><%=loc.get(95, "Confirm")%></a>
</body>
