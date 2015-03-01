<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<!DOCTYPE html>
<html>
	<head>
		<%if (probably_mobile) {%>
			<link 
        rel="stylesheet" href="includes/common_alt.css" title="mobile">
		<% } else { %>
			<link rel="stylesheet" href="includes/common.css" title="desktop">
		<% } %>
		<title><%=loc.get(97,"My Profile")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%
  String qs = request.getQueryString();
  Integer uid = Utils.parse_int(Utils.parse_qs(qs).get("user_id"));

  User the_user = User_utils.get_user(uid);
  if (potential_handler == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }
%>
	<body>
  <%@include file="includes/header.jsp" %>

  <ul>
    <li>Name: <%=the_user.username%></li>
    <li>Rank: <%=the_user.rank%></li>
    <li>Points: <%=the_user.points%></li>
  </ul>

  <h3><%=loc.get(79, "Rank")%></h3>
  <%
    Requestoffer_utils.Rank_detail[] rank_details = 
      Requestoffer_utils.get_rank_detail(uid);
  %>

  <%if (rank_details.length == 0) {%>
      <p>(<%=loc.get(103,"None")%>)</p>
  <% } %> 

  <%	for (Requestoffer_utils.Rank_detail rd : rank_details) { %>

  <%
  //there's two parties here: the judging and the judged
  if (rd.judging_user_id == uid) { // if this user is the judge
  %>

    <div class="rank-detail">
      <%=Utils.safe_render(rd.judging_username)%>

      <% if (rd.meritorious) { %>
      <%=loc.get(166,"increased")%>
      <% } else { %>
      <%=loc.get(167,"decreased")%>
      <% } %>

      <%=loc.get(168,"the reputation of")%>

      <a href="user.jsp?user_id=<%=rd.judged_user_id%>">
        <%=Utils.safe_render(rd.judged_username)%>
      </a>

      <%=loc.get(170,"for the favor")%>
      <span><a href="requestoffer.jsp?requestoffer=<%=rd.ro_id%>"><%=rd.ro_desc%></a></span>

    </div>

  <%
  } else { 
  %>

    <div class="rank-detail">
      <a href="user.jsp?user_id=<%=rd.judging_user_id%>">
        <%=Utils.safe_render(rd.judging_username)%>
      </a>
      <%=Utils.safe_render(rd.judging_username)%>

      <% if (rd.meritorious) { %>
      <%=loc.get(166,"increased")%>
      <% } else { %>
      <%=loc.get(167,"decreased")%>
      <% } %>
      
      <%=loc.get(168,"the reputation of")%>
      
      <%=Utils.safe_render(rd.judged_username)%>

      <%=loc.get(170,"for the favor")%>

      <span><a href="requestoffer.jsp?requestoffer=<%=rd.ro_id%>"><%=rd.ro_desc%></a></span>

    </div>

  <%
  }
  %>

  <% } %>


	<h3 class="my-requestoffers-header">
		<%=loc.get(173, "Their open Favors")%>:</h3>
		<div class="requestoffers mine">
		<%
			Requestoffer[] my_open_requestoffers = 
				Requestoffer_utils
        .get_requestoffers_for_user_by_status(uid,76);
        if (my_open_requestoffers.length == 0) {%>
        <p>(<%=loc.get(103,"None")%>)</p>
        <% } 
			for (Requestoffer r : my_open_requestoffers) {
		%>
			<div class="requestoffer mine">
				<a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
					<%=Utils.get_trunc(Utils.safe_render(r.description), 50) %> </a>
			</div>
		<% } %>
		</div>


  <script type="text/javascript" src="includes/timeout.js"></script>
	</body>
</html>
