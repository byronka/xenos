<%@include file="includes/init.jsp" %>
<%@ page import="com.renomad.xenos.Group_utils" %>
<!DOCTYPE html>
<html>
	<head>
    <link rel="stylesheet" href="static/css/reset.css">
    <link rel="stylesheet" href="static/css/header.css" >
    <link rel="stylesheet" href="static/css/footer.css" >
    <link rel="stylesheet" href="static/css/button.css" >
    <link rel="stylesheet" href="static/css/small_dialog.css" >
		<title>Group invite sent</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="content-type" value="text/html; charset=UTF8" />
	</head>

  <%

  String qs = request.getQueryString();

  // get the user info
  Integer uid = Utils.parse_int(Utils.parse_qs(qs).get("user_id"));
  if (uid == null) {
    uid = -1;
  }

  User the_user = User_utils.get_user(uid);
  if (the_user == null) {
    response.sendRedirect("general_error.jsp");
    return;
  }

  // get the group info
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
  <%@include file="includes/header.jsp" %>
  <div class="container">
    <h2>Group invite sent</h2>
    <p>
    You've just sent an invite to your group, <a href="group.jsp?group_id=<%=gid%>"><%=the_group.group_name%></a>, to the following user: <a href="user.jsp?user_id=<%=uid%>"><%=the_user.username%></a>
    </p>

    <p>
      <a 
        class="button" 
        href="dashboard.jsp">
          <%=loc.get(35, "Dashboard")%>
      </a>
    </p>

  </div>
  <%@include file="includes/footer.jsp" %>
  </body>
</html>

