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
  <%@include file="includes/footer.jsp" %>
	</body>
</html>
