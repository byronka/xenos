<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(139,"Choose a handler")%></title>
		<%if (probably_mobile) {%>
			<link rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>

<%@ page import="com.renomad.xenos.Utils" %>
<%@ page import="com.renomad.xenos.User_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<%

  String qs = request.getQueryString();
  Requestoffer r = 
    Requestoffer_utils.parse_querystring_and_get_requestoffer(qs);
  Integer huid = Utils.parse_int(Utils.parse_qs(qs).get("user"));
  if (huid == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  //make sure the requesting user isn't setting themselves as the
  // handler on the favor.  That's not allowed.
  User potential_handler = User_utils.get_user(huid);
  if (potential_handler == null || huid == user_id) {
    response.sendRedirect("general_error.jsp");
    return;
  }

    //make sure the requestoffer is there, and is open
  if (r == null || r.status != 76) { // "open"
    response.sendRedirect("general_error.jsp");
    return;
  }

  //make sure this user is the owner.
  if (user_id != r.requestoffering_user_id) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  //check if this is the last stage and we are confirmed to set a user
  Boolean confirm = Boolean.parseBoolean(Utils.parse_qs(qs).get("confirm"));
  if (confirm != null && confirm == true) {
    if (Requestoffer_utils.choose_handler(huid, r.requestoffer_id)) {
      response.sendRedirect("handler_chosen.jsp");
      return;
    } else {
      response.sendRedirect("general_error.jsp");
      return;
    }
  }


%>
<body>
  <%@include file="includes/header.jsp" %>
  <p>
    <%=loc.get(140,"Confirm that you would like the following user to handle this request.")%>
  </p>
  <p>
  <a href="choose_handler.jsp?requestoffer=<%=r.requestoffer_id%>&user=<%=huid%>&confirm=true">
      <%=loc.get(95, "Confirm")%> 
    </a>
  </p>
  <ul>
    <li>Name: <%=Utils.safe_render(potential_handler.username)%></li>
    <li>Rank: <%=potential_handler.rank%></li>
    <li>Points: <%=potential_handler.points%></li>
  </ul>
</body>
