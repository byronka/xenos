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
    <title>Group</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
<%
  String qs = request.getQueryString();
  Integer gid = Utils.parse_int(Utils.parse_qs(qs).get("group_id"));
  if (gid == null) {
    gid = -1;
  }

  Group_utils.Group the_group = Group_utils.get_group(gid);
  if (the_group == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

%>
	<body>
  <img id='my_background' src="img/front_screen.png" onload="xenos_utils.fade_in_background()"/>
  <%@include file="includes/header.jsp" %>

  <div class="container">
    <h3>Details on the group:</h3>
    <div class="row">
      <label>Name:</label>
      <span><%=the_group.group_name%></span>
    </div>
    <div class="row">
      <label>Description:</label>
      <span><%=the_group.description%></span>
    </div>
    <div class="row">
      <label>Owner:</label>
          <span>
            <a href="user.jsp?user_id=<%=the_group.owner_id%>"><%=the_group.owner_username%></a>
          </span>
    </div>
    <div class="row">
      <label>Members:</label>
      <% for (java.util.Map.Entry<Integer, String> member : the_group.get_members().entrySet()) { %>
          <span>
            <a href="user.jsp?user_id=<%=member.getKey()%>"><%=member.getValue()%></a>
          </span>
        <% } %>
    </div>
  </div>
  <%@include file="includes/footer.jsp" %>
	</body>
</html>
