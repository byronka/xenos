<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Requestoffer_utils" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <title><%=loc.get(97,"My Profile")%></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%
  if (request.getMethod().equals("POST")) {
    String the_user_desc = Utils.get_string_no_null(request.getParameter("user_description"));
    if (!User_utils.edit_description(logged_in_user_id, the_user_desc)) {
      response.sendRedirect("general_error.jsp");
      return;
    } else {
      response.sendRedirect("user.jsp?user_id="+logged_in_user_id);
      return;
    }
  }

  String qs = request.getQueryString();
  Integer uid = Utils.parse_int(Utils.parse_qs(qs).get("user_id"));
  if (uid == null) {
    uid = -1;
  }
  Boolean edit_desc = Boolean.parseBoolean(Utils.parse_qs(qs).get("edit_desc"));

  User the_user = User_utils.get_user(uid);
  if (the_user == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

%>
	<body>
  <%@include file="includes/header.jsp" %>

  <div class="container">
      <h3><%=Utils.safe_render(the_user.username)%></h3>

      <p class="user-description">
      <%if (edit_desc) { %>

        <form method="POST" action="user.jsp">
          <textarea 
            id="user_description" 
            name="user_description" 
            maxlength="500"
            ><%=Utils.safe_render(User_utils.get_user_description(uid))%></textarea>
          <div class="table">
          <div class="row">
            <button class="button" type="submit" >Save description</button>
            <a class="button" href="user.jsp?user_id=<%=uid%>" >
              Cancel
            </a>
          </div>
          </div>
        </form>

      <% } else { %>
        <em>
          <%=Utils.safe_render(User_utils.get_user_description(uid))%>
        </em>
      <% } %>
      <p>

      <% if (uid == logged_in_user_id && !edit_desc ) { %>

          <div class="row">
            <a 
              class="button" 
              href="user.jsp?user_id=<%=uid%>&amp;edit_desc=true">
                Edit description
            </a>
          </div>

      <% } %>



      <%if (the_user.urdp_count >= 30) {%>
        <div class="row">
          <label><%=loc.get(18,"Rank average")%>:</label>
          <span><%=the_user.rank_av%></span>
        </div>
      <%}%>

      <%int l_step = Requestoffer_utils.get_ladder_step(the_user.rank_ladder);%>

      <div class="row">
        <label><%=loc.get(19,"Rank ladder")%>:</label>
        <span><%=Utils.get_stars(l_step)%></span>
      </div>

      <%
        Group_utils.Group_id_and_name[] shared_groups = 
          Group_utils.get_shared_groups(logged_in_user_id,uid);
      %>

      <% if (shared_groups.length > 0) { %>
        <div class="row">
          <label>Shared groups:</label>
          <% for (Group_utils.Group_id_and_name gian : shared_groups) { %>
            <a href="group.jsp?group_id=<%=gian.id%>"><%=gian.name%></a>
          <% } %>
        </div>
      <% } %>

      <% if (the_user.points < 0) { %>
        <div class="row">
          <label>
            <%=the_user.username%> 
            <%=String.format(loc.get(27,"owes people %d points"),-the_user.points)%>
          </label>
        </div>
      <% } else { %>
        <div class="row">
          <label>
            <%=the_user.username%> 
            <%=String.format(loc.get(9,"is owed %d points"),the_user.points)%>
          </label>
        </div>
      <% } %>

    <%
      Requestoffer_utils.Rank_detail[] rank_details = 
        Requestoffer_utils.get_rank_detail(uid);
    %>

    <%if (rank_details.length != 0) {%>

      <%	for (Requestoffer_utils.Rank_detail rd : rank_details) { %>


      <% if (rd.status_id == 3) { %>
      <%
      //there's two parties here: the judging and the judged
      if (rd.judging_user_id == uid) { // if this user is the judge
      %>

        <div class="rank-detail">

          <% if(rd.meritorious != null) {%>
            <% if (rd.meritorious) { %>
            +1 <%=loc.get(17,"to")%>
            <% } else { %>
              -1 <%=loc.get(17,"to")%> 
            <% } %>
          <% } %>

          <a href="user.jsp?user_id=<%=rd.judged_user_id%>">
            <%=Utils.safe_render(rd.judged_username)%>
          </a>


        <%if (rd.comment.length() > 0) {%>
          ("<%=rd.comment%>")
        <%}%>
        </div>

      <%
      } else { 
      %>

        <div class="rank-detail">

          <% if(rd.meritorious != null) {%>
            <% if (rd.meritorious) { %>
           +1 from
            <% } else { %>
           -1 from
            <% } %>
          <% } %>

          <a href="user.jsp?user_id=<%=rd.judging_user_id%>">
            <%=Utils.safe_render(rd.judging_username)%>
          </a>


        <%if (rd.comment.length() > 0) {%>
          ("<%=rd.comment%>")
        <%}%>
        </div>
      <% } %>

    <% } %>
    <% } %>
    <% } %> 

    <%
      Requestoffer[] my_open_requestoffers = 
        Requestoffer_utils
        .get_requestoffers_for_user_by_status(uid,76);
    %>

    <% if (my_open_requestoffers.length != 0) {%>
      <div style="padding-top: 20px;" class="my-requestoffers-header">
        <em>
          <%=loc.get(173, "Their open Favors")%>:
        </em>
      </div>
      <div class="requestoffers mine">
        <%for (Requestoffer r : my_open_requestoffers) { %>
          <div class="requestoffer mine">
            <a href="requestoffer.jsp?requestoffer=<%=r.requestoffer_id %>"> 
              <%=Utils.get_trunc(Utils.safe_render(r.description), 50) %> </a>
          </div>
        <% } %>
      </div>
    <% } %>
  </div>
  <%@include file="includes/footer.jsp" %>
	</body>
</html>
