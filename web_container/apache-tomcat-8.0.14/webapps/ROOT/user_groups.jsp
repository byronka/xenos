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
      <p><a href="group.jsp?group_id=1">Group 1</a></p>
      <p><a href="group.jsp?group_id=2">Group 2</a></p>
      <p><a href="group.jsp?group_id=3">Group 3</a></p>
      <p><a href="group.jsp?group_id=4">Group 4</a></p>
      <p><a href="group.jsp?group_id=5">Group 5</a></p>

    <h3>You own these groups:</h3>
      <p><a href="group.jsp?group_id=5">Group 5</a></p>

      <a class="button" href="create_group.jsp">Create a group</a>

  </div>

  <%@include file="includes/footer.jsp" %>
	</body>
</html>
