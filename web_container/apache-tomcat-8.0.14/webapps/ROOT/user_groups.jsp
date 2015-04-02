<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<%@ page import="com.renomad.xenos.Requestoffer" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="includes/reset.css">
    <link rel="stylesheet" href="includes/header.css" >
    <link rel="stylesheet" href="includes/footer.css" >
    <link rel="stylesheet" href="small_dialog.css" >
    <script type="text/javascript" src="includes/utils.js"></script>
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
  <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>



  <div class="container">

    <h3>You are a member of these groups:</h3>
      <% for (Group_utils.Group_id_and_name g : Group_utils.get_groups_for_user(logged_in_user_id, false)) {%>
        <p><a href="group.jsp?group_id=<%=g.id%>"><%=g.name%></a></p>
      <% } %>

    <h3>You own these groups:</h3>
      <% for (Group_utils.Group_id_and_name g : Group_utils.get_groups_for_user(logged_in_user_id, true)) {%>
        <p><a href="group.jsp?group_id=<%=g.id%>"><%=g.name%></a></p>
      <% } %>

      <a class="button" href="create_group.jsp">Create a group</a>

  </div>

  <%@include file="includes/footer.jsp" %>
	</body>
</html>
