<%@include file="includes/securepage.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
    <title>User Groups</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%
  String qs = request.getQueryString();
  Integer uid = Utils.parse_int(Utils.parse_qs(qs).get("user_id"));
  if (uid == null) {
    uid = -1;
  }

%>
	<body>
  <%@include file="includes/header.jsp" %>



  <div class="container">

    <%
      Group_utils.Group_id_and_name[] gian_member =  
        Group_utils.get_groups_for_user(logged_in_user_id, false);
    %>

    <% if (gian_member.length > 0) { %>
    <h3><%=loc.get(26,"You are a member of these groups")%>:</h3>
      <% for (Group_utils.Group_id_and_name g : gian_member) {%>
        <p><a href="group.jsp?group_id=<%=g.id%>"><%=g.name%></a></p>
      <% } %>
    <% } %>

    <%
      Group_utils.Group_id_and_name[] gian_owner =  
        Group_utils.get_groups_for_user(logged_in_user_id, true);
    %>
      
    <% if (gian_owner.length > 0) { %>
      <h3><%=loc.get(40,"You own these groups")%>:</h3>
      <% for (Group_utils.Group_id_and_name g : gian_owner) {%>
        <p><a href="group.jsp?group_id=<%=g.id%>"><%=g.name%></a></p>
      <% } %>
    <% } %>

    <%
      Group_utils.Invite_info[] received_invites =  
        Group_utils.get_invites_for_user(logged_in_user_id);
    %>
    <% if (received_invites.length > 0) { %>
      <h3>Invites to groups:</h3>
      <% for (Group_utils.Invite_info ii : received_invites) {%>
        <p>
          <a href="group.jsp?group_id=<%=ii.group_id%>">
            <%=ii.groupname%>
          </a>
        </p>
      <% } %>
    <% } %>

    <div class="row">
      <a class="button" href="create_group.jsp"><%=loc.get(45,"Create a group")%></a>
      <a class="button" href="user.jsp?user_id=<%=logged_in_user_id%>"><%=loc.get(130,"Cancel")%></a>
    </div>

  </div>

  <%@include file="includes/footer.jsp" %>
	</body>
</html>
