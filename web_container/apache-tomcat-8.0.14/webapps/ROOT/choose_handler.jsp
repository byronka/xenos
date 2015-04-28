<%@include file="includes/init.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title><%=loc.get(139,"Choose a handler")%></title>
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
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
  if (potential_handler == null || huid == logged_in_user_id) {
    response.sendRedirect("general_error.jsp");
    return;
  }

    //make sure the requestoffer is there, and is open
  if (r == null || r.status != 76) { // "open"
    response.sendRedirect("general_error.jsp");
    return;
  }

  //make sure this user is the owner.
  if (logged_in_user_id != r.requestoffering_user_id) {
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
  <div class="container">
    <div class="table">
      <h3>
        <%=loc.get(140,"Confirm that you would like the following user to handle this request.")%>
      </h3>
      <div class="table">
        <div class="row">
          <label><%=loc.get(51,"Username")%>:</label>
          <a href="user.jsp?user_id=<%=huid%>">
            <%=Utils.safe_render(potential_handler.username)%>
          </a>
        </div>
        <%if (potential_handler.urdp_count >= 30) {%>
          <div class="row">
            <label><%=loc.get(18,"Rank average")%>:</label>
            <span><%=potential_handler.rank_av%></span>
          </div>
        <%}%>

        <%int l_step = Requestoffer_utils.get_ladder_step(potential_handler.rank_ladder);%>

        <div class="row">
          <label><%=loc.get(19,"Rank ladder")%>:</label>
          <span><%=Utils.get_stars(l_step)%></span>
        </div>

        <%
          Group_utils.Group_id_and_name[] shared_groups = 
            Group_utils.get_shared_groups(logged_in_user_id,huid);
        %>

        <% if (shared_groups.length > 0) { %>
          <div class="row">
            <label>Shared groups:</label>
            <% for (Group_utils.Group_id_and_name gian : shared_groups) { %>
              <a href="group.jsp?group_id=<%=gian.id%>"><%=gian.name%></a>
            <% } %>
          </div>
        <% } %>

        <div class="table">
          <div class="row">
          <a class="button" href="choose_handler.jsp?requestoffer=<%=r.requestoffer_id%>&user=<%=huid%>&confirm=true">
              <%=loc.get(95, "Confirm")%> 
            </a>
          </div>
        </div>


      </div>
    </div>
  </div>
  <%@include file="includes/footer.jsp" %>
</body>
